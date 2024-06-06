//
//  HistoryView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/15/24.
//

import SwiftUI

struct HistoryView: View {
    var historyViewModel = HistoryViewModel()
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("History")
                .bold()
            HStack {
                Spacer()
                VStack {
                    Text(historyViewModel.numberOfPastTrips.description).font(.title).bold()
                    Text("Past Trips").font(.caption)
                    
                }.padding([.leading, .trailing], 10)
                VStack {
                    Text(historyViewModel.numberOfLandMarks.description).font(.title).bold()
                    Text("Landmarks").font(.caption)
                    
                }
                VStack {
                    HStack {
                        Text(historyViewModel.totalDistance.description).font(.title).bold()
                        Text("km").italic()
                        
                    }
                    Text("Travelled").font(.caption)
                }.padding([.trailing], 10)
                Spacer()
            }
            .background(.gray)
            .cornerRadius(12)
            .foregroundColor(.white)
            

        }
        
    }
}

#Preview {
    HistoryView()
}
