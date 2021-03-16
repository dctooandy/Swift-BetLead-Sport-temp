//
//  BallTypeCollectionViewCell.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/7/29.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import UIKit
class SportTypeCollectionViewCell:UICollectionViewCell {
    
    private let icon = UIImageView()
    private let countLabel:UILabel =  {
        let label = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10, weight: .semibold), alignment: .center, textColor: .white)
        label.applyCornerRadius(radius: 5.5)
        label.backgroundColor = .red
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ dto:SportDto){
        icon.image = UIImage(named: "ball")?.blendedByColor(Themes.unSelectedGray)
        countLabel.text = "\(dto.eventCount)"
        countLabel.backgroundColor = dto.countLabelColor
    }
    
    private func setupViews(){
        contentView.addSubview(icon)
        contentView.addSubview(countLabel)
        
        icon.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 24, height: 24))
            maker.top.equalTo(8)
            maker.centerX.equalToSuperview()
        }
        countLabel.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(11)
            maker.bottom.equalTo(-7)
        }
    }
    func setSeleted(_ isSelected:Bool) {
        icon.image = icon.image?.blendedByColor(isSelected ? Themes.puple : Themes.unSelectedGray)
        contentView.backgroundColor = .white
    }
}
