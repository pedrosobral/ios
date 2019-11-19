//
//  Concentation.swift
//  Concentration
//
//  Created by pedro.h.sobral on 01/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import Foundation

class Concentration {
    private(set) var cards = [Card]()
    private(set) var moves = 0
    private var lastMatchTime = Date.init()
    
    var score: Int {
        var sum = 0.0
        var mismatches = 0
        for index in cards.indices {
            if cards[index].isMatched {
                sum += 1 * cards[index].matchFactor
            }
            if cards[index].countAlreadyBeenSeen > 1 {
                mismatches += cards[index].countAlreadyBeenSeen
            }
        }
        return Int(round((sum - (Double(mismatches) / 2.0))))
    }
    
    private var indexOfOneAndOnlyOneFaceUpCard: Int? {
        get {
            cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at \(index)): chosen index not in the cards")
        
        moves += 1
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    
                    var matchFactor = 1.2
                    if lastMatchTime.timeIntervalSinceNow < 5 {
                        matchFactor = 2
                    }
                    cards[index].matchFactor = matchFactor
                    cards[matchIndex].matchFactor = matchFactor
                    
                    lastMatchTime = Date.init()
                } else {
                    cards[index].countAlreadyBeenSeen += 1
                    cards[indexOfOneAndOnlyOneFaceUpCard!].countAlreadyBeenSeen += 1
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyOneFaceUpCard = index
            }
        }
    }
    
    func restart() {
        moves = 0
        
        for index in cards.indices {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
            cards[index].countAlreadyBeenSeen = 0
        }
        cards = cards.shuffled()
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one of pair of cards")
        
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards = cards.shuffled()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        count == 1 ? first : nil
    }
}
