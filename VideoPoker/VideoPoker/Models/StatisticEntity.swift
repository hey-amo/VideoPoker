//
//  StatisticEntity.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

import Foundation
import SwiftData

@Model
class StatisticEntity {
    var player: PlayerEntity
    var handsPlayed: Int
    var handsWon: Int
    var royalFlushes: Int
    var totalWinnings: Int
    
    init(player: PlayerEntity, handsPlayed: Int, handsWon: Int, royalFlushes: Int, totalWinnings: Int) {
        self.player = player
        self.handsPlayed = handsPlayed
        self.handsWon = handsWon
        self.royalFlushes = royalFlushes
        self.totalWinnings = totalWinnings
    }
}
