//
//  MainEntryView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/7/24.
//

import SwiftUI

struct MainEntryView: View {
    @StateObject var mainEntryViewModel = MainEntryViewModel()
    
    var body: some View {
        if mainEntryViewModel.isSignedIn {
            OnBoardingView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    MainEntryView()
}
