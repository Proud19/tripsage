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
        }
    label: {
        Image(systemName: hearted ? "heart.fill" : "heart")
            .tint(hearted ? .red : .black)
            .font(.system(size: 15))
    }
    }
}

#Preview {
    HeartButton()
}
