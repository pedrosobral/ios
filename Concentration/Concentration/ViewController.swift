//
//  ViewController.swift
//  Concentration
//
//  Created by pedro.h.sobral on 31/10/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import UIKit

struct Theme {
    var name: String
    var cards: [String]
    var bgColor: UIColor
    var bgCardColor: UIColor
}

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        (cards.count + 1) / 2
    }
    
    private(set) var theme: Theme? {
        didSet {
            emojiChoices = theme!.cards
            
            emoji.removeAll()
        }
    }
    
    @IBOutlet private var cards: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRandomTheme()
        updateViewFromModel()
    }
    
    @IBAction private func cardTouch(_ sender: UIButton) {
        if let cardIndex = cards.firstIndex(of: sender) {
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        for index in cards.indices {
            let button = cards[index]
            let card = game.cards[index]
            
            var title = ""
            var bgColor = card.isMatched ? UIColor.clear : theme!.bgCardColor
            
            if card.isFaceUp {
                title = emoji(for: card)
                bgColor = UIColor.white
            }
            
            button.setTitle(title, for: .normal)
            button.backgroundColor = bgColor
        }
        
        view.backgroundColor = theme!.bgColor
        
        scoreLabel.text = "\(game.score)"
        movesLabel.text = "\(game.moves)"
    }
    
    private var emojiChoices: [String] = []
    private var emoji = [Card:String]()
    
    private func setRandomTheme() {
        let animalCardColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
        let animalBgColor = #colorLiteral(red: 0.1607843137, green: 0.1960784314, blue: 0.2549019608, alpha: 1)
        
        let themes = [
            Theme(name: "animals", cards: ["🐒", "🦀", "🐙", "🦋"],
                  bgColor: animalBgColor,
                  bgCardColor: animalCardColor),
            
            Theme(name: "sports" , cards: ["🏇🏼", "🚣🏽‍♀️", "🏄🏽‍♂️", "⚾️"],
                  bgColor: UIColor(red:0.18, green:0.19, blue:0.28, alpha:1.0),
                  bgCardColor: UIColor(red:1.00, green:0.99, blue:0.51, alpha:1.0)),
            
            Theme(name: "faces"  , cards: ["😎", "🥳", "😍", "👻"], bgColor:
                UIColor(red:0.78, green:0.09, blue:0.95, alpha:1.0), bgCardColor:
                #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        ]
        
        theme = themes[themes.count.arc4random]
    }
    
    @IBAction func onRestart(_ sender: UIButton) {
        setRandomTheme()
        
        game.restart()
        
        updateViewFromModel()
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        
        if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        
        return 0
    }
}
