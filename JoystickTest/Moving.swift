//
//  Running.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-30.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class Moving: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {

        
        if (scene.player.physicsBody!.velocity.angle  > (3*π/4)  || scene.player.physicsBody!.velocity.angle  < (-3*π/4))  {
            self.scene.player.xScale = -0.5
            self.scene.player.yScale = 0.5
            scene.runAnim(scene.animMoveH)
        } else if (scene.player.physicsBody!.velocity.angle  < (π/4)  && scene.player.physicsBody!.velocity.angle  > (-π/4)){
            self.scene.player.xScale = 0.5
            self.scene.player.yScale = 0.5
            scene.runAnim(scene.animMoveH)
        } else if (scene.player.physicsBody!.velocity.angle  > (π/4)  && scene.player.physicsBody!.velocity.angle  < (3*π/4)) {
            self.scene.player.yScale = 0.5
            scene.runAnim(scene.animMoveV)
        } else if (scene.player.physicsBody!.velocity.angle  > (-3*π/4)  && scene.player.physicsBody!.velocity.angle  < (-π/4)) {
            self.scene.player.yScale = -0.5
            scene.runAnim(scene.animMoveV)
        }
        // We would only need 3 animations, one for up, flip for down, one for left, flip for right, and one for diagonal, rotate by 90 degrees for all diagonal movements.
        
        //Set the animation to the correct animation depending on the angle of movement.
        
    }
    
}