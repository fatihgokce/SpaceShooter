//
//  EndScene.swift
//  SpaceShooter
//
//  Created by fatih on 14/05/16.
//  Copyright © 2016 fatih. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : SKScene
{

    var restartBtn: UIButton!

    
 
    override func didMoveToView(view: SKView) {
        
        scene?.backgroundColor = UIColor.whiteColor()
        
        restartBtn = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 30))
        
        //restartBtn.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height / 7)
        restartBtn.setTitle("Restart", forState: .Normal)
        restartBtn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        restartBtn.addTarget(self, action: #selector(EndScene.restart), forControlEvents: .TouchUpInside)
        
        self.view?.addSubview(restartBtn)
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        
        var score = scoreDefault.valueForKey("Score") as! NSInteger
        
        print(score)
        
    }
    func restart(){
    
        self.view?.presentScene(GameScene(),transition: SKTransition.crossFadeWithDuration(0.3))
        restartBtn.removeFromSuperview()
    }
}