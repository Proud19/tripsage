//
//  LoginView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loggedIn: Bool = false
    
    var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo or title
                Text("Welcome to TripSage")
                    .font(.largeTitle)
                
                // Username text field
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Password text field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Login button
                Button(action: {
                    // Perform login logic here...
                    // For simplicity, just print the username and password
                    if loginViewModel.validateUser(username: username, password: password) {
                        loggedIn = true
                    } else {
                        // User is invalid, show error message or handle accordingly
                        print("Invalid username or password")
                    }
                }) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Additional actions like forgot password or signup
                HStack {
                    Spacer()
                    Button(action: {
                        // Forgot password action
                        print("Forgot password tapped")
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 10)
                
                // Spacer to push content to the top
                Spacer()
            }
            .padding()
            .background(
                // User is valid, perform login action
                NavigationLink(destination: OnBoardingView(), isActive: $loggedIn) {
                        EmptyView()
                }
            )
        }
    }
}

#Preview {
    LoginView()
}
