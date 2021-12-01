//
//  SpawnActive.swift
//  JoystickTest
//
//  Created by Nestor Jr. Sirilan on 2016-07-06.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpawnActive: GKState {
    unowned let node: SpawnerNode
    
    init(node: SpawnerNode) {
        self.node = node
        super.init()
        
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        node.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(node.spawn),
            SKAction.waitForDuration(1)
            ])))
        print("spawn activated")
    }
    
    override func willExitWithNextState(nextState: GKState) {
        node.removeAllActions()
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        for animal in node.animals {
            animal.update(seconds)
            if abs(node.parentScene!.player.position.x - animal.position.x) > node.despawnDistance {
                animal.despawns()
                print("bye chicken?")
            }
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is SpawnInactive.Type
    }
    
    /*
     if 
     tunnel.position.x < animal.position.x &&
     animal.position.x + animal.frame.width < tunnel.position.x + tunnel.frame.width
 
 */
}
