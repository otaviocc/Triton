import SwiftUI

struct Emoji: Decodable, Identifiable, CustomStringConvertible {

    // MARK: - Properties

    let emoji: String
    let description: String
    let category: Category
    let tags: [String]
    let aliases: [String]

    var id: Int {
        emoji.hashValue
    }

    var keywords: [String] {
        tags + aliases
    }
}

extension Emoji {

    // MARK: - Nested types

    enum Category: String, Decodable, CaseIterable, Identifiable, CustomStringConvertible {

        case smile = "Smileys & Emotion"
        case people = "People & Body"
        case animal = "Animals & Nature"
        case food = "Food & Drink"
        case travel = "Travel & Places"
        case activities = "Activities"
        case objects = "Objects"
        case symbols = "Symbols"
        case flags = "Flags"

        // MARK: - Properties

        var id: String {
            rawValue
        }

        var iconName: String {
            switch self {
            case .smile: "face.smiling.inverse"
            case .people: "person.fill"
            case .animal: "leaf"
            case .food: "cup.and.saucer"
            case .travel: "train.side.front.car"
            case .activities: "soccerball"
            case .objects: "lamp.desk"
            case .symbols: "circle.grid.cross.left.fill"
            case .flags: "flag"
            }
        }

        var description: String {
            rawValue
        }
    }
}
