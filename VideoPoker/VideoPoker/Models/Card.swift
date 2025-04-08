//
//  TraditionalCard.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

enum Suit: String, CaseIterable {
    case hearts = "♥︎", diamonds = "♦︎", clubs = "♣︎", spades = "♠︎"
}

enum Rank: Int, Comparable, CaseIterable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace

    var symbol: String {
        switch self {
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        case .ace: return "A"
        default: return "\(self.rawValue)"
        }
    }

    static func < (lhs: Rank, rhs: Rank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Card: Hashable {
    let rank: Rank
    let suit: Suit
}



// MARK: Card Descriptions

//
// Card description extensions
//

extension Suit : CustomStringConvertible {
    // map the output back to the key
    // there's probably a better way to do this
    var description: String {
        switch String(self.rawValue) {
        case "♠": return "spades"
        case "♡": return "hearts"
        case "♢": return "diamonds"
        case "♣": return "clubs"
        default:
            return ""
        }
    }
}

extension Rank : CustomStringConvertible {
    var description: String {
        switch self {
        case .two, .three, .four, .five, .six, .seven,.eight,.nine,.ten:
            return String(self.hashValue)
        case .ace:
            return "ace"
        case .jack:
            return "j"
        case .queen:
            return "q"
        case .king:
            return "k"
        }
    }
}

extension Card : CustomDebugStringConvertible {
    var debugDescription: String {
        let output = "\(suit.description) - suit: \(suit.rawValue), rank: \(rank.rawValue) \n"
        return output
    }
}
