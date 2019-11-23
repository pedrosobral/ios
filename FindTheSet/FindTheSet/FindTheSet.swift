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
    
    private func allSameOrAllDiff(a: Card.Feature, b: Card.Feature, c: Card.Feature) -> (allSame: Int, allDiff: Int) {
        return  (allSame: a == b && b == c ? 1 : 0, allDiff: a != b && b != c && a != c ? 1 : 0)
    }
    
    func match(aC: Card? = nil, bC: Card? = nil, cC: Card? = nil) -> Bool? {
        if aC == nil && selectedCards.count != 3 {
            return nil
        }
        
        let a = aC ?? selectedCards[0]
        let b = bC ?? selectedCards[1]
        let c = cC ?? selectedCards[2]
        
        let color = allSameOrAllDiff(a: a.color, b: b.color, c: c.color)
        let shape = allSameOrAllDiff(a: a.shape, b: b.shape, c: c.shape)
        let shapes = allSameOrAllDiff(a: a.shapes, b: b.shapes, c: c.shapes)
        let shading = allSameOrAllDiff(a: a.shading, b: b.shading, c: c.shading)
        
        let totalSame = color.allSame + shape.allSame + shapes.allSame + shading.allSame
        let totalDiff = color.allDiff + shape.allDiff + shapes.allDiff + shading.allDiff
        
        return totalSame == 0 && totalDiff == 4 ||
            totalSame == 1 && totalDiff == 3 ||
            totalSame == 2 && totalDiff == 2 ||
            totalSame == 3 && totalDiff == 1
    }
    
    func findASet() -> [Int]? {
        for indexA in table.indices {
            let a = table[indexA]
            for indexB in table.indices {
                let b = table[indexB]
                for indexC in table.indices {
                    let c = table[indexC]
                    
                    if a == b || b == c || a == c {
                        continue
                    }
                    
                    if match(aC: a, bC: b, cC: c) == true {
                        return [indexA, indexB, indexC]
                    }
                }
            }
        }
        return nil
    }
}
