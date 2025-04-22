//
//  VideoPokerViewModel.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

import SwiftUI

class VideoPokerViewModel: ObservableObject {
    @Published var credits: Int = 100
    @Published var bet: Int = 1
    @Published var gameState: GameState = .idle
    @Published var cards: [Card] = []
    @Published var heldCards: Set<Int> = []
    @Published var handResult: HandResult?
    @Published var errorMessage: String?
    
    // Add new properties for animation control
    @Published var dealingCardIndex: Int = 0
    private let dealingInterval: TimeInterval = 0.3
    
    private var deck: [Card] = []
    private let stateHandler: VideoPokerStateHandling
    private let settings = GameSettings.shared
    
    init(stateHandler: VideoPokerStateHandling = VideoPokerStateHandler()) {
        self.stateHandler = stateHandler
        resetDeck()
    }
    
    // MARK: - Clear Game State
    func clearGameState() {
        cards = []
        heldCards = []
        handResult = nil
        errorMessage = nil
    }
    
    func validateDeck() -> Bool {
        // 1. Check deck size
        guard deck.count == 52 else {
            errorMessage = "Invalid deck size"
            return false
        }
        
        // 2. Check for duplicates using Set
        let uniqueCards = Set(deck)
        guard uniqueCards.count == 52 else {
            errorMessage = "Duplicate cards found in deck"
            return false
        }
        
        // 3. Validate card values
        for card in deck {
            // Validate rank is within valid range
            guard card.rank.rawValue >= 2 && card.rank.rawValue <= 14 else {
                errorMessage = "Invalid card rank found"
                return false
            }
            
            // Validate suit is valid
            guard Suit.allCases.contains(card.suit) else {
                errorMessage = "Invalid card suit found"
                return false
            }
        }
        
        // 4. Verify deck is shuffled (basic check - cards aren't in order)
        let sortedDeck = deck.sorted { ($0.suit.rawValue, $0.rank.rawValue) < ($1.suit.rawValue, $1.rank.rawValue) }
        guard deck != sortedDeck else {
            errorMessage = "Deck is not properly shuffled"
            return false
        }
        
        errorMessage = nil
        return true
    }
    
    func validateGameReadyState() -> Bool {
        // Check cards array is empty
        guard cards.isEmpty else {
            return false
        }
        
        // Check held cards are cleared
        guard heldCards.isEmpty else {
            return false
        }
        
        // Check no previous hand result
        guard handResult == nil else {
            return false
        }
        
        // Check error message is cleared
        guard errorMessage == nil else {
            return false
        }
        return true
    }
    
    // MARK: - Public Methods
    
    func increaseBet() {
        guard gameState == .idle else { return }
        guard bet < 5 else { return }
        bet += 1
    }
    
    func decreaseBet() {
        guard gameState == .idle else { return }
        guard bet > 1 else { return }
        bet -= 1
    }
    
    func deal() {
        // First validate idle state
        guard stateHandler.handleIdle(viewModel: self) else {
            errorMessage = "Cannot deal: Invalid state or insufficient credits"
            return
        }
        
        // Deduct bet amount
        credits -= bet
        
        // Transition to dealing state
        gameState = .dealing
        
        // Start dealing animation
        dealCards()
    }
    
    // MARK: - Helper Methods
    
    func resetDeck() {
        print ("Shuffling deck")
        deck = Suit.allCases.flatMap { suit in
            Rank.allCases.map { rank in
                Card(rank: rank, suit: suit)
            }
        }
        deck.shuffle()
        print ("Shuffled deck")
    }
    
    func toggleHold(index: Int) {
        guard gameState == .holding else { return }
        
        if heldCards.contains(index) {
            heldCards.remove(index)
        } else {
            heldCards.insert(index)
        }
        
        settings.playHapticFeedback()
    }

    func draw() {
        guard gameState == .holding else { return }

        for i in 0..<cards.count {
            if !heldCards.contains(i), let newCard = deck.popLast() {
                cards[i] = newCard
            }
        }

        gameState = .evaluating
        evaluateHand()
    }

    func evaluateHand() {
        let result = PokerHandEvaluator.evaluate(hand: cards)
        handResult = result
        credits += result.payoutMultiplier * bet
        gameState = .resultShown
    }

    func resetHand() {
        resetDeck()
        cards = []
        heldCards = []
        handResult = nil
        gameState = .idle
    }
    
    private func dealCards() {
        guard gameState == .dealing else { return }
        
        // Reset dealing index
        dealingCardIndex = 0
        
        // Schedule dealing of each card
        for index in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + dealingInterval * Double(index)) {
                self.dealSingleCard(at: index)
            }
        }
        
        // Transition to holding state after all cards are dealt
        DispatchQueue.main.asyncAfter(deadline: .now() + dealingInterval * 5) {
            self.gameState = .holding
        }
    }
    
    private func dealSingleCard(at index: Int) {
        guard let card = deck.popLast() else {
            errorMessage = "Error: No cards left in deck"
            resetDeck()
            gameState = .idle
            return
        }
        
        // Update the dealing index for animation
        dealingCardIndex = index
        
        // Add the card to the hand
        if index < cards.count {
            cards[index] = card
        } else {
            cards.append(card)
        }
    }
}
