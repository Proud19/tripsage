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
    
    @EnvironmentObject var appState: AppState

    private let sageImage: UIImage = {
            guard let image = UIImage(named: "sageImage") else { return UIImage() }
            return image
    }()

    var body: some View {
        NavigationView {
            Group {
                if mainEntryViewModel.isLoading {
                    SageLoadingView()
                } else {
                    if mainEntryViewModel.isSignedIn {
                        if mainEntryViewModel.needsOnBoarding {
                            OnBoardingView(user: self.$mainEntryViewModel.user.wrappedValue!) // TODO, not cool!!!!
                        } else {
                            SageTabView(user: self.$mainEntryViewModel.user.wrappedValue!) // TODO, not cool 
                        }
                    } else {
                        LoginView()
                    }
                }
            }
        }
        .environmentObject(mainEntryViewModel)
    }
}

#Preview {
    MainEntryView()
}

