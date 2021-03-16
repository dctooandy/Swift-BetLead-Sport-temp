//
//  ParleyBottomSheet.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/27.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import Toaster
class ParleyBottomSheet:BottomSheet {
    private let titleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 20, weight: .semibold), textColor: Themes.darkGrey, text: "串关投注单")
    private lazy var clearBetBtn = makeBtn(title: "清除投注")
    private lazy var dismissBtn = makeBtn(title: "稍后投注")
    private lazy var tableView:UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.registerCell(type: ParleyBetTableViewCell.self)
        tableview.tableFooterView = UIView()
        tableview.separatorInset = UIEdgeInsets.zero
        return tableview
    }()
    private var parleyPlaceBetViewHeightConstraint:Constraint?
    private let bottombetView = UIView(color: Themes.purpleBase)
    private let amountLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12), textColor: .white, text: "总投注额 ¥ 0.00")
    private let prizeLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10), textColor: .white, text: "总可赢额 ¥ 0.00")
    private let placeBetBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("投注", for: .normal)
        btn.setTitleColor(Themes.purpleBase, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setBackgroundImage(UIImage(color: UIColor.white.withAlphaComponent(0.5)) , for: .disabled)
        btn.setBackgroundImage(UIImage(color: UIColor.white) , for: .normal)
        btn.applyCornerRadius(radius: 16)
        return btn
    }()
    private func makeBtn(title:String) -> UIButton {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = Themes.peachGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.applyCornerRadius(radius: 10)
        return btn
    }
    private lazy var parleyPlaceBetView = ParleyPlaceBetView(betDetailDtos: viewModel.betDetailDtos)
    private let parleyBottomSheetInitDtos:[ParleyBetDto]
    private let viewModel:ParleyBottomSheetViewModel
    init(parleyBottomSheetInitDtos:[ParleyBetDto]) {
        self.parleyBottomSheetInitDtos = parleyBottomSheetInitDtos
        self.viewModel = ParleyBottomSheetViewModel(sportService:Beans.sportServer,totalParleyBottomSheetInitDtos: parleyBottomSheetInitDtos)
        super.init(nil)
        bindViews()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(_ parameters: Any? = nil) {
        fatalError("init(_:) has not been implemented")
    }
    override func setupViews() {
        super.setupViews()
        defaultContainer.addSubview(titleLabel)
        defaultContainer.addSubview(clearBetBtn)
        defaultContainer.addSubview(dismissBtn)
        defaultContainer.addSubview(tableView)
        defaultContainer.addSubview(parleyPlaceBetView)
        defaultContainer.addSubview(bottombetView)
        bottombetView.addSubview(amountLabel)
        bottombetView.addSubview(prizeLabel)
        bottombetView.addSubview(placeBetBtn)
        defaultContainer.snp.makeConstraints { (maker) in
            maker.top.equalTo(70)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(45)
            maker.leading.equalTo(32)
        }
        dismissBtn.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-32)
            maker.size.equalTo(CGSize(width: 62, height: 20) )
            maker.centerY.equalTo(titleLabel)
        }
        clearBetBtn.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(dismissBtn.snp.leading).offset(-12)
            maker.size.equalTo(dismissBtn)
            maker.centerY.equalTo(titleLabel)
        }
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(16)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(parleyPlaceBetView.snp.top)
        }
        parleyPlaceBetView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            parleyPlaceBetViewHeightConstraint = maker.height.equalTo(90).constraint
            maker.bottom.equalTo(bottombetView.snp.top)
        }
        bottombetView.snp.makeConstraints { (maker) in
            maker.top.equalTo(parleyPlaceBetView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(56 + Views.bottomOffset)
            maker.bottom.equalToSuperview()
        }
        amountLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(12)
            maker.leading.equalTo(32)
        }
        prizeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(amountLabel.snp.bottom).offset(1)
            maker.leading.equalTo(amountLabel)
        }
        placeBetBtn.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-32)
            maker.top.equalTo(12)
            maker.size.equalTo(CGSize(width: 135, height: 32) )
        }
        view.layoutIfNeeded()
        defaultContainer.roundCorner(corners: [.topLeft,.topRight], radius: 25)
    }
    
    private func bindViewModel(){
        Observable.combineLatest(viewModel.isEnableBet,parleyPlaceBetView.rx.amountBet).subscribeSuccess {[weak self] (isEnable,bet) in
            guard let weakSelf = self else { return }
            weakSelf.placeBetBtn.isEnabled = isEnable && bet > 0
            }.disposed(by: disposeBag)
        
        viewModel.reload.subscribeSuccess {[weak self] (_) in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            }.disposed(by: disposeBag)
        
        
    }
    private func bindViews(){
        parleyPlaceBetView.rx.isExpand.map { $0 ? Views.screenHeight - 70 - 85 - (56 + Views.bottomOffset) : 90}
            .subscribeSuccess {[weak self] (height) in
                guard let weakSelf = self else { return }
                weakSelf.parleyPlaceBetViewHeightConstraint?.update(offset: height)
                UIView.animate(withDuration: 0.25, animations: {
                    weakSelf.view.layoutIfNeeded()
                })
            }.disposed(by: disposeBag)
        parleyPlaceBetView.rx.amountBet.subscribeSuccess { [weak self](amountBet) in
            guard let weakSelf = self else { return }
            weakSelf.amountLabel.text = "总投注额 " + "\(amountBet)".numberFormatter(.currency, 2)
            }.disposed(by: disposeBag)
        parleyPlaceBetView.rx.amountWinPrice.subscribeSuccess { [weak self](amountPrize) in
            guard let weakSelf = self else { return }
            weakSelf.prizeLabel.text = "总可赢额 " + "\(amountPrize)".numberFormatter(.currency, 2)
            }.disposed(by: disposeBag)
        
        dismissBtn.rx.tap.subscribeSuccess {[weak self] (_) in
            guard let weakSelf = self else { return }
            weakSelf.dismissVC()
            }.disposed(by: disposeBag)
        
        clearBetBtn.rx.tap.flatMap{[weak self] (_) -> Observable<Bool> in
            guard let weakSelf = self else { return Observable.just(false)}
            let newVC = BetleadSportDialog(content: "确定清除目前的串关纪录吗？", okTitle: "清除投注", cancelTitle: "否")
            newVC.start(viewController: weakSelf)
            return newVC.rxClickResult
            }.flatMap({[weak self] (isClear) -> Observable<Bool> in
                guard let weakSelf = self else { return  Observable.just(false)}
                return isClear ? weakSelf.viewModel.clearAll().map{_ in true} : Observable.just(false)
            })
            .subscribeSuccess {[weak self] (isDismissVC) in
                guard let weakSelf = self else { return }
                weakSelf.dismissVC()
                if isDismissVC {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        weakSelf.dismissVC()
                    })
                }
            }.disposed(by: disposeBag)
        
        
        let combinPlacedBet = Observable.combineLatest(parleyPlaceBetView.rx.betAmountsPostDto,
                                 viewModel.getLatestAddBetSlipPostDtos,
                                 viewModel.balance,
                                 parleyPlaceBetView.rx.amountBet)
        
        placeBetBtn.rx.tap.flatMap{ _ in combinPlacedBet.take(1)}
            .flatMap { [weak self] (betAmountsPostDtos, addBetSlipPostDtos , balanceDto , bet) -> Observable<BetStatus> in
                guard let weakSelf = self
                    else { return  Observable.just(.none)}
                betAmountsPostDtos.forEach({ (BetAmountsPostDto) in
                    print("\(BetAmountsPostDto.type)  \(BetAmountsPostDto.amount)")
                })
                addBetSlipPostDtos.forEach({ (BetAmountsPostDto) in
                    print("\(BetAmountsPostDto.odds)")
                })
                if bet > balanceDto.balance {
                    Toast.show(msg: "余额不足")
                    return Observable.just(.none)
                }
                return weakSelf.viewModel.placeBet(addBetSlipPostDto:addBetSlipPostDtos,betAmounts:betAmountsPostDtos)
            }.subscribeSuccess {[weak self] (status) in
                guard let weakSelf = self else { return }
                switch status {
                case .none:
                    return
                case .success:
                    weakSelf.dismissVC(nextSheet: BetResultBottomSheet(status: .success))
                    BetleadAssistiveTouch.share.refreshBalance()
                    BetCartManger.share.clearAll()
                    BetResultBottomSheet(status: .success,isParley: true).start(viewController: weakSelf)
                case .failure:
                    let newVC = BetResultBottomSheet(status: .failure,isParley: true)
                    newVC.nextSheetVC = self
                    weakSelf.dismissVC(nextSheet: newVC)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}

extension ParleyBottomSheet:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentParleyBettDtos.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: ParleyBetTableViewCell.self, indexPath: indexPath)
        cell.configureCell(parleyBottomSheetInitDto: viewModel.currentParleyBettDtos.value[indexPath.row] ,row:indexPath.row, oddsStr: viewModel.getCellOdds(row: indexPath.row) , deleteParleyBottomSheetInitDto:viewModel.deleteParleyBetDto)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
