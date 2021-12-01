//
//  SpawnerNode.swift
//  JoystickTest
//
//  Created by Nestor Jr. Sirilan on 2016-07-06.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpawnerNode: SKSpriteNode, SpawnerEvent {
    
    var despawnDistance: CGFloat = 0.0
    var parentScene: GameScene?
    var animals: [AnimalNode] = []
    var animalLimit: Int = 1
    var _position: CGPoint?
    
    lazy var _state: GKStateMachine = GKStateMachine(states: [
        SpawnActive(node: self),
        SpawnInactive(node: self)
        ])
    
    func didMoveToScene(scene: SKScene) {
        parentScene = scene as! GameScene
        despawnDistance = 3 * parentScene!.size.width
        _state.enterState(SpawnActive)
        _position = parent!.parent!.position
    }
    
    func spawn(animalType: AnimalType) {
        if animals.count < animalLimit {
//        let sprite = SKScene(fileNamed: animalType.rawValue)!.childNodeWithName("animal") as! SKSpriteNode
//        let node = sprite.copy() as! SKNode
//        addChild(node)
//        let animal = node as! AnimalNode
//        animals.append(animal)
//        animal.didMoveToScene(parentScene!, animalType: animalType)
        
            let animal = SKScene(fileNamed: animalType.rawValue)!.childNodeWithName("animal") as! AnimalNode
            animal.removeFromParent()
            parentScene!.addChild(animal)
            animal.didMoveToScene(self, animalType: animalType)
            animal.position = _position!
            animal.zPosition = 10
            animals.append(animal)
            print("caleb has been spawned - as a chicken")
        }
    }
    
    func spawn() {
        spawn(randomAnimal())
    }
    
    func removeAnimal(animalNode: AnimalNode) {
        animals.removeAtIndex(animals.indexOf(animalNode)!)
    }
    
    func clearAnimals() {
        parentScene!.removeChildrenInArray(animals)
        animals.removeAll()
    }
    
    func update(sec: NSTimeInterval) {
        _state.updateWithDeltaTime(sec)
        if abs(parentScene!.player.position.x - _position!.x) > despawnDistance {
            _state.enterState(SpawnInactive)
        } else {
            _state.enterState(SpawnActive)
        }
    }
    
    func randomAnimal() -> AnimalType {
        var type: AnimalType
        switch(Int.random(1)) {
        case 0:
            type = AnimalType.Chicken
            break;
        default:
            type = AnimalType.Chicken
            break;
        }
        return type
    }
}