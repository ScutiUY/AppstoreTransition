//
//  Transition.swift
//  AppStoreTransition
//
//  Created by UY on 2020/12/13.
//

import Foundation
import UIKit

class AppContentTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    var presentAnimator: AppContentPresentingAnimator?
    var dismissAnimator: AppContentDissmissingAnimator?
    var data: AppContentModel?
    var indexPath: IndexPath?
    
    init(data: AppContentModel, indexPath: IndexPath) {
        super.init()
        presentAnimator = AppContentPresentingAnimator()
        dismissAnimator = AppContentDissmissingAnimator()
        self.data = data
        self.indexPath = indexPath
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presentAnimator!.targetData = self.data
        self.presentAnimator!.targetIndexPath = indexPath
        
        return presentAnimator
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.dismissAnimator!.targetData = self.data
        self.dismissAnimator!.targetIndexPath = indexPath
        return dismissAnimator
    }
}
