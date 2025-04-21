import Foundation

protocol VideoPokerStateHandling {
    func handleIdle(viewModel: VideoPokerViewModel) -> Bool
    func handleDealing(viewModel: VideoPokerViewModel) -> Bool
    func handleHolding(viewModel: VideoPokerViewModel) -> Bool
    func handleDrawing(viewModel: VideoPokerViewModel) -> Bool
    func handleEvaluating(viewModel: VideoPokerViewModel) -> Bool
    func handleResultShown(viewModel: VideoPokerViewModel) -> Bool
    func handleGameOver(viewModel: VideoPokerViewModel) -> Bool
}

class VideoPokerStateHandler: VideoPokerStateHandling {
    private let logger = GameLogger.shared
    
    // MARK: - Idle State
    func handleIdle(viewModel: VideoPokerViewModel) -> Bool {
        logger.logState(.idle, message: "Starting `idle` state")

        // Validate current state
        guard viewModel.gameState == .idle else {
            logger.logError(.idle, message: "Invalid state: \(viewModel.gameState)")
            return false
        }
        logger.logValidation(.idle, message: "Current state is: `idle`")
        
        // Validate player has enough credits for current bet
        guard viewModel.credits >= viewModel.bet else {
            logger.logError(.idle, message: "Insufficient credits: \(viewModel.credits) < \(viewModel.bet)")
            viewModel.gameState = .gameOver
            return false
        }
        logger.logValidation(.idle, message: "Player has sufficient credits")
        
        // Ensure bet is within valid range (1-5)
        guard viewModel.bet >= 1 && viewModel.bet <= 5 else {
            logger.logError(.idle, message: "Invalid bet amount: \(viewModel.bet)")
            return false
        }
        logger.logValidation(.idle, message: "Bet amount: OK")

        // Clear any previous game state
        viewModel.clearGameState()
        logger.logValidation(.idle, message: "Previous game state cleared")
        
        // Reset deck and shuffle deck
        viewModel.resetDeck()
        guard viewModel.validateDeck() else {
            logger.logError(.idle, message: "Deck validation failed")
            return false
        }
        logger.logValidation(.idle, message: "Deck reset: OK")
        
        // Validate ready state
        guard viewModel.validateGameReadyState() else {
            logger.logError(.idle, message: "Game ready state validation failed")
            return false
        }
        
        // Game is OK to start
        logger.logState(.idle, message: "Game is ready to start")
        return true
    }
    
    // MARK: - Other States (Placeholder implementations)
    func handleDealing(viewModel: VideoPokerViewModel) -> Bool {
        // Will implement later
        return false
    }
    
    func handleHolding(viewModel: VideoPokerViewModel) -> Bool {
        // Will implement later
        return false
    }
    
    func handleDrawing(viewModel: VideoPokerViewModel) -> Bool {
        // Will implement later
        return false
    }
    
    func handleEvaluating(viewModel: VideoPokerViewModel) -> Bool {
        // Will implement later
        return false
    }
    
    func handleResultShown(viewModel: VideoPokerViewModel) -> Bool {
        // Will implement later
        return false
    }
    
    func handleGameOver(viewModel: VideoPokerViewModel) -> Bool {
        // Will implement later
        return false
    }
} 
