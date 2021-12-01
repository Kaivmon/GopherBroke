//
//  MainMenu.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-29.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenu: GKState {
    unowned let scene: GameScene
    let title = SKSpriteNode(imageNamed: "title")
    let tapToStart = SKLabelNode(fontNamed: "GillSans-UltraBold")
    let scaleIn = SKAction.scaleTo(1, duration: 0.5)
    let scaleOut = SKAction.scaleTo(0, duration: 0.5)
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        scene.hideHUD()
        title.position = scene.getCameraPosition() + CGPointMake(0, scene.size.height / 3)
        title.zPosition = 100
        title.setScale(0)        
        
        tapToStart.text = "Tap to start!"
        tapToStart.fontColor = SKColor.blueColor()
        tapToStart.position = scene.getCameraPosition() - CGPointMake(0, scene.size.height / 3)
        tapToStart.zPosition = 100
        tapToStart.setScale(0)
        
        scene.addChild(title)
        scene.addChild(tapToStart)
        
        title.runAction(scaleIn)
        tapToStart.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleTo(1, duration: 0.5), SKAction.scaleTo(0.7, duration: 0.5)])))
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
    override func willExitWithNextState(nextState: GKState) {
        if nextState is Playing {
            title.runAction(scaleOut, completion: {self.title.removeFromParent()})
            tapToStart.removeAllActions()
            tapToStart.runAction(scaleOut, completion: {self.tapToStart.removeFromParent()})
        }
    }
}
