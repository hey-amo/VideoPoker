//
//  VideoPokerView.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//


import SwiftUI

struct VideoPokerView: View {
    @State private var credits: Int = 102
    @State private var bet: Int = 3
    @State private var isPayTableVisible: Bool = true

    var body: some View {
        
        ScrollView(.vertical) {
            
            VStack(spacing: 20) {
                
                // MARK: Pay Table
                DisclosureGroup("Pay Table", isExpanded: $isPayTableVisible) {
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

                // MARK: Credits and Bet
                HStack {
                    Text("Credits: \(credits)")
                    Spacer()
                    Text("Bet: \(bet)")
                }
                .font(.headline)
                .padding(.horizontal)

                // MARK: Card Row
                HStack(spacing: 15) {
                    CardView(rank: "2", suit: "♦︎")
                    CardView(rank: "2", suit: "♣︎")
                    CardView(rank: "5", suit: "♥︎")
                    CardView(rank: "Q", suit: "♣︎")
                    CardView(rank: "10", suit: "♦︎")
                }
                .padding()

                // MARK: Bet Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        print("Decrease Bet")
                    }) {
                        Text("-")
                            .font(.title)
                            .frame(width: 44, height: 44)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }

                    Button(action: {
                        print("Increase Bet")
                    }) {
                        Text("+")
                            .font(.title)
                            .frame(width: 44, height: 44)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }

                // MARK: Deal Button
                Button(action: {
                    print("Deal button pressed!")
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

struct CardView: View {
    let rank: String
    let suit: String

    var body: some View {
        VStack {
            Text(rank)
                .font(.title)
            Text(suit)
                .font(.title2)
        }
        .frame(width: 50, height: 70)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

#Preview {
    VideoPokerView()
}
