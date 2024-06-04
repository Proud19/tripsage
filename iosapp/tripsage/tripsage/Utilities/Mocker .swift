//
//  Mocker .swift
//  tripsage
//
//  Created by Proud Mpala on 5/30/24.
//

import Foundation


class Mocker {
    // Function to generate a mock User
    static func generateMockUser(id: String = UUID().uuidString,
                          firstName: String = "Proud",
                          lastName: String = "Mpala",
                          emailAddress: String = "pmpala@stanford.edu") -> User {
        return User(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress)
    }

    // Function to generate a list of mock Users
    static func generateMockUsers(count: Int) -> [User] {
        var users = [User]()
        for _ in 0..<count {
            let user = generateMockUser(firstName: randomFirstName(), lastName: randomLastName(), emailAddress: randomEmail())
            users.append(user)
        }
        return users
    }

    // Helper functions to generate random first names, last names, and email addresses
    static func randomFirstName() -> String {
        let firstNames = ["John", "Jane", "Alex", "Emily", "Chris", "Katie", "Michael", "Sarah"]
        return firstNames.randomElement()!
    }

    static func randomLastName() -> String {
        let lastNames = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Miller", "Davis", "Garcia"]
        return lastNames.randomElement()!
    }

    static func randomEmail() -> String {
        let domains = ["example.com", "mail.com", "test.com", "mock.com"]
        return "\(randomFirstName().lowercased()).\(randomLastName().lowercased())@\(domains.randomElement()!)"
    }
}
