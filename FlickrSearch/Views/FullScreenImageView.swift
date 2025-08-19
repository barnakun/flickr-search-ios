//
//  FullScreenImageView.swift
//  FlickrSearch
//
//  Created by Barnabás Kun on 2025. 08. 19..
//

import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    let photo: FlickrPhoto
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            KFImage(URL(string: photo.largeURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
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
            
            VStack {
                HStack {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    Spacer()
                    
                    if scale > 1.0 {
                        Button("Reset") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                resetZoom()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                }
                
                Spacer()
            }
        }
    }
    
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
