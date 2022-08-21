# AppstoreTransition

![Simulator Screen Recording - iPhone 11 - 2022-08-21 at 18 51 23](https://user-images.githubusercontent.com/36326157/185785445-e8607d2d-6f37-4344-a2ed-72c29509b214.gif) | ![Simulator Screen Recording - iPhone 12 - 2022-08-18 at 16 46 36](https://user-images.githubusercontent.com/36326157/185785345-1fb2fe78-de14-4744-b35d-0346c0173fa0.gif)


# Overview

본 프로젝트는 Appstore의 미려한 화면 전환과 View(Cell)와의 상호작용 구현 기술을 카피한 것으로 외부 라이브러리는 layout 구성시 Snapkit 외에 transition 과정에선 외부 라이브러리의 추가 없이 구성 되었습니다.
UIViewControllerTransitioningDelegate를 통한 view의 transition과 statusBar, Tabbar 등의 자연스러운 사용자 인터렉션을 구현하였습니다.

<br>

# 사용기술
- UIViewControllerTransitioningDelegate
- UIPresentationController
- UIViewControllerAnimatedTransitioning
- UIPercentDrivenInteractiveTransition
- UIViewPropertyAnimator

<br>

# Animation

### Cell touch animation

UIKit의 기본 터치 이벤트 감지 메소드 오버라이딩을 통한 cell Interaction

```swift
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
                AppCollectionViewCell.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: [.allowUserInteraction], animations: {
                    self.transform = .init(scaleX: 0.96, y: 0.96)
                    self.layoutIfNeeded()
                }, completion: nil)
    } else {
            AppCollectionViewCell.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: .allowUserInteraction,
                animations: {
                    self.transform = .identity
                }, completion: nil)
        }
    }

```

<br>

# Transition

UIViewControllerTransitioningDelegate를 이용한 Transition 구현

- Presentation
- Present Transition
- dismiss Transition

```swift
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
```

<br>

## Presentation

presentation 효과를 담당하는 UIPresentationController 타입의 객체

- Presented 되는 VC와 Presenting 되는 VC를 지정하는 initailizer

```swift
override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
```

- presentation의 animation이 시작 될 때의 메소드

```swift
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
```

- dismiss animation이 시작 될 때의 메소드

```swift
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
```

<br>

## Present Transition

present transition을 담당하는 UIViewControllerAnimatedTransitioning 타입의 객체

- Present Transition 시간을 지정해주는 transitionDuration 메소드

```swift
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
```

- Present Transition에서 실제로 사용 할 transitionContext의 containerView에서 가져온 VC와 View

```swift
let containerView = transitionContext.containerView
guard let fromVC = transitionContext.viewController(forKey: .from) as? TabBarViewController else { fatalError() } // Tabar VC
guard let appStoreMenuVC = fromVC.viewControllers![0] as? AppStoreMenuViewController else { fatalError() } // From VC
guard let contentVC = transitionContext.viewController(forKey: .to) as? AppContentViewController else { fatalError() } // To VC
guard let fromView = appStoreMenuVC.view else { fatalError() }
guard let toView = contentVC.view else { fatalError() }
```

- collectionView의 cell의 frame을 transition에서 사용하는 fromView의 좌표로 변환 시켜주는 코드

```swift
let targetCell = appStoreMenuVC.appCollectionView.cellForItem(at: targetIndexPath!) as! AppCollectionViewCell
let startFrame = appStoreMenuVC.appCollectionView.convert(targetCell.frame, to: fromView)
```

- Transition에 사용할 autolayout을 설정 후 topAnchor만 따로 빼서 다른 animation을 적용해주는 코드

```swift
contentViewTopAnchor.constant = 0
        
UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveLinear,
            animations: {
            contentView.layoutIfNeeded()
        }) { (comp) in
            toView.alpha = 1.0
            contentView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
```

<br>

## Dismiss Transition

Dismiss transition을 담당하는 UIViewControllerAnimatedTransitioning 타입의 객체

- Dismissal Transition 시간을 지정해주는 transitionDuration 메소드

```swift
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
```

- Dismissal Transition에서 실제로 사용 할 transitionContext의 containerView에서 가져온 VC와 View

```swift
let containerView = transitionContext.containerView

guard let contentVC = transitionContext.viewController(forKey: .from) as? AppContentViewController else { fatalError() }
guard let toVC = transitionContext.viewController(forKey: .to) as? TabBarViewController else { fatalError() }
guard let appStoreMenuVC = toVC.viewControllers![0] as? AppStoreMenuViewController else { fatalError() }
guard let fromView = contentVC.view else { fatalError() }
guard let toView = appStoreMenuVC.view else { fatalError() }
```

- Dissmiss Transition 시에 적용 되는 view들의 animation

```swift
UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: .curveLinear) {
                
            reConfigureContentLabel()
            contentView.frame = finalFrame
            shadowView.frame = finalFrame
            floatingTabbar.frame = targetTabbar.frame
            
            toView.alpha = 1.0
            
            containerView.layoutIfNeeded()
        
        } completion: { [self] (comp) in
            
            let success = !transitionContext.transitionWasCancelled
            
            if !success {
                fromView.alpha = 1.0
                toView.removeFromSuperview()
            }
            toVC.reloadItems()
            floatingTabbar.alpha = 0.0
            targetCell.alpha = 1.0
            targetTabbar.alpha = 1.0
            appStoreMenuVC.appCollectionView.cellForItem(at: targetIndexPath!)?.contentView.alpha = 1.0
            
            contentView.removeFromSuperview()
            transitionContext.completeTransition(success)
        }
```

<br>

## Gesture Dissmiss Animation

gesture의 움직임에 따른 dismiss animation 구현

```swift
let targetShrinkScale: CGFloat = 0.85
let targetCornerRadius: CGFloat = GlobalConstants.cornerRadius
let progress = (currentLocation.y - startingPoint.y) / 100
            
func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
                if let animator = dismissalAnimator {
                    return animator
                } else {
                    let animator = UIViewPropertyAnimator(
                        duration: 0,
                        curve: .linear,
                        animations: {
                        targetAnimatedView.clipsToBounds = true
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
```
