//
//  HeartButton.swift
//  tripsage
//
//  Created by Emma Wong on 12/5/2024.
//

import SwiftUI

struct HeartButton: View {
    
    @State private var hearted = false
    
    var body: some View {
        Button {
            self.hearted.toggle()
        } label: {
            ZStack {
                image(Image(systemName: "heart.fill"), show: hearted)
                image(Image(systemName: "heart"), show: !hearted)
            }
        }
    }

        
    func image(_ image: Image, show: Bool) -> some View {
        image
            .tint(hearted ? .red : .black)
            .font(.system(size: 16))
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
    }
}

#Preview {
    HeartButton()
}

