//
//  SpawnInactive.swift
//  JoystickTest
//
//  Created by Nestor Jr. Sirilan on 2016-07-06.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpawnInactive: GKState {
    unowned let node: SpawnerNode
    
    init(node: SpawnerNode) {
        self.node = node
        super.init()
        
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        for animal in node.animals {
            animal.despawns()
        }
        print("spawn deactivated")
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is SpawnActive.Type
    }
}
