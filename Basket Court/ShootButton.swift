//
//  ShootButton.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 28/05/2024.
//

import SwiftUI
import Foundation
import SpriteKit

class ShootButton: SKNode{
    var shotRelease = false
    var shotMeterProportion: CGFloat = 0.5
    
    let sBISize = CGSize(width: screenWidth * 0.058, height: screenHeight * 0.127)
    let sBOSize = CGSize(width: screenWidth * 0.076, height: screenHeight * 0.165)
    let sMSize = CGSize(width: screenWidth * 0.05, height: screenHeight * 0.25)
    let lineSize = CGSize(width: screenWidth * 0.05, height: screenHeight * 0.01)
    let maxLinePos = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.528)
    let perfectLinePos = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.4085)
    let defaultLinePos = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.2885)
    
    let sBI: SKShapeNode
    let sBO: SKShapeNode
    let icon: SKSpriteNode
    let shotMeter: SKSpriteNode
    let line: SKShapeNode
    
    init(pos: CGPoint){
        sBI = SKShapeNode(rectOf: sBISize, cornerRadius: 10)
        sBO = SKShapeNode(rectOf: sBOSize, cornerRadius: 10)
        icon = SKSpriteNode(imageNamed: "shootButtonIcon")
        shotMeter = SKSpriteNode(imageNamed: "shotMeter")
        line = SKShapeNode(rectOf: lineSize, cornerRadius: 5)
        
        super.init()
        isUserInteractionEnabled = true
        
        sBI.position = pos
        sBI.fillColor = jsColor
        sBI.strokeColor = .black
        sBI.zPosition = 101
        
        sBO.position = pos
        sBO.fillColor = jbColor
        sBO.strokeColor = .black
        sBO.zPosition = 100
        
        icon.position = pos
        icon.size = sBISize
        icon.alpha = 0.75
        icon.zPosition = 102
        
        shotMeter.position.x = pos.x
        shotMeter.position.y = pos.y + sMSize.height / 2 + sBOSize.height / 2
        shotMeter.zPosition = 98
        shotMeter.alpha = 0
        shotMeter.size = sMSize
        
        line.position = defaultLinePos
        line.strokeColor = .clear
        line.fillColor = .black
        line.zPosition = 99
        line.alpha = 0
        
        self.addChild(sBO)
        self.addChild(sBI)
        self.addChild(icon)
        self.addChild(shotMeter)
        self.addChild(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if ballState == .bouncing{
            for touch in touches {
                let location = touch.location(in: self)
                if sBO.contains(location){
                    sBI.setScale(0.85)
                    icon.setScale(0.85)
                    shotMeter.alpha = 1
                    line.alpha = 1
                    let action = SKAction.move(to: CGPoint(x: line.position.x, y: shotMeter.position.y + sMSize.height * 0.5 - lineSize.height * 0.5), duration: 0.35)
                    line.run(action, withKey: "lineAction")
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        if ballState == .bouncing{
            sBI.setScale(1)
            icon.setScale(1)
            line.removeAction(forKey: "lineAction")
            if line.position.y <= perfectLinePos.y{
                shotMeterProportion = distanceBetweenPoints(line.position, defaultLinePos) / distanceBetweenPoints(perfectLinePos, defaultLinePos)
            }
            else{
                shotMeterProportion = distanceBetweenPoints(maxLinePos, line.position) / distanceBetweenPoints(perfectLinePos, maxLinePos)
            }
            if shotMeterProportion < 0.2{
                shotMeterProportion = 0.2
            }
            shotRelease = true
            run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.run {
                self.shotMeter.alpha = 0
                self.line.alpha = 0
                self.line.position.y = self.shotMeter.position.y - self.sMSize.height * 0.5 + self.lineSize.height * 0.5
            }]))
        }
    }
}
