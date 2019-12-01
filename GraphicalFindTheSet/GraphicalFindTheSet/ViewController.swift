//
//  ViewController.swift
//  GraphicalFindTheSet
//
//  Created by pedro.h.sobral on 24/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LayoutViews {
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    private let game = FindTheSet()
    private var score = 0
    
    lazy var grid = Grid(layout: .aspectRatio(5.0/8.0), frame: boardView.bounds)
    
    func setup() {
        boardView.delegate = self
        grid.cellCount = game.table.count
        
        createBoardView()
    }
    
    func createBoardView() {
        for index in 0..<grid.cellCount {
            addCardView(at: index)
        }
    }
    
    func addCardView(at index: Int) {
        let cell = grid[index]!
        let cv = CardView(frame: cell)
        cv.tag = index
        cv.card = game.table[index]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        cv.addGestureRecognizer(tap)
        boardView.addSubview(cv)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if game.selectedCards.count == 3 {
                if game.isASet() != nil {
                    game.selectedCards.removeAll()
                }
            }
            
            let card = sender.view as! CardView
            game.select(at: card.tag)
            
            updateViewFromModel()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.game.isASet() == true {
                    self.score += 100
                    self.game.deal()
                    self.updateViewFromModel()
                }
            }
        }
    }
    
    @IBAction func restart(_ sender: Any) {
        score = 0
        game.restart()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        grid.frame = boardView.bounds
        
        for (i, view) in boardView.subviews.enumerated() {
            let card = view as! CardView
            
            // update frame
            card.frame = grid[i]!
            
            // update state
            card.state = nil
            card.isHidden = true
        }
        
        grid.cellCount = game.table.count
        if game.table.count < boardView.subviews.count {
            for i in stride(from: boardView.subviews.count, to: game.table.count, by: -1) {
                boardView.subviews[i-1].removeFromSuperview()
            }
        }
        
        if game.table.count > boardView.subviews.count {
            for i in boardView.subviews.count..<game.table.count {
                addCardView(at: i)
            }
        }
        
        for i in 0..<game.table.count {
            let card = boardView.subviews[i] as! CardView
            
            card.card = game.table[i]
            
            // update state
            card.state = nil
            if game.selectedCards.contains(card.card!) {
                card.state = .selected
                
                if game.isASet() == true {
                    card.state = .set
                } else if game.isASet() == false {
                    card.state = .notset
                }
            }
            
            card.isHidden = false
        }
        
        scoreLabel.text = "\(score)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

