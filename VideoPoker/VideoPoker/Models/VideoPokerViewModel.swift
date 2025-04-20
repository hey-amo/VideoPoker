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
    
    private var deck: [Card] = []
    private let stateHandler: VideoPokerStateHandling
    
    init(stateHandler: VideoPokerStateHandling = VideoPokerStateHandler()) {
        self.stateHandler = stateHandler
        resetDeck()
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
        
        // Continue with deal process (to be implemented)
        // This will be handled by the dealing state handler in the future
    }
    
    // MARK: - Helper Methods
    
    func resetDeck() {
        deck = Suit.allCases.flatMap { suit in
            Rank.allCases.map { rank in
                Card(rank: rank, suit: suit)
            }
        }.shuffled()
    }
    
    func toggleHold(index: Int) {
        guard gameState == .holding else { return }

        if heldCards.contains(index) {
            heldCards.remove(index)
        } else {
            heldCards.insert(index)
        }
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
}
