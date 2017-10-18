//
//  GameViewController.swift
//  Hot Circle
//
//  Created by minhajul russel on 10/17/15.
//  Copyright (c) 2015 minhajul russel. All rights reserved.

import SpriteKit
import GameKit


class GameScene: SKScene, GKGameCenterControllerDelegate {
    
    
    let circle1 = SKSpriteNode(imageNamed: "color-circle1")
    let circle2 = SKSpriteNode(imageNamed: "color-circle1")
    var Circle = SKSpriteNode()
    var Person = SKShapeNode()
    var Dot = SKShapeNode()
    var blueFire = SKEmitterNode()
    var hotFire = SKEmitterNode()
    var greenFire = SKEmitterNode()
    var redFire = SKEmitterNode()
    var FBicon = SKSpriteNode()
    var Twittericon = SKSpriteNode()
    
    var Path = UIBezierPath()
    var gameStarted:Bool = false
    var movingClockWise = Bool()
    
    var intersected:Bool = false
    
    var score:Int = 0
    var scoreLabel = SKLabelNode()
    var highscore:Int = 0
    var highscoreLabel = SKLabelNode()
    let highscoreDefault = UserDefaults.standard
    
    
    var refresh = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor(red: 72.0/255.0, green: 172.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        
        Circle = SKSpriteNode(imageNamed: "Circle")
        Circle.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        Circle.size = CGSize(width: 252, height: 252)
        self.addChild(Circle)
        
        circle1.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        circle1.zPosition = 1.0
        circle1.xScale = 0.25
        circle1.yScale = 0.25
        self.addChild(circle1)
        let rotateCircle = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 2.0)
        let repeatRotation = SKAction.repeatForever(rotateCircle).reversed()
        circle1.run(repeatRotation)
        
