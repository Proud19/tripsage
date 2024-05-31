//
//  User.swift
//  tripsage
//
//  Created by Proud Mpala on 5/30/24.
//

import Foundation


struct User: Codable, Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case emailAddress
    }
    
}
