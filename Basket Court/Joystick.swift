//
//  Joystick.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 19/05/2024.
//

import SwiftUI
import Foundation
import SpriteKit

class Joystick: SKNode{
    let jsRadius = screenWidth * 0.035
    let jbRadius = screenWidth * 0.0525
    let js: SKShapeNode
    let jb: SKShapeNode
    
    init(pos: CGPoint){
        js = SKShapeNode(circleOfRadius: jsRadius)
        jb = SKShapeNode(circleOfRadius: jbRadius)
        super.init()
        js.position = pos
        js.fillColor = jsColor
        js.strokeColor = .black
        js.zPosition = 100
        
        jb.position = pos
        jb.fillColor = jbColor
        jb.strokeColor = .black
        jb.zPosition = 99
        
        self.addChild(js)
        self.addChild(jb)
        
        isUserInteractionEnabled = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch in touches {
            let location = touch.location(in: self)
            if distanceBetweenPoints(jb.position, location) <= jbRadius{
                let newLocation = CGPoint(x: location.x, y: location.y)
                let move = SKAction.move(to: newLocation, duration: 0.1)
                js.run(move)
            }
            else{
                if location.x >= jb.position.x{
                    js.position.x = jb.position.x + (jbRadius) * cos(atan((location.y - jb.position.y) / (location.x - jb.position.x)))
                    js.position.y = jb.position.y + (jbRadius) * sin(atan((location.y - jb.position.y) / (location.x - jb.position.x)))
                }
                else{
                    js.position.x = jb.position.x - (jbRadius) * cos(atan((location.y - jb.position.y) / (location.x - jb.position.x)))
                    js.position.y = jb.position.y - (jbRadius) * sin(atan((location.y - jb.position.y) / (location.x - jb.position.x)))
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        let move = SKAction.move(to: joystickPosition, duration: 0.1)
        js.run(move)
    }
    
    func movementVector() -> CGVector{
        let dx = js.position.x - jb.position.x
        let dy = js.position.y - jb.position.y
        let movementVector = CGVector(dx: dx, dy: dy)
        return movementVector
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

