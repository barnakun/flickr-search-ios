//
//  Constants.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 15..
//

import Foundation

struct APIConstants {
    static let flickrAPIKey = Config.flickrAPIKey
    static let flickrBaseURL = "https://www.flickr.com/services/rest/"
    static let defaultSearchTerm = "dog"
    static let photosPerPage = 20
}

struct UserDefaultsKeys {
    static let lastSearchTerm = "lastSearchTerm"
}
