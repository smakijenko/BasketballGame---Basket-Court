//
//  Functions.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 19/05/2024.
//

import SwiftUI
import Foundation
import SpriteKit


func distanceBetweenPoints(_ p1: CGPoint, _ p2: CGPoint) -> Double{
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        return sqrt(dx * dx + dy * dy)
    
}

