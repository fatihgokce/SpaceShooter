//
//  GameScene.swift
//  SpaceShooter
//
//  Created by fatih on 14/05/16.
//  Copyright (c) 2016 fatih. All rights reserved.
//

import SpriteKit

struct PhyCategory
{
    static let Enemy : UInt32 = 1
    static let Bullet : UInt32 = 2
    static let Player : UInt32 = 3
    static let Wall : UInt32 = 4
}

class EnemyNode : SKSpriteNode
{
    
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(imageNamed: "player")
    var score = Int()
    
    var scoreLbl = UILabel()
    var gameOver = false
    var timerS:NSTimer!
    var timerE: NSTimer!

    
  
    override func didMoveToView(view: SKView) {
        
        self.scene?.backgroundColor = UIColor.darkGrayColor()
        
        self.scene?.size = CGSize(width: 640, height: 1136)
        
        physicsWorld.contactDelegate = self
        player.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/5)
        
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        
        player.physicsBody?.affectedByGravity = false
        
        player.physicsBody?.categoryBitMask = PhyCategory.Player
        player.physicsBody?.contactTestBitMask = PhyCategory.Enemy
        player.physicsBody?.dynamic = false
        
        
        reloadGame()
        
        let wall = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: self.frame.width, height: 10))
        //wall.size.width = self.frame.width
        wall.position = CGPointMake(self.frame.width/2, 5)
        wall.physicsBody = SKPhysicsBody(rectangleOfSize: wall.size)
        
        wall.physicsBody?.affectedByGravity = false
        
        wall.physicsBody?.categoryBitMask = PhyCategory.Wall
        wall.physicsBody?.contactTestBitMask = PhyCategory.Enemy
        wall.physicsBody?.collisionBitMask = PhyCategory.Enemy

        wall.physicsBody?.dynamic = false

        
        self.addChild(wall)
        self.addChild(player)
        
        scoreLbl.text = "\(score)"
        scoreLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        
        scoreLbl.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        scoreLbl.textColor = UIColor.whiteColor()
        
        self.view?.addSubview(scoreLbl)
        
    }
    func reloadGame()  {
        timerS =  NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("spawnBullet"), userInfo: nil, repeats: true)
        
        
        timerS = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("spawnEnemies"), userInfo: nil, repeats: true)
        
        gameOver = false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            player.position.x = location.x
            //player.position.y = location.y
            
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            player.position.x = location.x
            //player.position.y = location.y
            
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func spawnBullet(){
        
       
        //bullet.runAction(SKAction.repeatActionForever(action))
        
       createBullet(player.position.x + 20, duration: 1)
        createBullet(player.position.x + 5, duration: 1)
        createBullet(player.position.x  - 5, duration: 1)
        createBullet(player.position.x - 20, duration: 1)



    }
    func createBullet(x:CGFloat,duration: NSTimeInterval){
        var bullet = SKSpriteNode(imageNamed: "bullet")
        
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody?.categoryBitMask = PhyCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhyCategory.Enemy
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.dynamic = false
        
        bullet.zPosition = -50
        
        bullet.position = CGPointMake(x, player.position.y)
        
        let action = SKAction.moveToY(self.size.height+15, duration: duration)
        let actionDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action,actionDone]))
        self.addChild(bullet)
    }
    func spawnEnemies(){
        
        
        let enemy = EnemyNode(imageNamed: "enemy")
        let minValue = self.size.width / 8
        
        let maxValue = self.size.width - 20
      
        if maxValue > 0
        {
            let spawnPoint = UInt32(maxValue - minValue)
            
            
            enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
            enemy.physicsBody?.categoryBitMask = PhyCategory.Enemy
            enemy.physicsBody?.contactTestBitMask = PhyCategory.Bullet
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.dynamic = true
            
            enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.frame.height)
            
            let action = SKAction.moveToY(-20, duration: 3.0)
            let actionDone = SKAction.removeFromParent()
            enemy.runAction(SKAction.sequence([action,actionDone]))
            //enemy.runAction(SKAction.repeatActionForever(action))
            
            
            self.addChild(enemy)
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
      
            var firstBody : SKPhysicsBody = contact.bodyA
            var secondBody : SKPhysicsBody = contact.bodyB
            //print(firstBody.node)
            //print(secondBody.node)
            if( (firstBody.categoryBitMask == PhyCategory.Enemy)  && (secondBody.categoryBitMask == PhyCategory.Bullet) ||
                (firstBody.categoryBitMask == PhyCategory.Bullet)  && (secondBody.categoryBitMask == PhyCategory.Enemy))
            {
                if firstBody.node != nil && secondBody.node != nil
                {
                collisionWithBullet(firstBody.node as! SKSpriteNode, bullet: secondBody.node as! SKSpriteNode)
                }
                
            }
            else if( (firstBody.categoryBitMask == PhyCategory.Enemy)  && (secondBody.categoryBitMask == PhyCategory.Player) ||
                (firstBody.categoryBitMask == PhyCategory.Player)  && (secondBody.categoryBitMask == PhyCategory.Enemy))
            {
                if firstBody.node != nil && secondBody.node != nil
                {
                    collisionWithPerson(firstBody.node as! SKSpriteNode, player: secondBody.node as! SKSpriteNode)
                }

                
            }
            else if( (firstBody.categoryBitMask == PhyCategory.Enemy)  && (secondBody.categoryBitMask == PhyCategory.Wall) ||
                (firstBody.categoryBitMask == PhyCategory.Wall)  && (secondBody.categoryBitMask == PhyCategory.Enemy))
            {
             
                if firstBody.node != nil && secondBody.node != nil
                {
                    score -= 50
                }
                
                
        }
            
        
    }
    func collisionWithPerson(enemy : SKSpriteNode,player : SKSpriteNode){
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        
        scoreDefault.setValue(score, forKey: "Score")
        scoreDefault.synchronize()
        
        enemy.removeFromParent()
        player.removeFromParent()
        self.view?.presentScene(EndScene())
        scoreLbl.removeFromSuperview()
        
     
        //timerS.invalidate()
        //timerE.invalidate()
    }
    func collisionWithBullet(enemy : SKSpriteNode,bullet : SKSpriteNode){
       
        if bullet is EnemyNode
        {
            bullet.texture = SKTexture(imageNamed: "bang2")
            bullet.physicsBody?.categoryBitMask = 6
            bullet.physicsBody?.dynamic = false
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("removeEnemy:"), userInfo: bullet, repeats: false)
        }
        else if enemy is EnemyNode
        {
            enemy.texture = SKTexture(imageNamed: "bang2")
            enemy.physicsBody?.categoryBitMask = 6
            enemy.physicsBody?.dynamic = false
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("removeEnemy:"), userInfo: enemy, repeats: false)

        }
        else
        {
            if !(bullet is EnemyNode)
            {
            
                bullet.removeFromParent()
            }
            if !(enemy is EnemyNode)
            {
                
                enemy.removeFromParent()
            }
        }
        //enemy.removeFromParent()
        score += 1
        scoreLbl.text = "\(score)"
    }
    func removeEnemy(timer:NSTimer){
        let enemy = timer.userInfo as! SKSpriteNode
        enemy.removeFromParent()
        //enemy.removeFromParent()
    }
    
}
