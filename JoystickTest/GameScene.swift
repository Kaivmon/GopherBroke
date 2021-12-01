//
//  GameScene.swift
//  JoystickTest
//
//  Created by Alex Kaivs on 2016-06-21.
//  Copyright (c) 2016 Kaivs. All rights reserved.
//

// TO DO!!!!!!
//Sound effects
//  Animals deaths
//      Chicken
//      Cow
//      Other animals???
//Add particles
//  digging
//  die - blood spray
//  eating - blood spray
//Fix animals
//  *Animals have to stay near the spawn, unless scared
//  when stop being scared, return towards spawn
//  Make sure despawn distance is same as tunnel despawn
//Add farmer
//  From ben's code
//Add app icon
//*Add score counter to HUD
//  increase score with animals eaten
//Animal animations
//  Dead
//  Flip upside down for falling


import SpriteKit
import GameplayKit

protocol SpawnerEvent {
    func didMoveToScene(scene: SKScene)
}

class GameScene: SKScene {
    
    let stickSensitivity: CGFloat = 4.0
    let base = SKSpriteNode(imageNamed:"base")
    let ball = SKSpriteNode(imageNamed:"ball")
    let playerSpawnPos: CGPoint = CGPointMake(775.367, 316.679)
    var player: SKNode!
    var energy: CGFloat = 50
    var score: Int = 0
    var lastUpdateTimeInterval: NSTimeInterval = 0
    var deltaTime: NSTimeInterval = 0
    var spawner: [SpawnerNode] = []
    var curAnim: SKAction? = nil
    var animMoveV: SKAction! = nil
    var animMoveH: SKAction! = nil
    var animDigV: SKAction! = nil
    var animDigH: SKAction! = nil
    var animDie: SKAction! = nil
    var animIdle: SKAction! = nil
    var playableRect: CGRect?
    var scoreLabel: SKLabelNode?
    var energyLabel: SKLabelNode?
    var energyBar: SKShapeNode?
    var energyAmount: SKSpriteNode?
    var tunnelNode: SKSpriteNode!
    let cameraNode = SKCameraNode()
    var compoundTunnels: SKNode!
    
