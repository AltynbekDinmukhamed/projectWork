//
//  ViewController.swift
//  Assignment
//
//  Created by Димаш Алтынбек on 10.10.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    //MARK: -Variables-
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Movie & Images"
        lbl.font = UIFont(name: "FontsFree-Net-SFProDisplay-Medium", size: 20)
        return lbl
    }()
    
    private lazy var pSegmentController: UISegmentedControl = {
        let items = ["Image", "Movie"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
        return segment
    }()
    
    let pSearchView: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search"
        let searchTextField = search.searchTextField
        searchTextField.leftViewMode = .always
        //left magnifyingglass
        let magnifierImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifierImageView.contentMode = .scaleAspectFit
        searchTextField.leftView = magnifierImageView
        //right Microphone
        let microphoneImageView = UIImageView(image: UIImage(systemName: "mic.fill"))
        microphoneImageView.contentMode = .scaleAspectFit
        searchTextField.rightViewMode = .always
        searchTextField.rightView = microphoneImageView
        
        search.backgroundImage = UIImage()
        search.isTranslucent = true
        return search
    }()
    
    let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    private let collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 158, height: 154)
        layout.minimumLineSpacing = 25
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PCell")
        collection.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VCell")
        collection.backgroundColor = .white
        return collection
    }()
    
    var photoData: [PhotoData]? = []
    var vieoData: [VideoData] = []
    
    //MARK: -LifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        makeContraints()
        gettingData()
    }
    //MARK: -Functions-
    func gettingData() {
        let photo = "https://pixabay.com/api/?key=39975920-1087ba3a8b7d7f1e975f1c2f4&q=yellow+flowers&image_type=photo"
        Server.shared.fetch(url: photo) { result in
            switch result {
            case .success(let data):
                self.photoData = [data]
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: -extension-
extension ViewController {
    private func setUpViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(titleLbl)
        view.addSubview(pSegmentController)
        view.addSubview(pSearchView)
        pSearchView.delegate = self
        view.addSubview(collection)
        collection.delegate = self
        collection.dataSource = self
    }
    
    private func makeContraints() {
        titleLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        pSegmentController.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(27)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(36)
        }
        
        pSearchView.snp.makeConstraints { make in
            make.top.equalTo(pSegmentController.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        collection.snp.makeConstraints { make in
            make.top.equalTo(pSearchView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-27)
        }
    }
}
//MARK: -Objc functions-
extension ViewController {
    @objc func segmentTapped(_ segment: UISegmentedControl){
        collection.reloadData()
    }
}

//MARK: -extension View Controller with SearchBar Delegate-
extension ViewController: UISearchBarDelegate {
    
}

//MARK: -extension Collection View Delegates-
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photoData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData?[section].hits.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch pSegmentController.selectedSegmentIndex {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PCell", for: indexPath) as! PhotoCollectionViewCell
            let hit = photoData?[indexPath.section].hits[indexPath.row]
            if let urlImage = hit?.largeImageURL, let url = URL(string: urlImage) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        cell.photoImage.image = image
                    }
                }.resume()
            }
            cell.nameLbl.text = hit?.tags
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VCell", for: indexPath) as! VideoCollectionViewCell
            return cell
        default:
            fatalError("something wrong with cells")
            break
        }
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TappedViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
