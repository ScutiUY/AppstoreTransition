//
//  AppCollectionView.swift
//  AppStoreTransition
//
//  Created by UY on 2020/11/21.
//

import UIKit
import SnapKit

class AppContentView: UIView {
    
    var dismissalAnimator: UIViewPropertyAnimator?
    var interactiveStartingPoint: CGPoint?
    var isTopOfScreen = false
    
    lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var subDescriptionLabel: UILabel = {
        var label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.contentMode = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.text = "Test"
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.contentMode = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.text = "TEST"
        return label
    }()
    
    lazy var thumbnailImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = GlobalConstants.cornerRadius
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        return titleLabel
    }()
    
    lazy var subTitleLabel: UILabel = {
        var titleLabel = UILabel()
        return titleLabel
    }()
    
    lazy var contentText: UITextView = {
        var textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.backgroundColor = .white
        return textView
    }()
    
    lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "closeB"), for: .normal)
        return button
    }()
    
    // MARK:- init
    init(isContentView: Bool, isTransition: Bool = false) {
        super.init(frame: .zero)
        // for reusable
        if isContentView {
            self.setLayoutForContentVC(isTransition: isTransition)
        } else {
            self.setLayoutForCollectionViewCell()
        }
        self.backgroundColor = .white
        scrollView.delegate = self
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayoutForCollectionViewCell()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setLayoutForCollectionViewCell()
    }
    
    // MARK:- set Layout for CollectionViewCell
    func setLayoutForCollectionViewCell(image: UIImage? = nil, subDescription: String? = "", description: String? = "") {
        
        self.addSubview(imageView)
        self.addSubview(subDescriptionLabel)
        self.addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { (const) in
            const.centerX.equalToSuperview()
            const.centerY.equalToSuperview()
            const.width.equalToSuperview()
            const.height.equalToSuperview()
        }
        subDescriptionLabel.snp.makeConstraints { (const) in
            const.top.equalToSuperview().offset(15)
            const.leading.equalToSuperview().offset(15)
            const.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        descriptionLabel.snp.makeConstraints { (const) in
            const.top.equalTo(subDescriptionLabel.snp.bottom).offset(10)
            const.leading.equalToSuperview().offset(15)
            const.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
    }
    // MARK:- set Layout for PresentedView
    func setLayoutForContentVC(isTransition: Bool = false) {
        
        
        
        
        self.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(subDescriptionLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(contentText)
        scrollView.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        scrollView.snp.makeConstraints { (const) in
            const.centerX.equalTo(self.snp.centerX)
            const.centerY.equalToSuperview()
            const.width.equalToSuperview()
            const.height.equalToSuperview()
        }
        imageView.snp.makeConstraints { (const) in
            const.top.equalTo(scrollView.snp.top)
            const.centerX.equalTo(scrollView.snp.centerX)
            const.width.equalTo(scrollView.snp.width)
            const.height.equalTo(self.snp.width).multipliedBy(0.9 * 1.2).offset(GlobalConstants.safeAreaLayoutTop)
        }
        
        //iphone 모델 별 safeAreaLayout 적용
        if !isTransition {
            subDescriptionLabel.snp.makeConstraints { (const) in
                const.top.equalTo(imageView.snp.top).offset(GlobalConstants.safeAreaLayoutTop)
                const.leading.equalTo(imageView.snp.leading).offset(20)
                const.width.equalTo(imageView.snp.width).multipliedBy(0.8)
            }
            descriptionLabel.snp.makeConstraints { (const) in
                const.top.equalTo(subDescriptionLabel.snp.bottom).offset(10)
                const.leading.equalTo(imageView.snp.leading).offset(20)
                const.width.equalTo(imageView.snp.width).multipliedBy(0.8)
            }
        } else {
            subDescriptionLabel.snp.makeConstraints { (const) in
                const.top.equalToSuperview().offset(15)
                const.leading.equalToSuperview().offset(15)
                const.width.equalTo(self.snp.width).multipliedBy(0.8)
            }
            descriptionLabel.snp.makeConstraints { (const) in
                const.top.equalTo(subDescriptionLabel.snp.bottom).offset(10)
                const.leading.equalToSuperview().offset(15)
                const.width.equalTo(self.snp.width).multipliedBy(0.8)
            }
        }
        closeButton.snp.makeConstraints { (const) in
            const.top.equalTo(self.snp.top).offset(20)
            const.right.equalTo(self.snp.right).offset(-20)
            const.width.equalTo(30)
            const.height.equalTo(30)
        }
        contentText.snp.makeConstraints { (const) in
            const.top.equalTo(imageView.snp.bottom)
            const.width.equalTo(scrollView.snp.width).multipliedBy(0.95)
            const.bottom.equalTo(scrollView.snp.bottom)
            const.height.equalTo(500)
        }
    }
    
    // MARK:- Fetch Data For ContentVC
    func fetchDataForContentVC(image: UIImage?, subD: String, desc: String, content: String, contentView superViewFrame: CGRect, isTransition: Bool = false) {
        imageView.image = image
        subDescriptionLabel.text = subD
        contentText.text = content
        descriptionLabel.text = desc
        
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: superViewFrame.width * (0.9 * 1.2) + GlobalConstants.safeAreaLayoutTop, left: 0, bottom: 0, right: 0)
        
        let size = CGSize(width: 1000, height: 10000)
        let estimateSize = contentText.sizeThatFits(size)
        
        if !isTransition {
            contentText.snp.remakeConstraints { (const) in
                const.top.equalTo(superViewFrame.width * 0.9 * 1.2 + GlobalConstants.safeAreaLayoutTop)
                const.centerX.equalTo(scrollView.snp.centerX)
                const.width.equalTo(scrollView.snp.width).multipliedBy(0.95)
                const.bottom.equalTo(scrollView.snp.bottom)
                const.height.equalTo(estimateSize.height)
            }
        } else {
            contentText.snp.remakeConstraints { (const) in
                const.top.equalTo(imageView.snp.bottom)
                const.centerX.equalTo(scrollView.snp.centerX)
                const.width.equalTo(scrollView.snp.width).multipliedBy(0.95)
                
                const.bottom.equalTo(scrollView.snp.bottom)
                const.height.equalTo(estimateSize.height)
            }
        }
        
    }
    //MARK:- Fetch Data For CellView
    func fetchDataForCell(image: UIImage?, subD: String, desc: String) {
        imageView.image = image
        subDescriptionLabel.text = subD
        descriptionLabel.text = desc
    }
    
    @objc func close() {
        NotificationCenter.default.post(name: .closeButton, object: nil)
    }
}

extension AppContentView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 && !scrollView.isTracking {
            
            imageView.snp.remakeConstraints { (const) in
                const.top.equalTo(self.snp.top)
                const.centerX.equalToSuperview()
                const.width.equalToSuperview()
                const.height.equalTo(self.snp.width).multipliedBy(0.9 * 1.2).offset(GlobalConstants.safeAreaLayoutTop)
            }
        } else if scrollView.contentOffset.y < 0 && scrollView.isTracking {
            
            isTopOfScreen = true
            scrollView.contentOffset = .zero
            scrollView.showsVerticalScrollIndicator = false
            imageView.snp.remakeConstraints { (const) in
                const.top.equalTo(self.snp.top)
                const.centerX.equalToSuperview()
                const.width.equalToSuperview()
                const.height.equalTo(self.snp.width).multipliedBy(0.9 * 1.2).offset(GlobalConstants.safeAreaLayoutTop)
            }
        } else {

            scrollView.showsVerticalScrollIndicator = true
            imageView.snp.remakeConstraints { (const) in
                const.top.equalToSuperview()
                const.centerX.equalToSuperview()
                const.width.equalToSuperview()
                const.height.equalTo(self.snp.width).multipliedBy(0.9 * 1.2).offset(GlobalConstants.safeAreaLayoutTop)
            }
        }
        
        if isTopOfScreen {
            scrollView.contentOffset = .zero
            scrollView.showsVerticalScrollIndicator = false
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 && scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = .zero
        }
    }
    
}
//extension AppContentView: UIGestureRecognizerDelegate {
//
//    @objc func handleDismissPanGeusture(_ pan: UIPanGestureRecognizer) {
//
//        if isTopOfScreen {
//
//            let startingPoint: CGPoint
//            let targetAnimatedView = pan.view!
//            if let p = interactiveStartingPoint {
//                startingPoint = p
//            } else {
//                // Initial location
//                startingPoint = pan.location(in: nil)
//                interactiveStartingPoint = startingPoint
//            }
//            let currentLocation = pan.location(in: nil)
//
//
//            let targetShrinkScale: CGFloat = 0.86
//            let targetCornerRadius: CGFloat = GlobalConstants.cornerRadius
//            let progress = (currentLocation.y - startingPoint.y) / 100
//
//            func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
//                if let animator = dismissalAnimator {
//                    return animator
//                } else {
//                    let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
//                        targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
//                        targetAnimatedView.layer.cornerRadius = targetCornerRadius
//                    })
//                    animator.isReversed = false
//                    animator.pauseAnimation()
//                    animator.fractionComplete = progress
//                    return animator
//                }
//            }
//
//
//            switch pan.state {
//            case .began:
//                dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
//
//            case .changed:
//                dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
//
//                let actualProgress = progress
//
//                let isDismissalSuccess = actualProgress >= 1.0
//
//                dismissalAnimator!.fractionComplete = actualProgress
//
//                if isDismissalSuccess {
//                    dismissalAnimator!.stopAnimation(false)
//                    dismissalAnimator!.addCompletion { [unowned self] (pos) in
//                        switch pos {
//                        case .end:
//                            NotificationCenter.default.post(name: .closeButton, object: nil)
//                        default:
//                            fatalError("Must finish dismissal at end!")
//                        }
//                    }
//                    dismissalAnimator!.finishAnimation(at: .end)
//                }
//            case .cancelled:
//                print("pan cancelled")
//            case .ended:
//                print("pan end")
//            default:
//                return
//            }
//        }
//    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//}
