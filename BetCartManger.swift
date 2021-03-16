//
//  BetCartManger.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/19.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Toaster
class BetCartManger {
    private let disposeBag = DisposeBag()
    static let share = BetCartManger()
    private var parleyBetDtos = BehaviorRelay<[ParleyBetDto]>(value: [ParleyBetDto]())
    let selectionIds = BehaviorRelay<[String]>(value: [])
    let betCartEmpty = PublishSubject<Void>()
    var isHidden:Observable<Bool>
    var count:Observable<Int>
    init() {
        isHidden = parleyBetDtos.map{$0.count == 0}
        count = parleyBetDtos.map{$0.count}
        parleyBetDtos.map{$0.map{$0.addBetSlipPostDto}.map{$0.selectionId}}
            .skip(1)
            .bind(to: selectionIds)
            .disposed(by: disposeBag)
        
        parleyBetDtos.distinctUntilChanged { (old, new) -> Bool in
            return !new.isEmpty
            }.map { _ in ()}.bind(to: betCartEmpty)
        .disposed(by: disposeBag)
        
    }
    
    func addBet(_ parleyBottomSheetInitDto: ParleyBetDto) {
        let eventIds = parleyBetDtos.value.map{$0.addBetSlipPostDto.eventId}
        let selectionIds = parleyBetDtos.value.map{$0.addBetSlipPostDto.selectionId}
        if eventIds.contains(parleyBottomSheetInitDto.addBetSlipPostDto.eventId){
            if selectionIds.contains(parleyBottomSheetInitDto.addBetSlipPostDto.selectionId) {
                parleyBetDtos.accept(parleyBetDtos.value.filter{$0.addBetSlipPostDto.eventId != parleyBottomSheetInitDto.addBetSlipPostDto.eventId})
            }
        } else {
            parleyBetDtos.accept(parleyBetDtos.value + [parleyBottomSheetInitDto])
        }
    }
    func getParleyBottomSheetInitDtos() -> Observable<[ParleyBetDto]> {
        return parleyBetDtos.asObservable()
    }
    
    func checkAddBetOrOpenBetSheet(oddsDto: OddsWithCompetitionNameDto, betBottomSheetInitDto: BetBottomSheetInitDto, isInParleyCategory:Bool,presentVC:UIViewController ,
                                   completetion:@escaping () -> Void = {}  ) {
        
        
        let count = parleyBetDtos.value.count
        let parleyBottomSheetInitDto = ParleyBetDto(competitionName: oddsDto.competitionName, information: oddsDto.information, oddsName: betBottomSheetInitDto.oddsName, oddsTitle: betBottomSheetInitDto.oddsTitle, addBetSlipPostDto: betBottomSheetInitDto.addBetSlipPostDto)
        if isInParleyCategory {
            addBet(parleyBottomSheetInitDto)
        }
        else {
            if count == 0 {
                BetBottomSheet(oddsDto: oddsDto, betBottomSheetInitDto: betBottomSheetInitDto).start(viewController: presentVC).subscribeSuccess { (_) in
                    completetion()
                }.disposed(by: disposeBag)
            } else if oddsDto.isParlay {
                BetCartManger.share.addBet(parleyBottomSheetInitDto)
            } else {
                Toast.show(msg: "此赛事无提供串关服务")
            }
        }
    }
    
    func clearAll(){
        parleyBetDtos.accept([])
    }
    
}
