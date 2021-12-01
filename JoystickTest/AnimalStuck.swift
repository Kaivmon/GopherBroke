//
//  AnimalStuck.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-07-08.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimalStuck: GKState {
    unowned let node: AnimalNode
    
    init(node: AnimalNode) {
        self.node = node
        super.init()
        
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is AnimalFalling {
            node.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({self.node.xScale = self.node.xScale * -1}), SKAction.waitForDuration(3.0)])))
            
            if node.type == AnimalType.Chicken {
                node.runAction(SKAction.setTexture(node.parentScene().ChickenStuck!))
            }
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
}
