//
//  GestureDismissalTransitionController.swift
//  AppStoreTransition
//
//  Created by UY on 2021/01/04.
//

import UIKit

class GestureDismissalTransitionController: UIPercentDrivenInteractiveTransition {
    
    var shouldCompleteTranisition = true
    var dismissalAnimator: UIViewPropertyAnimator?
    var interactiveStartingPoint: CGPoint?
    weak var targetViewController: UIViewController?
    
    var startScale: CGFloat = 0.0
    
    init(viewController: UIViewController) {
        super.init()
        targetViewController = viewController
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handleDismissPanGeusture(_:)))
        targetViewController?.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleDismissPanGeusture(_ pan: UIPanGestureRecognizer) {
        
            let startingPoint: CGPoint
            let targetAnimatedView = pan.view!
            if let p = interactiveStartingPoint {
                startingPoint = p
            } else {
                // Initial location
                startingPoint = pan.location(in: nil)
                interactiveStartingPoint = startingPoint
            }
            let currentLocation = pan.location(in: nil)
            
            let targetShrinkScale: CGFloat = 0.86
            let targetCornerRadius: CGFloat = GlobalConstants.cornerRadius
            let progress = (currentLocation.y - startingPoint.y) / 100
            
            func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
                if let animator = dismissalAnimator {
                    return animator
                } else {
                    let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
                        targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                        targetAnimatedView.layer.cornerRadius = targetCornerRadius
                    })
                    animator.isReversed = false
                    animator.pauseAnimation()
                    animator.fractionComplete = progress
                    return animator
                }
            }
            
            switch pan.state {
            case .began:
                dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
                
            case .changed:
                dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
                
                let actualProgress = progress
                
                let isDismissalSuccess = actualProgress >= 1.0

                dismissalAnimator!.fractionComplete = actualProgress

                if isDismissalSuccess {
                    dismissalAnimator!.stopAnimation(false)
                    dismissalAnimator!.addCompletion { (pos) in
                        switch pos {
                        case .end:
                            NotificationCenter.default.post(name: .closeButton, object: nil)
                        default:
                            fatalError("Must finish dismissal at end!")
                        }
                    }
                    dismissalAnimator!.finishAnimation(at: .end)
                }
            case .cancelled:
                print("pan cancelled")
            case .ended:
                print("pan end")
            default:
                return
            }
        }
}
