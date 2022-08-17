//
//  Transition.swift
//  AppStoreTransition
//
//  Created by UY on 2020/12/13.
//

import UIKit

class AppContentTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    var superViewcontroller: UIViewController?
    var targetCellFrame: CGRect?
    var indexPath: IndexPath?
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AppcontentPresentaion(presentedViewController: presented, presenting: presenting)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AppContentPresentTransitioningAnimator(indexPath: indexPath!)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AppContentDissmissTransitioningAnimator(indexPath: indexPath!, cellFrame: targetCellFrame!)
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
