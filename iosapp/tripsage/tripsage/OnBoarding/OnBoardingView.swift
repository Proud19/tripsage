//
//  OnBoardingView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State private var interestInput: String = ""
    @State private var selectedInterests: [String] = []
    @State private var onBoardingViewModel = OnBoardingViewModel()
    @State private var isDoneAddingInterests = false
    
    let user: User
    
    var body: some View {
            if onBoardingViewModel.userNeedOnBoarding {
                VStack {
                    Text("Hie \(user.firstName), Sage would like to know what you are interested in. You can update these in your profile settings later ")
                        .font(.title)
                        .padding()

                    HStack {
                        TextField("Type your interest", text: $interestInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onChange(of: interestInput) { newValue in
                                if newValue.count > 50 {
                                    interestInput = String(newValue.prefix(50))
                                }
                            }

                        Button(action: {
                            if !interestInput.isEmpty {
                                selectedInterests.append(interestInput)
                                interestInput = ""
                            }
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.sage)
                                .cornerRadius(5)
                        }
                        .padding(.trailing)
                    }
                    .padding()

                    List {
                        ForEach(selectedInterests, id: \.self) { interest in
                            HStack {
                                Text(interest)
                                Spacer()
                                Button(action: {
                                    if let index = selectedInterests.firstIndex(of: interest) {
                                        selectedInterests.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .padding()
                    .listStyle(PlainListStyle())

                    Button(action: {
                        isDoneAddingInterests = true
                    }) {
                        Text("Done")
                            .padding()
                            .background(Color.sage)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
                .background(
                    NavigationLink(destination: SageTabView(user: user).navigationBarBackButtonHidden(), isActive: $isDoneAddingInterests) {
                        EmptyView()
                    }
                )
                
            } else {
                SageTabView(user: Mocker.generateMockUser())
            }
        }
}

#Preview {
    OnBoardingView(user: Mocker.generateMockUser())
}
