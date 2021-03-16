//
//  BallMenu.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/7/30.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class SportTypeMenu:UIView {
    private let disposeBag = DisposeBag()
    private lazy var ballCollectionView:UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.registerCell(type: SportTypeCollectionViewCell.self)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    fileprivate lazy var flowLayout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 24)
        layout.minimumLineSpacing = 24
        return layout
    }()
    fileprivate let cellSize = CGSize(width: 24, height: 44)
    fileprivate let expandBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon-triangle-down"), for: .normal)
        return btn
    }()
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
        viewModel.sports.subscribeSuccess{[weak self] _ in
            self?.ballCollectionView.reloadData()
            }.disposed(by: disposeBag)
        viewModel.selectedSportIndex
            .distinctUntilChanged()
            .subscribeSuccess { [weak self](index) in
             guard let weakSelf = self ,
              weakSelf.viewModel.sports.value.count - 1 >= index
              else { return }
            weakSelf.ballCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                weakSelf.ballCollectionView.reloadData()
            }
        }.disposed(by: disposeBag)
        viewModel.isExpand.subscribeSuccess { [weak self](isExpand) in
             guard let weakSelf = self else { return }
            UIView.animate(withDuration: 0.25, animations: {
             weakSelf.expandBtn.transform = isExpand ? CGAffineTransform(rotationAngle: CGFloat.pi + 0.01) : CGAffineTransform.identity
            })
        }.disposed(by: disposeBag)
    }
    private func setupViews(){
        
        addSubview(ballCollectionView)
        addSubview(separator)
        addSubview(expandBtn)
        
        ballCollectionView.snp.makeConstraints { (maker) in
            maker.leading.top.bottom.equalToSuperview()
            maker.trailing.equalTo(separator.snp.leading)
        }
        separator.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 1, height: 24))
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(expandBtn.snp.leading).offset(-24)
        }
        expandBtn.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 15, height: 13) )
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(-50)
        }
        
    }
    
}

extension SportTypeMenu:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sports.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(type: SportTypeCollectionViewCell.self, indexPath: indexPath)
        cell.configureCell(viewModel.sports.value[indexPath.row])
        cell.setSeleted(indexPath.row == viewModel.selectedSportIndex.value)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedSportIndex.accept(indexPath.row)
        viewModel.isExpand.accept(false)
    }
    
     func didSelected(indexPath:IndexPath) {
        viewModel.selectedSportIndex.accept(indexPath.row)
        ballCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.ballCollectionView.reloadData()
        }
    }
}

extension Reactive where Base:SportTypeMenu {
    var clickExpand:Observable<Void> {
        return base.expandBtn.rx.tap.asObservable()
    }
}
