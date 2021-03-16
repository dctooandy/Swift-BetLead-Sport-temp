//
//  FavoriteSportTypeBottomSheetViewModel.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/12.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class FavoriteSportTypeBottomSheetViewModel:BaseViewModel {
    private var _selectedSportTypes = [SportTypeDto]()
    let selectedSportTypes = BehaviorRelay<[SportTypeDto]>(value:[SportTypeDto]())
    let selectedSportType =  PublishSubject<SportTypeDto>()
    let isEnableNext:Observable<Bool>
    let numberOfselectedSportTypes:Observable<String>
    
    let sportTypes:Observable<[SportTypeDto]>
    init(sportTypes:Observable<[SportTypeDto]> ){
        self.sportTypes = sportTypes
        isEnableNext = selectedSportTypes.map{ $0.count >= 3}
        numberOfselectedSportTypes =  selectedSportTypes.map{ SportTypeDtos in
            let count = SportTypeDtos.count
            guard count > 0 else {return "0"}
            return count < 10 ? "0\(count)" : "\(count)"
        }
        super.init()
        selectedSportType.map {[weak self] (sportTypeDto) -> [SportTypeDto] in
             guard let weakSelf = self else { return []}
            if weakSelf.setSelectedStatus(sportTypeDto) {
                if  let index = weakSelf._selectedSportTypes.firstIndex(where: { $0.value == sportTypeDto.value}){
                weakSelf._selectedSportTypes.remove(at: index)
                }
            } else {
                weakSelf._selectedSportTypes.append(sportTypeDto)
            }
            return weakSelf._selectedSportTypes
            }.bind(to: selectedSportTypes)
            .disposed(by: disposeBag)
        
    }
    
    func setSelectedStatus(_ sportTypeDto:SportTypeDto) -> Bool{
        return _selectedSportTypes.contains(where: {$0.value == sportTypeDto.value})
    }
}
