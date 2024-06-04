//
//  ExploreView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/8/24.
//

import SwiftUI

struct SwipeArrowView: View {
    @State private var animateUp = false

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "chevron.up")
                .font(.largeTitle)
                .foregroundColor(.white)
                .opacity(0.8)
                .offset(y: animateUp ? -20 : 0)
                .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animateUp)
            Spacer().frame(height: 50) // Adjust to position the arrow correctly
        }
        .onAppear {
            animateUp = true
        }
    }
}


struct VerticalSwipeView: View {
    @State private var currentIndex: Int = 0
    @State private var showSwipeArrow = true
    @StateObject var exploreViewModel = ExploreViewModel()

    var body: some View {
        GeometryReader { geometry in
            let _ = {
                print(exploreViewModel.landmarks)
            }()
            ZStack {
                ForEach(exploreViewModel.landmarks.indices, id: \.self) { index in
                    LandmarksView(landmark: exploreViewModel.landmarks[index])
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: CGFloat(index - currentIndex) * geometry.size.height)
                        .animation(.spring(), value: currentIndex)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    withAnimation {
                                        if value.translation.height < -50, currentIndex < exploreViewModel.landmarks.count - 1 {
                                            currentIndex += 1
                                            showSwipeArrow = false
                                        } else if value.translation.height > 50, currentIndex > 0 {
                                            currentIndex -= 1
                                            showSwipeArrow = false
                                        }
                                    }
                                }
                        )
                }
                
                if showSwipeArrow {
                    SwipeArrowView()
                }
            }
        }
    }
}

struct ExploreView: View {
    var body: some View {
        VerticalSwipeView()
    }
}

#Preview {
    ExploreView()
}
