//
//  SageTabViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 6/3/24.
//

import Foundation

class SageTabViewModel: ObservableObject, TripDelegate {
    
    @Published var tripStarted = false  // should probably get this information from the server
    
    var activityViewModel = ActivityViewModel()
    
    func userDidStartTrip() {
        print("SageTabViewModel userDidStartTrip")
        tripStarted = true
    }
    
    func userDidEndTrip() {
        print("SageTabViewModel userDidEndTrip")
        tripStarted = false
    }

}
