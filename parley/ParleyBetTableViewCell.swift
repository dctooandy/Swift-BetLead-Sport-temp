//
//  ParleyBetTableViewCell.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/27.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class ParleyBetTableViewCell:UITableViewCell {
    private let icon = UIImageView(image: UIImage(named: "icon-home") )
    private let competitionLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12), textColor: Themes.puple, text: "欧洲足球联赛2020外围赛")
    private let teamLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10), textColor: Themes.brownGrey, text: "国际米兰足球俱乐部")
    private let dateLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10), textColor: Themes.brownGrey, text: "2019/06/24  21:00")
    private let oddsNameLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10), textColor: Themes.puple, text: "15分鐘進球數：下半場開始-59:59分鐘-大/小")
    private let oddsTitleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10), textColor: Themes.brownGrey, text: "国际米兰足球俱乐部")
    private let oddsLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10), textColor: Themes.brownGrey, text: "@1.72")
    private let deleteIcon = UIImageView(image: UIImage(named: "icon-circle-close")?.blendedByColor(Themes.puple))
    private let serialLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 60,weight: .semibold), textColor: Themes.lightest, text: "1")
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        contentView.addSubview(icon)
        contentView.addSubview(competitionLabel)
        contentView.addSubview(teamLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(oddsNameLabel)
        contentView.addSubview(oddsTitleLabel)
        contentView.addSubview(oddsLabel)
        contentView.addSubview(deleteIcon)
        contentView.addSubview(serialLabel)
        
        icon.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 16, height: 16))
            maker.leading.equalTo(32)
            maker.top.equalTo(16)
        }
        deleteIcon.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-32)
            maker.size.equalTo(CGSize(width: 16, height: 16))
            maker.centerY.equalTo(icon)
        }
        competitionLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(icon.snp.trailing).offset(4)
            maker.centerY.equalTo(icon)
            maker.trailing.equalTo(deleteIcon.snp.leading).offset(-4)
        }
        teamLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(icon)
            maker.top.equalTo(icon.snp.bottom).offset(8)
            maker.trailing.equalTo(competitionLabel)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalTo(teamLabel)
            maker.top.equalTo(teamLabel.snp.bottom).offset(4)
        }
        oddsNameLabel.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalTo(teamLabel)
            maker.top.equalTo(dateLabel.snp.bottom).offset(4)
        }
        oddsTitleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(teamLabel)
            maker.top.equalTo(oddsNameLabel.snp.bottom).offset(4)
            maker.trailing.equalTo(oddsLabel.snp.leading).offset(-10)
        }
        oddsLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(oddsTitleLabel)
        }
        serialLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(deleteIcon)
            maker.bottom.equalToSuperview()
            
        }
    }
    
    func configureCell(parleyBottomSheetInitDto:ParleyBetDto ,row:Int,oddsStr:NSAttributedString,deleteParleyBottomSheetInitDto:PublishSubject<ParleyBetDto>){
        competitionLabel.text = parleyBottomSheetInitDto.competitionName
        teamLabel.text = "\(parleyBottomSheetInitDto.information.homeTeamName)  VS \(parleyBottomSheetInitDto.information.awayTeamName)"
        dateLabel.text = parleyBottomSheetInitDto.information.betDate
        oddsNameLabel.text = parleyBottomSheetInitDto.oddsName
        oddsTitleLabel.text = parleyBottomSheetInitDto.oddsTitle
        oddsLabel.attributedText = oddsStr
        serialLabel.text = (row + 1).toString()
        deleteIcon.rx.click.subscribeSuccess{ _  in
            deleteParleyBottomSheetInitDto.onNext(parleyBottomSheetInitDto)
        }.disposed(by: rx.reuseBag)
       
    }
}
