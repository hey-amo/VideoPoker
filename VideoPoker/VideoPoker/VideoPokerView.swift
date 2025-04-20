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
    @State private var isPayTableVisible: Bool = true

    var body: some View {
        
        ScrollView(.vertical) {
            
            VStack(spacing: 20) {
                
                // MARK: Payout Table
                DisclosureGroup("Payout Table", isExpanded: $isPayTableVisible) {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        // Loop through the Ranks and display the payout
                        ForEach(HandRank.allCases.filter { $0 != .none }, id: \.self) { rank in
                            let payout = PokerHandEvaluator.payoutTable[rank] ?? 0
                            payTableRow(rank.rawValue, payout)
                        }
                        
                    }
                    .padding()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                // ------
                // MARK: Credits and Bet
                HStack {
                    Text("Credits: \(viewModel.credits)")
                    Spacer()
                    Text("Bet: \(viewModel.bet)")
                }
                .font(.headline)
                .padding(.horizontal)

                // ------
                // MARK: Card Row
                /*
                HStack(spacing: 15) {
                    CardView(rank: "2", suit: "♦︎")
                    CardView(rank: "2", suit: "♣︎")
                    CardView(rank: "5", suit: "♥︎")
                    CardView(rank: "Q", suit: "♣︎")
                    CardView(rank: "10", suit: "♦︎")
                }
                .padding()
                 */
                
                // Card Backs
                HStack(spacing: 15) {
                    ForEach(0..<5, id: \.self) { _ in
                        CardView(card: nil, isBack: true)
                    }
                }.padding()

                // ------
                // MARK: Bet Buttons
                HStack(spacing: 20) {
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
                }.padding(.horizontal)

                // ------
                // MARK: Deal Button
                Button(action: {
                    print("Deal button pressed!")
                    viewModel.deal()
                }) {
                    Text("Deal")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(viewModel.credits < viewModel.bet || viewModel.gameState != .idle)

                Spacer()
            }
            .padding(.top)
        }
    }

    private func payTableRow(_ name: String, _ value: Int) -> some View {
        HStack {
            Text(name)
            Spacer()
            Text("\(value)")
                .bold()
        }
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

#Preview {
    VideoPokerView()
}
