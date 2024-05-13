//
//  SageTabView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/8/24.
//

import SwiftUI

extension View {
  func navigationBarBackground(_ background: Color = .white) -> some View {
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

struct SageTabView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.cyan
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                ExploreView()
                    .tabItem { Label("Explore", systemImage: "magnifyingglass.circle") }
                ActivityView()
                    .tabItem { Label("Activity", systemImage: "play") }
                AccountView()
                    .tabItem { Label("Account", systemImage: "person.crop.circle") }
            }.navigationTitle("Trip Sage")
                .navigationBarBackground(.blue)
        }
    }
}

#Preview {
    SageTabView()
}
