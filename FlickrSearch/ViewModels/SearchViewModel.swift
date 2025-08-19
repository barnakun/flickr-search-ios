//
//  SearchViewModel.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 19..
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var photos: [FlickrPhoto] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var hasMorePages = true
    
    private var currentPage = 1
    private var totalPages = 0
    private var currentSearchTerm = ""
    private let apiService = APIService.shared
    
    init() {
        loadLastSearchTerm()
        performInitialSearch()
    }
    
    
    func search() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        resetPagination()
        currentSearchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        saveLastSearchTerm()
        
        Task {
            await performSearch()
        }
    }
    
    func loadMorePhotosIfNeeded() {
        guard !isLoadingMore && hasMorePages && currentPage < totalPages else { return }
        
        Task {
            await loadMorePhotos()
        }
    }
    
    func refreshPhotos() {
        resetPagination()
        
        Task {
            await performSearch()
        }
    }
    
    
    private func loadLastSearchTerm() {
        let lastTerm = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastSearchTerm) ?? APIConstants.defaultSearchTerm
        searchText = lastTerm
        currentSearchTerm = lastTerm
    }
    
    private func saveLastSearchTerm() {
        UserDefaults.standard.set(currentSearchTerm, forKey: UserDefaultsKeys.lastSearchTerm)
    }
    
    private func performInitialSearch() {
        Task {
            await performSearch()
        }
    }
    
    private func resetPagination() {
        currentPage = 1
        totalPages = 0
        photos.removeAll()
        hasMorePages = true
        errorMessage = nil
    }
    
    private func performSearch() async {
        guard !currentSearchTerm.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.searchPhotos(search: currentSearchTerm, page: currentPage)
            
            photos = response.photos.photo
            totalPages = response.photos.pages
            currentPage = response.photos.page
            hasMorePages = currentPage < totalPages
            
        } catch {
            errorMessage = error.localizedDescription
            photos.removeAll()
        }
        
        isLoading = false
    }
    
    private func loadMorePhotos() async {
        guard !currentSearchTerm.isEmpty else { return }
        
        isLoadingMore = true
        let nextPage = currentPage + 1
        
        do {
            let response = try await apiService.searchPhotos(search: currentSearchTerm, page: nextPage)
            
            let newPhotos = response.photos.photo.filter { newPhoto in
                !photos.contains { existingPhoto in existingPhoto.id == newPhoto.id }
            }
            
            photos.append(contentsOf: newPhotos)
            currentPage = response.photos.page
            hasMorePages = currentPage < totalPages
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingMore = false
    }
}
