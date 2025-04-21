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
}
