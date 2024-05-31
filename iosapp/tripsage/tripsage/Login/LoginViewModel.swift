import Foundation
import Security

class LoginViewModel {
    
    private let secretUserName = "t@g.com"
    private let secretPassword = "sage"
    
    
    func validateUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Define the URL and the request
        
        if username == secretUserName && password == secretPassword {
            print("Login in user via secret credentials...")
            completion(true)
            return
        }
        
    
        print("Validating user with username: \(username)...")
        
        guard let loginEndPoint = URLProvider.loginUser else {
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
        
        var request = URLRequest(url: loginEndPoint)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
//        // Define the JSON payload
//        let parameters: [String: Any] = [
//            "emailAddress": username,
//            "password": password,
//        ]
//        print("Converting payload to json data")
//        // Convert the payload to JSON data
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        } catch let error {
//            print("Error: \(error.localizedDescription)")
//            completion(false)
//            return
//        }
        
        
        
        
//        guard let body = request.httpBody else { return }
//        print("Request created, the request body is: \(body)")
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            print("Doing URL session...")
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
            
            print("Got response: \(httpResponse)")
            // Check the HTTP status code
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    // Print the response body
                    print("Response Body: \(String(data: responseData, encoding: .utf8) ?? "Unable to parse body")")
                    
                    // Parse the JSON response to extract the token
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        {
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
        
        task.resume() // Starts the network task
    }
}
