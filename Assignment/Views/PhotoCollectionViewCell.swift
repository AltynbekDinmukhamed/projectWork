//
//  PhotoCollectionViewCell.swift
//  Assignment
//
//  Created by Димаш Алтынбек on 10.10.2023.
//

import Foundation
import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    //MARK: -Variables-
    let photoImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "photoCellBackground")
        img.contentMode = .scaleToFill
        return img
    }()
    
    let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.numberOfLines = 0
        lbl.font = UIFont(name: "SFProText-Regular", size: 15)
        lbl.textColor = .black
        return lbl
    }()
    
    
    //MARK: -LifeCycle-
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        makeViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -Functions-
}

//MARK: -Extension-
extension PhotoCollectionViewCell {
    private func setUpViews() {
        backgroundColor = UIColor(red: 0.929, green: 0.971, blue: 0.922, alpha: 1)
        addSubview(photoImage)
        addSubview(nameLbl)
    }
    
    private func makeViewConstraints() {
        photoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalToSuperview().dividedBy(1.5)
        }
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(photoImage.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
        }
    }
}
