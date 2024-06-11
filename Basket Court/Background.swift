//
//  Background.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 19/05/2024.
//

import SwiftUI
import Foundation
import SpriteKit

class Background: SKNode{
    
    let backGround: SKSpriteNode
    
    override init(){
        backGround = SKSpriteNode(imageNamed: "background")
        super.init()
        backGround.size = screenSize
        backGround.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        backGround.zPosition = -100
        self.addChild(backGround)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
