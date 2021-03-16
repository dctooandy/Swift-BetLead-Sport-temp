//
//  LikeSportLeagueViewModel.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/8.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FavoriteSportLeagueViewModel:BaseViewModel {
    typealias SportDict = [Int:[Int]]
    private let sportTypes:[SportTypeDto]
    private let sportService:SportServiceApi
    private var fullDict = SportDict()
    private var tempDict = SportDict()
    private var selectSections = [Int]()
    private var localLikeSportPostDto = [LikeSportPostDto]()
    private let selectedDict = BehaviorRelay<SportDict>(value: SportDict())
    let selectedIndexPath = PublishSubject<IndexPath>()
    let selectedSection = PublishSubject<Int>()
    let selectedSportPost = PublishSubject<[LikeSportPostDto]>()
    let competitions = BehaviorRelay<[[CompetitionInfoDto]]>(value: [[CompetitionInfoDto]]())
    let likeSportPostDto = BehaviorRelay<[LikeSportPostDto]>(value: [LikeSportPostDto]())
    let firstLoad = PublishSubject<Void>()
    let reload = PublishSubject<Void>()
    private var _isExpand = false
    let isExpand = PublishSubject<Bool>()
    init(sportService:SportServiceApi , sportTypes:[SportTypeDto] , changeExpand:Observable<Void> ){
        self.sportTypes = sportTypes
        self.sportService = sportService
        super.init()
        localLikeSportPostDto = UserDefaults.FavoriteSportInfo.decoderData(type: [LikeSportPostDto].self, forKey: .favoriteSportPosts) ?? []
        
        changeExpand.map({[weak self] (_) -> Bool in
             guard let weakSelf = self else { return false}
            weakSelf._isExpand = !weakSelf._isExpand
            return weakSelf._isExpand
        }).bind(to: isExpand)
            .disposed(by: disposeBag)
        
        selectedIndexPath.map { [weak self](indexPath) -> SportDict in
            guard let weakSelf = self ,
                var selectedRows = weakSelf.tempDict[indexPath.section]
                else { return self?.tempDict ?? SportDict()}
            if selectedRows.contains(indexPath.row) {
                selectedRows =  selectedRows.filter{$0 != indexPath.row}
            } else {
                selectedRows.append(indexPath.row)
            }
            weakSelf.tempDict[indexPath.section] = selectedRows
            return weakSelf.tempDict
            }.bind(to: selectedDict)
            .disposed(by: disposeBag)
        
        selectedSection.map {[weak self] section -> SportDict in
            guard let weakSelf = self ,
                var selectedRows = weakSelf.tempDict[section]
                else { return self?.tempDict ?? SportDict()}
            if weakSelf.selectSections.contains(section) {
                selectedRows = weakSelf.fullDict[section] ?? []
                weakSelf.selectSections.removeAll(where: {$0 == section})
            } else {
                selectedRows = []
                weakSelf.selectSections.append(section)
            }
            weakSelf.tempDict[section] = selectedRows
            return weakSelf.tempDict
            }.bind(to: selectedDict)
            .disposed(by: disposeBag)
        
        sportService.getComps(sportType: sportTypes).map {[weak self] (competitions) -> [[CompetitionInfoDto]] in
             guard let weakSelf = self else { return [[]]}
            let comps = competitions.map({ (competition) -> [CompetitionInfoDto] in
                return Array(Set(competition.groups.flatMap{$0.competitions}))
            })
            comps.enumerated().forEach({ (index, comp) in
                weakSelf.fullDict[index] = Array(0..<comp.count)
                let localSportIds = weakSelf.localLikeSportPostDto.map{$0.sport_id }
                let localCompIds = weakSelf.localLikeSportPostDto.flatMap{$0.competitions.map{$0.competition_id}}
                if localSportIds.contains(competitions[index].sportId.toString()){
                 weakSelf.tempDict[index] = comp.enumerated().reduce([Int]()) { (result, indexAndcom) -> [Int] in
                        var localComp = result
                        if localCompIds.contains(indexAndcom.element.competitionId){
                            localComp.append(indexAndcom.offset)
                        }
                        return localComp
                    }
                } else {
                    weakSelf.tempDict[index] = Array(0..<comp.count)
                }
            })
            return comps
            }.asObservable()
            .do( afterNext:{[weak self] _ in
                 guard let weakSelf = self else { return }
                weakSelf.firstLoad.onNext(())
                weakSelf.selectedDict.accept(weakSelf.tempDict)
            })
            .bind(to: competitions)
            .disposed(by: disposeBag)
        
        selectedDict.skip(1).map { [weak self](sportDict) -> [LikeSportPostDto] in
             guard let weakSelf = self else { return []}
          return  sportDict.map({ (section, rows) -> LikeSportPostDto in
                weakSelf.reload.onNext(())
                let sportType = sportTypes[section]
                let comps = rows.map{ weakSelf.competitions.value[section][$0]}
                return LikeSportPostDto(sport_id: sportType.value.toString(), competitions: comps.map{CompetitionPosDto(competition_id: $0.competitionId)})
            })
            }.bind(to: likeSportPostDto)
            .disposed(by: disposeBag)
        
    }
    
    func isSelected(at indexpath:IndexPath) -> Bool {
        guard let selectedRows = tempDict[indexpath.section] else { return false }
        return selectedRows.contains(indexpath.row)
    }
    
    func getHeaderInfo(at section:Int) -> (String,Int,Int,Bool) {
        return (sportTypes[section].display,
                selectedDict.value[section]?.count ?? 0,
                competitions.value[section].count,
                !selectSections.contains(section))
    }
    func getCellInfo(at indexPath:IndexPath) -> (String,Bool) {
        return (competitions.value[indexPath.section][indexPath.row].competitionName,
                selectedDict.value[indexPath.section]?.contains(indexPath.row) ?? false)
    }
    var numberOfSection:Int {
        return competitions.value.count
    }
    func numberOfRow(In section:Int) -> Int {
        return competitions.value[section].count
    }
    
    func firstUpdate() -> Observable<Bool> {
        return FavoriteManger.share.updateLikeSporte(likeSportPostDto: likeSportPostDto.value , isFirstTime: true)
    }
    func update() -> Observable<Bool> {
        return FavoriteManger.share.updateLikeSporte(likeSportPostDto: likeSportPostDto.value)
    }
}
