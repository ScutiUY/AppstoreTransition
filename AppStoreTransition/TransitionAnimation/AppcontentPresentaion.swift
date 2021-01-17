//
//  AppcontentPresentaion.swift
//  AppStoreTransition
//
//  Created by UY on 2020/12/28.
//

import UIKit
import SnapKit

class AppcontentPresentaion: UIPresentationController {
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    lazy var blurView: UIVisualEffectView = {
        var view = UIVisualEffectView(effect: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView else  { fatalError() }
        
        containerView.insertSubview(blurView, at: 0)
        
        blurView.alpha = 0.0
        blurView.frame = containerView.frame
        
        containerView.layoutIfNeeded()
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            blurView.alpha = 0.4
            blurView.effect = UIBlurEffect(style: .systemThickMaterialLight)
            return
        }
        coordinator.animate(alongsideTransition: { (animation) in
            self.blurView.alpha = 0.4
            self.blurView.effect = UIBlurEffect(style: .light)
            containerView.layoutIfNeeded()
        }, completion: { comp in
            self.blurView.alpha = 1
        })
        
    }
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentingViewController.transitionCoordinator else {
            blurView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { (animator) in
            self.blurView.alpha = 0.0
            self.containerView?.layoutIfNeeded()
        }, completion: nil)
    }
}
