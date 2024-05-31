//
//  LoginView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import SwiftUI

// Shake effect modifier
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

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
    @State private var shakeEffectTrigger: CGFloat = 0
    
    private let sageIcon: UIImage = {
        guard let image = Bundle.main.icon else { return UIImage() }
        return image
    }()
    
    var loginViewModel = LoginViewModel()
    
    var body: some View {
            VStack {
                // Logo or title
                VStack {
                    Text("Login")
                        .font(.title)
                        .bold()
                    Image(uiImage: sageIcon)
                        .cornerRadius(5)
                }
                
                // Username text field
                TextField("Email Address", text: $username)
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
                        .modifier(ShakeEffect(animatableData: shakeEffectTrigger))
                        .onAppear {
                            withAnimation(.default) {
                                shakeEffectTrigger += 1
                            }
                        }
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
                
                // Button to sign up
                NavigationLink(destination: SignUpView()) {
                    Text("Do not have an account, sign up instead")
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }

                // Spacer to push content to the top
                Spacer()
            }
            .padding()
            .background(
                NavigationLink(destination: OnBoardingView(user: Mocker.generateMockUser()), isActive: $loggedIn) {
                    EmptyView()
                }
            )
    }
}

#Preview {
    LoginView()
}
