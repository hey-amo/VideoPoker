//
//  CardEntity.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

import Foundation
import SwiftData

@Model
class CardEntity {
    var rank: String   // "A", "2", ..., "K"
    var suit: String   // "Hearts", "Spades", etc.
    var session: GameSessionEntity
    
    init(rank: String, suit: String, session: GameSessionEntity) {
        self.rank = rank
        self.suit = suit
        self.session = session
    }
}
