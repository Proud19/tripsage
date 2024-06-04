//
//  MessageView.swift
//  tripsage
//
//  Created by Beatriz Cunha Freire on 19/05/24.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    
    private let sageImage: UIImage = {
            guard let image = UIImage(named: "sageImage") else { return UIImage() }
            return image
    }()
    
    var body: some View {
        if !message.isFromUser {
            HStack () {
                HStack () {
                    Text(message.text).padding()
                }
                .frame(maxWidth: 260, alignment: .topLeading)
                .background(Color(uiColor: .systemBlue))
                .cornerRadius(20)
                
                Image(uiImage: sageImage)
                    .resizable()
                    .frame(width: 32, height: 32, alignment: .top)
                    .cornerRadius(16)
                    .padding(.trailing, 4)
            }
            .frame(maxWidth: 360, alignment: .trailing)
        } else {
            HStack () {
                Image(systemName: "person")
                    .frame(maxHeight: 32, alignment: .top)
                    .padding(.trailing, 4)
                HStack () {
                    Text(message.text).padding()
                }
                .frame(maxWidth: 260, alignment: .leading)
                .background(Color(uiColor: .lightGray))
                .cornerRadius(20)
            }
            .frame(maxWidth: 360, alignment: .leading)
        }
            
    }
}

struct MessageView_Preview: PreviewProvider{
    static var previews: some View{
        MessageView(message: Message(userId: "123", text: "hello", PhotoURL: "", createdAt: Date(), isFromUser: false))
    }
}
