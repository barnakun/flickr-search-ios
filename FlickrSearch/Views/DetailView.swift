//
//  DetailView.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 19..
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var showingFullScreen = false
    
    init(photo: FlickrPhoto) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(photo: photo))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                photoSection
                infoSection
            }
            .padding()
        }
        .navigationTitle(viewModel.photo.title.isEmpty ? "Photo" : viewModel.photo.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showingFullScreen) {
            FullScreenImageView(photo: viewModel.photo, isPresented: $showingFullScreen)
        }
    }
    
    
    // MARK: - Photo Section
    
    private var photoSection: some View {
        VStack(spacing: 12) {
            ZStack {
                KFImage(URL(string: viewModel.photo.largeURL))
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .aspectRatio(4/3, contentMode: .fit)
                            .cornerRadius(16)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(1.2)
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(combinedGesture)
                    .onTapGesture(count: 2) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            if scale > 1.0 {
                                resetZoom()
                            } else {
                                scale = 2.0
                            }
                        }
                    }
                    .onTapGesture {
                        showingFullScreen = true
                    }
                    .clipped()
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Double tap to zoom")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Tap to view fullscreen")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if scale > 1.0 {
                    Button("Reset Zoom") {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            resetZoom()
                        }
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                }
            }
        }
    }
    
    
    // MARK: - Info Section
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Photo Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            if viewModel.isLoadingInfo {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading photo details...")
                        .foregroundColor(.secondary)
                }
            } else if let errorMessage = viewModel.errorMessage {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Failed to load photo details")
                        .foregroundColor(.red)
                    
                    Button("Retry") {
                        viewModel.retryLoadingInfo()
                    }
                    .buttonStyle(.bordered)
                }
            } else if let photoInfo = viewModel.photoInfo {
                photoDetails(photoInfo.photo)
            }
            
            basicPhotoInfo
        }
    }
    
    private func photoDetails(_ detail: FlickrPhotoDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !detail.title._content.isEmpty {
                InfoRow(title: "Title", value: detail.title._content)
            }
            
            if !detail.description._content.isEmpty {
                InfoRow(title: "Description", value: detail.description._content)
            }
            
            InfoRow(title: "Owner", value: detail.owner.username)
            
            if let realname = detail.owner.realname, !realname.isEmpty {
                InfoRow(title: "Real Name", value: realname)
            }
            
            if let location = detail.owner.location, !location.isEmpty {
                InfoRow(title: "Location", value: location)
            }
            
            InfoRow(title: "Uploaded", value: detail.formattedUploadDate)
            
            if let views = detail.views {
                InfoRow(title: "Views", value: detail.formattedViews)
            }
            
            InfoRow(title: "Taken", value: detail.dates.taken)
            
            InfoRow(title: "License", value: detail.licenseText)
        }
    }
    
    private var basicPhotoInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()
            
            Text("Technical Details")
                .font(.subheadline)
                .fontWeight(.medium)
            
            InfoRow(title: "Photo ID", value: viewModel.photo.id)
            InfoRow(title: "Server", value: viewModel.photo.server)
            InfoRow(title: "Farm", value: "\(viewModel.photo.farm)")
        }
    }
    
    
    // MARK: - Gestures
    
    private var combinedGesture: some Gesture {
        SimultaneousGesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = max(1.0, min(value, 4.0))
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        if scale < 1.2 {
                            resetZoom()
                        }
                    }
                },
            
            DragGesture()
                .onChanged { value in
                    if scale > 1.0 {
                        offset = value.translation
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        if scale <= 1.0 {
                            offset = .zero
                        }
                    }
                }
        )
    }
    
    private func resetZoom() {
        scale = 1.0
        offset = .zero
    }
}


#Preview {
    NavigationView {
        DetailView(photo: FlickrPhoto(
            id: "123",
            owner: "owner",
            secret: "secret",
            server: "server",
            farm: 1,
            title: "Sample Photo",
            ispublic: 1,
            isfriend: 0,
            isfamily: 0
        ))
    }
    //ContentView()
}
