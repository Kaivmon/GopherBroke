//
//  Idle.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-30.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class Idle: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
        
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {

    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.player.yScale = 0.5
        scene.runAnim(scene.animIdle)
    }
}
