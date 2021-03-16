//
//  SportTypeView.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/8.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import RxSwift
class SportTypeView:UIView {
    private let bgImageView = UIImageView(image: UIImage(named: "bear"))
    private let chTitleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 16, weight: .semibold), alignment: .center, textColor: .white)
    private let enTitleLabel = UILabel.customLabel(font: UIFont.systemFont(ofSize: 10, weight: .semibold), alignment: .center, textColor: .white)
    private let checkIcon = UIImageView(image: UIImage(named: "icon-check"))
    private let deletedIcon = UIImageView(image: UIImage(named: "icon-circle-close"))
    private let unSelectedBgView = UIView(color: Themes.unSelectedBg.withAlphaComponent(0.65))
    private let selectedBgView = UIView(color: Themes.peach.withAlphaComponent(0.65))
    var isHideDeleteBtn = true {
        didSet {
            deletedIcon.isHidden = isHideDeleteBtn
        }
    }
    private lazy var stackView:UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalCentering
        view.addArrangedSubview(chTitleLabel)
        view.addArrangedSubview(enTitleLabel)
        view.addArrangedSubview(checkIcon)
        view.spacing = 4
        return view
    }()
    
    init(_ sportTypeDto:SportTypeDto) {
        super.init(frame: .zero)
        chTitleLabel.text = sportTypeDto.display
        enTitleLabel.text = sportTypeDto.enDisplay
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        addSubview(bgImageView)
        addSubview(unSelectedBgView)
        addSubview(selectedBgView)
        addSubview(stackView)
        addSubview(deletedIcon)
        checkIcon.contentMode = .scaleAspectFit
        bgImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        unSelectedBgView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        selectedBgView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
        chTitleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(22)
        }
        enTitleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(22)
        }
        checkIcon.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 20, height: 20))
        }
        deletedIcon.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 20, height: 20))
            maker.top.equalTo(8)
            maker.trailing.equalTo(-8)
        }
        deletedIcon.isHidden = true
        setSelected(isSelected: false)
    }
    
    func setSelected(isSelected:Bool) {
        unSelectedBgView.isHidden = isSelected
        selectedBgView.isHidden = !isSelected
        checkIcon.isHidden = !isSelected
    }
    func deleteDidClick() -> Observable<Void> {
        return deletedIcon.rx.click
    }
}
