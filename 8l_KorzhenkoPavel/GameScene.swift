//
//  GameScene.swift
//  8l_KorzhenkoPavel
//
//  Created by Pavel Korzhenko on 12/12/17.
//  Copyright © 2017 pavelkorzhenko. All rights reserved.
//

import SpriteKit
import GameplayKit

struct CollisionCategories {
    static let Snake: UInt32 = 0x1 << 0
    static let SnakeHead: UInt32 = 0x1 << 1
    static let Apple: UInt32 = 0x1 << 2
    static let EdgeBody: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    // наша змея
    var snake: Snake?
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    
    // вызывается при первом запуске сцены
    override func didMove(to view:   SKView) {
        // цвет фона сцены
        backgroundColor  =  SKColor.black
        // вектор и сила гравитации
        self.physicsWorld.gravity  =  CGVector(dx:0,dy:0)
        // добавляем поддержку физики
        self.physicsBody = SKPhysicsBody( edgeLoopFrom: frame)
        // выключаем внешние воздействия на нашу игру
        self.physicsBody?.allowsRotation = false
        // включаем отображение отладочной информации
        view.showsPhysics  = true
        // поворот против часовой стрелки
        // создаем ноду (объект)
        let counterClockwiseButton  =  SKShapeNode()
        // задаем форму круга
        counterClockwiseButton.path = UIBezierPath(ovalIn:CGRect(x:0, y:0, width: 45, height: 45)).cgPath
        // указываем координаты размещения
        counterClockwiseButton.position = CGPoint(x: view.scene!.frame.minX + 30, y:view.scene!.frame.minY + 30)
        // цвет заливки
        counterClockwiseButton.fillColor = UIColor.gray
        // цвет рамки
        counterClockwiseButton.strokeColor = UIColor.gray
        // толщина рамки
        counterClockwiseButton.lineWidth = 5
        // имя объекта для взаимодействия
        counterClockwiseButton.name  = "counterClockwiseButton"
        // Добавляем на сцену
        self.addChild(counterClockwiseButton)
        // Поворот по часовой стрелке
        let clockwiseButton = SKShapeNode()
        clockwiseButton.path = UIBezierPath(ovalIn: CGRect(x:0, y:0, width:45, height:45) ).cgPath
        clockwiseButton.position = CGPoint(x:view.scene!.frame.maxX - 80, y:view.scene!.frame.minY + 30)
        clockwiseButton.fillColor = UIColor.gray
        clockwiseButton.strokeColor = UIColor.gray
        clockwiseButton.lineWidth  =  5
        clockwiseButton.name = "clockwiseButton"
        self.addChild(clockwiseButton)
        
        // Делаем нашу сцену делегатом соприкосновений
        self.physicsWorld.contactDelegate = self
        // устанавливаем категорию взаимодействия с другими объектами
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        // устанавливаем категории, с которыми будут пересекаться края сцены
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake  | CollisionCategories.SnakeHead
        
        //add apple to scene
        createApple()
        
        xCenter = view.scene!.frame.midX
        yCenter = view.scene!.frame.midY
        // создаем змею по центру экрана и добавляем ее на сцену
        snake = Snake(atPoint: CGPoint(x: xCenter, y: yCenter))
        self.addChild(snake!)
    }
    
    // вызывается при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>,  with event: UIEvent?) {
        // перебираем все точки, куда прикоснулся палец
        for touch in touches {
            // определяем координаты касания для точки
            let touchLocation  = touch.location(in: self)
            // проверяем, есть ли объект по этим координатам, и если есть, то не наша ли это кнопка
            guard let touchedNode  =  self.atPoint(touchLocation) as? SKShapeNode,
                    touchedNode.name  == "counterClockwiseButton" || touchedNode.name  == "clockwiseButton"
            else {
                return
            }
            // если это наша кнопка, заливаем ее желтой
            touchedNode.fillColor  = .yellow
            // определяем, какая кнопка нажата и поворачиваем в нужную сторону
            if touchedNode.name  == "counterClockwiseButton" {
                snake!.moveCounterClockwise()
            } else if touchedNode.name == "clockwiseButton" {
                snake!.moveClockwise( )
            }
        }
    }
    
    // вызывается при прекращении нажатия на экран
    override func touchesEnded(_ touches: Set<UITouch>,  with event: UIEvent?) {
        // перебираем все точки, куда прикоснулся палец
        for touch in touches {
            // определяем координаты касания для точки
            let touchLocation  = touch.location(in: self)
            // проверяем, есть ли объект по этим координатам, и если есть, то не наша ли это кнопка
            guard let touchedNode  =  self.atPoint(touchLocation) as? SKShapeNode,
                touchedNode.name  == "counterClockwiseButton" || touchedNode.name  == "clockwiseButton"
                else {
                    return
            }
            // если это наша кнопка, заливаем ее зеленой
            touchedNode.fillColor  = .gray
        }
    }
    
    // вызывается при обрыве нажатия на экран, например ,если телефон примет звонок и свернет приложение
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // вызывается при обработке кадров сцены
    override func update(_ currentTime:TimeInterval)  {
        snake!.move()
    }
    
    // Создаем яблоко в случайной точке сцены
    func createApple(){
        // Случайная точка на экране
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)) + 1)
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)) + 1)
        // Создаем яблоко
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        // Добавляем яблоко на сцену
        self.addChild(apple)
    }
}

// Имплементируем протокол
extension GameScene: SKPhysicsContactDelegate {
    // Добавляем метод отслеживания начала столкновения
    func didBegin(_ contact: SKPhysicsContact)  {
        // логическая сумма масок соприкоснувшихся объектов
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        // вычитаем из суммы голову змеи и у нас остается маска второго объекта
        let collisionObject = bodyes ^ CollisionCategories.SnakeHead
        // проверяем, что это за второй объект
        switch collisionObject {
        case  CollisionCategories.Apple:
            // проверяем что это яблоко
            // яблоко это один из двух объектов, которые соприкоснулись. Используем тернарный оператор, чтобы вычислить какой именно
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            // добавляем к змее еще одну секцию
            snake?.addBodyPart()
            // удаляем съеденное яблоко со сцены
            apple?.removeFromParent()
            // создаем новое яблоко
            createApple()
        case  CollisionCategories.EdgeBody:
            // проверяем, что это стенка экрана
            // @TODO: соприкосновение со стеной будет домашним заданием
            
            // убьем змеюку!!!
            snake?.removeAllChildren()
            snake?.removeAllBodyPart()
            snake?.removeFromParent()
            snake = nil
            
            // All Hail Mr. Snake
            snake = Snake(atPoint: CGPoint(x: xCenter, y: yCenter))
            self.addChild(snake!)
        
        default:
            break
        }
    }
}
