//
//  AppState.swift
//  tripsage
//
//  Created by Proud Mpala on 6/4/24.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    
    func logout() {
        isAuthenticated = false
    }
    
    func login() {
        isAuthenticated = true
    }
}
