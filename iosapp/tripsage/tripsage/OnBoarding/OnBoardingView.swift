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
    
    var body: some View {
        if onBoardingViewModel.userNeedOnBoarding {
            VStack {
                Text("Select Your Interests")
                    .font(.title)
                    .padding()

                TextField("Type your interest", text: $interestInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    // Add the interest to the list
                    selectedInterests.append(interestInput)
                    // Clear the text field after adding
                    interestInput = ""
                }) {
                    Text("Add")
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding()

                List(selectedInterests, id: \.self) { interest in
                    Text(interest)
                }
                .padding()

                Spacer()
                
                Button(action: {
                    isDoneAddingInterests = true
                }) {
                    Text("Done")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .background(
                NavigationLink(destination: SageTabView(), isActive: $isDoneAddingInterests) {
                    EmptyView()
                }
            )
            
        } else {
            SageTabView()
        }
    }
}

#Preview {
    OnBoardingView()
}
