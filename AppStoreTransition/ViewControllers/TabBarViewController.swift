//
//  TabBarViewController.swift
//  AppStoreTransition
//
//  Created by UY on 2020/12/06.
//

import UIKit
import SnapKit

class TabBarViewController: UITabBarController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    var controllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let vc1 = AppStoreMenuViewController()
        let vcTabBarItem = UITabBarItem(title: "투데이", image: nil, tag: 0)
        
        let vc2 = SecondViewController()
        let vc2TabBarItem = UITabBarItem(title: "설정", image: nil, tag: 1)
        
        vc2TabBarItem.isEnabled = false
        
        vc1.tabBarItem = vcTabBarItem
        vc2.tabBarItem = vc2TabBarItem
        
        controllers = [vc1,vc2]
        
        self.viewControllers = controllers
        self.setViewControllers(controllers, animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        GlobalConstants.safeAreaLayoutTop = view.safeAreaInsets.top
    }
    
    func reloadItems() {
        
        self.viewControllers = controllers
        
        self.setViewControllers(controllers, animated: true)
    }
}
