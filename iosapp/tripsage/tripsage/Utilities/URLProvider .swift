//
//  URLProvider .swift
//  tripsage
//
//  Created by Proud Mpala on 5/29/24.
//

import Foundation

class URLProvider {
    static let baseURL = "https://tripsage-latest.onrender.com/"
    
    static let loginUser = URL(string: baseURL + "auth/login")
    
    static let profile = URL(string: baseURL + "auth/profile")
    
    static let registerUser = URL(string: baseURL + "auth/register")
    
    static let nearby = URL(string: baseURL + "attractions/nearby")
    
    static let interests = URL(string: baseURL + "users/interests")
    
    static let beginTrip = URL(string: baseURL + "users/beginTrip")
    
    static let getTripResponse = URL(string: baseURL + "users/getTripResponse")
    
    static let addTripMessage = URL(string: baseURL + "users/addTripMessage")
    
    static let podcasts = URL(string: baseURL + "attractions/podcast")
    
}
