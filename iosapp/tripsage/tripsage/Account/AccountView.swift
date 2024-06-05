//
//  AccountView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/8/24.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        ScrollView {
          
            InterestsViewNew(items: ["SwiftUI", "CS194W", "Stanford", "Proud Mpala", "Jason Chao", "Raghav Garg", "ice cream", "sushi"])
                .frame(height: 200)
            HistoryView()
        }.padding(10)
    }
}

#Preview {
    AccountView()
    
}
