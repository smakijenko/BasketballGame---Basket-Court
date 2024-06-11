//
//  GameScene.swift
//  Basket Court
//
//  Created by Stanisław Makijenko on 17/05/2024.
//

import SwiftUI
import Foundation
import SpriteKit

//Variables
enum StateOfBall{
    case bouncing
    case throwed
    case noOne
    case passed
}

let herosSpeed: CGFloat = 0.035
var ballState:StateOfBall = .bouncing

//Sizes and positions
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let screenSize = UIScreen.main.bounds.size

//let joystickPosition = CGPoint(x: -screenWidth * 0.357, y: -screenHeight * 0.3) // Relative to camera
//let shootButtonPosition = CGPoint(x: screenWidth * 0.3, y: -screenHeight * 0.3) // Relative to camera
let joystickPosition = CGPoint(x: screenWidth * 0.142, y: screenHeight * 0.201)
let shootButtonPosition = CGPoint(x: screenWidth * 0.75, y: screenHeight * 0.201)
let passButtonPosition = CGPoint(x: screenWidth * 0.85, y: screenHeight * 0.201)
let leftBasketPosition = CGPoint(x: screenWidth * 0.07, y: screenHeight * 0.664)
let rightBasketPosition = CGPoint(x: screenWidth * 0.925, y: screenHeight * 0.664)
let leftRimPosition = CGPoint(x: screenWidth * 0.14, y: screenHeight * 0.712)
let rightRimPosition = CGPoint(x: screenWidth * 0.855, y: screenHeight * 0.712)

//Colors
let backgroundBlue = UIColor(red: 0, green: 0.363, blue: 0.652, alpha: 1)
let jbColor = UIColor(red: 0.664, green: 0.664, blue: 0.664, alpha: 0.65)
let jsColor = UIColor(red: 0.429, green: 0.429, blue: 0.429, alpha: 0.8)

//Objects
let bg = Background()
let leftBasket = Basket(basketImage: "leftBasket", rimImage: "leftRim", pos: leftBasketPosition)
let rightBasket = Basket(basketImage: "rightBasket", rimImage: "rightRim", pos: rightBasketPosition)
let player1 = Hero(image: "heroStandingLeft1",pos: CGPoint(x: 300, y: 300))
let player2 = Hero(image: "heroStandingLeft1",pos: CGPoint(x: 400, y: 200))
let player3 = Hero(image: "heroStandingLeft1", pos: CGPoint(x: 300, y: 100))
let ball = Ball(handPos: hero.handPos)
let joystick = Joystick(pos: joystickPosition)
let shootButton = ShootButton(pos: shootButtonPosition)
let passButton = PassButton(pos: passButtonPosition)

var hero = player1
var nextHero = player1

//GameScene
class GameScene: SKScene{
    override init() {
        super.init(size: .zero)
        self.size = screenSize
        self.scaleMode = .resizeFill
        self.backgroundColor = backgroundBlue
        hero.steerable = true
    }
    
