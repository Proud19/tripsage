//
//  User.swift
//  tripsage
//
//  Created by Proud Mpala on 5/30/24.
//

import Foundation


struct User: Codable, Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case emailAddress
    }
    
    static func emptyUser() -> User {
        return User(id: "", firstName: "", lastName: "", emailAddress: "")
    }
    
    static func fetchUserInterests(completion: @escaping ([String]) -> Void) {
        guard let url = URLProvider.interests else {
            print("Invalid URL")
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            print("Doing URL session...")
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion([])
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
                        if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: String]] {
                            
                            completion(jsonResponse.map({ nameInterestPair in
                                nameInterestPair["name"]!
                            }))
                        } else {
                            print("Failed to create user JSON response")
                            completion([])
                        }
                    } catch {
                        print("Error parsing JSON response: \(error.localizedDescription)")
                        completion([])
                    }
                } else {
                    print("No response data")
                    completion([])
                }
            } else {
                completion([])
            }
        }
        
        task.resume()
    }
    
    static func fetchUserProfile(completion: @escaping (User?) -> Void) {
        print("Fetching user from the main entry view model")
        guard let loginEndPoint = URLProvider.profile else {
            print("Error in getting endpoint to login the user")
            completion(nil)
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            completion(nil)
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
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(nil)
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
                            let user = try JSONDecoder().decode(User.self, from: responseData)
                            completion(user)
                        } else {
                            print("Failed to create user JSON response")
                            completion(nil)
                        }
                    } catch {
                        print("Error parsing JSON response: \(error.localizedDescription)")
                        completion(nil)
                    }
                } else {
                    print("No response data")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume() // Starts the network task
    }
    
}
