//
//  ParleyPlaceBetViewModel.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/27.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class ParleyPlaceBetViewModel:BaseViewModel {
    
    let isExpand = PublishSubject<Bool>()
    let betSlipDto = PublishSubject<BetSlipDto>()
    let enterPriceAtRow = PublishSubject<(Double,Int)>()
    let amountBet = BehaviorRelay<Double>(value: 0)
    let amountWinPrice = PublishSubject<Double>()
    let betDetailDtos:BehaviorRelay<[BetDetailDto]>
    let activeTextfieldAtRow = PublishSubject<Int>()
    let activeCellY = PublishSubject<CGFloat>()
    private var _betDict = [Int:Double]()
    private var _betAmountsPostDto = [BetAmountsPostDto]()
    let betAmountsPostDto = BehaviorRelay<[BetAmountsPostDto]>(value: [BetAmountsPostDto]())
    private let betDict = PublishSubject<[Int:Double]>()
    private var _isExpand = false
    
    init(sportService:SportServiceApi,betDetailDtos: BehaviorRelay<[BetDetailDto]>, clickArrow:Observable<Void>){
        self.betDetailDtos = betDetailDtos
        super.init()
        clickArrow.map { [weak self](_) -> Bool in
            guard let weakSelf = self else { return false}
            weakSelf._isExpand = !weakSelf._isExpand
            return weakSelf._isExpand
            }.bind(to: isExpand)
            .disposed(by: disposeBag)
        
        enterPriceAtRow.map {[weak self] (price,row) -> [Int:Double] in
            guard let weakSelf = self else { return [Int:Double]()}
            weakSelf._betDict[row] = price
            return weakSelf._betDict
            }.bind(to: betDict)
            .disposed(by: disposeBag)
        enterPriceAtRow.map {[weak self] (price,row) -> [BetAmountsPostDto] in
            guard let weakSelf = self else { return [BetAmountsPostDto]()}
            let removeBet = weakSelf._betAmountsPostDto.remove(at: row)
            weakSelf._betAmountsPostDto.insert(BetAmountsPostDto(type: removeBet.type, amount: "\(price)"), at: row)
            return weakSelf._betAmountsPostDto
            }.bind(to: betAmountsPostDto)
            .disposed(by: disposeBag)
        
        betDetailDtos.distinctUntilChanged { (old , new) -> Bool in
            return old.count == new.count
            }.subscribeSuccess {[weak self] (betDetailDtos) in
                 guard let weakSelf = self else { return }
                weakSelf._betDict = [Int:Double]()
                weakSelf.betDict.onNext([Int:Double]())
                weakSelf._betAmountsPostDto = betDetailDtos.map{BetAmountsPostDto(type: $0.wagerType ?? "", amount: "0")}
                weakSelf.betAmountsPostDto.accept(weakSelf._betAmountsPostDto)
        }.disposed(by: disposeBag)
        
        let betDictAndBetDetail = Observable.combineLatest(betDict,betDetailDtos).filter{!$1.isEmpty}
        
        betDictAndBetDetail.map {(dict ,betDetailDtos ) -> Double in
            return  dict.map({ (row,price) -> Double in
                return betDetailDtos[row].odds * Double(betDetailDtos[row].numberOfCombination) * price
            }).reduce(0, +)
            }.bind(to: amountWinPrice)
            .disposed(by: disposeBag)
        
        betDictAndBetDetail.map {(dict ,betDetailDtos ) -> Double in
            return  dict.map({ (row,price) -> Double in
                return Double(betDetailDtos[row].numberOfCombination) * price
            }).reduce(0, +)
            }.bind(to: amountBet)
            .disposed(by: disposeBag)
    }
    
    func getPrice(row:Int) -> Double? {
        return _betDict[row]
    }
    
}

