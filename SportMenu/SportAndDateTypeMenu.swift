//
//  BallAndDateMenu.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/7/30.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit
class SportAndDateTypeMenu:UIView {
    private let disposeBag = DisposeBag()
    
    fileprivate let ballIcon = UIImageView(image: UIImage(named: "ball")?.blendedByColor(Themes.puple))
    fileprivate let ballTitleLabel:UILabel = {
        let label = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12, weight: .medium), alignment: .center, textColor: Themes.puple)
        label.numberOfLines = 2
        return label
    }()
    fileprivate let arrowIcon = UIImageView(image: UIImage(named: "icon-arrow-up")?.blendedByColor(Themes.puple))
    private let dateViewWidth:CGFloat = 70
    private let indicatorWidth:CGFloat = 60
    private let indicator = UIView(color: Themes.puple)
    private let dateScrollView:UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private var leadingConstrant:Constraint?
    private var dateViews = [DateView]()
    private let viewModel:SportTypeMenuViewModel
    private let separator = UIView(color: Themes.gray)
    init(viewModel:SportTypeMenuViewModel){
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        bindViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bindViewModel(){
        viewModel.dates.skip(1).map{$0.map(self.createDateView)}.subscribeSuccess {[weak self] (dateViews) in
            guard let weakSelf = self else { return }
            weakSelf.dateScrollView.subviews.forEach{$0.removeFromSuperview()}
            weakSelf.dateViews = dateViews
            dateViews.enumerated().forEach({ (index ,dateView) in
                weakSelf.dateScrollView.addSubview(dateView)
                dateView.frame = CGRect(x: CGFloat(index) * (weakSelf.dateViewWidth), y: 0, width: weakSelf.dateViewWidth, height: 44)
                dateView.rx.click.map({ _ -> Int in
                    return index
                }).bind(to: weakSelf.viewModel.selectedDateIndex)
                    .disposed(by: weakSelf.disposeBag)
            })
            weakSelf.addIndicator()
            weakSelf.dateScrollView.contentSize = CGSize(width: CGFloat(dateViews.count) * weakSelf.dateViewWidth, height: 44)
            weakSelf.dateScrollView.setContentOffset(.zero, animated: false)
            }.disposed(by: disposeBag)
        
        viewModel.selectedSport.subscribeSuccess { [weak self](sportDto) in
             guard let weakSelf = self else { return }
            weakSelf.ballIcon.image = UIImage(named: "ball")?.blendedByColor(Themes.puple)
            weakSelf.ballTitleLabel.text = sportDto.sportName
        }.disposed(by: disposeBag)
        
        viewModel.selectedDateIndex.subscribeSuccess(setDateSelected).disposed(by: disposeBag)
        
    }
    private func setupViews(){
        
        addSubview(separator)
        addSubview(ballIcon)
        addSubview(ballTitleLabel)
        addSubview(arrowIcon)
        addSubview(dateScrollView)
        
        ballIcon.snp.makeConstraints { (maker) in
            maker.leading.equalTo(32)
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 18, height: 18))
        }
        ballTitleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(ballIcon.snp.trailing).offset(6)
            maker.width.equalTo(36)
        }
        arrowIcon.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 14, height: 14))
            maker.leading.equalTo(ballTitleLabel.snp.trailing).offset(6)
        }
        separator.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.size.equalTo(CGSize(width: 1, height: 24))
            maker.leading.equalTo(arrowIcon.snp.trailing).offset(15)
        }
        dateScrollView.snp.makeConstraints { (maker) in
            maker.top.bottom.trailing.equalToSuperview()
            maker.leading.equalTo(separator.snp.trailing).offset(15)
        }
       
    }
    func addIndicator(){
        dateScrollView.addSubview(indicator)
        indicator.frame = CGRect(x: (dateViewWidth - indicatorWidth)/2, y: 41, width: indicatorWidth, height: 3)
    }
    
    func setDateSelected(index:Int){
        guard index < dateViews.count  else { return }
        dateViews.forEach({$0.setSelected(false)})
        dateViews[index].setSelected(true)
        let offset = CGFloat(index) * dateViewWidth
        let contenOffset = dateScrollView.contentSize.width - dateScrollView.frame.size.width
        dateScrollView.setContentOffset(CGPoint(x: offset < contenOffset ? offset : contenOffset , y: 0) , animated: true)
        UIView.animate(withDuration: 0.2) {
            self.indicator.frame = CGRect(x: offset + (self.dateViewWidth - self.indicatorWidth)/2, y: 41, width: self.indicatorWidth, height: 3)
        }
        
    }
    
    private func createDateView(dateStr:String) -> DateView {
        let topLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12, weight: .medium), alignment: .center, textColor: Themes.gray)
        let bottomLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 12, weight: .medium), alignment: .center, textColor: Themes.gray)
        let date = DateHelper.share.getDateFromString(date: dateStr, dateForm: .date)
        topLabel.text = DateHelper.share.dateString(with: date, dateFormatter: .menuDate)
        bottomLabel.text = DateHelper.share.weekDateString(with: date)
        let view = DateView()
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        topLabel.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(view.snp.centerY).offset(2)
        }
        bottomLabel.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(view.snp.centerY).offset(2)
        }
        return view
    }
    class DateView:UIView {
        func setSelected(_ isSelected:Bool) {
            subviews.map{$0 as? UILabel}.forEach{$0?.textColor = isSelected ? Themes.puple : Themes.gray}
        }
    }
    
}

extension Reactive where Base:SportAndDateTypeMenu {
    var clickExpand:Observable<Void> {
        return Observable.merge(base.ballIcon.rx.click,base.ballTitleLabel.rx.click , base.arrowIcon.rx.click)
    }
}