        circle2.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        circle2.zPosition = -1.0
        circle2.xScale = 0.45
        circle2.yScale = 0.45
        self.addChild(circle2)
        let rotateCircle2 = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 3.5)
        let repeatRotation2 = SKAction.repeatForever(rotateCircle2)
        circle2.run(repeatRotation2)
        
        let gameCentre = SKSpriteNode(imageNamed: "Game-Center")
        gameCentre.position = CGPoint(x: self.frame.width*0.85, y: self.frame.height*0.95)
        gameCentre.xScale = 0.03
        gameCentre.yScale = 0.03
        gameCentre.name = "gameCentre"
        self.addChild(gameCentre)
        
        
        highscoreLabel = SKLabelNode(fontNamed: "Superclarendon-BlackItalic")
        highscoreLabel.position = CGPoint(x: self.frame.size.width*0.32, y: self.frame.size.height*0.935)
        highscoreLabel.fontSize = 30
        highscoreLabel.text = "BEST: 0"
        highscoreLabel.zPosition = 2.0
        highscoreLabel.fontColor = SKColor.white
        
        self.addChild(highscoreLabel)
        
        if (highscoreDefault.value(forKey: "highscore") != nil) {
            let highscoreDefault = UserDefaults.standard
            highscore = highscoreDefault.value(forKey: "highscore") as! NSInteger
            highscoreLabel.text = NSString(format: "BEST : %i", highscore) as String
            
        }
        
        
        /*************************/
        loadView()
        
        
        
    }
    
    func loadView() {
        
        Person = SKShapeNode(rectOf: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        Person.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 102)
        Person.fillColor = SKColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        Person.zRotation = 3.14 / 2 // it gives a 90 degree
        Person.zPosition = 2.0
        self.addChild(Person)
        
        scoreLabel = SKLabelNode(fontNamed: "Superclarendon-Light")
        scoreLabel.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*0.475)
        scoreLabel.fontSize = 35
        scoreLabel.text = "0"
        scoreLabel.zPosition = 2.0
        scoreLabel.fontColor = SKColor(red: 25.0/255.0, green: 25.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        self.addChild(scoreLabel)
        
        blueFire = SKEmitterNode(fileNamed: "blueFire.sks")!
        blueFire.position = CGPoint(x: 0 , y: 0)
        blueFire.zPosition = 5.0
        blueFire.zRotation = 3.14/2
        blueFire.isHidden = true
        Person.addChild(blueFire)
        
        hotFire = SKEmitterNode(fileNamed: "hotFire.sks")!
        hotFire.position = CGPoint(x: 0 , y: 0)
        hotFire.zPosition = 5.0
        hotFire.zRotation = 3.14/2
        hotFire.isHidden = true
        Person.addChild(hotFire)
        
        greenFire = SKEmitterNode(fileNamed: "greenFire.sks")!
        greenFire.position = CGPoint(x: 0 , y: 0)
        greenFire.zPosition = 5.0
        greenFire.zRotation = 3.14/2
        greenFire.isHidden = true
        Person.addChild(greenFire)
        
        
        redFire = SKEmitterNode(fileNamed: "redFire.sks")!
        redFire.position = CGPoint(x: 0 , y: 0)
        redFire.zPosition = 5.0
        redFire.zRotation = 3.14/2
        redFire.isHidden = true
        Person.addChild(redFire)
        
        AddDot()
        
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    for touch in touches {

        if gameStarted == false {
            
            moveClockWise()
            movingClockWise = true
            gameStarted = true
            
        }else if gameStarted == true {
            
            if movingClockWise == true {
                
                antiClockWise()
                movingClockWise = false
                
            }else if movingClockWise == false {
                
                moveClockWise()
                movingClockWise = true
                
            }
            
            dotTouched()
            
        }
        
        
            let location = touch.location(in: self)
            let sprites = self.nodes(at: location)
            for sprite in sprites {
                if let spriteNode = sprite as? SKSpriteNode {
                    
                    if spriteNode.name != nil {
                        
                        if spriteNode.name == "gameCentre" {
                            
                            Person.isPaused = true
                            Dot.isPaused = true
                            saveHighscore(highscore)
                            showLeader()
                      } else if spriteNode.name == "fbicon" {
                        
                            Person.isPaused = true
                            Dot.isPaused = true
                        }
                   }
                    
                }
                
            }
        
        
        }
        
        
    }
    
    
    func AddDot() {
        
        Dot = SKShapeNode(circleOfRadius: 15.0)
        Dot.fillColor = SKColor(red: 255.0/255.0, green: 165.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        Dot.zPosition = 1.0
        
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let radient = atan2(dy, dx)
        
        if movingClockWise == true {
            
            let tempAngle = CGFloat.random(min: radient - 1.0 , max: radient - 1.5)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 1), radius: 102, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 3.90), clockwise: true)
            Dot.position = path2.currentPoint
            
        }else if movingClockWise == false {
            
            let tempAngle = CGFloat.random(min: radient + 1.0 , max: radient + 2.5)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 1), radius: 102, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 3.90), clockwise: true)
            Dot.position = path2.currentPoint
            
        }
        
        self.addChild(Dot)
        
        
        
    }
    
    func moveClockWise() {
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let radient = atan2(dy, dx)
        
        let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 1), radius: 102, startAngle: radient, endAngle: radient + CGFloat(M_PI * 4), clockwise: true)
        
        var follow = SKAction()
        if score >= 0 && score < 10 {
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 220)
        }else if score >= 10 && score < 20 {
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 230)
        }else if score >= 20 && score < 30{
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 240)
        }else if score >= 30 && score < 50{
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 250)
        }else if score >= 50 && score < 100{
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 280)
        }else if score >= 100 {
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 300)
        }
        
        Person.run(SKAction.repeatForever(follow).reversed())
        
        
        
    }
    func antiClockWise() {
        let dx = Person.position.x - self.frame.width/2
        let dy = Person.position.y - self.frame.height/2
        
        let radient = atan2(dy, dx)
        
        let Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 1), radius: 102, startAngle: radient, endAngle: radient + CGFloat(M_PI * 4), clockwise: true)
        
        var follow = SKAction()
        if score >= 0 && score < 10 {
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 220)
        }else if score >= 10 && score < 20 {
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 230)
        }else if score >= 20 && score < 30{
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 240)
        }else if score >= 30 && score < 50{
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 250)
        }else if score >= 50 && score < 100{
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 280)
        }else if score >= 100 {
            follow = SKAction.follow(Path.cgPath, asOffset: false, orientToPath: true, speed: 300)
        }
        Person.run(SKAction.repeatForever(follow))
        
    }
    
    
    func dotTouched() {
        
        if intersected == true {
            
            clickedSound()
            Dot.removeFromParent()
            AddDot()
            intersected = false
            score += 1
            scoreLabel.text = String(score)
            if score > highscore {
                
                highscore = score
                highscoreLabel.text = NSString(format: "BEST : %i", highscore) as String
                highscoreDefault.setValue(highscore , forKey: "highscore")
                highscoreDefault.synchronize()
            }
            
            
            if (score >= 10 && score < 15) {
                blueFire.isHidden = false
                self.backgroundColor = SKColor(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
            }else if score >= 15 && score < 20 {
                self.backgroundColor = SKColor(red: 0.0/255.0, green: 70.0/255.0, blue: 160.0/255.0, alpha: 1.0)
                blueFire.isHidden = true
                hotFire.isHidden = false
            }else if score >= 20 && score < 25 {
                self.backgroundColor = SKColor(red: 0.0/255.0, green: 0.0/255.0, blue: 139.0/255.0, alpha: 1.0)
                blueFire.isHidden = true
                hotFire.isHidden = true
                redFire.isHidden = false
            }else if score >= 25 {
                self.backgroundColor = SKColor(red: 75.0/255.0, green: 0.0/255.0, blue: 130.0/255.0, alpha: 1.0)
                blueFire.isHidden = true
                hotFire.isHidden = true
                redFire.isHidden = true
                greenFire.isHidden = false
            }
            
            
            
        }else if intersected == false {

            self.backgroundColor = SKColor(red: 72.0/255.0, green: 172.0/255.0, blue: 162.0/255.0, alpha: 1.0)
            FBicon.isHidden = false
            Twittericon.isHidden = false
            died()
            
            
        }
    }
    
    func died() {
        
        self.shakeCamera(0.4)
        clickedMissed()
        score = 0
        Person.isPaused = true
        Dot.removeFromParent()
        FBicon.isHidden = false
        Twittericon.isHidden = false
        
        
        let action1 = SKAction.colorize(with: backgroundColor, colorBlendFactor: 0.0, duration: 0.25)
        let action2 = SKAction.wait(forDuration: 0.5)
        
        self.scene?.run(SKAction.sequence([action1,action2]), completion: { () -> Void in
            
            self.intersected = false
            self.gameStarted = false
            self.Dot.removeAllActions()
            self.Dot.removeFromParent()
            self.Person.removeFromParent()
            self.scoreLabel.removeFromParent()
            self.loadView()
        })
        
        
    }
    
    func shakeCamera(_ duration:Float) {
        
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        circle2.run(actionSeq);
    }

    
    //send high score to leaderboard
    func saveHighscore(_ highscore:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "hotCircle.nthrussell.leaderboard") //leaderboard id here
            
            scoreReporter.value = Int64(highscore) //highscore variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: { (error) -> Void in
                if error != nil {
                    print("error")
                }
            })
        }
        
    }
    
    //shows leaderboard screen
    func showLeader() {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.present(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    //Sounds
    func clickedSound() {
        
        run(SKAction.playSoundFileNamed("Blop", waitForCompletion: false))
    }
    
    func clickedMissed() {
        
        run(SKAction.playSoundFileNamed("Missed", waitForCompletion: false))
    }
    
   
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if Person.intersects(Dot) {
            
            intersected = true
            
        }
        else {
            if intersected == true {
                if Person.intersects(Dot) == false {
                    
                    gameStarted = false
                    intersected = false
                    
                    died()
                }
            }
        }
    }
    
    
    
    
    
    
    
}
