//
//  Playing.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-29.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is MainMenu {
            scene.player.physicsBody!.dynamic = true
            scene.showHUD()
            scene.playBackgroundMusic("GopherBrokeTheme.mp3")

        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.updateCamera()
        scene.updatePlayer()
        scene.updateLevel()
        scene.boundsCheck()
        scene.updateHUD()

    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }
    
}