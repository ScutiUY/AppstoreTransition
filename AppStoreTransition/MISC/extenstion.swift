//
//  extenstion.swift
//  AppStoreTransition
//
//  Created by UY on 2020/12/16.
//

import Foundation
import UIKit

extension Notification.Name {
    static let closeButton = Notification.Name("closeButton")
}
extension UIView {
    func addShadowAndRoundCorner(cornerRadius : CGFloat) {
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
    }
}
