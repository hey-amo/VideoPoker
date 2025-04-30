import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: VideoPokerViewModel
    @ObservedObject private var router = Router.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Game Over!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Display round-by-round results
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.roundResults, id: \.roundNumber) { result in
                            RoundResultRow(result: result)
                        }
                    }
                    .padding()
                }
                
                // Summary section
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.gameSummary)
                        .font(.headline)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding()
                
                // Action buttons
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.startNewGame()
                        router.dismissModal()
                    }) {
                        Text("New Game")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Return to main menu
                        router.showModal(.menu)
                    }) {
                        Text("Main Menu")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct RoundResultRow: View {
    let result: VideoPokerViewModel.RoundResult
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Round \(result.roundNumber)")
                    .font(.headline)
                Spacer()
                Text(result.timestamp, style: .time)
                    .font(.caption)
            }
            
            HStack {
                Text(result.handRank.rawValue)
                    .font(.subheadline)
                Spacer()
                Text("Bet: \(result.bet)")
                Text("Won: \(result.payout)")
                    .foregroundColor(result.payout > 0 ? .green : .primary)
            }
            
            // Display final hand
            HStack {
                ForEach(result.finalHand, id: \.self) { card in
                    Text("\(card.rank.symbol)\(card.suit.rawValue)")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
} 