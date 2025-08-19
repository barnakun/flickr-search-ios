//
//  DetailViewModel.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 19..
//

import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    @Published var photo: FlickrPhoto
    @Published var isLoadingInfo = false
    @Published var photoInfo: FlickrPhotoInfo?
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    init(photo: FlickrPhoto) {
        self.photo = photo
        loadPhotoInfo()
    }
    
    
    func retryLoadingInfo() {
        loadPhotoInfo()
    }
    
    
    private func loadPhotoInfo() {
        isLoadingInfo = true
        errorMessage = nil
        
        Task {
            do {
                let info = try await apiService.getPhotoInfo(photoId: photo.id)
                photoInfo = info
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoadingInfo = false
        }
    }
}
