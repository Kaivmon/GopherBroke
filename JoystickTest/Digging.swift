//
//  Digging.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-30.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class Digging: GKState {
    unowned let scene: GameScene
    var count: Int32 = 0
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is Moving {
            count = (rand() % 2)
            if count == 0 {
                scene.runAction(scene.soundDig[1])
            } else {
                scene.runAction(scene.soundDig[0])
            }
            scene.energy -= 1
            scene.emitParticles("dig", sprite: scene.player)
        }

    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {

    }
    
}