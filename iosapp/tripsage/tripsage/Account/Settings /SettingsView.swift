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
    
    @State private var responseLength: Double = 150
    @State private var funFactsFrequency: Int = 5
    @State private var selectedTheme: String = "Light"
    @State private var notificationsEnabled: Bool = true
    @State private var volume: Double = 0.5
    @State private var locationServicesEnabled: Bool = true
    @State private var darkMode: Bool = false
    @State private var autoPlayAudio: Bool = true
    @State private var preferredLanguage: String = "English"
    @State private var backgroundUpdates: Bool = true
    @State private var downloadOverWiFiOnly: Bool = true
    @State private var showMapPins: Bool = true
    @State private var voiceType: String = "Default"
    
    let themes = ["Light", "Dark", "System"]
    let languages = ["English", "Spanish", "French", "German", "Chinese"]
    let voiceTypes = ["Soprano", "Mezzo-Soprano", "Contralto"]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Preferences")) {
                    VStack(alignment: .leading) {
                        Text("Desired Length of Responses")
                        Slider(value: $responseLength, in: 30...500, step: 1)
                        Text("\(Int(responseLength)) words")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical)

                    VStack(alignment: .leading) {
                        Text("Desired Frequency of Fun Facts")
                        TextField("Frequency", value: $funFactsFrequency, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.vertical)
                }

                Section(header: Text("Appearance")) {
                    Picker("Select Theme", selection: $selectedTheme) {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Toggle(isOn: $darkMode) {
                        Text("Enable Dark Mode")
                    }
                }

                Section(header: Text("Notifications")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }

                    Toggle(isOn: $backgroundUpdates) {
                        Text("Allow Background Updates")
                    }
                }

                Section(header: Text("Audio")) {
                    VStack(alignment: .leading) {
                        Text("Volume")
                        Slider(value: $volume, in: 0...1, step: 0.01)
                        Text("\(Int(volume * 100))%")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical)
                    
                    Picker("Voice Type", selection: $voiceType) {
                        ForEach(voiceTypes, id: \.self) { voice in
                            Text(voice)
                        }
                    }

                    Toggle(isOn: $autoPlayAudio) {
                        Text("Auto Play Audio")
                    }
                }

                Section(header: Text("General")) {
                    Picker("Preferred Language", selection: $preferredLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }

                    Toggle(isOn: $locationServicesEnabled) {
                        Text("Enable Location Services")
                    }

                    Toggle(isOn: $downloadOverWiFiOnly) {
                        Text("Download Content Over WiFi Only")
                    }

                    Toggle(isOn: $showMapPins) {
                        Text("Show Points of Interest on Map")
                    }
                }
            }
            .frame(maxHeight: 600)
            .cornerRadius(10)
            .padding(.horizontal)
            .background(Color(.systemGroupedBackground))

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
        .environmentObject(AppState())
        .environmentObject(MainEntryViewModel())
}
