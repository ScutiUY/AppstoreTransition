//
//  AppCollectionView.swift
//  AppStoreTransition
//
//  Created by UY on 2020/11/21.
//

import UIKit
import SnapKit

class AppContentView: UIView {
    
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
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    lazy var thumbnailImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 15
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
    
    lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "closeB"), for: .normal)
        return button
    }()
    
    init(isContentView: Bool) {
        super.init(frame: .zero)
        
        if isContentView {
            self.setLayoutForContentVC()
        } else {
            self.setLayoutForCollectionViewCell()
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setLayoutForCollectionViewCell()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setLayoutForCollectionViewCell()
    }
    
    func setLayoutForCollectionViewCell(image: UIImage? = nil, subDescription: String? = "", description: String? = "") {
        
        self.addSubview(imageView)
        self.addSubview(subDescriptionLabel)
        self.addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { (const) in
            const.center.equalTo(self.snp.center)
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
    
    func setLayoutForContentVC() {
        
        self.addSubview(imageView)
        self.addSubview(subDescriptionLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        
        imageView.snp.makeConstraints { (const) in
            const.top.equalToSuperview()
            const.centerX.equalToSuperview()
            const.width.equalToSuperview()
            const.height.equalTo(self.frame.size.width * 0.9 * 1.2)
        }
        
        // iphone 모델 별 safeAreaLayout 적용
        subDescriptionLabel.snp.makeConstraints { (const) in
            const.top.equalTo(self.snp.top).offset(GlobalConstants.safeAreaLayoutTop)
            const.leading.equalToSuperview().offset(15)
            const.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        descriptionLabel.snp.makeConstraints { (const) in
            const.top.equalTo(subDescriptionLabel.snp.bottom).offset(10)
            const.leading.equalToSuperview().offset(15)
            const.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        
        closeButton.snp.makeConstraints { (const) in
            const.top.equalTo(self.snp.top).offset(20)
            const.right.equalTo(self.snp.right).offset(-20)
            const.width.equalTo(30)
            const.height.equalTo(30)
        }
        
    }
    
    @objc func close() {
        NotificationCenter.default.post(name: .closeButton, object: nil)
    }
    
    func fetchData(image: UIImage?, subD: String, desc: String, isContentVC: Bool = false) {
        imageView.image = image
        subDescriptionLabel.text = subD
        descriptionLabel.text = desc
    }
    
}
