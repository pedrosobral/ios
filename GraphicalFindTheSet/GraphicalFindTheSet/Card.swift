//
//  Card.swift
//  FindTheSet
//
//  Created by pedro.h.sobral on 20/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import Foundation

struct Card: Equatable {
    var shapes: Feature
    var shape: Feature
    var shading: Feature
    var color: Feature
    
    var values: [Int] {
        [self.shapes.rawValue, self.shape.rawValue, self.shading.rawValue, self.color.rawValue]
    }
    
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
