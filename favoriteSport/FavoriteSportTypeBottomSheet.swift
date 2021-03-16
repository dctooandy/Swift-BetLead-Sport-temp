//
//  FavoriteSportTypeBottomSheet.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/12.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
class FavoriteSportTypeBottomSheet:BaseBottomSheet {
    
    private let selectedFrontTitleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12, weight: .semibold), textColor: Themes.likeSelectedTitle, text: "请选取最少")
    private let selectedFrontValueLabel = UILabel.customLabel(font: Fonts.impact(22), textColor: Themes.yellow, text: "3")
    private let selectedEndTitleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                            textColor: Themes.likeSelectedTitle, text: "项   |   已选 ")
    private let selectedEndValueLabel = UILabel.customLabel(font: Fonts.impact(22), textColor: Themes.yellow, text: "04")
    
    
    private var sportTypeViews = [SportTypeView]()
    private let scrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private var seletedSportTypes = [SportTypeDto]()
    private let viewModel:FavoriteSportTypeBottomSheetViewModel
    init(sportTypes:[SportTypeDto] ,seletedSportTypes:[SportTypeDto]){
        self.viewModel = FavoriteSportTypeBottomSheetViewModel(sportTypes: Observable.just(sportTypes))
        self.seletedSportTypes = seletedSportTypes
        super.init()
        titleLabel.text = "类别关注"
    }
    
    required init(_ parameters: Any? = nil) {
        self.viewModel = FavoriteSportTypeBottomSheetViewModel(sportTypes: Beans.sportServer.getSportType().asObservable())
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "偏好设定"
        setupViews()
        bindViewModel()
        bindBtn()
        BetleadAssistiveTouch.share.isHidden = true
    }
    
    
    override func setupViews(){
        super.setupViews()
        defaultContainer.addSubview(selectedFrontTitleLabel)
        defaultContainer.addSubview(selectedFrontValueLabel)
        defaultContainer.addSubview(selectedEndTitleLabel)
        defaultContainer.addSubview(selectedEndValueLabel)
        defaultContainer.addSubview(scrollView)
        
        
        selectedEndTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(separator.snp.bottom).offset(16)
            maker.leading.equalTo(defaultContainer.snp.centerX)
        }
        selectedEndValueLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(selectedEndTitleLabel.snp.trailing)
            maker.centerY.equalTo(selectedEndTitleLabel)
        }
        selectedFrontValueLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(selectedEndTitleLabel.snp.leading)
            maker.centerY.equalTo(selectedEndTitleLabel)
        }
        selectedFrontTitleLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(selectedFrontValueLabel.snp.leading)
            maker.centerY.equalTo(selectedEndTitleLabel)
        }
        scrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(selectedEndTitleLabel.snp.bottom).offset(24)
            maker.leading.equalTo(32)
            maker.trailing.equalTo(-32)
            maker.bottom.equalTo(submitBtn.snp.top).offset(-6)
        }
       
    }
    
    private let spacing:CGFloat = (Views.screenWidth - 32*2 - 94*3)/2
    private func bindViewModel(){
        viewModel.sportTypes.subscribeSuccess({[weak self] (sportTypeDtos) in
            guard let weakSelf = self else { return }
            sportTypeDtos.enumerated().forEach({ (index,sportTypeDto) in
                let sportTypeView = SportTypeView(sportTypeDto)
                weakSelf.sportTypeViews.append(sportTypeView)
                weakSelf.scrollView.addSubview(sportTypeView)
                sportTypeView.frame = CGRect(x: (index%3) * Int(94 + weakSelf.spacing) , y: (index/3) * (115 + 12), width: 94, height: 115)
                sportTypeView.rx.click.map{_ in sportTypeDto}
                    .do(afterNext:{ sportTypeView.setSelected(isSelected: weakSelf.viewModel.setSelectedStatus($0))})
                    .bind(to: weakSelf.viewModel.selectedSportType)
                    .disposed(by: weakSelf.disposeBag)
            })
            weakSelf.seletedSportTypes.forEach{ sportType in
                weakSelf.viewModel.selectedSportType.onNext(sportType)
                if let index = sportTypeDtos.firstIndex(where: {$0.value == sportType.value}) {
                 weakSelf.sportTypeViews[index].setSelected(isSelected: true)
                }
            }
            weakSelf.scrollView.contentSize.height = floor(CGFloat(sportTypeDtos.count/3)) * (115 + 12)
        }).disposed(by: disposeBag)
        
        viewModel.numberOfselectedSportTypes
                 .bind(to: selectedEndValueLabel.rx.text)
                 .disposed(by: disposeBag)
        
        viewModel.isEnableNext
                 .bind(to: submitBtn.rx.isEnabled)
                 .disposed(by: disposeBag)
        
    }
    private func bindBtn(){
        submitBtn.rx.tap.subscribeSuccess { [weak self](_) in
             guard let weakSelf = self else { return }
            FavoriteLeagueBottomSheet(sportTypeDtos: weakSelf.viewModel.selectedSportTypes.value).start(viewController: weakSelf)
        }.disposed(by: disposeBag)
    }
    
}
