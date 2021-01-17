//
//  AppCollectionViewCell.swift
//  AppStoreTransition
//
//  Created by UY on 2020/11/21.
//

import UIKit
import SnapKit

class AppCollectionViewCell: UICollectionViewCell {

    lazy var appContentView: AppContentView = {
        var view = AppContentView(isContentView: false)
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureCellLayout()
    }
    
    func configureCellLayout() {
        contentView.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        
        contentView.addSubview(appContentView)
        
        appContentView.snp.makeConstraints { (const) in
            const.top.equalToSuperview()
            const.bottom.equalToSuperview()
            const.leading.equalToSuperview()
            const.trailing.equalToSuperview()
        }
    }
    
    func fectchData(model: AppContentModel) {
        appContentView.fetchData(image: model.image, subD: model.subDescription!, desc: model.description!)
    }
    
}

