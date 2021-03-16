//
//  UIViewController+Util.swift
//  agency.ios
//
//  Created by Victor on 2019/5/22.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    static func className() -> String {
        return NSStringFromClass(self)
    }
    
    func className() -> String {
        return NSStringFromClass(self.classForCoder)
    }
}
extension UIViewController {
    
    
    func showAppUpdateAlert(title: String, version: String, link: String, isForced: Bool) {
        
        let alert = UIAlertController(title: title, message: "版本号: \(version)", preferredStyle: .alert)
        let update = UIAlertAction(title: "立马更新", style: .default) { (action) in
            if UIApplication.shared.canOpenURL(URL(string: link)!) {
                UIApplication.shared.open((URL(string: link)!), options: [:], completionHandler: nil)
            }
        }
        alert.addAction(update)
        
        if !isForced {
            let cancel = UIAlertAction(title: "狠心拒绝", style: .default, handler: nil)
            alert.addAction(cancel)
        }
        
        present(alert, animated: true, completion: nil)
    
    }
    
}

// MARK: - keyboard tool bar
extension UIViewController: UITextFieldDelegate {
    func addToolBar(textField: UITextField) {
        let toolbarView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        toolbarView.backgroundColor = UIColor(red: 99, green: 67, blue: 163)
//        textField.delegate = self
        textField.inputAccessoryView = toolbarView
        
        let lastBtn = UIButton()
        lastBtn.setImage(UIImage(named: "icon-arrow-up"), for: .normal)
        lastBtn.addTarget(self, action: #selector(keyboardLastBtnPressed), for: .touchUpInside)
        toolbarView.addSubview(lastBtn)
        
        let nextBtn = UIButton()
        nextBtn.setImage(UIImage(named: "icon-arrow-down"), for: .normal)
        nextBtn.addTarget(self, action: #selector(keyboardNextBtnPressed), for: .touchUpInside)
        toolbarView.addSubview(nextBtn)
        
        let doneBtn = UIButton()
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.setTitleColor(.white, for: .normal)
        doneBtn.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 14)
        doneBtn.addTarget(self, action: #selector(keyboardDoneBtnPressed), for: .touchUpInside)
        toolbarView.addSubview(doneBtn)
        
        let btns = createPriceButton()
        let stackView = UIStackView(arrangedSubviews: btns)
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        toolbarView.addSubview(stackView)
        
        lastBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(24)
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(lastBtn)
            make.left.equalTo(lastBtn.snp.right).offset(10)
            make.size.equalTo(24)
        }
        
        doneBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(35)
            make.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(doneBtn.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(27)
        }
    }
    
    func createPriceButton() -> [UIButton] {
        let priceTitle = [10, 50, 100, 300, 500, 000]
        var btnArr = [UIButton]()
        for i in priceTitle {
            let btn = UIButton()
            let title = i == 0 ? "MAX" : i.description
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor(red: 99, green: 67, blue: 163), for: .normal)
            btn.backgroundColor = .white
            btn.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 20)
            btn.layer.cornerRadius = 3.0
            btn.clipsToBounds = true
            btn.tag = i
            btn.addTarget(self, action: #selector(keyboardPriceBtnPressed(_:)), for: .touchUpInside)
            btnArr.append(btn)
        }
        
        return btnArr
    }
    
    @objc func keyboardDoneBtnPressed() {
        view.endEditing(true)
        print("keyboardDoneBtnPressed")
    }
    @objc func keyboardLastBtnPressed() {
        print("keyboardLastBtnPressed")
    }
    @objc func keyboardNextBtnPressed() {
        print("keyboardNextBtnPressed")
    }
    
    @objc func keyboardPriceBtnPressed(_ sender: UIButton) {
        print("price : \(sender.tag)")
    }
}
