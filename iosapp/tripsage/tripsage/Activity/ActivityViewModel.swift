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
    
    var tripDelegate: TripDelegate?
    
    @Published var mockData = [Message]()
    
    func serveInitialMessages() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.mockData.append(Message(userId: "12345", text: "Welcome to Salt Lake City!\nMy name is Sage, and I'll be your tour guide today. I'll be back when you're near a landmark you might be interested in!", PhotoURL: "", createdAt: Date(), isFromUser: false))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.mockData.append(Message(userId: "12345", text: "You are near the Natural History Museum of Utah, a museum as dramatic as the wonders it holds. There, you can learn about the natural world and the place of humans within it", PhotoURL: "", createdAt: Date(), isFromUser: false))
            }
        }
    }
    
    
    func didFinishTrip() {
        activityViewPageState = .savingFinishedTrip
        
        // Simulate a response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.activityViewPageState = .tripFinished
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.activityViewPageState = .tripNotStarted
            }
        }
        
    }
    
    func sendMessage(text: String) {
        print(text)
        let userMessage = Message(userId: "12345", text: text, PhotoURL: "", createdAt: Date(), isFromUser: true)
        mockData.append(userMessage)
        
        // Simulate a response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let responseMessage = Message(userId: "54321", text: "Thank you for your message! How can I assist you further?", PhotoURL: "", createdAt: Date(), isFromUser: false)
            self.mockData.append(responseMessage)
        }
    }
}
