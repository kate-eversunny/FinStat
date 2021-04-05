//
//  SwiperView.swift
//  FinStat
//
//  Created by Ekaterina Gornostaewa on 4/4/21.
//  Copyright © 2021 Ekaterina Gornostaeva. All rights reserved.
//

import SwiftUI

struct SwiperView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var favorites: Favorites
    @EnvironmentObject var searches: SearchResultData
    
    let pages: [PageViewData]
    
    @Binding var index: Int
    @State private var offset: CGFloat = 0
    @State private var isUserSwiping: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(self.pages) { viewData in
                        PageView(viewData: viewData)
                            .environmentObject(self.modelData)
                            .environmentObject(self.favorites)
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                    }
                }
            }
            .content
            .offset(x: self.isUserSwiping ? self.offset : CGFloat(self.index) * -geometry.size.width)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.isUserSwiping = true
                        self.offset = value.translation.width + -geometry.size.width * CGFloat(self.index)
                    })
                    .onEnded({ value in
                        if value.predictedEndTranslation.width < geometry.size.width / 2, self.index < self.pages.count - 1 {
                            self.index += 1
                        }
                        if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                            self.index -= 1
                        }
                        withAnimation {
                            self.isUserSwiping = false
                        }
                    })
            )
        }
    }
}
