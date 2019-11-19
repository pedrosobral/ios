//
//  Card.swift
//  Concentration
//
//  Created by pedro.h.sobral on 01/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var isFaceUp = false
    var isMatched = false
    var matchFactor = 1.0
    var countAlreadyBeenSeen = 0
    
    private var identifier: Int
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }
}
