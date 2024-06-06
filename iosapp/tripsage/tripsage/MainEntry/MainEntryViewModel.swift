//
//  MainEntryViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import Foundation


class MainEntryViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var isSignedIn: Bool = false
    
    var user: User?
    var needsOnBoarding = true // True until proven otherwise
    
    var interests = [String]()
    
    init() {
        fetchUserProfile()
    }
    
    private func completion(_ isSignedIn: Bool) {
        DispatchQueue.main.async {
            self.isSignedIn = isSignedIn
            self.isLoading = false
        }
    }

    func fetchUserProfile() {
        print("Fetching user from the main entry view model")
        guard let loginEndPoint = URLProvider.profile else {
            print("Error in getting endpoint to login the user")
            completion(false)
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            completion(false)
            return
        }
        if let query = URLProvider.nearby  {
            print("The retrieved token, so can use the command: \ncurl -X GET '\(query)?latitude=40.7128&longitude=-74.0060' -H 'Authorization: Bearer \(token)'")
        }
        
        
        var request = URLRequest(url: loginEndPoint)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            print("Doing URL session...")
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                self.completion(false)
                return
            }
            
            print("Got response: \(httpResponse)")
            // Check the HTTP status code
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    // Print the response body
                    print("Response Body: \(String(data: responseData, encoding: .utf8) ?? "Unable to parse body")")
                    
                    // Parse the JSON response to extract the token
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                            self.user = try JSONDecoder().decode(User.self, from: responseData)
                            print("Fetching user interests")
                            User.fetchUserInterests { interests in
                                print("Successfully fetched user interests")
                                self.needsOnBoarding = interests.isEmpty
                                self.completion(true)
                            }
            
                        } else {
                            print("Failed to create user JSON response")
                            self.completion(false)
                        }
                    } catch {
                        print("Error parsing JSON response: \(error.localizedDescription)")
                        self.completion(false)
                    }
                } else {
                    print("No response data")
                    self.completion(false)
                }
            } else {
                self.completion(false)
            }
        }
        
        task.resume() // Starts the network task
    }
}
