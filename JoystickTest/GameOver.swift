//
//  GameOver.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-29.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    unowned let scene: GameScene
    let gameOver = SKLabelNode(fontNamed: "GillSans-UltraBold")
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is Playing {

            scene.hideHUD()
            gameOver.position = scene.getCameraPosition() + CGPointMake(0, scene.size.height / 3)
            gameOver.text = "Game Over!"
            gameOver.fontColor = SKColor.redColor()
            gameOver.zPosition = 100
            gameOver.setScale(0)
            scene.addChild(gameOver)
            gameOver.runAction(
                SKAction.repeatAction(
                    SKAction.sequence(
                        [SKAction.scaleTo(2.5, duration: 1),
                            SKAction.scaleTo(2, duration: 0.8)
                        ]), count: 4)
            ) // End gameOver Action
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is MainMenu.Type
    }
    
    override func willExitWithNextState(nextState: GKState) {
        if nextState is MainMenu {
            gameOver.removeFromParent()
        }
    }
}
