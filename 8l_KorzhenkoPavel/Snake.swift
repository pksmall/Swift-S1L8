//
//  Snake.swift
//  8l_KorzhenkoPavel
//
//  Created by Pavel Korzhenko on 12/13/17.
//  Copyright © 2017 pavelkorzhenko. All rights reserved.
//

import UIKit
import SpriteKit

class Snake: SKShapeNode {
    // массив где хранятся сегменты тела
    var body = [SnakeBodyPart]()
    
    // конструктор
    convenience init(atPoint point: CGPoint)  {
        self.init()
        // змейка начинается с головы, создадим ее
        let head = SnakeHead(atPoint:  point)
        // и добавим в массив
        body.append(head)
        // и сделаем ее дочерним объектом.
        addChild(head)
    }
    
    // метод добавляет еще один сегмент тела
    func addBodyPart(){
        // инстанцируем сегмент
        let newBodyPart = SnakeBodyPart(atPoint: CGPoint(x: body[0].position.x, y:body[0].position.y))
        // добавляем его в массив
        body.append(newBodyPart)
        // делаем дочерним объектом
        addChild(  newBodyPart)
    }
}
