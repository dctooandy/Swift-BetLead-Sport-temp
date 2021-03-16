//
//  BallTypeMenuViewModel.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/7/29.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class SportTypeMenuViewModel:BaseViewModel {
    
    let sports = BehaviorRelay<[SportDto]>(value: [SportDto]())
    let selectedSportIndex = BehaviorRelay<Int>(value: 0)
    let selectedDate:Observable<String>
    let selectedDateIndex = BehaviorRelay<Int>(value: 0)
    let selectedSport:Observable<SportDto>
    let reload = PublishSubject<Void>()
    let categoryDetail = PublishSubject<CategoryDetailDto>()
    let sportTypeViewIndexAndCount = PublishSubject<(Int,Int)?>()
    let isExpand = BehaviorRelay<Bool>(value:false)
    let dates = BehaviorRelay<[String]>(value: [String]())
    init(sportService:SportServiceApi ){
        selectedSport = Observable.combineLatest(sports.asObservable().skip(1),selectedSportIndex.asObservable(), resultSelector: { sports, index -> SportDto? in
            if index >= sports.count {return nil}
            return sports[index]
        }).compactMap{$0}
        selectedDate = Observable.combineLatest(dates.asObservable().skip(1),selectedDateIndex.asObservable(), resultSelector: { dates, index -> String in
            return dates.count == 0 ? "" : dates[index]
        }).filter{$0 != ""}
        super.init()
        
        categoryDetail.map{$0.sports}.bind(to: sports).disposed(by: disposeBag)
    }
    
    private func createDates() -> [Date] {
        let today = Date()
        return (0...7).map{today.addingTimeInterval(Double($0)*24*60*60)}
    }
    func reset(_ categoryDetailDto:CategoryDetailDto){
        categoryDetail.onNext(categoryDetailDto)
        selectedSportIndex.accept(0)
        selectedDateIndex.accept(0)
        isExpand.accept(false)
    }
    
}

