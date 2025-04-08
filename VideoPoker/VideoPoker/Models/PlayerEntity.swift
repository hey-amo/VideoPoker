//
//  PlayerEntity.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

import Foundation
import SwiftData

@Model
class PlayerEntity {
    var id: UUID
    var name: String
    var balance: Int
    var createdAt: Date
    var lastPlayed: Date
    
    init(id: UUID, name: String, balance: Int, createdAt: Date, lastPlayed: Date) {
        self.id = id
        self.name = name
        self.balance = balance
        self.createdAt = createdAt
        self.lastPlayed = lastPlayed
    }
}
