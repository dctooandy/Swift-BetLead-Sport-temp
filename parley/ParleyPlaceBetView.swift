//
//  PlaceBetView.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/27.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class ParleyPlaceBetView:UIView {
    private let separator = UIView(color: Themes.grayLightest)
    private let disposeBag = DisposeBag()
    private let titleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12), textColor: Themes.purpleBase, text: "更多串关投注类型")
    private let downArrow = UIImageView(image: UIImage(named: "icon-arrow-down") )
    private lazy var tableView:UITableView = {
        let tableview = UITableView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorInset = UIEdgeInsets.zero
        tableview.tableFooterView = UIView()
        tableview.registerCell(type: ParleyPlaceBetTableViewCell.self)
        return tableview
    }()
    private var keyboardHeight:CGFloat = 337 + Views.bottomOffset
    fileprivate let viewModel: ParleyPlaceBetViewModel
    init(betDetailDtos: BehaviorRelay<[BetDetailDto]>) {
        self.viewModel = ParleyPlaceBetViewModel(sportService:Beans.sportServer ,betDetailDtos:betDetailDtos,clickArrow: downArrow.rx.click)
        super.init(frame: CGRect.zero)
        setupViews()
        bindViewModel()
        bindViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bindViews(){
        
    }
    private let cellHeight:CGFloat = 63
    private func bindViewModel(){
        viewModel.isExpand.subscribeSuccess { [weak self](isExpand) in
             guard let weakSelf = self else { return }
            weakSelf.downArrow.transform = isExpand ? CGAffineTransform(rotationAngle: CGFloat.pi + 0.01) : CGAffineTransform.identity
        }.disposed(by: disposeBag)
        
        viewModel.betDetailDtos.distinctUntilChanged({ (oldDtos, newDtos) -> Bool in
           return oldDtos.map{$0.betSetting.maxBet} == newDtos.map{$0.betSetting.maxBet} &&
                  oldDtos.map{$0.betSetting.minBet} == newDtos.map{$0.betSetting.minBet}
        }).subscribeSuccess { [weak self](_) in
             guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }.disposed(by: disposeBag)
        
        viewModel.activeCellY.subscribeSuccess { [weak self] cellY in
             guard let weakSelf = self else { return }
             let cotentOffsetY = weakSelf.tableView.contentOffset.y
             let absoluteCellY = cellY - cotentOffsetY
             let gap = (Views.screenHeight - (70 + absoluteCellY + 85 + 7 + weakSelf.cellHeight)) - weakSelf.keyboardHeight
             if gap < 0 {
                weakSelf.tableView.setContentOffset(CGPoint(x:0,y:cotentOffsetY - gap), animated: true)
            }
        }.disposed(by: disposeBag)
        
    }
    private func setupViews(){
        addSubview(separator)
        addSubview(tableView)
        addSubview(downArrow)
        addSubview(titleLabel)
        
        separator.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(1)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(32)
            maker.top.equalTo(16)
        }
        downArrow.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-32)
            maker.size.equalTo(CGSize(width: 14, height: 14))
            maker.centerY.equalTo(titleLabel)
        }
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(-7)
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension ParleyPlaceBetView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.betDetailDtos.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: ParleyPlaceBetTableViewCell.self, indexPath: indexPath)
        cell.configureCell(betDetailDto: viewModel.betDetailDtos.value[indexPath.row], row: indexPath.row, enterPriceAtRow: viewModel.enterPriceAtRow, activeTextfieldAtRow: viewModel.activeTextfieldAtRow , activeCellY: viewModel.activeCellY ,price:viewModel.getPrice(row: indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension Reactive where Base:ParleyPlaceBetView {
    var isExpand:Observable<Bool>{
        return base.viewModel.isExpand.asObserver()
    }
    var amountBet:Observable<Double> {
        return base.viewModel.amountBet.asObservable()
    }
    var amountWinPrice:Observable<Double> {
        return base.viewModel.amountWinPrice
    }
    var betAmountsPostDto:Observable<[BetAmountsPostDto]> {
        return base.viewModel.betAmountsPostDto.asObservable()
    }
}
