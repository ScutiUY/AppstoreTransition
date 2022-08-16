//
//  AppCollectionViewCell.swift
//  AppStoreTransition
//
//  Created by UY on 2020/11/21.
//

import UIKit
import SnapKit

class AppCollectionViewCell: UICollectionViewCell {
  
    var disabledHighlightedAnimation = false

    func resetTransform() {
        transform = .identity
    }

    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
    
    lazy var appContentView: AppContentView = {
        var view = AppContentView(isContentView: false)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = GlobalConstants.cornerRadius
        view.contentMode = .center
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
        
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 12
        
        contentView.addSubview(appContentView)
        
        appContentView.snp.makeConstraints { (const) in
            const.top.equalToSuperview()
            const.bottom.equalToSuperview()
            const.leading.equalToSuperview()
            const.trailing.equalToSuperview()
        }
    }
    
    func fectchData(model: AppContentModel) {
        guard let subDescription = model.subDescription else { return }
        guard let desc = model.description else { return }
        appContentView.fetchDataForCell(image: model.image, subDescription: subDescription, desc: desc)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bounceAnimate(isTouched: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        bounceAnimate(isTouched: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        bounceAnimate(isTouched: false)
    }
    
    private func bounceAnimate(isTouched: Bool) {
        
        if disabledHighlightedAnimation {
            return
        }
        
        if isTouched {
            AppCollectionViewCell.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: [.allowUserInteraction], animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
                            self.layoutIfNeeded()
                           }, completion: nil)
        } else {
            AppCollectionViewCell.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: .allowUserInteraction, animations: {
                            self.transform = .identity
                           }, completion: nil)
        }
    }
 
}


