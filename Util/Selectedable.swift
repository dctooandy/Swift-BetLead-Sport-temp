//
//  Selectedable.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/21.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation

protocol Selectedable {
    
}
extension Selectedable where Self:UIView {
    
    
    func setSelectedStatus(_ isSelected:Bool) {
        isSelected ? addSelected() : removeSelected()
    }
    
    private func addSelected() {
        let selectedView = UIImageView(image: UIImage(named: "navigation-bg"))
        selectedView.tag = Constants.SelectedTag
        insertSubview(selectedView, at: 0)
        selectedView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    private func removeSelected(){
        subviews.filter{$0.tag == Constants.SelectedTag}.first?.removeFromSuperview()
    }
}
//private let selectedBgView = UIImageView(image: UIImage(named: "navigation-bg"))
