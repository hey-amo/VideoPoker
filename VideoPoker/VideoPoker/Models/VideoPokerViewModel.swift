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
    
    private var deck: [Card] = []
    
    init() {
           resetDeck()
    }
    
    func resetDeck() {
           deck = Suit.allCases.flatMap { suit in
               Rank.allCases.map { rank in
                   Card(rank: rank, suit: suit)
               }
           }.shuffled()
       }

       func deal() {
           guard gameState == .idle, deck.count >= 5 else { return }

           cards = Array(deck.prefix(5))
           deck.removeFirst(5)
           heldCards = []
           gameState = .holding
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

       func increaseBet() {
           if gameState == .idle {
               bet += 1
           }
       }

       func decreaseBet() {
           if gameState == .idle && bet > 1 {
               bet -= 1
           }
       }
}
