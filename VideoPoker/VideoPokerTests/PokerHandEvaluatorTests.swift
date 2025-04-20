//
//  PokerHandEvaluatorTests.swift
//  VideoPokerTests
//
//  Created by Amarjit on 20/04/2025.
//

import XCTest
@testable import VideoPoker

/// A collection of tests against video poker hands
final class PokerHandEvaluatorTests: XCTestCase {

    /// Create Card Helper
    private func createCard(_ rank: Rank, _ suit: Suit) -> Card {
        return Card(rank: rank, suit: suit)
    }
    
    /// Create Hand Helper: an array of cards, mapping the card to the rank, suit
    private func createHand(_ cards: [(Rank, Suit)]) -> [Card] {
        return cards.map { createCard($0.0, $0.1) }
    }
    
    // MARK: Tests
    
    /// Test Royal Flush
    /* There are only four different ways of completing this hand.
    Hearts: A♥ K♥ Q♥ J♥ 10♥
    Spades: A♠ K♠ Q♠ J♠ 10♠
    Diamonds: A♦ K♦ Q♦ J♦ 10♦
    Clubs: A♣ K♣ Q♣ J♣ 10♣
    */
    func testRoyalFlush() {
        let hand = createHand([
            (.ten, .hearts),
            (.jack, .hearts),
            (.queen, .hearts),
            (.king, .hearts),
            (.ace, .hearts)
        ])
        
        // Evaluate
        let result = PokerHandEvaluator.evaluate(hand: hand)
        
        // Assert
        XCTAssertEqual(result.rank, .royalFlush)
        XCTAssertEqual(result.payoutMultiplier, 750)
    }

}
