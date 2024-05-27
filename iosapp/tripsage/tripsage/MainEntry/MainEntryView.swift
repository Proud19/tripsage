//
//  MainEntryView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/7/24.
//

import SwiftUI

struct MainEntryView: View {
    @StateObject var mainEntryViewModel = MainEntryViewModel()
    @State private var showAnimation = true
    @State private var pulse = false

    private let sageIcon: UIImage = {
        guard let image = Bundle.main.icon else { return UIImage() }
        return image
    }()

    var body: some View {
        Group {
            if showAnimation {
                VStack {
                    Spacer()
                    Image(uiImage: sageIcon)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(5.0)
                        .scaleEffect(pulse ? 1.2 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: pulse
                        )
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.sage.edgesIgnoringSafeArea(.all))
                .onAppear {
                    pulse = true
                    // Transition to the main entry view after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showAnimation = false
                        }
                    }
                }
            } else {
                if mainEntryViewModel.isSignedIn {
                    OnBoardingView()
                } else {
                    LoginView()
                }
            }
        }
    }
}

#Preview {
    MainEntryView()
}
