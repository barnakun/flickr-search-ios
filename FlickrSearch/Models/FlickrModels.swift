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
    let total: Int
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

struct FlickrPhotoInfo: Codable {
    let photo: FlickrPhotoDetail
    let stat: String
}

struct FlickrPhotoDetail: Codable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let dateuploaded: String
    let isfavorite: Int
    let license: String
    let safety_level: String
    let rotation: Int
    let views: String?
    let media: String
    let title: FlickrTitle
    let description: FlickrDescription
    let visibility: FlickrVisibility
    let dates: FlickrDates
    let owner: FlickrOwner
    let comments: FlickrComments
    
    var formattedUploadDate: String {
        let timestamp = Double(dateuploaded) ?? 0
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedViews: String {
        guard let views = views, let viewCount = Int(views) else { return "Unknown" }
        
        if viewCount >= 1_000_000 {
            return String(format: "%.1fM", Double(viewCount) / 1_000_000.0)
        } else if viewCount >= 1_000 {
            return String(format: "%.1fK", Double(viewCount) / 1_000.0)
        } else {
            return "\(viewCount)"
        }
    }
    
    var licenseText: String {
        switch license {
        case "0": return "All Rights Reserved"
        case "1": return "Attribution-NonCommercial-ShareAlike"
        case "2": return "Attribution-NonCommercial"
        case "3": return "Attribution-NonCommercial-NoDerivs"
        case "4": return "Attribution"
        case "5": return "Attribution-ShareAlike"
        case "6": return "Attribution-NoDerivs"
        case "7": return "No known copyright restrictions"
        case "8": return "United States Government Work"
        case "9": return "Public Domain Dedication (CC0)"
        case "10": return "Public Domain Mark"
        default: return "Unknown License"
        }
    }
}

struct FlickrTitle: Codable {
    let _content: String
}

struct FlickrDescription: Codable {
    let _content: String
}

struct FlickrVisibility: Codable {
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}

struct FlickrDates: Codable {
    let posted: String
    let taken: String
    let takengranularity: Int
    let takenunknown: String
    let lastupdate: String
}

struct FlickrOwner: Codable {
    let nsid: String
    let username: String
    let realname: String?
    let location: String?
    let iconserver: String
    let iconfarm: Int
    let path_alias: String?
}

struct FlickrComments: Codable {
    let _content: String
}
