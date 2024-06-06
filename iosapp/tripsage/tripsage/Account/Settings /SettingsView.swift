//
//  SettingsView.swift
//  tripsage
//
//  Created by Proud Mpala on 6/3/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var appState: AppState
    
    @EnvironmentObject var mainEntryVieModel: MainEntryViewModel

    var body: some View {
        VStack {
            Spacer()

            Button(action: {
                self.mainEntryVieModel.isSignedIn = false
                KeyChainUtility.removeTokenFromKeychain()
                    
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarBackground(.sage)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        
    }
}

#Preview {
    SettingsView()
}
