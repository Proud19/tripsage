//
//  InterestsViewNew.swift
//  tripsage
//
//  Created by Emma Catherine Wong on 6/5/24.
//

import SwiftUI

struct InterestsView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    
    @StateObject var interestsViewModel = InterestsViewModel()
    
    private func createGroupedItems(_ items: [String]) -> [[String]] {
        
        var groupedItems: [[String]] = [[String]]()
        var tempItems: [String] =  [String]()
        var width: CGFloat = 0
        
        for word in items {
            
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 20
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(word)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(word)
            }
            
        }
        
        groupedItems.append(tempItems)
        return groupedItems
        
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                // Add heading here
                HStack {
                    Text("Interests")
                        .font(.headline)
                        .padding(.bottom, 10)
                    Spacer()
                }.padding([.top, .leading])
                Divider()
                ForEach(createGroupedItems(interestsViewModel.interests), id: \.self) { subItems in
                    HStack {
                        ForEach(subItems, id: \.self) { word in
                            Text(word)
                                .fixedSize()
                                .padding()
                                .frame(height: 30)
                                .background(Color.sageOrange)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 100.0, style: .continuous))
                        }
                    }.padding()
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2) // Adding border color and width
            )

    }
}

struct InterestsViewNew_Previews: PreviewProvider {
    static var previews: some View {
        InterestsView()
    }
}
