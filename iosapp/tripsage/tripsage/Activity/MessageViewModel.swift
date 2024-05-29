//
//  MessageViewModel.swift
//  tripsage
//
//  Created by Beatriz Cunha Freire on 19/05/24.
//

import Foundation

struct Message: Decodable, Identifiable, Equatable {
    let id = UUID()
    let userId: String
    let text: String
    let PhotoURL: String
    let createdAt: Date
    let isFromUser: Bool
}
