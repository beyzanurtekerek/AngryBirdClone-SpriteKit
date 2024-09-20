//
//  GameScene.swift
//  AngryBirdClone
//
//  Created by Beyza Nur Tekerek on 20.09.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // var bird2 = SKSpriteNode()
    
    var bird = SKSpriteNode()
    var box1 = SKSpriteNode()
    var box2 = SKSpriteNode()
    var box3 = SKSpriteNode()
    var box4 = SKSpriteNode()
    var box5 = SKSpriteNode()
    
    var gameStarted = false
    
    var originalPosition: CGPoint?
    
    var score = 0
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 {
        case Bird = 1
        case Box = 2
    }
    
    override func didMove(to view: SKView) {
        // TASARIMIN KOD İLE YAPILISI
        /*
        let texture = SKTexture(imageNamed: "pinkbird")
        bird2 = SKSpriteNode(texture: texture)
        bird2.position = CGPoint(x: -self.frame.width / 4, y: 0)
        bird2.size = CGSize(width: self.frame.width / 16, height: self.frame.height / 10)
        bird2.zPosition = 1
        self.addChild(bird2)
        */
        
        // physics body
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame) // mesela kus dustugu zaman bu frame e carpıp duruyor
        // self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self

        // bird
        bird = childNode(withName: "pinkbird") as! SKSpriteNode
        let birdTexture = SKTexture(imageNamed: "pinkbird")
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().width / 13)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.mass = 0.11
        originalPosition = bird.position
        
        bird.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Box.rawValue
        
        
        // box
        let boxTextures = SKTexture(imageNamed: "brick")
        let size = CGSize(width: boxTextures.size().width / 6.01, height: boxTextures.size().height / 6.01)
        
        // Tüm kutular için aynı ayarları yapıyoruz, boxları tek tek yazmaktansa bir func olusturup kodu kısalttık
        setupBox(box: &box1, size: size, nodeName: "box1")
        setupBox(box: &box2, size: size, nodeName: "box2")
        setupBox(box: &box3, size: size, nodeName: "box3")
        setupBox(box: &box4, size: size, nodeName: "box4")
        setupBox(box: &box5, size: size, nodeName: "box5")
        
        box1.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        box2.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        box3.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        box4.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        box5.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        /*
        box1 = childNode(withName: "box1") as! SKSpriteNode
        box1.physicsBody = SKPhysicsBody(rectangleOf: size)
        box1.physicsBody?.affectedByGravity = true
        box1.physicsBody?.isDynamic = true
        box1.physicsBody?.allowsRotation = true
        box1.physicsBody?.mass = 0.4
        
        box2 = childNode(withName: "box2") as! SKSpriteNode
        box2.physicsBody = SKPhysicsBody(rectangleOf: size)
        box2.physicsBody?.affectedByGravity = true
        box2.physicsBody?.isDynamic = true
        box2.physicsBody?.allowsRotation = true
        box2.physicsBody?.mass = 0.4
        
        box3 = childNode(withName: "box3") as! SKSpriteNode
        box3.physicsBody = SKPhysicsBody(rectangleOf: size)
        box3.physicsBody?.affectedByGravity = true
        box3.physicsBody?.isDynamic = true
        box3.physicsBody?.allowsRotation = true
        box3.physicsBody?.mass = 0.4
        
        box4 = childNode(withName: "box4") as! SKSpriteNode
        box4.physicsBody = SKPhysicsBody(rectangleOf: size)
        box4.physicsBody?.affectedByGravity = true
        box4.physicsBody?.isDynamic = true
        box4.physicsBody?.allowsRotation = true
        box4.physicsBody?.mass = 0.4
        
        box5 = childNode(withName: "box5") as! SKSpriteNode
        box5.physicsBody = SKPhysicsBody(rectangleOf: size)
        box5.physicsBody?.affectedByGravity = true
        box5.physicsBody?.isDynamic = true
        box5.physicsBody?.allowsRotation = true
        box5.physicsBody?.mass = 0.4
        */
        
        
        // Invisible ground - Görünmez zemin ekleme
        let invisibleGround = SKNode()
        invisibleGround.position = CGPoint(x: 0, y: -self.frame.height / 2 + 100) // Y pozisyonunu background'a göre ayarla
        invisibleGround.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 10)) // Zemin genişliği ve yüksekliği
        invisibleGround.physicsBody?.isDynamic = false // Zemin hareket etmeyecek
        addChild(invisibleGround)
        
        
        // label
        scoreLabel.fontName = "HelveticaNeue-Light"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 4)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel) // score labeli buraya ekle demek
        
    }
    
    func setupBox(box: inout SKSpriteNode, size: CGSize, nodeName: String) {
            box = childNode(withName: nodeName) as! SKSpriteNode
            box.physicsBody = SKPhysicsBody(rectangleOf: size)
            box.physicsBody?.affectedByGravity = true
            box.physicsBody?.isDynamic = true
            box.physicsBody?.allowsRotation = true
            box.physicsBody?.mass = 0.4
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue {

            score += 1
            scoreLabel.text = "\(score)"
            
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* ucma ayarları
        // asagıdan yukarı 200 vektor ımpulse uygula demek
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
        bird.physicsBody?.affectedByGravity = true
        */
        
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                bird.position = touchLocation
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false {
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                let touchNodes = nodes(at: touchLocation)
                
                if touchNodes.isEmpty == false {
                    for node in touchNodes {
                        if let sprite = node as? SKSpriteNode {
                            if sprite == bird {
                                
                                let dx = -(touchLocation.x - originalPosition!.x)
                                let dy = -(touchLocation.y - originalPosition!.y)
                                
                                let impulse = CGVector(dx: dx, dy: dy)
                                
                                bird.physicsBody?.applyImpulse(impulse)
                                bird.physicsBody?.affectedByGravity = true
                                
                                gameStarted = true
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if let birdPhysicsBody = bird.physicsBody {
            
            if birdPhysicsBody.velocity.dx <= 0.1 && birdPhysicsBody.velocity.dy <= 0.1 && birdPhysicsBody.angularVelocity <= 0.1 && gameStarted == true{
                
                bird.physicsBody?.affectedByGravity = false
                bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                bird.physicsBody?.angularVelocity = 0
                bird.zPosition = 1
                bird.position = originalPosition!
                gameStarted = false
                
                
            }
            
        }
        
    }
}
