//
//  SageLoadingView.swift
//  tripsage
//
//  Created by Proud Mpala on 6/4/24.
//

import SwiftUI

struct SageLoadingView: View {
    @State private var pulse = false
    private let sageImage: UIImage = {
            guard let image = UIImage(named: "sageImage") else { return UIImage() }
            return image
    }()
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: sageImage)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(5.0)
                .scaleEffect(pulse ? 1.5 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                    value: pulse
                )
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            pulse = true
        }
        .background(Color.sage)
    }
}

#Preview {
    SageLoadingView()
}
