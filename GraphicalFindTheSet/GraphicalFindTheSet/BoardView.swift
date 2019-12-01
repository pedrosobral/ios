//
//  BoardView.swift
//  GraphicalFindTheSet
//
//  Created by pedro.h.sobral on 24/11/19.
//  Copyright © 2019 pedro.h.sobral. All rights reserved.
//

import UIKit

protocol LayoutViews: class {
    func updateViewFromModel()
}

@IBDesignable
class BoardView: UIView {
    weak var delegate: LayoutViews?

    override func layoutSubviews() {
        super.layoutSubviews()
        
        delegate?.updateViewFromModel()
    }
}
