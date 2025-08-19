//
//  ContentView.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 15..
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var showingDetail = false
    @State private var selectedPhoto: FlickrPhoto?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                
                if viewModel.isLoading && viewModel.photos.isEmpty {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage, viewModel.photos.isEmpty {
                    errorView(errorMessage)
                } else {
                    photoGrid
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                viewModel.refreshPhotos()
            }
        }
    }
    
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search photos...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        viewModel.search()
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            
            Button("Search") {
                viewModel.search()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .padding(.trailing)
        }
        .padding(.vertical, 8)
    }
    
    
    // MARK: - Photo Grid
    
    private var photoGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.photos) { photo in
                    NavigationLink(destination: DetailView(photo: photo)) {
                        PhotoGridItem(photo: photo)
                    }
                    .onAppear {
                        if photo.id == viewModel.photos.last?.id {
                            viewModel.loadMorePhotosIfNeeded()
                        }
                    }
                }
                
                if viewModel.isLoadingMore {
                    loadMoreView
                }
            }
            .padding(.horizontal)
        }
    }
    
    
    // MARK: - Loading States
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Searching photos...")
                .scaleEffect(1.2)
            Spacer()
        }
    }
    
    private var loadMoreView: some View {
        HStack {
            Spacer()
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading more photos...")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button("Try Again") {
                viewModel.search()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
    }
}


#Preview {
    ContentView()
}
