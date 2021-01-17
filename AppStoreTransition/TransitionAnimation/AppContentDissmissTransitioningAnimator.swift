//
//  AppContentDissmisingAnimator.swift
//  AppStoreTransition
//
//  Created by UY on 2020/12/23.
//

import Foundation
import UIKit

class AppContentDissmissingAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    var targetIndexPath: IndexPath?
    var targetData: AppContentModel?
    
    var subDescTopAnchor: NSLayoutConstraint!
    var subDescLeadingAnchor: NSLayoutConstraint!
    
    var descTopAnchor: NSLayoutConstraint!
    var descLeadingAnchor: NSLayoutConstraint!
    
    
    
    init(indexPath: IndexPath) {
        targetIndexPath = indexPath
        targetData = model[indexPath.row]
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let contentVC = transitionContext.viewController(forKey: .from) as? AppContentViewController else { fatalError() }
        guard let toVC = transitionContext.viewController(forKey: .to) as? TabBarViewController else { fatalError() }
        guard let appStoreMenuVC = toVC.viewControllers![0] as? AppStoreMenuViewController else { fatalError() }
        guard let fromView = contentVC.view else { fatalError() }
        guard let toView = appStoreMenuVC.view else { fatalError() }
        
        let targetCell = appStoreMenuVC.appCollectionView.cellForItem(at: targetIndexPath!) as! AppCollectionViewCell
        targetCell.resetTransform()
        
        let tabbar = toVC.tabBar
        let floatingTabbar = UITabBar(frame: tabbar.frame)
        floatingTabbar.frame.origin.y = toView.frame.maxY
        floatingTabbar.items = tabbar.items
        
        let startFrame = containerView.frame
        let finalFrame = appStoreMenuVC.appCollectionView.convert(targetCell.frame, to: toView)
    
        
        fromView.alpha = 0.0
        
        let contentView = AppContentView(isContentView: true)
        contentView.clipsToBounds = true
        contentView.frame = startFrame
        
        contentView.fetchDataForContentVC(image: targetData!.image, subD: targetData!.subDescription!, desc: targetData!.description!, content: targetData!.content!, contentView: startFrame, isTransition: true)
        
        contentView.layer.cornerRadius = 20
        
        contentView.closeButton.alpha = 0.0
        
        containerView.addSubview(contentView)
        containerView.addSubview(floatingTabbar)
        
        containerView.layoutIfNeeded()
        
        func reConfigureContentLabel() {
            
            subDescTopAnchor = contentView.subDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
            subDescLeadingAnchor = contentView.subDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
            descTopAnchor =  contentView.descriptionLabel.topAnchor.constraint(equalTo: contentView.subDescriptionLabel.bottomAnchor, constant: 10)
            descLeadingAnchor = contentView.descriptionLabel.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor, constant:  15)
            
            NSLayoutConstraint.activate([
                subDescTopAnchor,
                subDescLeadingAnchor,
                descTopAnchor,
                descLeadingAnchor
            ])
            
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveLinear) {
            reConfigureContentLabel()
            
            floatingTabbar.frame = tabbar.frame
            
            contentView.frame = finalFrame
            contentView.alpha = 1.0
            
            toView.alpha = 1.0
            toVC.view.alpha = 1.0
        
        } completion: { (comp) in
            targetCell.alpha = 1.0
            tabbar.alpha = 1.0
            
            contentView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
    
    
}
