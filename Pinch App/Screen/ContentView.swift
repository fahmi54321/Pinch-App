//
//  ContentView.swift
//  Pinch App
//
//  Created by Fahmi Aziz on 20/08/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    @State private var pageIndex: Int = 1
    
    let pages: [Page] = pagesData
    
    //MARK: - FUNCTION
    func resetImageState(){
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    func currentPage() -> String {
        return pages[pageIndex-1].imageName
    }
    
    //MARK: - CONTENT
    
    var body: some View {
        NavigationView {
            ZStack{
                
                Color.clear
                
                // MARK: - PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10.0)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12,x: 2,y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width,y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2) {
                        // MARK: 1. TAP GESTURE
                        
                        if(imageScale == 1){
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }else{
                            resetImageState()
                        }
                    }
                    
                    // MARK: 2. DRAG GESTURE
                    .gesture(
                        
                        
                        DragGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                            })
                            .onEnded({ _ in
                                if(imageScale <= 1){
                                    resetImageState()
                                }
                            })
                    )
                    
                    // MARK: 3. MAGNIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5{
                                        imageScale = value
                                    } else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded({ _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                }else if imageScale <= 1 {
                                    resetImageState()
                                }
                            })
                    )
                
                
            }// ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                withAnimation(.linear(duration: 1)){
                    isAnimating = true
                }
            }
            // MARK: - INFO PANEL
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top,30.0)
                ,alignment: .top
            )
            
            // MARK: - CONTROLS
            .overlay (
                Group{
                    HStack{
                        // SCALE DOWN
                        
                        Button {
                            // Some Action
                            
                            withAnimation {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                                
                                
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }

                        
                        // RESET
                        
                        Button {
                            // Some Action
                             resetImageState()
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // SCALE UP
                        Button {
                            // Some Action
                            withAnimation(.spring()){
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                        
                    } // CONTROLS
                    .padding(EdgeInsets(top: 12.0, leading: 20.0, bottom: 12.0, trailing: 20.0))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12.0)
                    .opacity(isAnimating ? 1 : 0)
                }.padding(.bottom,30.0)
                ,alignment: .bottom
                
            )
            
            // MARK: - DRAWER
            .overlay(
                HStack(spacing: 12.0) {
                    // MARK: - DRAWER HANDLE
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40.0)
                        .padding(8.0)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    // MARK: - THUMBNAILS
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5),value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    
                    Spacer()
                }// DRAWER
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame(width: 260)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                    .offset(x: isDrawerOpen ? 20 : 215)
                , alignment:  .topTrailing
            )
            
            
            
            
        }// NAVIGATION
        .navigationViewStyle(.stack)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 13")
    }
}
