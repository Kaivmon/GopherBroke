//
//  AnimalFalling.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-07-08.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimalFalling: GKState {
    unowned let node: AnimalNode
    var fallDistance = 0
    
    init(node: AnimalNode) {
        self.node = node
        super.init()
        
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is AnimalIdle {
            node.removeAllActions()
            if node.type == AnimalType.Chicken {
                    node.runAction(SKAction.setTexture(node.parentScene().ChickenFall!))
            }
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        node.physicsBody?.velocity.dx = 0
        if node.checkIfFalling() {
            node.position.y -= 10
            fallDistance += 10
        } else {
            if fallDistance > 200 {
               node._state.enterState(AnimalDead)
            } else {
                node._state.enterState(AnimalStuck)
            }
        }
    }
    
    override func willExitWithNextState(nextState: GKState) {

    }
}
