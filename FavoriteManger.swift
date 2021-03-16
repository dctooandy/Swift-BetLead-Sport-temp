//
//  FavoriteManger.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/14.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class FavoriteManger {
    
    static let share = FavoriteManger()
    private let disposeBag = DisposeBag()
    private var loginOddsType:OddsType =  .europe
    
    func launchAndCheckUpdate() -> Observable<Bool>{
        if UserStatus.share.isLogin && UserDefaults.FavoriteSportInfo.bool(forKey: .needUpdateToService) {
            return  Beans.sportServer.launch().flatMap{_ in Beans.sportServer.updateOddsType(oddsType:  UserDefaults.SportInfo.oddsType.rawValue)}
                .asObservable()
                .flatMap {[weak self] (isSuccess) -> Observable<Bool> in
                    guard let weakSelf = self else { return Observable.just(false)}
                    weakSelf.loginOddsType = UserDefaults.SportInfo.oddsType
                    if let likeSportPostDtos = UserDefaults.FavoriteSportInfo.decoderData(type: [LikeSportPostDto].self, forKey: .favoriteSportPosts) {
                        return  Beans.sportServer.updateLikeSport(likeSportPostDto: likeSportPostDtos).asObservable().do(onNext:{ (isSuccess) in
                            if isSuccess {
                                UserDefaults.FavoriteSportInfo.set(value: false, forKey: .needUpdateToService)
                            }
                        })
                    } else {
                        return Observable.just(false)
                    }
            }
        } else {
            return Observable.just(true)
        }
        
    }
    
    func overrideLocalSetting() -> Observable<Bool>{
        return Beans.sportServer.launch().asObservable().map({[weak self] (launchDto) -> Bool in
            guard let weakSelf = self ,
                let  oddsType = OddsType(rawValue: launchDto.oddsType.toString())
                else { return  false}
            weakSelf.loginOddsType = oddsType
            UserDefaults.SportInfo.set(value: oddsType.rawValue, forKey: .oddsType)
            return true
        }).flatMap{ _ in  Beans.sportServer.getLikeSport()
            .map{$0.map{$0.transToLikeSportPostDto()}}}
            .map { (likeSportPostDtos) -> Bool in
                if !likeSportPostDtos.isEmpty {
                UserDefaults.FavoriteSportInfo.setEncodeData(value: likeSportPostDtos, forKey: .favoriteSportPosts)
                }
                return true
        }
    }
    
    
    func checkUpdate(){
        if UserStatus.share.isLogin && UserDefaults.FavoriteSportInfo.bool(forKey: .needUpdateToService){
            if let likeSportPostDtos = UserDefaults.FavoriteSportInfo.decoderData(type: [LikeSportPostDto].self, forKey: .favoriteSportPosts) {
                Beans.sportServer.updateLikeSport(likeSportPostDto: likeSportPostDtos).subscribeSuccess { (isSuccess) in
                    if isSuccess {
                        UserDefaults.FavoriteSportInfo.set(value: false, forKey: .needUpdateToService)
                    }
                    }.disposed(by: disposeBag)
            }
        }
    }
    
    func getOddsType() -> OddsType {
        if UserStatus.share.isLogin {
            return loginOddsType
        } else {
            return UserDefaults.SportInfo.oddsType
        }
    }
    
    func updateOddsType(oddsType:OddsType , isFirstTime:Bool = false) -> Observable<Bool>{
        if UserStatus.share.isLogin {
            return Beans.sportServer.updateOddsType(oddsType: oddsType.rawValue).do(onSuccess: {[weak self] isSuccess in
                guard let weakSelf = self else { return }
                weakSelf.loginOddsType = oddsType
                if isFirstTime {
                    UserDefaults.SportInfo.set(value: oddsType.rawValue, forKey: .oddsType)
                }
            }).asObservable()
            
        } else {
            UserDefaults.SportInfo.set(value: oddsType.rawValue, forKey: .oddsType)
            return Observable.just(true)
        }
    }
    
    func updateLikeSporte(likeSportPostDto:[LikeSportPostDto] , isFirstTime:Bool = false) -> Observable<Bool>{
        if UserStatus.share.isLogin {
            return Beans.sportServer.updateLikeSport(likeSportPostDto: likeSportPostDto).asObservable().do(onNext: { isSuccess in
                if isSuccess && isFirstTime {
                    UserDefaults.FavoriteSportInfo.setEncodeData(value: likeSportPostDto, forKey: .favoriteSportPosts)
                }
            })
            
        } else {
            UserDefaults.FavoriteSportInfo.setEncodeData(value: likeSportPostDto, forKey: .favoriteSportPosts)
            return Observable.just(true)
        }
    }
    
}
