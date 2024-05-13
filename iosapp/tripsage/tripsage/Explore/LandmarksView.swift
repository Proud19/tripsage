//
//  LandmarksView.swift
//  tripsage
//
//  Created by Emma Wong on 12/5/2024.
//

import SwiftUI

struct LandmarksView: View {
    
    var landmark_images = ["exp-1", "exp-2", "exp-3", "exp-4"]
    
    var body: some View {
        VStack(spacing: 8) {
            // landmark images
            TabView {
                ForEach(landmark_images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tabViewStyle(.page)
            
            // landmark details
            VStack (alignment: .leading){
                // first line
                HStack {
                    // landmark name
                    Text("Memorial Church").fontWeight(.semibold)
                    Spacer()
                    // distance away
                    Text("1 mile away")
                }
                // city / town name
                Text("Stanford, CA").foregroundStyle(.gray)
                // other details
                Spacer()
                Text("Stanford Memorial Church is located on the Main Quad at the center of the Stanford University campus in Stanford, California, United States. It was built during the American Renaissance by Jane Stanford as a memorial to her husband Leland.")
            }
            .font(.footnote)
        }
        .padding()
    }
}

#Preview {
    LandmarksView()
}
