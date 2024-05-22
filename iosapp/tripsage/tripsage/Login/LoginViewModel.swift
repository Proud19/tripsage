//
//  LoginViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import Foundation


class LoginViewModel {
    
    func validateUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Simulate a network call with a delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            // Perform user validation logic here...
            let isValid = !username.isEmpty && !password.isEmpty
            DispatchQueue.main.async {
                completion(isValid)
            }
        }
    }
}
