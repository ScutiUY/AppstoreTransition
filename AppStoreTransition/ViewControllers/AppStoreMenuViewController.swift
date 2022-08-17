//
//  ViewController.swift
//  AppStoreTransition
//
//  Created by UY on 2020/11/20.
//

import UIKit
import SnapKit


class AppStoreMenuViewController: UIViewController {
    
    var statusBarShouldBeHidden: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    var appStoreTransition = AppContentTransitionController()
    
    lazy var appCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let cellWidth = view.frame.size.width * 0.9
        let cellHeight = cellWidth * 1.2
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset.top = 30
        layout.minimumLineSpacing = 30
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delaysContentTouches = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(AppCollectionViewCell.self, forCellWithReuseIdentifier: "AppCollectionViewCell")
    
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setLayout() {
        
        view.addSubview(appCollectionView)
        
        appCollectionView.snp.makeConstraints { (const) in
            const.top.equalTo(view.snp.top)
            const.bottom.equalToSuperview()
            const.centerX.equalToSuperview()
            const.width.equalToSuperview()
        }
    }
}

extension AppStoreMenuViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = appCollectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionViewCell", for: indexPath) as! AppCollectionViewCell
        cell.fectchData(model: model[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AppCollectionViewCell
        let appContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Appcontent") as! AppContentViewController
        appStoreTransition.indexPath = indexPath
        appStoreTransition.superViewcontroller = appContentVC
        
        let currentCellFrame = cell.superview!.convert(cell.frame, to: nil)
        
        appStoreTransition.targetCellFrame = currentCellFrame
        appContentVC.fetchData(model: model[indexPath.row])
        appContentVC.modalPresentationStyle = .custom
        appContentVC.transitioningDelegate = appStoreTransition
        appContentVC.modalPresentationCapturesStatusBarAppearance = true
        
        self.present(appContentVC, animated: true, completion: { 
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
}
