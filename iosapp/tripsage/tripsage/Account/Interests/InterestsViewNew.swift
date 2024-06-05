//
//  InterestsViewNew.swift
//  tripsage
//
//  Created by Emma Catherine Wong on 6/5/24.
//

import SwiftUI

struct InterestsViewNew: View {
    
    let items: [String]
    var groupedItems: [[String]] = [[String]]()
    let screenWidth = UIScreen.main.bounds.width
    
    init(items: [String]) {
        self.items = items
        self.groupedItems = createGroupedItems(items)
    }
    
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
        ScrollView {
            VStack(alignment: .leading) {
                // Add heading here
                Text("Interests")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                ForEach(groupedItems, id: \.self) { subItems in
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
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct InterestsViewNew_Previews: PreviewProvider {
    static var previews: some View {
        InterestsViewNew(items: ["SwiftUI", "CS194W", "Stanford", "Proud Mpala", "Jason Chao", "Raghav Garg", "ice cream", "sushi"])
    }
}
