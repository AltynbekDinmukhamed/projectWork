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
    
    private let pSearchView: UISearchBar = {
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
    
    private let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    private let collection: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //layout.itemSize = CGSize(width: 158, height: 174)
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 5
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PCell")
        collection.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VCell")
        collection.backgroundColor = .white
        return collection
    }()
    
    private var photoData: [PhotoData]? = []
    private var vieoData: [VideoData]? = []
    
    var photoDelegate: TappedViewPhotoDelegate?
    
    var viewDeleagate: TappedVideoVideoDelegate?
    
    //MARK: -LifeCycle-
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        makeContraints()
        gettingData()
        gettingVideo()
    }
    //MARK: -Functions-
    private func gettingData() {
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
    
    private func gettingVideo() {
        let video = "https://pixabay.com/api/videos/?key=39975920-1087ba3a8b7d7f1e975f1c2f4&q=yellow+flowers"
        Server.shared.fetchVideo(url: video) { result in
            switch result {
            case .success(let data):
                self.vieoData = [data]
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
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
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
        switch pSegmentController.selectedSegmentIndex {
        case 0:
            return photoData?.count ?? 0
        case 1:
            return vieoData?.count ?? 0
        default:
            fatalError("Dimash guilty")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch pSegmentController.selectedSegmentIndex {
        case 0:
            return photoData?[0].hits.count ?? 0
        case 1:
            return vieoData?[0].hits.count ?? 0
        default:
            fatalError("Dimash guilty too")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch pSegmentController.selectedSegmentIndex {
        //MARK: Working with first cell
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
            cell.layoutMargins = UIEdgeInsets.zero
            cell.layer.cornerRadius = 10
            cell.nameLbl.text = hit?.tags
            cell.photoImage.clipsToBounds = true
            cell.photoImage.layer.cornerRadius = 10
            return cell
            
        //MARK: working with secound cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VCell", for: indexPath) as! VideoCollectionViewCell
            cell.layer.cornerRadius = 10
            let hit = vieoData?[indexPath.section].hits[indexPath.row]
            if let urlImage = hit?.userImageURL, let url = URL(string: urlImage) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        cell.videoPhotoImage.image = image
                    }
                }.resume()
                
            }
            cell.videoPhotoImage.clipsToBounds = true
            cell.videoPhotoImage.layer.cornerRadius = 10
            return cell
        default:
            fatalError("something wrong with cells")
            break
        }
    }
    
}
//MARK: -Collection Delegate-
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TappedViewController()
        let vc2 = TappedVideoViewController()
        vc.modalPresentationStyle = .fullScreen
        photoDelegate = vc
        
//        navigationController?.present(vc, animated: true, completion: { [self] in
//            if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell, let image = cell.photoImage.image {
//                photoDelegate?.sendPhoto(image)
//            } 
//            
//            if let vidCell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell, let image = vidCell.videoURL {
//                photoDelegate?.sendPhoto(videoUrl)
//            }
//            
//        })
        if pSegmentController.selectedSegmentIndex == 0 {
            let vc = TappedViewController()
            vc.modalPresentationStyle = .fullScreen
            
            if let photoCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell, let image = photoCell.photoImage.image {
                vc.image = image
            }
            navigationController?.present(vc, animated: true)
        } else if pSegmentController.selectedSegmentIndex == 1 {
            let vc = TappedVideoViewController()
            vc.modalPresentationStyle = .fullScreen
            
            let selectedVideo = vieoData![indexPath.section].hits[indexPath.row].videos.medium.url
            let urlVidep = URL(string: selectedVideo)
            vc.videoUrl = urlVidep
            navigationController?.present(vc, animated: true)
        }
    }
}

//MARK: -Collection View Flow Layout Delegate-
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2.2, height: 184)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension ViewController: TappedVideoVideoDelegate {
    func sendVideo(withURl url: URL) {
        let tappedVidepVC = TappedVideoViewController()
        tappedVidepVC.delegate = self
        tappedVidepVC.videoUrl = url
        present(tappedVidepVC, animated: true)
    }
}
