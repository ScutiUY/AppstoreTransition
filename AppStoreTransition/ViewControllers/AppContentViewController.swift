//
//  ContentViewController.swift
//  AppStoreTransition
//
//  Created by UY on 2020/11/29.
//

import UIKit
import SnapKit

class AppContentViewController: UIViewController {
    
    var dismissalAnimator: UIViewPropertyAnimator?
    var interactiveStartingPoint: CGPoint?
   
    var statusBarShouldBeHidden: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    var contentView = AppContentView(isContentView: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ContentView", #function)
        setLayout()
        addNoti()
        
        let dismissPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismissPanGeusture(_:)))
        dismissPanGesture.delegate = self
        view.addGestureRecognizer(dismissPanGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ContentView", #function)
        updateStatusBar(hidden: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .closeButton, object: nil)
        print("ContentView", #function)
    }
    
    func setLayout() {
        contentView.contentMode = .center
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (const) in
            const.top.equalToSuperview()
            const.bottom.equalToSuperview()
            const.leading.equalToSuperview()
            const.trailing.equalToSuperview()
        }
    }
    
    func fetchData(model: AppContentModel) {
        contentView.fetchDataForContentVC(image: model.image, subD: model.subDescription!, desc: model.description!, content: model.content!, contentView: view.frame)
    }
    
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(closeVC), name: .closeButton, object: nil)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    func updateStatusBar(hidden: Bool, completion: ((Bool) -> Void)?) {
        statusBarShouldBeHidden = hidden
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}

extension AppContentViewController: UIGestureRecognizerDelegate {
    
    @objc func handleDismissPanGeusture(_ pan: UIPanGestureRecognizer) {
        
        if contentView.isTopOfScreen {
            
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
                        targetAnimatedView.layoutIfNeeded()
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
                    dismissalAnimator!.addCompletion { [unowned self] (pos) in
                        switch pos {
                        case .end:
                            NotificationCenter.default.post(name: .closeButton, object: nil)
                        default:
                            fatalError("Must finish dismissal at end!")
                        }
                    }
                    dismissalAnimator!.finishAnimation(at: .end)
                }
            case .cancelled, .ended:
                if dismissalAnimator == nil {
                    // Gesture's too quick that it doesn't have dismissalAnimator!
                    print("Too quick there's no animator!")
                    didCancelDismissalTransition()
                    return
                }
                dismissalAnimator!.pauseAnimation()
                dismissalAnimator!.isReversed = true

                // Disable gesture until reverse closing animation finishes.
                pan.isEnabled = false
                dismissalAnimator!.addCompletion { [unowned self] (pos) in
                    self.didCancelDismissalTransition()
                    pan.isEnabled = true
                }
                dismissalAnimator!.startAnimation()
            default:
                return
            }
        }
    }
    
    func didCancelDismissalTransition() {
        // Clean up
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        contentView.isTopOfScreen = false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
