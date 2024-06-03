//
//  SettingsView.swift
//  tripsage
//
//  Created by Proud Mpala on 6/3/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            Spacer()

            Button(action: {
                viewModel.logout()
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

            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
