//
//  Card.swift
//  HearthstoneBG
//
//  Created by Ivan on 17.04.2021.
//

import Foundation

struct CardData: Decodable {
    let cards: [Card]
}

struct Card: Decodable {
    let id: Int
    let name: String
    let text: String
    let battlegrounds: Battlegrounds
}

struct Battlegrounds: Decodable {
    let image: String
}
