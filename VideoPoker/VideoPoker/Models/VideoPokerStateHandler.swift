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

        // 1. First validate current state
        guard viewModel.gameState == .idle else {
            viewModel.errorMessage = "Invalid game state for dealing"
            logger.logError(.idle, message: "Invalid state: \(viewModel.gameState)")
            return false
        }
        logger.logValidation(.idle, message: "Current state is: `idle`")
        
        // 2. Validate bet amount first (before checking credits)
        guard viewModel.bet >= 1 && viewModel.bet <= 5 else {
            viewModel.errorMessage = "Please place a bet between 1 and 5 credits"
            logger.logError(.idle, message: "Invalid bet amount: \(viewModel.bet)")
            return false
        }
        logger.logValidation(.idle, message: "Bet amount: OK")
        
        // 3. Then validate credits
        guard viewModel.credits >= viewModel.bet else {
            viewModel.errorMessage = "Insufficient credits for current bet"
            logger.logError(.idle, message: "Insufficient credits: \(viewModel.credits) < \(viewModel.bet)")
            viewModel.gameState = .gameOver
            return false
        }
        logger.logValidation(.idle, message: "Player has sufficient credits")
        
        // 4. Validate deck state before clearing game state
        guard viewModel.validateDeck() else {
            viewModel.errorMessage = "Error with card deck. Please try again"
            logger.logError(.idle, message: "Deck validation failed")
            return false
        }
        logger.logValidation(.idle, message: "Deck validation: OK")
        
        // 5. Only clear game state after all validations pass
        viewModel.clearGameState()
        logger.logValidation(.idle, message: "Previous game state cleared")
        
        // 6. Final validation of game ready state
        guard viewModel.validateGameReadyState() else {
            viewModel.errorMessage = "Error preparing game state"
            logger.logError(.idle, message: "Game ready state validation failed")
            return false
        }
        
        // 7. Set transitioning state
        viewModel.gameState = .preparingToDeal
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
