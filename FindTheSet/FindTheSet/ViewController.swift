//
//  ViewController.swift
//  FindTheSet
//
//  Created by pedro.h.sobral on 20/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet var cards: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var deckLabel: UILabel!
    
    private var score = 0
    
    var game = FindTheSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewFromModel()
    }
    
    @IBAction func cardSelect(_ sender: UIButton) {
        if game.selectedCards.count == 3 {
            if game.match() != nil {
                game.selectedCards.removeAll()
            }
        }
        
        if let cardIndex = cards.firstIndex(of: sender) {
            game.select(at: cards[cardIndex].tag)
        }
        
        updateViewFromModel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.game.match() == true {
                self.score += 100
                self.game.deal()
                self.updateViewFromModel()
            }
        }
    }
    
    @IBAction func restartSelect(_ sender: UIButton) {
        score = 0
        game.restart()
        updateViewFromModel()
    }
    
    @IBAction func debug(_ sender: Any) {
    }
    
    private func updateViewFromModel() {
        for index in cards.indices {
            let button = cards[index]
            
            button.setAttributedTitle(nil, for: .normal)
            button.backgroundColor = UIColor.white
            button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor.white.cgColor
            button.isEnabled = false
        }
        
        for index in game.table.indices {
            if let cardIndex = cards.firstIndex(where: { $0.tag == index }) {
                let button = cards[cardIndex]
                let card = game.table[index]
                
                var borderWidth: CGFloat = 0.25
                var borderColor = UIColor.blue.cgColor
                
                // handle visual feedback for matched or unmatched set
                if game.selectedCards.contains(card) {
                    borderWidth = 2.0
                    
                    if game.match() == true {
                        borderColor = UIColor.green.cgColor
                    } else if game.match() == false {
                        borderColor = UIColor.red.cgColor
                    }
                }
                
                button.setAttributedTitle(image(for: card), for: .normal)
                button.backgroundColor = UIColor.white
                button.layer.cornerRadius = 8.0
                
                button.layer.borderWidth = borderWidth
                button.layer.borderColor = borderColor
                button.isEnabled = true
            }
        }
        
        scoreLabel.text = "\(score)"
        deckLabel.text = "🃏 \(game.deck.count)"
    }
    
    private func image(for card: Card) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 30)
        
        let shape = ModelToView.shape[card.shape]!
        let color = ModelToView.color[card.color]!
        let alpha = ModelToView.alpha[card.shading]!
        
        let shapes: String
        switch card.shapes {
        case .one:
            shapes = "\n\(shape)\n"
        case .two:
            shapes = "\(shape)\n\(shape)"
        case .three:
            shapes = "\(shape)\n\(shape)\n\(shape)"
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .strokeWidth: -5.0,
            .strokeColor: color,
            .foregroundColor: color.withAlphaComponent(CGFloat(alpha))
        ]
        
        return NSAttributedString(string: shapes, attributes: attributes)
    }
}

struct ModelToView {
    static let shape: [Card.Feature: String] = [.one: "●", .two: "▲", .three: "■"]
    static var color: [Card.Feature: UIColor] = [.one: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), .two: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), .three: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)]
    static var alpha: [Card.Feature: CGFloat] = [.one: 1.0, .two: 0.40, .three: 0.00]
}

