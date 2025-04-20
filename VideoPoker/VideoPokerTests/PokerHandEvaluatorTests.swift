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
    
    /// Royal Flush
    func testRoyalFlush() {
        let hand = createHand([
            (.ten, .hearts),
            (.jack, .hearts),
            (.queen, .hearts),
            (.king, .hearts),
            (.ace, .hearts)
        ])
        
        // Evaluate hand
        let result = PokerHandEvaluator.evaluate(hand: hand)
        
        // Assert
        XCTAssertEqual(result.rank, .royalFlush)
        XCTAssertEqual(result.payoutMultiplier, 750)
    }

    /// Straight flush
    func testStraightFlush() {
        // Create hand
        let hand = createHand([
            (.six, .clubs),
            (.seven, .clubs),
            (.eight, .clubs),
            (.nine, .clubs),
            (.ten, .clubs)
        ])
        
        // Evaluate hand
        let result = PokerHandEvaluator.evaluate(hand: hand)
        
        // Assert
        XCTAssertEqual(result.rank, .straightFlush)
        XCTAssertEqual(result.payoutMultiplier, 150)
    }
    
    /// Four-of-a-kind
    func testFourOfAKind() {
        // Create hand
        let hand = createHand([
            (.queen, .hearts),
            (.queen, .diamonds),
            (.queen, .clubs),
            (.queen, .spades),
            (.king, .hearts)
        ])
        
        // Evaluate
        let result = PokerHandEvaluator.evaluate(hand: hand)
        
        // Assert
        XCTAssertEqual(result.rank, .fourOfAKind)
        XCTAssertEqual(result.payoutMultiplier, 75)
    }
    
    

}
