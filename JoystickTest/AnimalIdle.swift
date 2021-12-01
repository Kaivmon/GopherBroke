//
//  AnimalIdle.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-07-08.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimalIdle: GKState {
    unowned let node: AnimalNode
    
    init(node: AnimalNode) {
        self.node = node
        super.init()
        
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        // Change Directions Forever
        node.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(node.changeDirection),
            SKAction.waitForDuration(2)
            ])))
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if node.checkIfFalling() {
            node._state.enterState(AnimalFalling)
        }
        node.move()
    }
    
    override func willExitWithNextState(nextState: GKState) {
        if nextState is AnimalFalling {
        }
    }
}
