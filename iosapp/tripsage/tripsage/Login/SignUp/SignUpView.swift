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
    
    @StateObject var signUpViewModel = SignUpViewModel()
    
    var body: some View {
        
        if accountCreated && signUpViewModel.user != nil {
            OnBoardingView(user: signUpViewModel.user!)
        } else {
            VStack {
                VStack {
                    Text("Sign Up")
                        .font(.title)
                        .bold()
                    Image(uiImage: sageIcon)
                        .cornerRadius(5)
                }
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                TextField("Email Address", text: $emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(pageState == .loading)
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
                Button(action: {
                    pageState = .loading
                    signUpViewModel.registerUser(firstName: firstName, lastName: lastName, emailAddress: emailAddress, password: password) { success in
                        pageState = .normal
                        if success {
                            print("Account successfuly created!")
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
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    SignUpView()
}

