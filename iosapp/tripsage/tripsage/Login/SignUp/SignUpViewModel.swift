//
//  SignUpViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 5/28/24.
//

import Foundation

class SignUpViewModel {
    
    
    var loginViewModel = LoginViewModel()
    var user: User?
    
    func registerUser(firstName: String, lastName: String, emailAddress: String, password: String, completion: @escaping (Bool) -> Void) {
        // Define the URL and the request
        guard let url = URLProvider.registerUser else {
            print("Invalid URL")
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Define the JSON payload
        let parameters: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "emailAddress": emailAddress,
            "password": password
        ]
        
        // Convert the payload to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(false)
                return
            }
            print(httpResponse)
            // Check the HTTP status code
            if httpResponse.statusCode == 201 {
                if let responseData = data {
                    // Print the response body
                    print("Response Body: \(String(data: responseData, encoding: .utf8) ?? "Unable to parse body")")
                    
                    // Parse the JSON response to extract the token
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let token = jsonResponse["access_token"] as? String
                         {
                            print("Access Token: \(token)")
                            KeyChainUtility.saveTokenToKeychain(token)
                            self.user = self.loginViewModel.user
                            completion(true)
                        } else {
                            print("Failed to parse JSON response")
                            completion(false)
                        }
                    } catch {
                        print("Error parsing JSON response: \(error.localizedDescription)")
                        completion(false)
                    }
                } else {
                    print("No response data")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        
        task.resume()
    }
}
