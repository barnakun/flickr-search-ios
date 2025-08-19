//
//  PhotoGridItem.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 17..
//

import SwiftUI
import Kingfisher

struct PhotoGridItem: View {
    let photo: FlickrPhoto
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            KFImage(URL(string: photo.thumbnailURL))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.7)
                        )
                }
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
