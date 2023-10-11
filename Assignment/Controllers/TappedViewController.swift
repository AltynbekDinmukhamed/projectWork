//
//  TappedViewController.swift
//  Assignment
//
//  Created by Димаш Алтынбек on 11.10.2023.
//

import Foundation
import UIKit
import SnapKit

class TappedViewController: UIViewController {
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
    //MARK: -LifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        makeConstraintsForView()
    }
    //MARK: -Functions-
    
}

//MARK: -Extensions-
extension TappedViewController {
    private func setUpView(){
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.81)
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(mainImage)
        view.addSubview(backBtn)
    }
    
    private func makeConstraintsForView() {
        mainImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(412)
            make.height.equalTo(368)
        }
        
        backBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-49)
        }
    }
}
//  MARK: -Objc func extension for btn-
extension TappedViewController {
    @objc private func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
