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
    
    /// Full house
    func testFullHouse() {
        // Create hand
        let hand = createHand([
            (.ten, .hearts),
            (.ten, .diamonds),
            (.ten, .clubs),
            (.king, .hearts),
            (.king, .diamonds)
        ])
        
        // Evaluate
        let result = PokerHandEvaluator.evaluate(hand: hand)
        
        // Assert
        XCTAssertEqual(result.rank, .fullHouse)
        XCTAssertEqual(result.payoutMultiplier, 27)
    }
    
    func testFlush() {
        // Create hand
        let hand = createHand([
            (.two, .spades),
            (.five, .spades),
            (.seven, .spades),
            (.jack, .spades),
            (.king, .spades)
        ])
        
        // Evaluate
        let result = PokerHandEvaluator.evaluate(hand: hand)
        
        // Assert
        XCTAssertEqual(result.rank, .flush)
        XCTAssertEqual(result.payoutMultiplier, 18)
    }

    func testStraight() {
            // Create hand
            let hand = createHand([
                (.four, .hearts),
                (.five, .diamonds),
                (.six, .clubs),
                (.seven, .spades),
                (.eight, .hearts)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .straight)
            XCTAssertEqual(result.payoutMultiplier, 12)
        }
        
        func testWheelStraight() {
            // Create hand - Testing Ace-2-3-4-5 straight
            let hand = createHand([
                (.ace, .hearts),
                (.two, .diamonds),
                (.three, .clubs),
                (.four, .spades),
                (.five, .hearts)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .straight)
            XCTAssertEqual(result.payoutMultiplier, 12)
        }
        
        func testThreeOfAKind() {
            // Create hand
            let hand = createHand([
                (.jack, .hearts),
                (.jack, .diamonds),
                (.jack, .clubs),
                (.three, .spades),
                (.king, .hearts)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .threeOfAKind)
            XCTAssertEqual(result.payoutMultiplier, 9)
        }
        
        func testTwoPair() {
            // Create hand
            let hand = createHand([
                (.nine, .hearts),
                (.nine, .diamonds),
                (.queen, .clubs),
                (.queen, .spades),
                (.ace, .hearts)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .twoPair)
            XCTAssertEqual(result.payoutMultiplier, 6)
        }
        
        func testJacksOrBetter() {
            // Create hand
            let hand = createHand([
                (.jack, .hearts),
                (.jack, .diamonds),
                (.three, .clubs),
                (.seven, .spades),
                (.ace, .hearts)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .jacksOrBetter)
            XCTAssertEqual(result.payoutMultiplier, 3)
        }
        
        func testPairLowerThanJacks() {
            // Create hand
            let hand = createHand([
                (.ten, .hearts),
                (.ten, .diamonds),
                (.three, .clubs),
                (.seven, .spades),
                (.ace, .hearts)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .none)
            XCTAssertEqual(result.payoutMultiplier, 0)
        }
        
        func testNoWinningHand() {
            // Create hand
            let hand = createHand([
                (.two, .hearts),
                (.five, .diamonds),
                (.seven, .clubs),
                (.jack, .spades),
                (.ace, .hearts)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .none)
            XCTAssertEqual(result.payoutMultiplier, 0)
        }
        
        func testInvalidHandSize() {
            // Create hand
            let hand = createHand([
                (.two, .hearts),
                (.five, .diamonds),
                (.seven, .clubs)
            ])
            
            // Evaluate hand
            let result = PokerHandEvaluator.evaluate(hand: hand)
            
            // Assert
            XCTAssertEqual(result.rank, .none)
            XCTAssertEqual(result.payoutMultiplier, 0)
        }
}
