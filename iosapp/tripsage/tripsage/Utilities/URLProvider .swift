//
//  URLProvider .swift
//  tripsage
//
//  Created by Proud Mpala on 5/29/24.
//

import Foundation

class URLProvider {
    static let baseURL = "https://tripsage-latest.onrender.com/"
    
    static let loginUser = URL(string: baseURL + "auth/profile")
    
    static let registerUser = URL(string: baseURL + "auth/register")
    
    static let nearby = URL(string: baseURL + "attractions/nearby")
}
