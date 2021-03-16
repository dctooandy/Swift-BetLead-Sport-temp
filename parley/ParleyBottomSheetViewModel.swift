//
//  ParleyBottomSheetViewModel.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/27.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Toaster
class ParleyBottomSheetViewModel:BaseViewModel {
    
    let deleteParleyBetDto = PublishSubject<ParleyBetDto>()
    private var totalParleyBetDtos = [ParleyBetDto]()
    let currentParleyBettDtos = BehaviorRelay<[ParleyBetDto]>(value: [])
    private  let addBetSlipPostDto = BehaviorRelay<[AddBetSlipPostDto]>(value: [AddBetSlipPostDto]())
    let betSlipDto = PublishSubject<BetSlipDto>()
    let betEntriesResponses = BehaviorRelay<[BetEntriesResponseDto]>(value: [BetEntriesResponseDto]())
    let betDetailDtos = BehaviorRelay<[BetDetailDto]>(value: [BetDetailDto]())
    let isEnableBet:Observable<Bool>
    let reload = PublishSubject<Void>()
    let balance:Observable<BalanceDto>
    let sportService: SportServiceApi
    private var oddsDict = [String:Double]()
    private var oddsStrDict = [String:NSAttributedString]()
    init(sportService:SportServiceApi, totalParleyBottomSheetInitDtos :[ParleyBetDto]) {
        self.totalParleyBetDtos = totalParleyBottomSheetInitDtos
         currentParleyBettDtos.accept(totalParleyBottomSheetInitDtos)
         oddsDict = totalParleyBottomSheetInitDtos.reduce([String:Double]()){ (result, parleyBetDto) -> [String:Double] in
            var oddsDict = result
            oddsDict[parleyBetDto.addBetSlipPostDto.eventId] =  parleyBetDto.addBetSlipPostDto.odds
            return oddsDict
        }
        self.balance = sportService.getBalance().asObservable().catchError({ (error) -> Observable<BalanceDto> in
            ErrorHandler.show(error: error)
            return Observable<BalanceDto>.empty()
        })
        isEnableBet = currentParleyBettDtos.map{$0.count > 1}
        self.sportService = sportService
        super.init()
        deleteParleyBetDto.map {[weak self] (parleyBetDto) -> [ParleyBetDto] in
             guard let weakSelf = self else { return []}
            weakSelf.totalParleyBetDtos =  weakSelf.totalParleyBetDtos.filter{$0.addBetSlipPostDto.eventId != parleyBetDto.addBetSlipPostDto.eventId}
            BetCartManger.share.addBet(parleyBetDto)
            return weakSelf.totalParleyBetDtos
        }.bind(to: currentParleyBettDtos)
        .disposed(by: disposeBag)
        
        currentParleyBettDtos.map { $0.map{$0.addBetSlipPostDto}}
            .bind(to: addBetSlipPostDto)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(Observable<Int>.timer(0,period:5, scheduler: MainScheduler.instance) , addBetSlipPostDto)
            .do(onNext: {[weak self]( _ ,addBetSlipPostDtoa) in
                 guard let weakSelf = self else { return }
                if addBetSlipPostDtoa.isEmpty && !weakSelf.betDetailDtos.value.isEmpty {
                    weakSelf.betDetailDtos.accept([])
                    weakSelf.betEntriesResponses.accept([])
                  }
                }
            )
            .filter{!$1.isEmpty}
            .map{$1}
            .flatMap(Beans.sportServer.addBetSlip)
            .bind(to: betSlipDto)
            .disposed(by: disposeBag)
        
        betSlipDto.map{$0.bets}.bind(to: betDetailDtos ).disposed(by: disposeBag)
        betSlipDto.map{$0.betEntriesResponse}.bind(to: betEntriesResponses).disposed(by: disposeBag)
        
        betEntriesResponses.subscribeSuccess {[weak self] (betEntriesResponseDtos) in
             guard let weakSelf = self else { return }
            betEntriesResponseDtos.forEach({ betEntriesResponseDto in
                let eventId = betEntriesResponseDto.eventId.toString()
                let oldOdds = weakSelf.oddsDict[eventId] ?? betEntriesResponseDto.odds
                let newOdds = betEntriesResponseDto.odds
                weakSelf.oddsStrDict[eventId] = Themes.getOddsStr(old: oldOdds, new: newOdds,normalColor: Themes.brownGrey )
                weakSelf.oddsDict[eventId] = newOdds
            })
            weakSelf.reload.onNext(())
        }.disposed(by: disposeBag)
        
    }
    
    func getCellOdds(row:Int) -> NSAttributedString {
        guard row < betEntriesResponses.value.count else { return NSAttributedString(string: "\(currentParleyBettDtos.value[row].addBetSlipPostDto.odds)")}
        let betEntriesRespone =  betEntriesResponses.value[row]
        return oddsStrDict[betEntriesRespone.eventId.toString()] ?? NSAttributedString(string: "\(betEntriesRespone.odds)")
    }
    
    func clearAll() -> Observable<Void>{
        currentParleyBettDtos.accept([])
        BetCartManger.share.clearAll()
        return Observable.just(())
    }
    
    var getLatestAddBetSlipPostDtos: Observable<[AddBetSlipPostDto]> {
      return addBetSlipPostDto.enumerated().map {[weak self] (index, addBetSlipPostDtos) -> [AddBetSlipPostDto] in
             guard let weakSelf = self else { return [AddBetSlipPostDto]()}
        print(weakSelf.oddsDict.values)
        return addBetSlipPostDtos.map{AddBetSlipPostDto(eventId: $0.eventId, isInPlay: $0.isInPlay, odds: (weakSelf.oddsDict[$0.eventId]  ?? $0.odds), selectionId: $0.selectionId, handicap: $0.handicap, score: $0.score)}
        }
    }
    
    func placeBet(addBetSlipPostDto:[AddBetSlipPostDto],betAmounts:[BetAmountsPostDto]) -> Observable<BetStatus> {
        let result = PublishSubject<BetStatus>()
        sportService.placeBet(betAmounts:betAmounts, addBetSlipPostDto: addBetSlipPostDto).subscribeSuccess {[weak self] (betSlipDto) in
            guard let weakSelf = self else { return }
            if betSlipDto.isBetSuccess {
                result.onNext(.success)
            } else if betSlipDto.isOddsChange {
                betSlipDto.betEntriesResponse.forEach({ (betEntriesResponseDto) in
                    let eventId = betEntriesResponseDto.eventId.toString()
                    let oldOdds = weakSelf.oddsDict[eventId] ?? betEntriesResponseDto.odds
                    let newOdds = betEntriesResponseDto.renewOdds
                    weakSelf.oddsStrDict[eventId] = Themes.getOddsStr(old: oldOdds, new: newOdds ,normalColor: Themes.brownGrey)
                    weakSelf.oddsDict[eventId] = newOdds
                    weakSelf.reload.onNext(())
                })
                Toast.show(msg: "賠率已更新 请重新下注")
                result.onNext(.none)
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    ErrorHandler.show(error: ApiServiceError.domainError(405, betSlipDto.errorMessage))
                })
                result.onNext(.failure)
            }
            }.disposed(by: disposeBag)
        return result
    }
    
}
