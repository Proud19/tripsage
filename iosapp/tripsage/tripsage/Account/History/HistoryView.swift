//
//  HistoryView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/15/24.
//

import SwiftUI

struct AutoScrollingTabView: View {
    @State private var currentIndex = 0
    private let images = ["exp-1", "exp-2", "exp-3", "exp-4"]
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<images.count) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }
}

struct HistoryView: View {
    var historyViewModel = HistoryViewModel()
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text("History")
                .bold()
                .padding()
            Divider()
            VStack {
                
                AutoScrollingTabView()
                    .frame(height: UIScreen.main.bounds.height * 0.3)
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
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2) // Adding border color and width
        )
    }
}

#Preview {
    HistoryView()
}
