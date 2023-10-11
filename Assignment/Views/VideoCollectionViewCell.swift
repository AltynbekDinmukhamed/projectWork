//
//  VideoCollectionViewCell.swift
//  Assignment
//
//  Created by Димаш Алтынбек on 10.10.2023.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation
import AVKit

class VideoCollectionViewCell: UICollectionViewCell {
    //MARK: -Variables-
    let videoImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "play.circle")
        img.tintColor = .white
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let videoPhotoImage: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor(red: 0.118, green: 0.42, blue: 0.875, alpha: 0.2)
        img.alpha = 0.6
        img.contentMode = .scaleAspectFill
        return img
    }()
    
//    var videoImage: AVPlayer?
//    var videoImageLayer: AVPlayerLayer?
    
    let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.font = UIFont(name: "SFProText-Regular", size: 17)
        lbl.textColor = .black
        return lbl
    }()
    
    //MARK: -LifeCcycle-
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

//MARK: -extensions-
extension VideoCollectionViewCell {
    private func setUpViews() {
        backgroundColor = UIColor(red: 0.118, green: 0.42, blue: 0.875, alpha: 0.2)
        addSubview(videoPhotoImage)
        addSubview(videoImage)
        addSubview(nameLbl)
    }
    
    private func makeViewConstraints() {
        videoImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(66)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
        
        videoPhotoImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-70)
        }
    }
}
