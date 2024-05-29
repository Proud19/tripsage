//
//  MainEntryViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import Foundation


class MainEntryViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    
    init() { }
    
    public var isSignedIn: Bool {
        return KeyChainUtility.retrieveTokenFromKeychain() != nil
    }
}
