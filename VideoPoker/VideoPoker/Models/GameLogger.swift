//
//  GameLogger.swift
//  VideoPoker
//
//  Created by Amarjit on 21/04/2025.
//

import Foundation
import OSLog

class GameLogger {
    static let shared = GameLogger()
    private let logger: Logger
    
    private init() {
        self.logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "VideoPoker", category: "GameState")
    }
    
    func logState(_ state: GameState, message: String) {
        let stateString = String(describing: state)
        logger.info("🎮 [\(stateString)] \(message)")
    }

    func logError(_ state: GameState, message: String) {
        let stateString = String(describing: state)
        logger.error("❌ [\(stateString)] \(message)")
    }

    func logValidation(_ state: GameState, message: String) {
        let stateString = String(describing: state)
        logger.debug("✓ [\(stateString)] \(message)")
    }
}