    //Sounds
    var backgroundMusic: SKAudioNode!
    let soundDig = [
        SKAction.playSoundFileNamed("dig1.mp3", waitForCompletion: false),
        SKAction.playSoundFileNamed("dig2.wav", waitForCompletion: false)]
    //let soundWalk = [
    //   SKAction.playSoundFileNamed("footstep1.wav", waitForCompletion: false),
    //    SKAction.playSoundFileNamed("footstep2.wav", waitForCompletion: false)]
    let soundDie = SKAction.playSoundFileNamed("die.mp3", waitForCompletion: false)
    
    
    //Animal textures
    var ChickenDead: SKTexture?
    var ChickenFall: SKTexture?
    var Chicken: SKTexture?
    var ChickenStuck: SKTexture?
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        Title(scene: self),
        MainMenu(scene: self),
        Playing(scene: self),
        GameOver(scene: self)])
    
    lazy var playerState: GKStateMachine = GKStateMachine(states: [
        Idle(scene: self),
        Moving(scene: self),
        Digging(scene: self),
        Dead(scene: self)])
    
    override func didMoveToView(view: SKView) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        self.backgroundColor = SKColor.whiteColor()
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        cameraNode.setScale(1.6)
        addChild(cameraNode)
        camera = cameraNode
        
        setupJoystick()
        setupHUD()
        setupAnimalTextures()
        
        animMoveV = setupAnimWithPrefix("player_move_v_", start: 1, end: 3, timePerFrame: 0.2)
        animMoveH = setupAnimWithPrefix("player_move_h_", start: 1, end: 3, timePerFrame: 0.2)
        animDigV = setupAnimWithPrefix("player_dig_v_", start: 1, end: 3, timePerFrame: 0.2)
        animDigH = setupAnimWithPrefix("player_dig_h_", start: 1, end: 3, timePerFrame: 0.2)
        animDie = setupAnimWithPrefix("player_die_", start: 1, end: 1, timePerFrame: 0.1)
        animIdle = setupAnimWithPrefix("player_idle_", start: 1, end: 4, timePerFrame: 0.3)

        //Spawn everything
        
        //Constructor for the Objects Set up
        // Spawner Constructor
        enumerateChildNodesWithName("//spawn", usingBlock: {node, _ in
            let spawner = node as! SpawnerNode
            self.spawner.append(spawner)
            spawner.didMoveToScene(self)
        })
        
        //Tunnels
        compoundTunnels = SKNode()
        addChild(compoundTunnels)
        tunnelNode = childNodeWithName("tunnel") as! SKSpriteNode
        tunnelNode.removeFromParent()
        compoundTunnels.addChild(tunnelNode)
        
        player = childNodeWithName("gopher")
        player.position = playerSpawnPos
        
        
        setCameraPosition(player.position)
        gameState.enterState(MainMenu)
        
        
    }
    
    // =========================================================
    //  MARK: - Events
    // =========================================================
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if gameState.currentState is Playing{
            for touch in touches {
                let location = touch.locationInNode(camera!)
                base.removeAllActions()
                ball.removeAllActions()
                base.position = location
                ball.position = base.position
                base.alpha = 0.7
                ball.alpha = 0.7
                
            }
        } else if gameState.currentState is GameOver {
            resetLevel()
            gameState.enterState(MainMenu)
        } else if gameState.currentState is MainMenu {
            gameState.enterState(Playing)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(camera!)
            
                let v = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                let angle = atan2(v.dy, v.dx)
                
                let length: CGFloat = base.frame.height / 2
                
                let xDist: CGFloat = sin(angle - 1.5) * length
                let yDist: CGFloat = cos(angle - 1.5) * length
            
                if (CGRectContainsPoint(base.frame, location))
                {
                    
                    ball.position = location
                    
                } else {
                    
                    ball.position = CGPointMake(base.position.x - xDist, base.position.y + yDist)
                }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            let move: SKAction = SKAction.moveTo(base.position, duration: 0.2)
            move.timingMode = .EaseOut
            let fade: SKAction = SKAction.fadeOutWithDuration(0.5)
            ball.runAction(move)
            ball.runAction(fade)
            base.runAction(fade)
    }
    
    func boundsCheck() {
        let bounds = childNodeWithName("bounds")
        let bottomLeft = CGPoint(x: CGRectGetMinX(bounds!.frame), y: CGRectGetMinY(bounds!.frame))
        let topRight = CGPoint(x: CGRectGetMaxX(bounds!.frame), y: CGRectGetMaxY(bounds!.frame))
        
        if player.position.x <= bottomLeft.x {
            player.position.x = bottomLeft.x
        }
        if player.position.x >= topRight.x {
            player.position.x = topRight.x
        }
        if player.position.y <= bottomLeft.y {
            player.position.y = bottomLeft.y
        }
        if player.position.y >= topRight.y {
            player.position.y = topRight.y
        }
    }
    
    // Tunneling
    // --------------------------------
    
    func checkIfTunneling() {
        var counter = 0
        
        // Once contact bitmasks are implemented..
        // Later the check for if is tunneling just checks if the contact bitmask is equal to the compound node.
        for tunnel in compoundTunnels.children {
            if CGRectContainsPoint(self.player.frame, tunnel.position) {
                counter += 1
            }
        }
        
        if (counter == 0 && player.position.y < 620) {
            spawnTunnel(self.player.position)
            playerState.enterState(Digging)
            
        } else {
            playerState.enterState(Moving)
            counter = 0
        }
    }
    
    func spawnTunnel(tPosition: CGPoint) -> SKSpriteNode {
        let newTunnel = SKSpriteNode(imageNamed: "ball")
        newTunnel.color = SKColor.blackColor()
        newTunnel.colorBlendFactor = 1
        newTunnel.position = tPosition
        newTunnel.setScale(0.25)
        newTunnel.name = "tunnel"
        compoundTunnels.addChild(newTunnel)
        
        // Add the node to a compound node here to reduce the amount of rendering

        return newTunnel
    }
    
    // =========================================================
    //  MARK: - Setup
    // =========================================================
    
    func setupJoystick() {
        
        // Create joystick
        camera!.addChild(base)
        base.setScale(0.25)
        base.zPosition = 90
        base.alpha = 0.0
        
        camera!.addChild(ball)
        ball.setScale(0.25)
        ball.zPosition = 100
        ball.alpha = 0.0
        
    }
    
    func setupHUD() {
        
        //create the score counter
        scoreLabel = SKLabelNode(fontNamed: "GillSans-UltraBold")
        scoreLabel!.text = "SCORE: \(score)"
        scoreLabel!.fontColor = SKColor.whiteColor()
        scoreLabel!.fontSize = 20
        scoreLabel!.position = CGPointMake(-250, 125)
        scoreLabel!.zPosition = 52
        
        // create the Energy Bar
        energyLabel = SKLabelNode(fontNamed: "GillSans-UltraBold")
        energyLabel!.text = "ENERGY"
        energyLabel!.fontColor = SKColor.whiteColor()
        energyLabel!.fontSize = 20
        energyLabel!.position = CGPointMake(250, 100)
        energyLabel!.zPosition = 52
        
        energyBar = SKShapeNode(rect: CGRectMake( 100, 100, 200, 50), cornerRadius: 2.0 )
        energyAmount = SKSpriteNode(color: SKColor.greenColor(), size: CGSize(width: 200, height: 50))
        energyBar!.fillColor = SKColor.blackColor()
        energyAmount!.position = CGPointMake(100, 125)
        energyAmount!.anchorPoint = CGPointMake(0.0, 0.5)
        energyBar?.zPosition = 50
        energyAmount?.zPosition = 51
        
        cameraNode.addChild(scoreLabel!)
        cameraNode.addChild(energyLabel!)
        cameraNode.addChild(energyBar!)
        cameraNode.addChild(energyAmount!)
    }
    
    func setupAnimalTextures() {
        ChickenDead = SKTexture(imageNamed: "ChickenDead")
        ChickenFall = SKTexture(imageNamed: "ChickenFall")
        Chicken = SKTexture(imageNamed: "Chicken")
        ChickenStuck = SKTexture(imageNamed: "ChickenStuck")
    }
    
    //  Animation
    // ------------------------------------
    
    func setupAnimWithPrefix(prefix: String, start: Int, end: Int, timePerFrame: NSTimeInterval) -> SKAction {
        var textures = [SKTexture]()
        for i in start...end {
            textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
        }
        return SKAction.animateWithTextures(textures, timePerFrame: timePerFrame)
    }
    
    func runAnim(anim: SKAction) {
        if curAnim == nil || curAnim! != anim {
            player.removeActionForKey("anim")
            player.runAction(SKAction.repeatActionForever(anim), withKey: "anim")
            curAnim = anim
        }
    }
    
    // Music
    // ----------------------------------
    
    func playBackgroundMusic(name: String) {
        var delay = 0.0
        if backgroundMusic != nil {
            backgroundMusic.removeFromParent()
        } else {
            delay = 0.1
        }
        runAction(SKAction.waitForDuration(delay)) {
            self.backgroundMusic = SKAudioNode(fileNamed: name) as? SKAudioNode
            self.backgroundMusic.autoplayLooped = true
            self.addChild(self.backgroundMusic)
        }
    }
    
    // =========================================================
    //  MARK: - Update
    // =========================================================
   
    override func update(currentTime: CFTimeInterval) {
        if lastUpdateTimeInterval > 0 {
            deltaTime = currentTime - lastUpdateTimeInterval
        } else {
            deltaTime = 0
        }
        lastUpdateTimeInterval = currentTime
        gameState.updateWithDeltaTime(deltaTime)
        playerState.updateWithDeltaTime(deltaTime)
        
        if !spawner.isEmpty {
            for spawner in self.spawner {
                spawner.update(deltaTime)
            }
        }
    }
    
    func updateLevel() {
        //remove old tunnels...
        for tunnel in compoundTunnels.children {
            if (abs(player.position.x - tunnel.position.x) > (3*size.width)) {
                tunnel.removeFromParent()
            }
        }
        
        // Also spawn enemies here?
    }
 
    func updatePlayer() {
        
        let point = CGPoint(x: (ball.position.x - base.position.x), y: (ball.position.y - base.position.y))
        let movement = CGVector(dx: point.x*stickSensitivity, dy: point.y*stickSensitivity)
        
        player.physicsBody!.velocity = movement
        
        if player.physicsBody!.velocity == CGVectorMake(0.0, 0.0) {
            playerState.enterState(Idle)
        } else {
            checkIfTunneling()
        }
        
        //Check if player is dead
        if energy <= 0 {
            backgroundMusic.removeFromParent()
            playerState.enterState(Dead)
            gameState.enterState(GameOver)
        }
    }
    
    func updateHUD() {
        energyAmount!.size = CGSize(width: energy * 4.0, height: energyAmount!.size.height)
        scoreLabel!.text = "SCORE: \(score)"
        
        if (energy < 12) {
            energyAmount!.color = SKColor.redColor()
        } else if (energy < 25) {
            energyAmount!.color = SKColor.yellowColor()
        } else {
            energyAmount!.color = SKColor.greenColor()
        }
    }

    
    // =========================================================
    //  MARK: - Camera
    // =========================================================
    

    
    func updateCamera() {
        var cameraTarget = player.position
        let minCameraY: CGFloat = size.height - 75
        let minCameraX: CGFloat = -2048 + size.width - 130
        let maxCameraX: CGFloat = 4098 - size.width + 130
        
        if cameraTarget.y < minCameraY { cameraTarget.y = minCameraY }
        if cameraTarget.x < minCameraX { cameraTarget.x = minCameraX }
        if cameraTarget.x > maxCameraX { cameraTarget.x = maxCameraX }
        
        let targetPosition = CGPoint(x: cameraTarget.x, y: cameraTarget.y)
        
        let diff = targetPosition - getCameraPosition()
        let lerpValue = CGFloat(0.4)
        let lerpDiff = diff * lerpValue
        let newPosition = getCameraPosition() + lerpDiff
        
        setCameraPosition(CGPoint(x: newPosition.x, y: newPosition.y))
    }
    
    func overlapAmount() -> CGFloat {
        guard let view = self.view else {
            return 0
        }
        
        let scale = view.bounds.size.height / self.size.height
        let scaledWidth = self.size.width * scale
        let scaledOverlap = scaledWidth - view.bounds.size.width
        return scaledOverlap / scale
    }
    
    func getCameraPosition() -> CGPoint {
        return CGPoint(
            x: cameraNode.position.x + overlapAmount()/2,
            y: cameraNode.position.y)
    }
    
    func setCameraPosition(position: CGPoint) {
        cameraNode.position = CGPoint(
            x: position.x - overlapAmount()/2,
            y: position.y)
    }
    
    
    // ======================================
    // MARK: - Helpers
    // ======================================
    
    func resetLevel() {
        for tunnel in compoundTunnels.children {
            tunnel.removeFromParent()
        }
        for spawn in spawner {
            spawn._state.enterState(SpawnInactive)
        }

        player.position = playerSpawnPos
        spawnTunnel(player.position)
        setCameraPosition(playerSpawnPos)
        energy = 50
        updateHUD()
        playerState.enterState(Idle)

        
        //Also reset enemies here
    }
    
    func hideHUD() {
        scoreLabel!.hidden = true
        energyLabel!.hidden = true
        energyBar!.hidden = true
        energyAmount!.hidden = true
    }
    
    func showHUD() {
        scoreLabel!.hidden = false
        energyLabel!.hidden = false
        energyBar!.hidden = false
        energyAmount!.hidden = false
    }
    
    func updateCompoundNode(inScene scene: SKScene, compoundTunnels: SKNode){
        
        let bodies = compoundTunnels.children.map({node in
            SKPhysicsBody(rectangleOfSize: node.frame.size, center: node.position)
        })
        
        compoundTunnels.physicsBody = SKPhysicsBody(bodies: bodies)
        compoundTunnels.zPosition = 1

    }
    
    // =========================================
    // MARK: - Particles
     // =========================================
    
    func emitParticles(name: String, sprite: SKNode) {
        let pos = convertPoint(sprite.position, toNode: scene!)
        let particles = SKEmitterNode(fileNamed: name)!
        particles.position = pos
        particles.zPosition = 3
        addChild(particles)
        particles.runAction(SKAction.removeFromParentAfterDelay(1.0))
       // sprite.runAction(SKAction.sequence([SKAction.scaleTo(0.0, duration: 0.5), SKAction.removeFromParent()]))
        
    }
}

// Used to delete an element in an array based on the value rather than index
extension Array where Element: Equatable {
    
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}
