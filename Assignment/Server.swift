//
//  Server.swift
//  Assignment
//
//  Created by Димаш Алтынбек on 11.10.2023.
//

import Foundation

class Server {
    //MARK: -Variables-
    static let shared = Server()
    
    //MARK: -LifeCycle-
    private init() {}
    
    //MARK: -Functions-
    
    func fetch(url: String,for completion: @escaping (Result<PhotoData, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
                guard let data = data else { return }
                
                do {
                    let task = try JSONDecoder().decode(PhotoData.self, from: data)
                    completion(.success(task))
                    
                } catch let jsonError {
                    print(jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
        
    }
    
    func fetchVideo(url: String,for completion: @escaping (Result<VideoData, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
                guard let data = data else { return }
                
                do {
                    let task = try JSONDecoder().decode(VideoData.self, from: data)
                    completion(.success(task))
                    
                } catch let jsonError {
                    print(jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
        
    }
    
}
