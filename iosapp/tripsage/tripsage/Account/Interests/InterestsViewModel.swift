//
//  InterestsViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 6/6/24.
//

import Foundation


class InterestsViewModel: ObservableObject {
    @Published var interests = [String]()
    
    init()  {
        User.fetchUserInterests { interests in
            DispatchQueue.main.async {
                print("Fetched interests: \(interests)")
                self.interests = interests
            }
        }
    }
}
