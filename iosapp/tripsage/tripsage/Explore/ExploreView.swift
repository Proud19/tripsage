//
//  ExploreView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/8/24.
//

import SwiftUI

struct ExploreView: View {
    // navigation stack to nav to another view
    var body: some View {
        // Text("Explore")
        NavigationStack {
            ScrollView {
                LazyVStack{
                    ForEach(0 ... 5, id: \.self) { landmark in
                        LandmarksView()
                            .frame(height: 500)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                }
            }
        }
    }
    
    
    
}

#Preview {
    ExploreView()
}
