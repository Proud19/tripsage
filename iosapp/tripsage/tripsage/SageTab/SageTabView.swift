import SwiftUI

extension View {
    func navigationBarBackground(_ background: Color) -> some View {
        self.modifier(ColoredNavigationBar(background: background))
    }
    
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor]
        return self
    }
}

struct ColoredNavigationBar: ViewModifier {
    var background: Color

    func body(content: Content) -> some View {
        content
            .toolbarBackground(
                background,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.hidden, for: .tabBar)
    }
}


extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}

struct SageTabView: View {
    @State private var selectedIndex = 0
    private let tabTitles = ["What's Nearby", "Activity", "Profile"]
    
    var user: User?
    @StateObject var sageTabViewModel = SageTabViewModel()
    
    private let sageIcon: UIImage =  {
        guard let image = Bundle.main.icon else { return UIImage() }
        return image
    }()
    
    private let sageImage: UIImage = {
            guard let image = UIImage(named: "sageImage") else { return UIImage() }
            return image
    }()
    
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    init(user: User?) {
        UITabBar.appearance().backgroundColor = UIColor(Color.sage)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().isHidden = true
        self.user = user
    }
    
    // Function to hide the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    func didTapStopTrip() {
        print("Stop trip button tapped")
        sageTabViewModel.activityViewModel.didFinishTrip()
        sageTabViewModel.userDidEndTrip()
    }
    
    var body: some View {
        Group {
            ZStack {
                CustomTabView(selectedIndex: $selectedIndex) {
                    ExploreView()
                        .tag(0)
                    ActivityView(activityViewModel: sageTabViewModel.activityViewModel, tripDelegate: sageTabViewModel)
                        .tag(1)
                    AccountView()
                        .tag(2)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if selectedIndex == 2 {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Image(uiImage: sageIcon)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        ToolbarItem(placement: .principal) {
                            Text(tabTitles[selectedIndex])
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                    } else if selectedIndex == 1 {
                        if keyboardResponder.isKeyboardVisible && sageTabViewModel.tripStarted {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    hideKeyboard()
                                }) {
                                    Image(systemName: "arrow.backward")
                                }
                            }
                            ToolbarItem(placement: .principal) {
                                Image(uiImage: sageImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    didTapStopTrip()
                                }) {
                                    Image(systemName: "stop.circle.fill")
                                        .foregroundColor(.red)
                                        .frame(width: 40, height: 40)
                                    
                                }
                            }
                        } else if sageTabViewModel.tripStarted {
                            ToolbarItem(placement: .principal) {
                                Image(uiImage: sageImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    didTapStopTrip()
                                }) {
                                    Image(systemName: "stop.circle.fill")
                                        .foregroundColor(.red)
                                        .frame(width: 40, height: 40)
                                    
                                }
                            }
                        }  else if keyboardResponder.isKeyboardVisible {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    hideKeyboard()
                                }) {
                                    Image(systemName: "arrow.backward")
                                }
                            }
                            ToolbarItem(placement: .principal) {
                                Image(uiImage: sageImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                
                            }
                        } else {
                            ToolbarItem(placement: .principal) {
                                Image(uiImage: sageImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    } else {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Image(uiImage: sageIcon)
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        ToolbarItem(placement: .principal) {
                            Text(tabTitles[selectedIndex])
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
                .navigationBarBackground(.sage)
       
                
                if keyboardResponder.isKeyboardVisible {
                    Color.clear
                        .onAppear {
                            UITabBar.appearance().isHidden = true
                        }
                        .onDisappear {
                            UITabBar.appearance().isHidden = false
                        }
                }
            }
        }
        .environmentObject(keyboardResponder)
    }
}

struct CustomTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let content: Content
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var keyboardResponder: KeyboardResponder

    init(selectedIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectedIndex = selectedIndex
        self.content = content()
    }

    var body: some View {
        VStack (spacing: 0) {
            TabView(selection: $selectedIndex) {
                        content
                        .overlay(
                            Rectangle()
                                .foregroundColor(.clear)
                        )
            }
            if !keyboardResponder.isKeyboardVisible {
                HStack {
                    TabBarItem(icon: "magnifyingglass.circle", isSelected: selectedIndex == 0)
                        .onTapGesture {
                            selectedIndex = 0
                        }
                    Spacer()
                    TabBarItem(icon: "record.circle", isSelected: selectedIndex == 1, isLarge: true)
                        .onTapGesture {
                            selectedIndex = 1
                        }
                    Spacer()
                    TabBarItem(icon: "person.crop.circle", isSelected: selectedIndex == 2)
                        .onTapGesture {
                            selectedIndex = 2
                        }
                }
                .padding()
                .background(Color.sage)
                .foregroundColor(.white)
            }
        }.toolbarBackground(.hidden, for: .tabBar)
    }
}

struct TabBarItem: View {
    let icon: String
    let isSelected: Bool
    var isLarge: Bool = false

    var body: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40)
            .padding(8)
            .background(isSelected ? Color.white.opacity(0.2) : Color.clear)
            .clipShape(Circle())
            .scaleEffect(isLarge ? 1.5 : 1.0)
    }
}

#Preview {
    SageTabView(user: Mocker.generateMockUser())
}
