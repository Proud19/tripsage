//
//  InterestsView.swift
//  tripsage
//
//  Created by Proud Mpala on 5/15/24.
//

import SwiftUI

struct InterestsView: View {
    @State private var interests1 = ["SwiftUI", "iOS Development"]
    @State private var interests2 = [ "Machine Learning", "Gaming", "Cooking"]
    @State private var interests3 = [ "Soccer", "rocks", "gymn"]
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Interests")
                .bold()
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
                .overlay(
                    VStack {
                        HStack(spacing: 8) {
                            ForEach(interests1, id: \.self) { interest in
                                PillView(text: interest, color: .random(), onDelete: {
                                    if let index = interests1.firstIndex(of: interest) {
                                        interests1.remove(at: index)
                                    }
                                })
                            }
                        }
                        .padding(8)
                        
                        HStack(spacing: 8) {
                            ForEach(interests2, id: \.self) { interest in
                                PillView(text: interest, color: .random(), onDelete: {
                                    if let index = interests2.firstIndex(of: interest) {
                                        interests2.remove(at: index)
                                    }
                                })
                            }
                        }
                        .padding(8)
                        
                        HStack(spacing: 8) {
                            ForEach(interests3, id: \.self) { interest in
                                PillView(text: interest, color: .random(), onDelete: {
                                    if let index = interests3.firstIndex(of: interest) {
                                        interests3.remove(at: index)
                                    }
                                })
                            }
                        }
                        .padding(8)
                        
                        Spacer()
                    }
                )
            
        }
    }
}

struct PillView: View {
    var text: String
    var color: Color
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(text)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .lineLimit(1)
            
            Button(action: onDelete) {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .background(color)
        .cornerRadius(12)
        .foregroundColor(.white)
    }
}

extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

#Preview {
    InterestsView()
}
