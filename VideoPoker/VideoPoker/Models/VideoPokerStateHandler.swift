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
    // MARK: - Idle State
    func handleIdle(viewModel: VideoPokerViewModel) -> Bool {
        // Validate current state
        guard viewModel.gameState == .idle else { return false }
        
        // Validate player has enough credits for current bet
        guard viewModel.credits >= viewModel.bet else {
            viewModel.gameState = .gameOver
            return false
        }
        
        // Ensure bet is within valid range (1-5)
        guard viewModel.bet >= 1 && viewModel.bet <= 5 else { return false }
        
        // Reset and shuffle deck
        viewModel.resetDeck()
        
        // Clear any existing cards and holds
        viewModel.cards = []
        viewModel.heldCards = []
        
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