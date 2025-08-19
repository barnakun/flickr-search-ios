//
//  APIService.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 19..
//

import Foundation

final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    private let session = URLSession.shared
    private let baseURL = APIConstants.flickrBaseURL
    private let apiKey = APIConstants.flickrAPIKey
    
    enum APIError: Error, LocalizedError {
        case invalidURL
        case noData
        case decodingError(Error)
        case networkError(Error)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .noData:
                return "No data received"
            case .decodingError(let error):
                return "Failed to decode response: \(error.localizedDescription)"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .invalidResponse:
                return "Invalid response from server"
            }
        }
    }
    
    func searchPhotos(search: String, page: Int) async throws -> FlickrResponse {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "text", value: search),
            URLQueryItem(name: "per_page", value: String(APIConstants.photosPerPage)),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
            return flickrResponse
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    func getPhotoInfo(photoId: String) async throws -> FlickrPhotoInfo {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.getInfo"),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "photo_id", value: photoId),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let photoInfo = try decoder.decode(FlickrPhotoInfo.self, from: data)
            return photoInfo
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
