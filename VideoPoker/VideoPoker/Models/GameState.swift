//
//  GameState.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

enum GameState {
    case idle          // Bet setting phase, table is empty
    case preparingToDeal // Transition from idle to dealing
    case dealing       // Cards are being dealt
    case holding       // Player is choosing cards to hold
    case drawing       // Drawing new cards
    case evaluating    // Evaluating final hand
    case resultShown   // Showing win/loss result, Display result, ready for next hand
    case gameOver      // Optional: no more credits
}

extension GameState: CustomStringConvertible {
    var description: String {
        switch self {
        case .idle: return "IDLE"
        case .preparingToDeal: return "PREPARING"
        case .dealing: return "DEALING"
        case .holding: return "HOLDING"
        case .drawing: return "DRAWING"
        case .evaluating: return "EVALUATING"
        case .resultShown: return "RESULT"
        case .gameOver: return "GAMEOVER"
        }
    }
}
