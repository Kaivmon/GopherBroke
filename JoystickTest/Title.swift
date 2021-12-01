//
//  Title.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-07-06.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class Title: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is MainMenu.Type
    }
}
