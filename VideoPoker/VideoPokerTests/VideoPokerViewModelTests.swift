//
//  VideoPokerViewModelTests.swift
//  VideoPokerTests
//
//  Created by Amarjit on 22/04/2025.
//

import XCTest
@testable import VideoPoker

final class VideoPokerViewModelTests: XCTestCase {
    var viewModel: VideoPokerViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = VideoPokerViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Deck Validation Tests
    
    // Validate deck
    // 1. Check deck size
    // 2. Check for duplicates using Set
    // 3. Validate card values
    // 4. Verify deck is shuffled (basic check - cards aren't in order)
    func testValidate_Deck() throws {
        XCTAssertTrue( viewModel.validateDeck() )
        XCTAssertNil( viewModel.errorMessage )
    }
    
    func testDeckValidation_AfterInitialization() {
        // A fresh deck should be valid
        XCTAssertTrue(viewModel.validateDeck())
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testDeckValidation_AfterFullDeal() {
        // Deal all cards (52 cards in 11 hands)
        for _ in 1...11 {
            viewModel.gameState = .idle  // Reset to idle for each deal
            viewModel.deal()
        }
        XCTAssertFalse(viewModel.validateDeck(), "Deck did not validate")
        XCTAssertEqual(viewModel.errorMessage, "Invalid deck size")
    }
    
    func testDeckValidation_AfterReset() {
        // Deal some cards
        viewModel.deal()
        // Reset deck
        viewModel.resetDeck()
        XCTAssertTrue(viewModel.validateDeck())
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testDeckValidation_AfterDealingAllCards() {
        // Deal all 52 cards (10 full hands plus 2 cards)
        for _ in 1...10 {
            viewModel.gameState = .idle
            viewModel.deal()  // Deals 5 cards
        }
        viewModel.gameState = .idle
        viewModel.deal()  // Deals last 2 cards
        
        // Try one more deal which should fail validation
        viewModel.gameState = .idle
        viewModel.deal()
        
        XCTAssertFalse(viewModel.validateDeck(), "Game State is: \(viewModel.gameState.description)")
        XCTAssertEqual(viewModel.errorMessage, "Invalid deck size")
    }
    
    func testDeckValidation_AfterMultipleResets() {
        // Deal some cards
        viewModel.deal()
        
        // Reset multiple times
        viewModel.resetDeck()
        viewModel.resetDeck()
        
        // Deck should still be valid
        XCTAssertTrue(viewModel.validateDeck())
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Game Ready State Tests
    
    func testGameReadyState_IsValid() {
        viewModel.clearGameState()
        XCTAssertTrue(viewModel.validateGameReadyState())
    }
    
    func testGameReadyState_AfterDealing_ReturnsFalse() {
        viewModel.deal()
        XCTAssertFalse(viewModel.validateGameReadyState(), "Game State is: \(viewModel.gameState.description)")
    }
    
    func testGameReadyState_AfterHoldingCard_ReturnsFalse() {
        // Set up a game state where we can hold cards
        viewModel.deal()
        viewModel.gameState = .holding
        viewModel.toggleHold(index: 0)
        XCTAssertFalse(viewModel.validateGameReadyState(), "Game State is: \(viewModel.gameState.description)")
    }
    
    // MARK: - Betting Tests
    
    func testIncreaseBet_FromValidState() {
        viewModel.gameState = .idle
        viewModel.bet = 3
        viewModel.increaseBet()
        XCTAssertEqual(viewModel.bet, 4)
    }
    
    func testIncreaseBet_AtMaximum() {
        viewModel.gameState = .idle
        viewModel.bet = 5
        viewModel.increaseBet()
        XCTAssertEqual(viewModel.bet, 5, "Bet should not increase beyond maximum")
    }
    
    func testDecreaseBet_FromValidState() {
        viewModel.gameState = .idle
        viewModel.bet = 3
        viewModel.decreaseBet()
        XCTAssertEqual(viewModel.bet, 2)
    }
    
    func testDecreaseBet_AtMinimum() {
        viewModel.gameState = .idle
        viewModel.bet = 1
        viewModel.decreaseBet()
        XCTAssertEqual(viewModel.bet, 1, "Bet should not decrease below minimum")
    }
    
    func testBetControls_DisabledDuringDealing() {
        viewModel.gameState = .dealing
        let initialBet = viewModel.bet
        
        viewModel.increaseBet()
        XCTAssertEqual(viewModel.bet, initialBet, "Bet should not change during dealing")
        
        viewModel.decreaseBet()
        XCTAssertEqual(viewModel.bet, initialBet, "Bet should not change during dealing")
    }
}
