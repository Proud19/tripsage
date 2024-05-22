//
//  LoginView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import SwiftUI


enum LoginPageState {
    case normal
    case invalidCredentials
    case loading
}

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loggedIn: Bool = false
    @State private var pageState: LoginPageState = .normal
    
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
                    .disabled(pageState == .loading)
                
                // Password text field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                
                // Error message for invalid credentials
                if pageState == .invalidCredentials {
                    Text("Invalid username or password")
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Login button
                Button(action: {
                    pageState = .loading
                    loginViewModel.validateUser(username: username, password: password) { success in
                        pageState = .normal
                        if success {
                            loggedIn = true
                        } else {
                            pageState = .invalidCredentials
                        }
                    }
                }) {
                    if pageState == .loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                            .background(Color.sage)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Text("Login")
                            .padding()
                            .background(Color.sage)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(pageState == .loading)
                
                // Additional actions like forgot password or signup
                HStack {
                    Spacer()
                    Button(action: {
                        // Forgot password action
                        print("Forgot password tapped")
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.sage)
                    }
                }
                .padding(.top, 10)
                
                // Spacer to push content to the top
                Spacer()
            }
            .padding()
            .background(
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
