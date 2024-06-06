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
            InterestsView()
            Divider()
            HistoryView()
        }.padding(10)
    }
}

#Preview {
    AccountView()
    
}
