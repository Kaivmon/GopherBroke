//
//  Dead.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-30.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class Dead: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.physicsWorld.contactDelegate = nil
        scene.player.physicsBody?.dynamic = false
        scene.player.yScale = 0.5
        scene.runAction(scene.soundDie)
        scene.emitParticles("bloodSpray", sprite: scene.player)
        
        scene.runAnim(scene.animDie)
        
        
        // Set player animation to dying
        // create a particle emitter to spray blood for a few seconds when killed.
        // set the gameState to GameOver in the same palce that playerState gets set to Dead.


    }
}