    override func didMove(to view: SKView) {
        print("Scene has been loaded.")
        addChild(bg)
        addChild(leftBasket)
        addChild(rightBasket)
        addChild(player1)
        addChild(player2)
        addChild(player3)
        addChild(ball)
        addChild(joystick)
        addChild(shootButton)
        addChild(passButton)
        view.isMultipleTouchEnabled = true
        view.preferredFramesPerSecond = 60
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//Updating scene
    override func update(_ currentTime: TimeInterval) {
// Handling hero moving
        hero.moving(dx: joystick.movementVector().dx, dy: joystick.movementVector().dy, speed: herosSpeed)
// Switching ball state
        ballStateSwitching()
// ShootButton
        shootButtonPressed()
// PassButton
        passButtonPressed()
    }
    func ballStateSwitching(){
        switch ballState {
        case .bouncing:
            ball.bouncingBall(pos: hero.handPos)
        case .throwed:
            if ball.isInPossession == false {ballState = .noOne}
        case .noOne:
            if distanceBetweenPoints(ball.position, hero.handPos) <= 20{
                ball.removeAllActions()
                ball.isInPossession = true
                ballState = .bouncing
            }
        case .passed:
            if ball.isPassed == false {ballState = .bouncing}
        }
    }
     
    func shootButtonPressed(){
        if shootButton.shotRelease && ballState == .bouncing{
            ball.start = ball.position
            hero.shooting()
            ball.throwingBall(target: leftRimPosition, duration: 1.5, shotProportion: shootButton.shotMeterProportion)
            ballState = .throwed
            shootButton.shotRelease = false
        }
    }
    
    func passButtonPressed(){
        if passButton.passRelease && ballState == .bouncing && hero.direction != .standingLeft && hero.direction != .standingRight{
            ball.start = ball.position
            let alphaDegree: CGFloat = 35
            let dirDegree = hero.degree
            switch hero{
            case player1:
                switchingHero(player1: player2, player2: player3)
            case player2:
                switchingHero(player1: player1, player2: player3)
            case player3:
                switchingHero(player1: player1, player2: player2)
            default:
                print("error")
            }
            ballState = .passed
            passButton.passRelease = false
            
            func switchingHero(player1: Hero, player2: Hero){
                let checkingFirst = checkObjectInTriangle(start: ball.start, dirDegree: dirDegree, alphaDegree: alphaDegree, player: player1.handPos)
                let checkingSecond = checkObjectInTriangle(start: ball.start, dirDegree: dirDegree, alphaDegree: alphaDegree, player: player2.handPos)
                if checkingFirst && checkingSecond{
                    let distanceToFirst = distanceBetweenPoints(ball.start, player1.handPos)
                    let distanceToSecond = distanceBetweenPoints(ball.start, player2.handPos)
                    if distanceToFirst <= distanceToSecond {
                        nextHero = player1
                        ball.passingBall(target: player1.handPos, duration: 1)
                    }
                    else{
                        nextHero = player2
                        ball.passingBall(target: player2.handPos, duration: 1)
                    }
                }
                else if checkingFirst{
                    nextHero = player1
                    ball.passingBall(target: player1.handPos, duration: 1)
                }
                else if checkingSecond{
                    nextHero = player2
                    ball.passingBall(target: player2.handPos, duration: 1)
                }
            }
            
            func checkObjectInTriangle(start: CGPoint, dirDegree: CGFloat, alphaDegree: CGFloat, player: CGPoint) -> Bool{
                let radians: CGFloat = alphaDegree / 2 * .pi / 180
                let distance: CGFloat = 300 / cos(radians)
                var dMinus = dirDegree - alphaDegree / 2
                var dPlus = dirDegree + alphaDegree / 2
                if dMinus < 0{
                    dMinus += 360
                }
                if dPlus > 360{
                    dPlus -= 360
                }
                
                let A = start
                let B = calculatePoint(startPoint: start, distance: distance, angleDegrees: dMinus)
                let C = calculatePoint(startPoint: start, distance: distance, angleDegrees: dPlus)
                
                return isInside(x1: A.x, y1: A.y, x2: B.x, y2: B.y, x3: C.x, y3: C.y, xP: player.x, yP: player.y)
                
                func calculatePoint(startPoint: CGPoint, distance: CGFloat, angleDegrees: CGFloat) -> CGPoint {
                    let angleRadians: CGFloat = angleDegrees * .pi / 180.0
                    let deltaX: CGFloat = distance * sin(angleRadians)
                    let deltaY: CGFloat = distance * cos(angleRadians)
                    return CGPoint(x: startPoint.x + deltaX, y: startPoint.y + deltaY)
                }
                
                func isInside(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, x3: CGFloat, y3: CGFloat, xP: CGFloat, yP: CGFloat) -> Bool {
                    let x2C = x2 - x1
                    let y2C = y2 - y1
                    let x3C = x3 - x1
                    let y3C = y3 - y1
                    let xPC = xP - x1
                    let yPC = yP - y1
                    let d = x2C * y3C - x3C * y2C
                    let w1 = (xPC * (y2C - y3C) + yPC * (x3C - x2C) + x2C * y3C - x3C * y2C) / d
                    let w2 = (xPC * y3C - yPC * x3C) / d
                    let w3 = (yPC * x2C - xPC * y2C) / d

                    return checkRange(val: w1, min: 0, max: 1) && checkRange(val: w2, min: 0, max: 1) && checkRange(val: w3, min: 0, max: 1)
                    
                    func checkRange(val: CGFloat, min: CGFloat, max: CGFloat) -> Bool {
                        return val >= min && val <= max
                    }
                }
            }
        }
    }
}


