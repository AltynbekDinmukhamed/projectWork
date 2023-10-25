//
//  TappedVideoViewController.swift
//  Assignment
//
//  Created by Димаш Алтынбек on 23.10.2023.
//

import Foundation
import UIKit
import SnapKit
import AVKit

protocol TappedVideoVideoDelegate {
    func sendVideo(withURl url: URL)
}

class TappedVideoViewController: UIViewController {
    //MARK: -Variables-
    private let mainImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photoCellBackground")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Close", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 28)
        btn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "play.circle"), for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.tintColor = .blue
        btn.addTarget(self, action: #selector(playBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    var delegate: TappedVideoVideoDelegate?
    
    var player: AVPlayer?
    
    var playerLayer: AVPlayerLayer?
    
    var videoUrl: URL?
    
    //MARK: -Life Cycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addViewConstraints()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        playerLayer?.removeFromSuperlayer()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        player = nil
    }
    //MARK: -Functions-

}

//MARK: -Extension-
extension TappedVideoViewController {
    private func setUpViews() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.81)
        navigationController?.isNavigationBarHidden = true
        view.addSubview(mainImage)
        view.addSubview(backBtn)
        view.addSubview(playButton)
    }
    
    private func addViewConstraints() {
        mainImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalTo(mainImage.snp.center)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
    }
}

//MARK: -Button objs functions-
extension TappedVideoViewController {
    @objc func backTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func playBtnTapped(_ sender: UIButton) {
        guard let url = videoUrl else { return }
        
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        
        if let playerLayer = playerLayer {
            playerLayer.frame = view.bounds
            view.layer.addSublayer(playerLayer)
        }
        
        player?.play()
        
        // add observer for video playback
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem)
        
        playButton.isHidden = true
    }
    
    @objc func videoDidEnd() {
        playButton.isHidden = false
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self, name: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem)
    }
}
