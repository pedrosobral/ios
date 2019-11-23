//
//  FindTheSet.swift
//  FindTheSet
//
//  Created by pedro.h.sobral on 20/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import Foundation

class FindTheSet {
    private(set) var deck = [Card]()
    private(set) var table = [Card]()
    var selectedCards = [Card]()
    
    init() {
        restart()
    }
    
    func restart() {
        selectedCards.removeAll()
        
        initDeck()
        initTable()
    }
    
    private func initDeck() {
        deck.removeAll()
        
        for shapes in Card.Feature.all {
            for shape in Card.Feature.all {
                for shading in Card.Feature.all {
                    for color in Card.Feature.all {
                        deck.append(Card(shapes: shapes, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
        
        deck.shuffle()
    }
    
    private func initTable() {
        table.removeAll()
        
        for index in 0..<12 {
            table.append(deck.remove(at: index))
        }
        deal()
    }
    
    func select(at index: Int) {
        let card = table[index]
        if let cardIndex = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: cardIndex)
        } else {
            selectedCards.append(card)
        }
    }
    
    func deal() {
        if table.count > 12 || deck.isEmpty {
            removeMatchedCards()
        } else {
            replaceMatchedCards()
        }
        selectedCards.removeAll()
        
        while findASet() == nil {
            if deal3More() == false {
                break
            }
        }
    }
    
    private func removeMatchedCards() {
        for selectIndex in selectedCards.indices {
            let card = selectedCards[selectIndex]
            table.removeAll(where: {$0 == card})
        }
    }
    
    private func replaceMatchedCards() {
        for selectIndex in selectedCards.indices {
            let card = selectedCards[selectIndex]
            if let matchIndex = table.firstIndex(of: card) {
                table[matchIndex] = deck.removeFirst()
            }
        }
    }
    
    private func deal3More() -> Bool {
        if deck.isEmpty || isTableFull() {
            return false
        }
        
        for _ in 0..<3 {
            table.append(deck.removeFirst())
        }
        
        return true
    }
    
    private func isTableFull() -> Bool {
        return table.count == 24
    }
    
    func isASet(_ set: [Card]? = nil) -> Bool? {
        if set == nil && selectedCards.count != 3 {
            return nil
        }
        
        let cards = set ?? selectedCards
        let numberOfFeature = cards[0].values.count
        
        var sumValues = [Int](repeating: 0, count: numberOfFeature)
        
        for cards in cards {
            for index in 0..<numberOfFeature {
                sumValues[index] += cards.values[index]
            }
        }
        
        return sumValues.reduce(true, { $0 && ($1 % 3) == 0 })
    }
    
    func findASet() -> [Int]? {
        for i in 0..<table.count - 2 {
            for j in (i+1)..<table.count - 1 {
                for k in (j+1)..<table.count {
                    if isASet([table[i], table[j], table[k]]) == true {
                        return [i, j, k]
                    }
                }
            }
        }
        return nil
    }
}
