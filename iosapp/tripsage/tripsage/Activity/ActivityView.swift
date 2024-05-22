//
//  ActivityView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/8/24.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var messages = [Message]()
    
    @Published var mockData = [
        Message(userId: "12345", text: "Welcome to Salt Lake City!\nMy name is Sage, and I’ll be your tour guide today. I’ll be back when you’re near a landmark you might be interested in!", PhotoURL: "", createdAt: Date(), isFromUser: false),
        Message(userId: "12345", text: "You are near the Natural History Museum of Utah, a museum as dramatic as the wonders it holds. There, you can learn about the natural world and the place of humans within it", PhotoURL: "", createdAt: Date(), isFromUser: false),
        ]
    
    func sendMessage(text: String){
        print(text)
    }
                
}

struct ActivityView: View {
    @StateObject var chatViewModel = ChatViewModel()
    @State var text = ""
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing:8){
                    ForEach(chatViewModel.mockData){ message in
                        MessageView(message: message)
                    }
                }
            }
            HStack {
                TextField("Hello there", text: $text, axis: .vertical)
                    .padding()
                Button{
                    if text.count >= 2{
                        chatViewModel.sendMessage(text: text)
                        chatViewModel.mockData.append(Message(userId: "12345", text: text, PhotoURL: "", createdAt: Date(), isFromUser: true))
                        text = ""
                    }
                } label: {
                    Text("Send")
                        .padding()
                        .foregroundColor(.white)
                        .background(.mint)
                        .cornerRadius(50)
                        .padding(.trailing)
                }
            }.background(Color(uiColor: .systemGray6))
        }
    }
}

struct ActivityView_Previews: PreviewProvider{
    static var previews: some View{
        ActivityView()
    }
}

