//
//  ActivityView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/8/24.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        HStack () {
            Image(systemName: "person")
                .frame(maxHeight: 32, alignment: .top)
                .padding(.trailing, 4)
            HStack () {
                Text("Welcome to Salt Lake City!\nMy name is Sage, and I’ll be your tour guide today. I’ll be back when you’re near a landmark you might be interested in!").padding()
            }
            .frame(maxWidth: 260, alignment: .leading)
            .background(.gray)
            .cornerRadius(20)
        }
        .frame(maxWidth: 360, alignment: .leading)
    }
}

#Preview {
    ActivityView()
}
