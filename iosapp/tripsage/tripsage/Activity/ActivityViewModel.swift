//
//  ActivityViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 6/4/24.
//


import Foundation

class ActivityViewModel: ObservableObject {
    @Published var messages = [Message]()
    
    @Published var activityViewPageState: ActivityViewState = .tripNotStarted
    @Published var isLoadingForTripStart = false
    
    var tripDelegate: TripDelegate?
    var tripID: String?
    
    @Published var mockData = [Message]()
    
    func tripInSession() -> Bool {
        return tripID != nil
    }
    var userInterests = [String]()
    
    func fetchUserInterests() {
        User.fetchUserInterests { interests in
            self.userInterests = interests
        }
    }
    
    init() {
        fetchUserInterests()
    }
    
    func requestForInitialMessages() {
        
        guard let location = LocationManager.shared.location else {
            print("Could not get user location for exploreview")
            return
        }
        
        let message = "Tell me a fun fact about anything nearby."
        
        
        var modifiedText = !self.userInterests.isEmpty ? "I like \(self.userInterests) and I'm at the \(location.coordinate) and Im am interested in \(self.userInterests), and \(message)" : message
        
        print(modifiedText)
        modifiedText += " KEEP YOUR RESPONSE TO PARAGRAPH FORM AND LESS THAN 100 WORDS."
        
        sendMessageForResponse(text: modifiedText) { response in
            if !response.isEmpty {
                DispatchQueue.main.async {
                    self.mockData.append(Message(userId: "", text: response, PhotoURL: "", createdAt: Date(), isFromUser: false))
                }
            } else {
                print("Got an empty message from sage")
            }
        }
        
    }
    
    func postMessageToSage(text: String) {
        sendMessage(text: text, interests: userInterests)
    }
    
    func sendMessage(text: String, interests: [String]) {
        print("Here!!!!!!!")
        if !text.isEmpty {
            DispatchQueue.main.async {
                self.mockData.append(Message(userId: "", text: text, PhotoURL: "", createdAt: Date(), isFromUser: true))
                
            }
        } else {
            print("Cannot send empty message")
            return
        }
        
        
        guard let location = LocationManager.shared.location else {
            print("Could not get user location for exploreview")
            return
        }
        
//        var modifiedText = interests.isEmpty ? "Hi, here is my message to you: \(text). \n\nI'm at the location \(location.coordinate) and Im am interested in \(interests), make your response relevant to the previous messaege as well as strongly take into account my interests" : text
        var modifiedText = !interests.isEmpty ? "I like \(interests) and I'm at the \(location.coordinate) and Im am interested in \(interests), and \(text)" : text
        
        print("The prompt is: \(modifiedText)")
        
        modifiedText += " KEEP YOUR RESPONSE TO PARAGRAPH FORM AND LESS THAN 100 WORDS."
        
        sendMessageForResponse(text: modifiedText) { response in
            print("user interests are \(interests), gettting response")
            if !response.isEmpty {
                DispatchQueue.main.async {
                    self.mockData.append(Message(userId: "", text: response, PhotoURL: "", createdAt: Date(), isFromUser: false))
                }
            } else {
                print("Got an empty message from sage")
            }
        }
    }
    
    func startTrip() {
        print("About to post start of a trip to the backend")
        guard let url = URLProvider.beginTrip else {
            print("Invalid URL")
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        isLoadingForTripStart = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoadingForTripStart = false
                if let error = error {
                    print("Error starting trip: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("Unexpected response: \(response.debugDescription)")
                    return
                }
                
                guard let responseData = data else {
                    print("No data received")
                    return
                }
                
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                        let tripID = jsonResponse["id"] as? String {
                        self.tripID = tripID
                        if self.tripDelegate != nil {
                            print("Delegate is there, so what the heck is going on")
                        }
                        self.tripDelegate?.userDidStartTrip()
                        self.activityViewPageState = .tripInSession
                        print("Trip started with id \(tripID)!")
                        print("curl -X POST 'https://tripsage-latest.onrender.com/users/getTripResponse' -H 'Content-Type: application/json' -H 'Authorization: Bearer \(token)' -d '{\"chatThreadId\": \"\(tripID)\", \"new_message\": \"\"}'")
                        
                    } else {
                        print("Failed to create user JSON response")
                    }
                } catch {
                    print("Error parsing JSON response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func didFinishTrip() {
        activityViewPageState = .savingFinishedTrip
        
        
        // Simulate a response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.activityViewPageState = .tripFinished
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.activityViewPageState = .tripNotStarted
                self.mockData.removeAll()
            }
        }
    }
    
    func sendMessageForResponse(text: String, completion: @escaping (String) -> Void) {
        guard let url = URLProvider.getTripResponse else {
            print("Invalid URL")
            completion("")
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            completion("")
            return
        }
        guard let tripID = tripID else {
            print("TripID does not exist")
            completion("")
            return
        }
        let parameters: [String: Any] = [
            "chatThreadId": tripID,
            "new_message": text
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            completion("")
            return
        }
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            print("Doing URL session...")
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion("")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion("")
                return
            }
            
            print("Got response: \(httpResponse)")
            // Check the HTTP status code
            if httpResponse.statusCode == 201 {
                if let responseData = data {
                    // Print the response body
                    print("Response Body: \(String(data: responseData, encoding: .utf8) ?? "Unable to parse body")")
                    // Parse the JSON response to extract the token
                    if let stringResponse = String(data: responseData, encoding: .utf8) {
                        completion(stringResponse)
                    } else {
                        print("Failed to create user JSON response")
                        completion("")
                    }
                } else {
                    print("No response data")
                    completion("")
                }
            } else {
                completion("")
            }
        }
        
        task.resume() // Starts the network task
        
    }
}

