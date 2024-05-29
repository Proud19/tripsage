import Foundation
import Security

class LoginViewModel {
    
    func validateUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Define the URL and the request
        
        
        completion(true)
        return
        
        print("Starting to validate...")
        let url = URL(string: "https://6062-171-66-12-150.ngrok-free.app/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("About to send request...")
        
        // Define the JSON payload
        let parameters: [String: Any] = [
            "emailAddress": username,
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
        
        print("The request body is")
        guard let body = request.httpBody else { return }
        print(body)
        
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
        
            print(httpResponse)
            
            // Check the HTTP status code
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    // Print the response body
                    print("Response Body: \(String(data: responseData, encoding: .utf8) ?? "Unable to parse body")")
                    
                    // Parse the JSON response to extract the token
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let token = jsonResponse["access_token"] as? String {
                            print("Access Token: \(token)")
                            // Save the token to Keychain
                            KeyChainUtility.saveTokenToKeychain(token)
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
