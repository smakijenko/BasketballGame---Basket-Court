//
//  Ball.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 27/05/2024.
//

import SwiftUI
import Foundation
import SpriteKit

class Ball: SKSpriteNode{
    var isPassed = false
    var isInPossession = true // Needed while throwingBall
    var start: CGPoint = CGPoint(x: 0, y: 0) //Needed while throwingBall and passingBall
    
    init(handPos: CGPoint){
        let texture = SKTexture(imageNamed: "ball")
        let size = CGSize(width: screenHeight * 0.03, height: screenHeight * 0.03)
        super.init(texture: texture, color: .clear, size: size)
        position = handPos
        zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bouncingBall(pos: CGPoint){
        position.x = pos.x
        position.y = pos.y
        let bouncing = SKAction.repeatForever(SKAction.sequence([SKAction.move(by: CGVector(dx: 0, dy: -screenHeight * 0.0153), duration: 0.25), SKAction.move(by: CGVector(dx: 0, dy: screenHeight * 0.0153), duration: 0.25), SKAction.wait(forDuration: 0.1)]))
        run(bouncing)
    }
        
    func throwingBall(target: CGPoint, duration: CGFloat, shotProportion: CGFloat) {
        removeAllActions()
        var actions: [SKAction] = []
        
        throwParabola(target: target,start: start, actions: &actions)
        if Double(Int.random(in: 1...100)) <= shotProportion * 100{
            actions.append(bouncingAfterSuccessfulShot())
        }
        else{
            actions.append(bouncingAfterMissShot())
            
        }
        actions.append(bouncingOfTheFloor())
        let sequence = SKAction.sequence(actions)
        run(sequence)
        
        func throwParabola(target: CGPoint, start: CGPoint, actions: inout [SKAction]){
            ball.zPosition = 4
            let deltaX = target.x - start.x
            let deltaY = target.y - start.y
            let stepDuration = 0.01
            let numberOfSteps = Int(duration / stepDuration)
            
            for step in 0...numberOfSteps {
                let t = CGFloat(step) / CGFloat(numberOfSteps)
                let newX = start.x + t * deltaX
                let newY = start.y + t * deltaY + -4 * (t - 1) * t * 80
                let moveTo = SKAction.move(to: CGPoint(x: newX, y: newY), duration: stepDuration)
                actions.append(moveTo)
            }
        }
        
        func bouncingAfterSuccessfulShot() -> SKAction{
            let floorUnderLeftBasket = CGPoint(x: screenWidth * 0.14, y: screenHeight * 0.508)
            let one = SKAction.run {self.isInPossession = false}
            let two = SKAction.move(to: floorUnderLeftBasket, duration: 0.6)
            return SKAction.sequence([one, two])
        }
        
        func bouncingAfterMissShot() -> SKAction{
            let start = target
            let finalPos = CGPoint(x: Double.random(in: (screenHeight * 0.3)...(screenHeight * 0.45)), y: Double.random(in: (screenHeight * 0.25)...(screenHeight * 0.75)))
            let zero = SKAction.run {ball.zPosition = 6}
            let one = SKAction.run {self.isInPossession = false}
            var twoArray: [SKAction] = []
            throwParabola(target: finalPos, start: start, actions: &twoArray)
            let twoSequence = SKAction.sequence(twoArray)
            return SKAction.sequence([zero, one, twoSequence])
            
        }
        
        func bouncingOfTheFloor() -> SKAction{
            let one = SKAction.run {self.zPosition = 1}
            let two = SKAction.move(by: CGVector(dx: 0, dy: screenHeight * 0.071), duration: 0.4)
            two.timingMode = .easeOut
            let three = SKAction.wait(forDuration: 0)
            let four = SKAction.move(by: CGVector(dx: 0, dy: screenHeight * -0.071), duration: 0.4)
            four.timingMode = .easeIn
            let five = SKAction.move(by: CGVector(dx: 0, dy: screenHeight * 0.029), duration: 0.25)
            five.timingMode = .easeOut
            let six = SKAction.wait(forDuration: 0)
            let seven = SKAction.move(by: CGVector(dx: 0, dy: screenHeight * -0.029), duration: 0.25)
            seven.timingMode = .easeIn
            return SKAction.sequence([one, two, three, four, five, six, seven])
        }
    }
    
    func passingBall(target: CGPoint, duration: CGFloat){
        removeAllActions()
        isPassed = true
        let moveTo = SKAction.move(to: target, duration: duration)
        let heroChange = SKAction.run {hero = nextHero}
        let stateChange = SKAction.run {self.isPassed = false}
        run(SKAction.sequence([moveTo, heroChange, stateChange, stateChange]))
    }
}
