//
//  ContentView.swift
//  Pinch
//
//  Created by Sandesh Naik on 18/06/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - properties
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffSet: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    @State private var pageIndex: Int = 1

    let pages: [Page] = pagesData
    
    //MARK: - functions
    //MARK: - content
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                //MARK: - Image
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ?  1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffSet.width, y: imageOffSet.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) { _  in
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                           reset()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear) {
                                    imageOffSet = value.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale <= 1 {
                                   reset()
                                }
                            })
                        
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                } else if imageScale <= 1 {
                                    reset()
                                }
                            })
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {self.isAnimating.toggle() })
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffSet)
                    .padding(.horizontal)
                    .padding(.top,30)
            }
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        //MARK: -SCALE DOWN
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    if imageScale <= 1 { reset() }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        //MARK: -RESET
                        Button {
                            reset()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        //MARK: -SCALEUP
                        Button {
                            withAnimation(.spring()) {
                                if imageScale <= 5 {
                                    imageScale += 1
                                    if imageScale >= 5 {  }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30)
            }
            .overlay(
                HStack(spacing: 12) {
                    //MARK: -Drawer handle
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    //MARK: - Thumbnail
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 1), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215),
                alignment: .topTrailing
                )
        }
        .navigationViewStyle(.stack)
        .padding()
    }
    
    private func reset() {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffSet = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex-1].imageName
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
