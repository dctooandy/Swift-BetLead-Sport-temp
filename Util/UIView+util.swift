//
//  UIView+util.swift
//  agency.ios
//
//  Created by Andy Chen on 2019/4/15.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadowBgView(radius:CGFloat) -> UIView {
        let shadow = UIView()
        let frame = self.frame
        shadow.layer.shadowOpacity = 0.3
        shadow.layer.cornerRadius = 10
        shadow.addSubview(self)
        shadow.frame = frame
        self.snp.makeConstraints { maker in
            maker.edges.equalTo(UIEdgeInsets.zero)
        }
        return shadow
    }
    
    func addGradientBlueLayer(size:CGSize = .zero) {
        let layerSize = size == .zero ? frame.size :size
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x:0,
                                     y:0,
                                     width:layerSize.width,
                                     height:layerSize.height)
        gradientLayer.colors = [Themes.gradientStartBlue.cgColor,Themes.gradientEndBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0.0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        layer.insertSublayer(gradientLayer, at:0)
    }
    func addGradientLayer(size:CGSize = .zero, startColor:UIColor, endColor:UIColor,axis: NSLayoutConstraint.Axis = .horizontal) {
        let layerSize = size == .zero ? frame.size :size
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x:0,
                                     y:0,
                                     width:layerSize.width,
                                     height:layerSize.height)
        gradientLayer.colors = [startColor.cgColor,endColor.cgColor]
        if axis == .horizontal{
            gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
            gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x:0.5, y:0.0)
            gradientLayer.endPoint = CGPoint(x:0.5, y:1.0)
        }
        layer.insertSublayer(gradientLayer, at:0)
    }
    
    func applyCornerRadius(radius:CGFloat = 5) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func applyShadow(size:CGSize = CGSize(width: 0, height: 5), radius:CGFloat = 5) {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = size
        layer.shadowRadius = radius
        layer.shadowOpacity = 1
    }
    
    func applyCornerAndShadow(radius:CGFloat = 5){
        layer.addShadow()
        layer.roundCorners(radius: radius)
    }
    
    func addBottomSeparator(color:UIColor, edgeSpacing:CGFloat = 0) {
        let separator = UIView(color:color)
        self.addSubview(separator)
        separator.snp.makeConstraints { maker in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(edgeSpacing)
            maker.trailing.equalToSuperview().offset(-edgeSpacing)
            maker.height.equalTo(1)
        }
    }
    convenience init(color:UIColor) {
        self.init(frame:.zero)
        self.backgroundColor = color
    }
    
    func applyDefaultLayer() {
        layer.masksToBounds = false
        layer.cornerRadius = 0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0
    }
    
    func roundCorner(corners:UIRectCorner, radius:CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale);
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // old style: self.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() };
        UIGraphicsEndImageContext();
        return image;
    }
    
    func setAnchorPoint(_ point:CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
    
    
    func addGradientLayer(colors: [CGColor], direction: GradientDirection = .toBottom) {
        let addLayer = layer.sublayers?.first{$0.name == Constants.Gradient_Layer_Name}
        if addLayer == nil {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = Constants.Gradient_Layer_Name
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = direction.points.0
        gradientLayer.endPoint = direction.points.1
        self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    func removeGradientLayer(){
      layer.sublayers?.first{$0.name == Constants.Gradient_Layer_Name}?.removeFromSuperlayer()
    }
    
    enum GradientDirection {
        case toBottom
        case toLeft
        case toRight
        
        var points: (CGPoint, CGPoint) {
            switch self {
            case .toBottom:
                return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
            case .toLeft:
                return (CGPoint(x: 1, y: 0.5), CGPoint(x: 0, y: 0.5))
            case .toRight:
                return (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
            }
        }
        
    }
    
    func addDashedBorder(color:UIColor = Themes.grayLayer) {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
