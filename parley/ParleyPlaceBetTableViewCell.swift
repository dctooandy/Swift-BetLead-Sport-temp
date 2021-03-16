//
//  ParleyPlaceBetTableViewCell.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/27.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
import Toaster
class ParleyPlaceBetTableViewCell:UITableViewCell {
    
    private let titleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 14), textColor: Themes.prupleBet, text: "2串1")
    private let rangeLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10,weight: .light), textColor: Themes.prupleBet, text: "限額：¥0.5 - 1,200.00")
    private lazy var priceTextField:AmountTextField = {
        let tf = AmountTextField()
        tf.leftView = priceTextFieldLeftView
        tf.leftViewMode = .always
        tf.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        tf.textColor = UIColor(rgb: 0x8567c1)
        tf.attributedPlaceholder = NSAttributedString(string: "请输入投注额", attributes: [NSAttributedString.Key.foregroundColor: Themes.base,
                                                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)])
        tf.applyCornerRadius(radius: 4)
        tf.layer.borderColor = UIColor(rgb: 0xb1b1b1).cgColor
        tf.layer.borderWidth = 1
        return tf
    }()
    private let priceTextFieldLeftView:UIView = {
        let view = UIView()
        let yen = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12), textColor: Themes.purpleBase, text: "¥")
        view.addSubview(yen)
        view.frame = CGRect(x: 0, y: 0, width: 28, height: 32)
        yen.snp.makeConstraints({ (maker) in
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(-4)
        })
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
      contentView.addSubview(titleLabel)
      contentView.addSubview(rangeLabel)
      contentView.addSubview(priceTextField)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(15)
            maker.leading.equalTo(32)
        }
        rangeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.leading.equalTo(titleLabel)
        }
        priceTextField.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-32)
            maker.size.equalTo(CGSize(width: 135, height: 33))
            maker.centerY.equalToSuperview()
        }
        
    }
    
    func configureCell(betDetailDto:BetDetailDto ,row:Int ,enterPriceAtRow:PublishSubject<(Double,Int)> ,activeTextfieldAtRow:PublishSubject<Int> ,activeCellY:PublishSubject<CGFloat>,
                       price:Double?){
        titleLabel.text = "\(betDetailDto.wagerType ?? "") X \(betDetailDto.numberOfCombination)"
        rangeLabel.text = "限額：¥\(betDetailDto.betSetting.minBet) - \(betDetailDto.betSetting.maxBet)"
        if let prviousPrice = price {
        priceTextField.text =  "\(prviousPrice)"
        } else {
         priceTextField.text =  ""
        }
        priceTextField.setRange(max: betDetailDto.betSetting.maxBet, min: betDetailDto.betSetting.minBet, bag: rx.reuseBag)
        priceTextField.rx.text.compactMap{$0}.compactMap{Double($0)}.map{($0,row)}.bind(to: enterPriceAtRow).disposed(by: rx.reuseBag)
        
        activeTextfieldAtRow.subscribeSuccess {[weak self] (activeRow) in
             guard let weakSelf = self ,
                   let superView =  weakSelf.contentView.superview?.superview
                   else { return }
            if row == activeRow {
                if let  yPosition = weakSelf.contentView.superview?.convert(weakSelf.contentView.frame.origin, to: superView).y {
                    activeCellY.onNext(yPosition)
                }
                weakSelf.priceTextField.becomeFirstResponder()
            }
        }.disposed(by: rx.reuseBag)
        
        priceTextField.moveCursorBtnClick.map { (cursor) -> Int in
            switch cursor {
            case .next:
                return row + 1
            case .last:
                return row - 1
            }
        }.bind(to: activeTextfieldAtRow)
        .disposed(by: rx.reuseBag)
        
        priceTextField.rx.controlEvent(.editingDidBegin).subscribeSuccess {[weak self] (_) in
            guard let weakSelf = self ,
                let superView =  weakSelf.contentView.superview?.superview
                else { return }
            if let  yPosition = weakSelf.contentView.superview?.convert(weakSelf.contentView.frame.origin, to: superView).y {
                activeCellY.onNext(yPosition)
            }
        }.disposed(by: rx.reuseBag)
        
    }
    
}
