//
//  HandRank.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

// A list of ranks in Video Poker

enum HandRank: String {
    case royalFlush = "Royal Flush"
    case straightFlush = "Straight Flush"
    case fourOfAKind = "Four of a Kind"
    case fullHouse = "Full House"
    case flush = "Flush"
    case straight = "Straight"
    case threeOfAKind = "Three of a Kind"
    case twoPair = "Two Pair"
    case jacksOrBetter = "Jacks or Better"
    case none = "No Win"
}

struct HandResult {
    let rank: HandRank
    let payoutMultiplier: Int
}

class PokerHandEvaluator {
    static let payoutTable: [HandRank: Int] = [
        .royalFlush: 750,
        .straightFlush: 150,
        .fourOfAKind: 75,
        .fullHouse: 27,
        .flush: 18,
        .straight: 12,
        .threeOfAKind: 9,
        .twoPair: 6,
        .jacksOrBetter: 3,
        .none: 0
    ]

    static func evaluate(hand: [Card]) -> HandResult {
        guard hand.count == 5 else {
            return HandResult(rank: .none, payoutMultiplier: 0)
        }

        let ranks = hand.map { $0.rank }.sorted()
        let suits = Set(hand.map { $0.suit })
        let rankCounts = Dictionary(grouping: hand, by: { $0.rank }).mapValues { $0.count }

        let isFlush = suits.count == 1
        let isStraight = checkStraight(ranks: ranks)

        let rankCountValues = Array(rankCounts.values).sorted(by: >)

        // Check in priority order
        if isFlush && ranks == [.ten, .jack, .queen, .king, .ace] {
            return .init(rank: .royalFlush, payoutMultiplier: payoutTable[.royalFlush]!)
        } else if isFlush && isStraight {
            return .init(rank: .straightFlush, payoutMultiplier: payoutTable[.straightFlush]!)
        } else if rankCountValues == [4, 1] {
            return .init(rank: .fourOfAKind, payoutMultiplier: payoutTable[.fourOfAKind]!)
        } else if rankCountValues == [3, 2] {
            return .init(rank: .fullHouse, payoutMultiplier: payoutTable[.fullHouse]!)
        } else if isFlush {
            return .init(rank: .flush, payoutMultiplier: payoutTable[.flush]!)
        } else if isStraight {
            return .init(rank: .straight, payoutMultiplier: payoutTable[.straight]!)
        } else if rankCountValues == [3, 1, 1] {
            return .init(rank: .threeOfAKind, payoutMultiplier: payoutTable[.threeOfAKind]!)
        } else if rankCountValues == [2, 2, 1] {
            return .init(rank: .twoPair, payoutMultiplier: payoutTable[.twoPair]!)
        } else if rankCountValues == [2, 1, 1, 1] {
            let pairRank = rankCounts.first(where: { $0.value == 2 })!.key
            if pairRank.rawValue >= Rank.jack.rawValue {
                return .init(rank: .jacksOrBetter, payoutMultiplier: payoutTable[.jacksOrBetter]!)
            }
        }

        return .init(rank: .none, payoutMultiplier: 0)
    }

    private static func checkStraight(ranks: [Rank]) -> Bool {
        let rawValues = ranks.map { $0.rawValue }.sorted()

        // Standard case
        if rawValues == Array(rawValues.first!...rawValues.first! + 4) {
            return true
        }

        // Special case: A-2-3-4-5
        let wheel = [2, 3, 4, 5, 14]
        return rawValues == wheel
    }
}
