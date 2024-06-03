//
//  MainEntryView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/7/24.
//


/* Here we try to check if there is an existing token in the user device
    and fet*/

import SwiftUI

extension Color {
    static let sageOrange = Color(hex: "#ed8837")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}


struct MainEntryView: View {
    @StateObject var mainEntryViewModel = MainEntryViewModel()
    @State private var pulse = false
    
    let mockUser = Mocker.generateMockUser()

    private let sageImage: UIImage = {
            guard let image = UIImage(named: "sageImage") else { return UIImage() }
            return image
    }()

    var body: some View {
        NavigationView {
            Group {
                if mainEntryViewModel.isLoading {
                    VStack {
                        Spacer()
                        Image(uiImage: sageImage)
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
                    .onAppear {
                        pulse = true
                    }
                } else {
                    if mainEntryViewModel.isSignedIn {
                        OnBoardingView(user: self.$mainEntryViewModel.user.wrappedValue!) // TODO, not cool!!!!
                    } else {
                        LoginView()
                    }
                }
            }
        }
    }
}

#Preview {
    MainEntryView()
}

