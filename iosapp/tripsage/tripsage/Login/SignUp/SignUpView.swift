import SwiftUI

enum SignUpPageState {
    case normal
    case invalidCredentials
    case loading
}

struct SignUpView: View {

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var accountCreated: Bool = false
    @State private var pageState: SignUpPageState = .normal
    @State private var shakeEffectTrigger: CGFloat = 0
    
    private let sageIcon: UIImage = {
        guard let image = Bundle.main.icon else { return UIImage() }
        return image
    }()
    
    var signUpViewModel = SignUpViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo or title
                VStack {
                    Text("Sign Up")
                        .font(.title)
                        .bold()
                    Image(uiImage: sageIcon)
                        .cornerRadius(5)
                }
                
                // First name text field
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                
                // Last name text field
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                
                // Email address text field
                TextField("Email Address", text: $emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                
                // Password text field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                
                // Error message for invalid input
                if pageState == .invalidCredentials {
                    Text("An error occurred in registering")
                        .foregroundColor(.red)
                        .padding()
                        .modifier(ShakeEffect(animatableData: shakeEffectTrigger))
                        .onAppear {
                            withAnimation(.default) {
                                shakeEffectTrigger += 1
                            }
                        }
                }
                
                // Sign Up button
                Button(action: {
                    pageState = .loading
                    signUpViewModel.registerUser(firstName: firstName, lastName: lastName, emailAddress: emailAddress, password: password) { success in
                        pageState = .normal
                        if success {
                            accountCreated = true
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
                        Text("Sign Up")
                            .padding()
                            .background(Color.sage)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(pageState == .loading)
                
                // Spacer to push content to the top
                Spacer()
            }
            .padding()
            .background(
                NavigationLink(destination: OnBoardingView()) {
                    EmptyView()
                }
            )
        }
    }
}

#Preview {
    SignUpView()
}

