//
//  PhotoGridItem.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 19..
//

import SwiftUI
import Kingfisher

struct PhotoGridItem: View {
    let photo: FlickrPhoto
    
    var body: some View {
        ZStack {
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
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width / 2 - 24, height: UIScreen.main.bounds.width / 2 - 24)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}
