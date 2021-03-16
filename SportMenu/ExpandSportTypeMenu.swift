//
//  ExpandBallTypeMenu.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/7/29.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class ExpandSportTypeMenu:UIView {
    
    private let disposeBag = DisposeBag()
    private let contentScrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        
        return view
    }()
    private var sportTypeViews = [SportTypeView]()
    private let viewModel:SportTypeMenuViewModel
    init(viewModel: SportTypeMenuViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        bindViewModel()
        
    }
    
    private func bindViewModel() {
        viewModel.sports.skip(1).map{$0.map{SportTypeView(dto:$0)}}
            .subscribeSuccess {[weak self] (ballTypeViews) in
                guard let weakSelf = self else { return }
                weakSelf.sportTypeViews = ballTypeViews
                weakSelf.contentScrollView.subviews.forEach{$0.removeFromSuperview()}
                ballTypeViews.enumerated().forEach({ (index, ballTypeView) in
                    weakSelf.contentScrollView.addSubview(ballTypeView)
                    let width:CGFloat = (Views.screenWidth - 24*2 - 8*2)/2
                    let isOdd = index%2 == 0
                    ballTypeView.frame = CGRect(x: isOdd ? 24 : Views.screenWidth/2 + 8 , y: 18 + CGFloat(index/2 * (38 + 8)) , width: width, height: 38)
                    weakSelf.contentScrollView.contentSize = CGSize(width: Views.screenWidth, height: CGFloat( ceil((Double(ballTypeViews.count)/2)) * (38 + 8) + 18 * 2))
                    ballTypeView.rx.click.map({ _ -> Int in
                        weakSelf.viewModel.isExpand.accept(false)
                        weakSelf.setSelected(index:index)
                        return index
                    }).bind(to: weakSelf.viewModel.selectedSportIndex)
                        .disposed(by: weakSelf.disposeBag)
                })
                weakSelf.setSelected(index: 0)
            }.disposed(by: disposeBag)
        viewModel.isExpand.map{!$0}.bind(to: shadow.rx.isHidden).disposed(by: disposeBag)
    }
    
    func setSelected(index:Int){
        guard sportTypeViews.count - 1 >= index else { return }
        sportTypeViews.forEach({$0.setSelected(false)})
        sportTypeViews[index].setSelected(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let shadow:UIView = {
        let view = UIView(color: .white)
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.7
        return view
    }()
    private func setupViews() {
        addSubview(shadow)
        addSubview(contentScrollView)
                contentScrollView.snp.makeConstraints { (maker) in
                    maker.edges.equalToSuperview()
                }
        shadow.snp.makeConstraints { (maker) in
            maker.top.equalTo(-20)
            maker.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    
    class SportTypeView:UIView {
        let icon = UIImageView()
        let titleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12, weight: .medium), alignment: .left, textColor: Themes.unSelectedGray)
        let countLabel:UILabel =  {
            let label = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10, weight: .semibold), alignment: .center, textColor: .white)
            label.applyCornerRadius(radius: 5.5)
            label.backgroundColor = .red
            return label
        }()
        
        init(dto: SportDto) {
            super.init(frame: .zero)
            setupViews()
            applyCornerRadius(radius: 19)
            layer.borderColor = Themes.borderGray.cgColor
            layer.borderWidth = 1
            configureView(dto)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setupViews(){
            addSubview(icon)
            addSubview(titleLabel)
            addSubview(countLabel)
            
            icon.snp.makeConstraints { (maker) in
                maker.leading.equalTo(20)
                maker.size.equalTo(CGSize(width: 24, height: 24))
                maker.centerY.equalToSuperview()
            }
            titleLabel.snp.makeConstraints { (maker) in
                maker.leading.equalTo(icon.snp.trailing).offset(5)
                maker.trailing.equalTo(countLabel.snp.leading).offset(5)
                maker.centerY.equalToSuperview()
            }
            countLabel.snp.makeConstraints { (maker) in
                maker.centerY.equalToSuperview()
                maker.size.equalTo(CGSize(width: 24, height: 11))
                maker.trailing.equalTo(-15)
            }
        }
        func configureView(_ dto:SportDto){
            icon.image = UIImage(named: "ball")?.withRenderingMode(.alwaysTemplate)
            titleLabel.text = dto.sportName
            countLabel.text = "\(dto.eventCount)"
        }
        
        func setSelected(_ isSelected:Bool){
            icon.tintColor = isSelected ? Themes.puple : Themes.unSelectedGray
            titleLabel.textColor = isSelected ? Themes.puple : Themes.unSelectedGray
        }
        
    }
}
