//
//  Basket.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 30/05/2024.
//
// basket zpos = 2
// rim zpos = 2, while shooting rim zpos = 4

import SwiftUI
import Foundation
import SpriteKit

class Basket: SKNode{
    let basketSize = CGSize(width: screenWidth * 0.176, height: screenHeight * 0.381)
    let basket: SKSpriteNode
    let rim: SKSpriteNode
    
    init(basketImage: String, rimImage: String, pos: CGPoint) {
        basket = SKSpriteNode(imageNamed: basketImage)
        rim = SKSpriteNode(imageNamed: rimImage)
        super.init()
        basket.position = pos
        basket.zPosition = 3
        basket.size = basketSize

        rim.zPosition = 5
        rim.position = pos
        rim.size = basketSize
        
        self.addChild(basket)
        self.addChild(rim)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
