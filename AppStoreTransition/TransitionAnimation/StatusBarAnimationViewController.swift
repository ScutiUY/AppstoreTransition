//
//  StatusBarAnimationViewController.swift
//  AppStoreTransition
//
//  Created by UY on 2021/01/04.
//

import UIKit

protocol StatusBarAnimationViewController: class {
    var statusBarShouldBeHidden: Bool { get set }
    var statusBarAnimationStyle: UIStatusBarAnimation { get set }
}

extension StatusBarAnimationViewController where Self: UIViewController {
    func updateStatusBarAppearance(hidden: Bool, withDuration duration: Double = 0.5, completion: ((Bool) -> Void)? = nil) {
        statusBarShouldBeHidden = hidden
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }, completion: completion)
    }
}
