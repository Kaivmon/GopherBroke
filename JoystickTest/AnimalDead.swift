//
//  AnimalDead.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-07-08.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimalDead: GKState {
    unowned let node: AnimalNode
    
    init(node: AnimalNode) {
        self.node = node
        super.init()
        
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.removeAllActions()
        node.parentScene().emitParticles("bloodSpray", sprite: node)
        if node.type == AnimalType.Chicken {
            node.runAction(SKAction.setTexture(node.parentScene().ChickenDead!))
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}
