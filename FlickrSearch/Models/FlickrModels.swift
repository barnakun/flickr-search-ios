//
//  FlickrModels.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 15..
//

import Foundation

struct FlickrResponse: Codable {
    let photos: FlickrPhotos
    let stat: String
}

struct FlickrPhotos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [FlickrPhoto]
}

struct FlickrPhoto: Codable, Identifiable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
    var thumbnailURL: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
    }
    
    var mediumURL: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_c.jpg"
    }
    
    var largeURL: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
    }
}
