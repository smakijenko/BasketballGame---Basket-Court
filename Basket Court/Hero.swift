import SwiftUI
import Foundation
import SpriteKit

class Hero: SKSpriteNode {
// Variables
    var handPos = CGPoint(x: 1, y: 1)
    var degree: CGFloat = 0
    var steerable = false
    
// Animations Handling
    var standingLeftTextures: [SKTexture] = []
    var standingRightTextures: [SKTexture] = []
    var upRightTextures: [SKTexture] = []
    var downRightTextures: [SKTexture] = []
    var downLeftTextures: [SKTexture] = []
    var upLeftTextures: [SKTexture] = []
    
    enum directionOfHero{
        case standingLeft
        case standingRight
        case upRight
        case downRight
        case downLeft
        case upLeft
    }
    
    var pastDirection: directionOfHero = .standingLeft
    var direction: directionOfHero = .standingLeft
    
    var standingLeftAction: SKAction?
    var standingRightAction: SKAction?
    var movingUpRightAction: SKAction?
    var movingDownRightAction: SKAction?
    var movingDownLeftAction: SKAction?
    var movingUpLeftAction: SKAction?
        
// Init
    init(image: String, pos: CGPoint) {
        let texture = SKTexture(imageNamed: image)
        let size = CGSize(width: screenHeight * 0.12, height: screenHeight * 0.12)
        super.init(texture: texture, color: .clear, size: size)
        position = pos
        zPosition = 2
        handPos = CGPoint(x: position.x - screenWidth * 0.014, y: position.y - screenHeight * 0.026)
        uploadingAnimations(lS: &standingLeftTextures, rS: &standingRightTextures, uR: &upRightTextures, dR: &downRightTextures, dL: &downLeftTextures, uL: &upLeftTextures)
        uploadingActions()
        run(standingLeftAction!)
    }
    
    // Methods
    func moving(dx: CGFloat, dy: CGFloat, speed: CGFloat) {
        let firstPos = position
        position.x += dx * speed
        position.y += dy * speed
        let secondPos = position
        
        if secondPos != firstPos{
            degree = countingDegree(fP: firstPos, sP: secondPos)
            if degree >= 0 && degree <= 30{
                direction = .upRight
            }
            else if degree > 30 && degree <= 180{
                direction = .downRight
            }
            else if degree > 180 && degree <= 330{
                direction = .downLeft
            }
            else if degree > 330 && degree < 360{
                direction = .upLeft
            }
        }
        else{
            if position.x >= screenWidth / 2{
                direction = .standingRight
            }
            else{
                direction = .standingLeft
            }
        }
        
        if direction != pastDirection{
            pastDirection = direction
            removeAllActions()
            switch direction {
            case .standingLeft:
                run(standingLeftAction!)
            case .standingRight:
                run(standingRightAction!)
            case .upRight:
                run(movingUpRightAction!)
            case .downRight:
                run(movingDownRightAction!)
            case .downLeft:
                run(movingDownLeftAction!)
            case .upLeft:
                run(movingUpLeftAction!)
            }
        }
        
        if direction == .standingLeft || direction == .downLeft || direction == .upLeft{
            handPos = CGPoint(x: position.x - screenWidth * 0.014, y: position.y - screenHeight * 0.026)
        }
        else{
            handPos = CGPoint(x: position.x + screenWidth * 0.014, y: position.y - screenHeight * 0.026)
        }
    }
    
    func shooting(){
        removeAllActions()
        if position.x < screenWidth / 2{
            handPos = CGPoint(x: position.x - screenWidth * 0.014, y: position.y + screenHeight * 0.026)
            texture = SKTexture(imageNamed: "heroShootingLeft")
            let sequence = SKAction.sequence([SKAction.wait(forDuration: 0.3), standingLeftAction!])
            run(sequence)
        }
        else{
            handPos = CGPoint(x: position.x + screenWidth * 0.014, y: position.y + screenHeight * 0.026)
            texture = SKTexture(imageNamed: "heroShootingRight")
            let sequence = SKAction.sequence([SKAction.wait(forDuration: 0.3), standingRightAction!])
            run(sequence)
        }
    }
    
    func countingDegree(fP: CGPoint, sP: CGPoint) -> CGFloat{
        let dX = sP.x - fP.x
        let dY = sP.y - fP.y
        var degree = (atan2(dX, dY)) * 180 / .pi
        if degree < 0 {
            degree += 360
        }
        return degree
    }
    
    func uploadingAnimations(lS: inout [SKTexture], rS: inout [SKTexture], uR: inout [SKTexture], dR: inout [SKTexture], dL: inout [SKTexture], uL: inout [SKTexture]) {
        for i in 1...3 {
            let textureNamelS = "heroStandingLeft\(i)"
            let textureNamerS = "heroStandingRight\(i)"
            let textureNameuR = "heroUpRight\(i)"
            let textureNamedR = "heroDownRight\(i)"
            let textureNamedL = "heroDownLeft\(i)"
            let textureNameuL = "heroUpLeft\(i)"

            lS.append(SKTexture(imageNamed: textureNamelS))
            rS.append(SKTexture(imageNamed: textureNamerS))
            uR.append(SKTexture(imageNamed: textureNameuR))
            dR.append(SKTexture(imageNamed: textureNamedR))
            dL.append(SKTexture(imageNamed: textureNamedL))
            uL.append(SKTexture(imageNamed: textureNameuL))
        }
    }
    
    func uploadingActions(){
        standingLeftAction = SKAction.repeatForever(SKAction.animate(with: standingLeftTextures, timePerFrame: 0.18))
        standingRightAction = SKAction.repeatForever(SKAction.animate(with: standingRightTextures, timePerFrame: 0.18))
        movingUpRightAction = SKAction.repeatForever(SKAction.animate(with: upRightTextures, timePerFrame: 0.18))
        movingDownRightAction = SKAction.repeatForever(SKAction.animate(with: downRightTextures, timePerFrame: 0.18))
        movingDownLeftAction = SKAction.repeatForever(SKAction.animate(with: downLeftTextures, timePerFrame: 0.18))
        movingUpLeftAction = SKAction.repeatForever(SKAction.animate(with: upLeftTextures, timePerFrame: 0.18))
    }
    
    //-----------------------------------------------------
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
