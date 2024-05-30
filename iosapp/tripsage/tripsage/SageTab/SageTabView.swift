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
    private let tabTitles = ["Explore", "Activity", "Account"]
    
    private let sageIcon: UIImage =  {
        guard let image = Bundle.main.icon else { return UIImage() }
        return image
    }()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.sage)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CustomTabView(selectedIndex: $selectedIndex) {
                    ExploreView()
                        .tag(0)
                    ActivityView()
                        .tag(1)
                    AccountView()
                        .tag(2)
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(uiImage: sageIcon)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    ToolbarItem(placement: .principal) {
                        Text(tabTitles[selectedIndex])
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .navigationBarBackground(.sage)
                .onAppear {
                    UITabBar.appearance().isHidden = true
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                    UINavigationBar.appearance().tintColor = .white
                }
            }
        }
    }
}

struct CustomTabView<Content: View>: View {
    @Binding var selectedIndex: Int
    let content: Content

    init(selectedIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectedIndex = selectedIndex
        self.content = content()
    }

    var body: some View {
        VStack {
            TabView(selection: $selectedIndex) {
                        content
                        .overlay(
                            Rectangle()
                                .foregroundColor(.clear)
                        )
            }
            HStack {
                TabBarItem(icon: "magnifyingglass.circle", isSelected: selectedIndex == 0)
                    .onTapGesture {
                        selectedIndex = 0
                    }
                Spacer()
                TabBarItem(icon: "record.circle", isSelected: selectedIndex == 1, isLarge: true)
                    .onTapGesture {
                        print("TApped")
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
    SageTabView()
}
