//
//  FavoriteViewController.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/12.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
class FavoriteViewController:ParlayViewController {
    private let favoriteIcon = UIImageView(image: UIImage(named: "icon-favorite"))
    private let titleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 20, weight: .semibold), textColor: Themes.darkGrey, text: "关注")
    private let favoriteBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("偏好设定", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        btn.backgroundColor = Themes.peachGray
        btn.applyCornerRadius(radius: 10)
        return btn
    }()
    private let topBgImageView = UIImageView(image: UIImage(named: "top-bg") )
    private let contentView = UIView(color: .white)
    private let sportTypeMenu = SportMenu()
    private let topCategoryView = TopCategoryView(method: .favorite)
    private let isAllowFetchingData = PublishSubject<Bool>()
    private lazy var sportOddsTableView = SportOddsTableView(sportId: sportTypeMenu.rx.selectedSport.map{"\($0.sportId)"},
                                                             category: topCategoryView.rx.categoryMode,
                                                             selectedDate: sportTypeMenu.rx.selectedDate,
                                                             direction: .vertical,
                                                             method: .favorite,
                                                             isAllowFetchingData:isAllowFetchingData,
                                                             tag:"favorite")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindBtn()
        view.backgroundColor = .white
        BetleadAssistiveTouch.share.setDisable([.choseLeague])
        if #available(iOS 11, *) {
            self.sportOddsTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false;
        }
    }
    func setSelectedCategory(_ index:Int){
        topCategoryView.setSelectedIndex(index)
    }
    
    lazy var loadData:Void = {
        topCategoryView.loadData()
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BetLeadTabbarViewController.share.rx.frontView.map{ $0 == .favorite}
            .do(onNext:{[weak self] isFavorite in
                 guard let weakSelf = self else { return }
                if isFavorite {
                    weakSelf.topCategoryView.loadData()
                }
            })
            .bind(to: isAllowFetchingData).disposed(by: disposeBag)
        _ = lazyBindView
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isAllowFetchingData.onNext(false)
       
    }
    private func setupViews(){
        view.addSubview(topBgImageView)
        view.addSubview(contentView)
        contentView.addSubview(favoriteIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteBtn)
        contentView.addSubview(topCategoryView)
        let topSeparator = UIView(color: Themes.grayLightest)
        let bottomSeparator = UIView(color: Themes.grayLightest)
        topCategoryView.addSubview(topSeparator)
        topCategoryView.addSubview(bottomSeparator)
        contentView.addSubview(sportOddsTableView)
        contentView.addSubview(sportTypeMenu)
        
        topBgImageView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(174)
        }
        favoriteIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(35)
            maker.leading.equalTo(32)
            maker.size.equalTo(CGSize(width: 20, height: 20))
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(favoriteIcon.snp.trailing).offset(6)
            maker.centerY.equalTo(favoriteBtn)
        }
        favoriteBtn.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-32)
            maker.centerY.equalTo(favoriteIcon)
            maker.size.equalTo(CGSize(width: 62, height: 20) )
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(Views.statusBarHeight + 20)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        topCategoryView.snp.makeConstraints { (maker) in
            maker.top.equalTo(favoriteIcon.snp.bottom).offset(20)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(55)
        }
        topSeparator.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalToSuperview()
            maker.height.equalTo(1)
        }
        bottomSeparator.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(1)
        }
        sportTypeMenu.snp.makeConstraints { (maker) in
            maker.top.equalTo(topCategoryView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }
        sportOddsTableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topCategoryView.snp.bottom).offset(44)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(-Views.betleadTabbarHeight)
        }
        view.layoutIfNeeded()
        contentView.roundCorner(corners: [.topLeft,.topRight], radius: 36)
    }
    private func bindBtn(){
        favoriteBtn.rx.tap.subscribeSuccess {[weak self] _ in
          guard let weakSelf = self else { return }
         weakSelf.navigationController?.pushViewController(FavoriteSportSettingViewController() , animated: true)
        }.disposed(by: disposeBag)
    }
    
     private lazy var lazyBindView:Void = {
        topCategoryView.rx.categoryMode.subscribeSuccess(sportTypeMenu.changeMode(_:)).disposed(by: disposeBag)
        sportTypeMenu.bindDates(dates: sportOddsTableView.rx.dates)
        sportOddsTableView.rx.selectedLeagueOddsDto.subscribeSuccess {[weak self] (leagueOddsDto) in
            guard let weakSelf = self else { return }
            weakSelf.navigationController?.pushViewController(LeagueOddsViewController(leagueOddsDto: leagueOddsDto,isParley: weakSelf.topCategoryView.isParley), animated: true)
            }.disposed(by: disposeBag)
        
        sportOddsTableView.rx.clickOdds.subscribeSuccess{[weak self] (oddsDto) in
            guard let weakSelf = self else { return }
            weakSelf.navigationController?.pushViewController(EventDetailViewController(oddsDto: oddsDto,isInParleyCategory: weakSelf.topCategoryView.isParley), animated: true)
            }.disposed(by: disposeBag)
        sportOddsTableView.rx.clickBetBottomSheetInfo.subscribeSuccess {[weak self] (odds, betBottomSheetInitDto) in
            guard let weakSelf = self else { return }
            UserStatus.share.checkLogin( UserStatus.share.checkLogin(BetCartManger.share.checkAddBetOrOpenBetSheet(oddsDto: odds, betBottomSheetInitDto: betBottomSheetInitDto, isInParleyCategory: weakSelf.topCategoryView.isParley, presentVC: weakSelf)))
            }.disposed(by: disposeBag)
        
        BetLeadTabbarViewController.share.rx.frontView.map{ frontView in
           return frontView == .favorite
            }.bind(to: isAllowFetchingData).disposed(by: disposeBag)
        
        isAllowFetchingData.distinctUntilChanged().subscribeSuccess({ [weak self](isShowFavorite) in
             guard let weakSelf = self else { return }
            if isShowFavorite {
                BetleadAssistiveTouch.share.setDisable([.choseLeague])
            } else {
                BetleadAssistiveTouch.share.initState()
            }
        }).disposed(by: disposeBag)
    }()
}
