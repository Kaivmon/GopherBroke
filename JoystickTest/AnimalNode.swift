//
//  AnimalNode.swift
//  JoystickTest
//
//  Created by Nestor Jr. Sirilan on 2016-07-04.
//  Copyright © 2016 Kaivs. All rights reserved.
//

import SpriteKit
import GameplayKit

enum AnimalType: String {
    case Chicken = "Chicken"
}

protocol AnimalNodeEvent {
    func didMoveToScene(spawner: SpawnerNode, animalType: AnimalType)
}

class AnimalNode : SKSpriteNode, AnimalNodeEvent {
    
    struct underLine {
        var x: CGFloat
        var width: CGFloat
    }
    
    lazy var _state: GKStateMachine = GKStateMachine(states: [
        AnimalIdle(node: self),
        AnimalDead(node: self),
        AnimalFalling(node: self),
        AnimalStuck(node:self)
        ])
    
    // ANIMAL PROPERTIES
    var _speed: CGFloat = 0.0
    var _speedDirection: CGFloat = CGFloat.randomSign()
    var spawner: SpawnerNode?
    var isFalling: Bool = false
    var type: AnimalType?
    
    func didMoveToScene(spawner: SpawnerNode, animalType: AnimalType) {
        self.spawner = spawner
        
        // MARK - Animal Properties
        setPhysicsBody()
        _state.enterState(AnimalIdle)
        type = animalType
        
        switch (animalType) {
        case .Chicken:
            _speed = 100.0
            break
        }
    }
    
    func update(sec: NSTimeInterval) {
        _state.updateWithDeltaTime(sec)
    }
    
    func setPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: parent!.frame.width, height: parent!.frame.height))
        physicsBody!.affectedByGravity = false
        physicsBody!.dynamic = true
        physicsBody!.categoryBitMask = 0
        physicsBody!.collisionBitMask = 0
        physicsBody!.contactTestBitMask = 0
    }
    
    func move() {
        physicsBody?.velocity.dx = _speed * _speedDirection        
    }
    
    func scared() {
        if spawner!.parentScene!.player.position.x < position.x {
            _speedDirection = 1.0
        }
        else {
            _speedDirection = -1.0
        }
    }
    
    func changeDirection() {
        _speedDirection = _speedDirection * -1
        xScale = -_speedDirection
    }
    
    func changeDirection(float: CGFloat = 0) {
        _speedDirection = float
        xScale = -_speedDirection
    }
    
    // HERE'S WHERE THE SHIT GOES DOWWWWWNNNNNN LOLOLOLLLLL0l0l0l0l0lol0l GET IT! HAHAHAHA
    func checkIfFalling() -> Bool{
        
        var contactedNodes: Int = 0
        //Check if it is falling into a tunnel or not
        for tunnel in parentScene().compoundTunnels.children {
            for nodes in self.children {
                if tunnel.frame.contains(convertPoint(nodes.position, toNode: parentScene()) ) == true {
                    contactedNodes += 1
                }
                if contactedNodes == children.count {
                    return true
                }
            }
            contactedNodes = 0
        }
        return false
    }
    
    // GETTER FUNCTION
    
    func parentScene() -> GameScene {
        return spawner!.parentScene!
    }
    
    func despawns() {
        removeFromParent()
        spawner?.removeAnimal(self)
    }
}
