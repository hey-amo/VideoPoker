//
//  TraditionalCard.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

struct Card {
    // Suit enumerated
    enum Suit: Character, CaseIterable {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }
    
    enum Rank: Int, CaseIterable {
      case two = 2, three, four, five, six, seven, eight, nine, ten
      case jack, queen, king
      case ace
    }
    
    let rank: Rank, suit : Suit
}

//
// Card description extensions
//

extension Card.Suit : CustomStringConvertible {
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

extension Card.Rank : CustomStringConvertible {
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

