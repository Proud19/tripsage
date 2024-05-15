//
//  AccountView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/8/24.
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        VStack {
            VStack {
                InterestsView()
                HistoryView()
                Spacer()
            }.padding(10)
            
            Spacer()
        }
    }
}

#Preview {
    AccountView()
}
