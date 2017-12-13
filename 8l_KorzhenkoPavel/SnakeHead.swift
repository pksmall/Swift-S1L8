//
//  SnakeHead.swift
//  8l_KorzhenkoPavel
//
//  Created by Pavel Korzhenko on 12/13/17.
//  Copyright © 2017 pavelkorzhenko. All rights reserved.
//

import UIKit

class SnakeHead: SnakeBodyPart {
    override init(atPoint point: CGPoint) {
        super.init(atPoint: point)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
