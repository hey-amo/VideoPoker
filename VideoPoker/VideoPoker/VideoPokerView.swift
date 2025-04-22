//
//  VideoPokerView.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//


import SwiftUI

struct VideoPokerView: View {
    @StateObject var viewModel = VideoPokerViewModel()
    @State private var credits: Int = 100
    @State private var bet: Int = 3

    var body: some View {
        
        ScrollView(.vertical) {
            
            VStack(spacing: 20) {
                
                // MARK: Payout Table
                PayoutTableView(viewModel: viewModel)

                // ------
                // MARK: Credits and Bet
                CreditsAndBetView()

                // ------
                // MARK: Card Row
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

                // ------
                // MARK: +/- Bet Buttons
                
                HStack(spacing: 20) {
                    DecreaseBetButtonView(viewModel: viewModel)
                    IncreaseBetButtonView(viewModel: viewModel)
                }.padding(.horizontal)
                
                // ------
                // MARK: Deal Button
                DealButtonView(viewModel: viewModel)

                // Add error message display if needed
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
        }
    }
    
}

// MARK: Buttons

struct DealButtonView: View {
    @StateObject var viewModel = VideoPokerViewModel()
    var body: some View {
        Button(action: {
            viewModel.deal()
        }) {
            Text("Deal")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(viewModel.credits >= viewModel.bet ? Color.green : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .disabled(viewModel.credits < viewModel.bet)
    }
}

struct IncreaseBetButtonView: View {
    @StateObject var viewModel = VideoPokerViewModel()
    var body: some View {
        Button(action: {
            print("Increase Bet")
            viewModel.increaseBet()
        }) {
            Text("+")
                .font(.title)
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }.disabled(viewModel.gameState != .idle)
    }
}

struct DecreaseBetButtonView: View {
    @StateObject var viewModel = VideoPokerViewModel()
    var body: some View {
        Button(action: {
            print("Decrease Bet")
            viewModel.decreaseBet()
        }) {
            Text("-")
                .font(.title)
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }.disabled(viewModel.gameState != .idle || viewModel.bet <= 1)
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
    var viewModel = VideoPokerViewModel()
    var body: some View {
        HStack {
            Text("Credits: \(viewModel.credits)")
            Spacer()
            Text("Bet: \(viewModel.bet)")
        }
        .font(.headline)
        .padding(.horizontal)
    }
}


#Preview {
    VideoPokerView()
}
