//
//  Card.swift
//  FindTheSet
//
//  Created by pedro.h.sobral on 20/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import Foundation

// number of shapes (one, two, or three), shape (diamond, squiggle, oval), shading (solid, striped, or open), and color (red, green, or purple).

struct Card: Equatable {
    var shapes: Feature
    var shape: Feature
    var shading: Feature
    var color: Feature
    
    enum Feature: Int {
        case one = 1
        case two
        case three
        
        static var all = [Feature.one, .two, .three]
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.shapes == rhs.shapes &&
            lhs.color == rhs.color &&
            lhs.shading == rhs.shading &&
            lhs.shape == rhs.shape
    }
}
