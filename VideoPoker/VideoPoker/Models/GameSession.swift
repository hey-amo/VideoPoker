//
//  GameSessionEntity.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

import Foundation
import SwiftData

@Model
class GameSessionEntity {
    var id: UUID
    var player: PlayerEntity
    var date: Date
    var betAmount: Int
    var winnings: Int
    var finalHand: [CardEntity]
    
    init(id: UUID, player: PlayerEntity, date: Date, betAmount: Int, winnings: Int, finalHand: [CardEntity]) {
        self.id = id
        self.player = player
        self.date = date
        self.betAmount = betAmount
        self.winnings = winnings
        self.finalHand = finalHand
    }
}
