//
//  GameState.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

enum GameState {
    case idle          // Bet setting phase, table is empty
    case dealing       // Cards are being dealt
    case holding       // Player is choosing cards to hold
    case drawing       // Drawing new cards
    case evaluating    // Evaluating final hand
    case resultShown   // Showing win/loss result
    case gameOver      // Optional: no more credits
}
