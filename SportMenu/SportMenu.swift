//
//  BallTypeMenu.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/7/29.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class SportMenu:UIView {
    
    enum Mode {
        case sport
        case sportAndDate
    }
    private let disposeBag = DisposeBag()
    fileprivate let topContentView = UIView(color: .white)
    private lazy var expandSportTypeMenu = ExpandSportTypeMenu(viewModel: viewModel)
    private lazy var sportMenu = SportTypeMenu(viewModel: viewModel)
    private lazy var sportAndDateMenu = SportAndDateTypeMenu(viewModel: viewModel)
    fileprivate lazy var viewModel = SportTypeMenuViewModel(sportService: Beans.sportServer)
     init() {
        super.init(frame:.zero)
        backgroundColor = .clear
        setupViews()
        bindBtn()
        bindViewModel()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    private let topLine = UIView(color: Themes.grayLightest)
    private let bottomLine = UIView(color: Themes.grayLightest)
    private func setupViews(){
        addSubview(expandSportTypeMenu)
        addSubview(topContentView)
        topContentView.addSubview(sportMenu)
        topContentView.addSubview(sportAndDateMenu)
        topContentView.addSubview(topLine)
        topContentView.addSubview(bottomLine)
        
        topContentView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }
        
        sportMenu.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        sportAndDateMenu.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        topLine.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }
        bottomLine.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }
        expandSportTypeMenu.snp.makeConstraints { (maker) in
            maker.top.equalTo(topContentView.snp.bottom)
            maker.leading.bottom.trailing.equalToSuperview()
        }
        sportAndDateMenu.alpha = 0
    }
    func bindDates(dates:Observable<[String]>){
        dates.bind(to: viewModel.dates)
    }
    
    func changeMode(_ mode:TopCategoryView.MenuType){
        viewModel.reset(mode.getCategoryDetailDto())
        switch mode {
        case .today,.rolling:
            changeMode(.sport)
        case .earlyplate,.parley:
            changeMode(.sportAndDate)
        }
    }
    func bindCategoryDetail(_ categoryDetail:CategoryDetailDto){
//        viewModel.categoryDetail.onNext(categoryDetail)
    }
    fileprivate func changeMode(_ mode:Mode){
        switch mode {
        case .sport:
            UIView.animate(withDuration: 0.25) {
                self.sportMenu.alpha = 1
                self.sportMenu.isUserInteractionEnabled = true
                self.sportAndDateMenu.alpha = 0
                self.sportAndDateMenu.isUserInteractionEnabled = false
            }
        case .sportAndDate:
            UIView.animate(withDuration: 0.25) {
                self.sportMenu.alpha = 0
                self.sportMenu.isUserInteractionEnabled = false
                self.sportAndDateMenu.alpha = 1
                self.sportAndDateMenu.isUserInteractionEnabled = true
            }
        }
    }
    
   
    
    private func bindBtn(){
       Observable.merge(sportMenu.rx.clickExpand,sportAndDateMenu.rx.clickExpand)
            .subscribeSuccess(changeExpandBallView)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel(){
        viewModel.isExpand.skip(1).distinctUntilChanged().subscribeSuccess { (isExpand) in
            self.snp.updateConstraints({ (maker) in
                maker.height.equalTo( isExpand ? 212 : 44)
            })
            }.disposed(by: disposeBag)
        viewModel.selectedSportIndex.skip(1).subscribeSuccess(expandSportTypeMenu.setSelected).disposed(by: disposeBag)
    }
    
    private func changeExpandBallView(){
        viewModel.isExpand.accept(!viewModel.isExpand.value)
    }
}
extension Reactive where Base:SportMenu {
    var selectedSport:Observable<SportDto>{
        return base.viewModel.selectedSport
    }
    var selectedDate:Observable<String>{
        return base.viewModel.selectedDate
    }
}

