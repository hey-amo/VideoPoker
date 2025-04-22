//
//  VideoPokerView.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//


import SwiftUI

struct VideoPokerView: View {
    @StateObject var viewModel = VideoPokerViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                GameStatusView(viewModel: viewModel)
                    .padding(.top)
                
                PayoutTableView(viewModel: viewModel)
                
                CreditsAndBetView(viewModel: viewModel)
                
                // Card Row
                HStack(spacing: 15) {
                    ForEach(0..<5) { index in
                        if index < viewModel.cards.count {
                            CardView(
                                card: viewModel.cards[index],
                                isBack: viewModel.gameState == .dealing
                            )
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .slide),
                                removal: .scale
                            ))
                        } else {
                            CardView(card: nil, isBack: true)
                                .opacity(viewModel.gameState == .dealing ? 0.5 : 1.0)
                        }
                    }
                }
                .padding()
                .animation(.easeInOut(duration: 0.3), value: viewModel.cards.count)
                
                if viewModel.gameState == .idle {
                    BetControlsView(viewModel: viewModel)
                }
                
                DealButtonView(viewModel: viewModel)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

// MARK: Buttons

struct DealButtonView: View {
    @ObservedObject var viewModel: VideoPokerViewModel
    
    var body: some View {
        Button(action: {
            viewModel.deal()
        }) {
            Text(viewModel.gameState == .idle ? "Deal" : "...")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    viewModel.gameState == .idle && viewModel.credits >= viewModel.bet 
                    ? Color.green 
                    : Color.gray
                )
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .disabled(viewModel.gameState != .idle || viewModel.credits < viewModel.bet)
    }
}

struct BetControlsView: View {
    @ObservedObject var viewModel: VideoPokerViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            // Decrease Button
            Button(action: { viewModel.decreaseBet() }) {
                Text("-")
                    .font(.title)
                    .frame(width: 44, height: 44)
                    .background(viewModel.gameState == .idle ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .disabled(viewModel.gameState != .idle || viewModel.bet <= 1)
            
            // Current Bet Display
            Text("\(viewModel.bet)")
                .font(.title2)
                .bold()
                .frame(width: 44)
            
            // Increase Button
            Button(action: { viewModel.increaseBet() }) {
                Text("+")
                    .font(.title)
                    .frame(width: 44, height: 44)
                    .background(viewModel.gameState == .idle ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .disabled(viewModel.gameState != .idle || viewModel.bet >= 5)
        }
        .padding(.horizontal)
    }
}

// MARK: CardView

struct CardView: View {
    let card: Card?
    let isBack: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isBack ? Color.gray : Color.white)
                .frame(width: 60, height: 90)
                .overlay(
                    Group {
                        if let card = card, !isBack {
                            VStack {
                                Text(card.rank.symbol)
                                Text(card.suit.rawValue)
                            }
                        } else {
                            Text("🂠")
                        }
                    }
                )
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black))
        }
    }
}

// MARK: Payout Table View

struct PayoutTableView: View {
    @StateObject var viewModel = VideoPokerViewModel()
    @State private var isPayTableVisible: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Payout Table")
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    isPayTableVisible.toggle()
                }) {
                    Image(systemName: "chevron.up")
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isPayTableVisible ? 0 : 180))
                        .animation(.easeInOut, value: isPayTableVisible)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if isPayTableVisible {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(HandRank.allCases.filter { $0 != .none }, id: \.self) { rank in
                        let payout = PokerHandEvaluator.payoutTable[rank] ?? 0
                        payTableRow(rank.rawValue, payout)
                    }
                }
                .padding()
            }
        }
        .background(Color.blue)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    
    private func payTableRow(_ name: String, _ value: Int) -> some View {
        HStack {
            Text(name)
                .foregroundColor(.white)
            Spacer()
            Text("\(value)")
                .foregroundColor(.white)
                .bold()
        }
    }
}

// MARK: Credits and Bet View

struct CreditsAndBetView: View {
    @ObservedObject var viewModel: VideoPokerViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Credits")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(viewModel.credits)")
                    .font(.headline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Current Bet")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("\(viewModel.bet)")
                    .font(.headline)
            }
        }
        .padding(.horizontal)
    }
}

struct GameStatusView: View {
    @ObservedObject var viewModel: VideoPokerViewModel
    
    var statusMessage: String {
        switch viewModel.gameState {
        case .idle:
            return viewModel.credits >= viewModel.bet 
                ? "Ready to Deal - Bet: \(viewModel.bet)" 
                : "Insufficient Credits"
        case .preparingToDeal:
            return "Preparing..."
        case .dealing:
            return "Dealing Cards..."
        case .holding:
            return "Select Cards to Hold"
        case .drawing:
            return "Drawing New Cards..."
        case .evaluating:
            return "Evaluating Hand..."
        case .resultShown:
            return "Hand Complete"
        case .gameOver:
            return "Game Over"
        }
    }
    
    var statusColor: Color {
        switch viewModel.gameState {
        case .idle:
            return viewModel.credits >= viewModel.bet ? .green : .red
        case .gameOver:
            return .red
        default:
            return .primary
        }
    }
    
    var body: some View {
        HStack {
            // Status indicator
            Circle()
                .fill(statusColor)
                .frame(width: 10, height: 10)
            
            // Status message
            Text(statusMessage)
                .font(.caption)
                .foregroundColor(statusColor)
            
            Spacer()
        }
        .padding(.horizontal)
        .animation(.easeInOut, value: viewModel.gameState)
    }
}

#Preview {
    VideoPokerView()
}
