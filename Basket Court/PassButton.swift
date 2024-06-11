//
//  PassButton.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 08/06/2024.
//

import Foundation
import SpriteKit

class PassButton: SKNode{
    var passRelease = false
    let pBISize = CGSize(width: screenWidth * 0.058, height: screenHeight * 0.127)
    let pBOSize = CGSize(width: screenWidth * 0.076, height: screenHeight * 0.165)
    
    let pBI: SKShapeNode
    let pBO: SKShapeNode
    let icon: SKSpriteNode
    
    init(pos: CGPoint){
        pBI = SKShapeNode(rectOf: pBISize, cornerRadius: 10)
        pBO = SKShapeNode(rectOf: pBOSize, cornerRadius: 10)
        icon = SKSpriteNode(imageNamed: "passButtonIcon")
        
        super.init()
        isUserInteractionEnabled = true

        pBI.position = pos
        pBI.fillColor = jsColor
        pBI.strokeColor = .black
        pBI.zPosition = 101
        
        pBO.position = pos
        pBO.fillColor = jbColor
        pBO.strokeColor = .black
        pBO.zPosition = 100
        
        icon.position = pos
        icon.size = pBISize
        icon.alpha = 0.75
        icon.zPosition = 102
        
        self.addChild(pBI)
        self.addChild(pBO)
        self.addChild(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        if ballState == .bouncing{
            for touch in touches {
                let location = touch.location(in: self)
                if pBO.contains(location){
                    pBI.setScale(0.85)
                    icon.setScale(0.85)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        if ballState == .bouncing{
            pBI.setScale(1)
            icon.setScale(1)
            passRelease = true
        }
    }
}
