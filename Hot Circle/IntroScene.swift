//
//  IntroScene.swift
//  Hot Circle
//
//  Created by minhajul russel on 10/4/15.
//  Copyright © 2015 minhajul russel. All rights reserved.
//

import Foundation
import SpriteKit

class IntroScene: SKScene {

    
    override func didMove(to view: SKView) {
    
        backgroundColor = SKColor(red: 72.0/255.0, green: 172.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        
        let playButton = SKSpriteNode(imageNamed: "play")
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.60)
        playButton.xScale = 0.2
        playButton.yScale = 0.2
        playButton.name = "play"
        self.addChild(playButton)
        
        playButton.alpha = 0
        let wait = SKAction.wait(forDuration: 0.8)
        let appear = SKAction.fadeAlpha(to: 1, duration: 0.2)
        let popUp = SKAction.scale(to: 0.2, duration: 0.1)
        let dropDown = SKAction.scale(to: 0.25, duration: 0.1)
        let pauseAndappear = SKAction.sequence([wait, appear, popUp, dropDown])
        let repeatForever = SKAction.repeatForever(pauseAndappear)
        playButton.run(repeatForever)
        
        let circle1 = SKSpriteNode(imageNamed: "color-circle1")
        circle1.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*0.60)
        circle1.zPosition = -1.0
        circle1.xScale = 0.3
        circle1.yScale = 0.3
        self.addChild(circle1)
        let rotateCircle = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1.0)
        let repeatRotation = SKAction.repeatForever(rotateCircle).reversed()
        circle1.run(repeatRotation)

        
        let name = SKLabelNode(fontNamed: "Superclarendon-BlackItalic")
        name.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*0.25)
        name.text = "HOT CIRCLE"
        name.fontColor = SKColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0/255.0, alpha: 1.0)

        self.addChild(name)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
          
            let location = touch.location(in: self)
            let sprites = nodes(at: location)
            for sprite in sprites {
                if let spriteNode = sprite as? SKSpriteNode {
                    
                    if spriteNode.name != nil {
                        
                        if spriteNode.name == "play" {
                            
                            let scene = GameScene(size: self.frame.size)
                            let transition = SKTransition.fade(withDuration: 1.0)
                            self.view?.presentScene(scene, transition: transition)

                        }
                    }
                }
                
            }
        }
    }
}
