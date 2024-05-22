import SwiftUI

extension View {
    func navigationBarBackground(_ background: Color) -> some View {
        return self
            .modifier(ColoredNavigationBar(background: background))
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
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                ExploreView()
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle")
                         
                    }
                    .tag(0)
                ActivityView()
                    .tabItem {
                        Image(systemName: "record.circle")
                          
                    }
                    .tag(1)
                AccountView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                         
                    }
                    .tag(2)
            }
            .navigationTitle(tabTitles[selectedIndex])
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(uiImage: sageIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
            .navigationBarBackground(.sage)
            .onAppear {
                UITabBar.appearance().barTintColor = UIColor(Color.sage)
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.red]
            }
        }
    }
}

#Preview {
    SageTabView()
}
