//
//  VideoData.swift
//  Assignment
//
//  Created by Димаш Алтынбек on 11.10.2023.
//

import Foundation

class VideoData: Codable {
    let total: Int
    let totalHits: Int
    let hits: [VideoHits]
}

struct VideoHits: Codable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let duration: Int
    let picture_id: String
    let videos: Videos
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
}

struct Videos: Codable {
    let large: Large
    let medium: Medium
    let small: Small
    let tiny: Tiny
}

struct Large: Codable {
    let url: String
    let width: Int
    let height: Int
    let size: Int
}

struct Medium: Codable {
    let url: String
    let width: Int
    let height: Int
    let size: Int
}
struct Small: Codable {
    let url: String
    let width: Int
    let height: Int
    let size: Int
}
struct Tiny: Codable {
    let url: String
    let width: Int
    let height: Int
    let size: Int
}
