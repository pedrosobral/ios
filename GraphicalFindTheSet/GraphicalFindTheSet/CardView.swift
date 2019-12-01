//
//  CardView.swift
//  GraphicalFindTheSet
//
//  Created by pedro.h.sobral on 24/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import UIKit

class CardView: UIView {
    var card: Card?
    
    var state: CardState? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    enum CardState {
        case selected
        case set
        case notset
    }
    
    private func setup() {
        backgroundColor = UIColor.white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let rect = UIBezierPath(rect: bounds)
        
        if state != nil {
            rect.lineWidth = 4
            let borderColor = ModelToView.borderColor[state!]
            borderColor?.setStroke()
        }
        
        rect.stroke()
        
        // card
        let o = CardForView(card: card!, view: self)
        let path = o.object()
        let lines = o.lines()
        
        // color
        ModelToView.color[(card?.color)!]?.setStroke()
        ModelToView.color[(card?.color)!]?.setFill()
        
        // shading
        path.lineWidth = 3.0
        switch (card?.shading)! {
        case .one:
            path.fill()
        case .two:
            path.stroke()
        case .three:
            path.lineWidth = 2.5
            path.append(lines)
            path.addClip()
            path.lineWidth = 3.0
            path.stroke()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

struct CardForView {
    var card: Card
    var view: UIView
    
    var width: CGFloat {
        view.frame.size.width
    }
    var height: CGFloat {
        view.frame.size.height
    }
    var numOfObjects: Int {
        switch card.shapes {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
    var vSize: CGFloat {
        ((height * 0.75) / 3.0)
    }
    
    func object() -> UIBezierPath {
        let paths = UIBezierPath()
        
        switch card.shape {
        case .one:
            for origin in rectOrigins() {
                let path = UIBezierPath(rect: CGRect(origin: origin, size: CGSize(width: vSize, height: vSize)))
                paths.append(path)
            }
            
        case .two:
            for origin in arcOrigins() {
                let path = UIBezierPath(arcCenter: origin, radius: vSize/2, startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: true)
                paths.append(path)
            }
            
        case .three:
            let path = UIBezierPath()
            
            for (a, b, c) in triOrigins() {
                path.move(to: a)
                path.addLine(to: b)
                path.addLine(to: c)
                path.close()
            }
            
            paths.append(path)
        }
            
        return paths
    }
    
    func lines() -> UIBezierPath {
        let path = UIBezierPath()
        
        let space = CGFloat(0.1)
        let x = width * space
        let y = height * space
        for index in 1...Int(((1/space) * 2)) {
            let i = CGFloat(index)
            path.move(to: CGPoint(x: 0.0, y: y * i))
            path.addLine(to: CGPoint(x: x * i, y: 0.0))
        }
        return path
    }
    
    func triOrigins() -> [(a: CGPoint, b: CGPoint, c: CGPoint)] {
        var origins = [(a: CGPoint, b: CGPoint, c: CGPoint)]()
        
        let n = CGFloat(numOfObjects)
        let space = (height - n * vSize)/(n + 1.0)
        let x = width/2
        
        for i in 0..<numOfObjects {
            let y = (space) + CGFloat(i) * (vSize + space)
            
            origins.append((
                a: CGPoint(x: x, y: y),
                b: CGPoint(x: x * 1.5, y: y + vSize),
                c: CGPoint(x: x * 0.5, y: y + vSize)
            ))
        }
        
        return origins
    }
    
    func arcOrigins() -> [CGPoint] {
        var origins = [CGPoint]()
        
        let n = CGFloat(numOfObjects)
        let space = (height - n * vSize)/(n + 1.0)
        let x = width/2
        
        for i in 0..<numOfObjects {
            let y = (space) + vSize/2 + CGFloat(i) * (vSize + space)
            origins.append(CGPoint(x: x, y: y))
        }
        
        return origins
    }
    
    func rectOrigins() -> [CGPoint] {
        var origins = [CGPoint]()
        
        let n = CGFloat(numOfObjects)
        let space = (height - n * vSize)/(n + 1.0)
        let x = (width - vSize)/2
        
        for i in 0..<numOfObjects {
            let y = (space) + CGFloat(i) * (vSize + space)
            origins.append(CGPoint(x: x, y: y))
        }
        
        return origins
        
    }
}

struct ModelToView {
    static var borderColor: [CardView.CardState: UIColor] = [
        .selected: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), .set: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), .notset: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]
    static var color: [Card.Feature: UIColor] = [.one: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), .two: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), .three: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)]
}
