//
//  GameViewController.swift
//  Hot Circle
//
//  Created by minhajul russel on 10/17/15.
//  Copyright (c) 2015 minhajul russel. All rights reserved.
//
import UIKit
import SpriteKit
import iAd
import GameKit
import Social

class GameViewController: UIViewController , ADBannerViewDelegate {
    
    var iAdBanner = ADBannerView()
    var bannerVisible :Bool = false
    var scene : IntroScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        
        scene = IntroScene(size: view.bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene!.scaleMode = .aspectFill
        
        
        skView.presentScene(scene)
        
        // Initialize game center
        self.initGameCenter()
        
        iAdBanner.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 50)
        iAdBanner.delegate = self
        bannerVisible = false
        
        // Prepare fullscreen Ad
        UIViewController.prepareInterstitialAds()
        self.interstitialPresentationPolicy = .manual
        
        
        
    }
    
    // Initialize Game Center
    func initGameCenter() {
        
        // Check if user is already authenticated in game center
        if GKLocalPlayer.localPlayer().isAuthenticated == false {
            
            // Show the Login Prompt for Game Center
            GKLocalPlayer.localPlayer().authenticateHandler = {(viewController, error) -> Void in
                if viewController != nil {
                    self.scene!.isPaused = false
                    self.present(viewController!, animated: true, completion: nil)
                    
                    // Add an observer which calls 'gameCenterStateChanged' to handle a changed game center state
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.addObserver(self, selector:#selector(GameViewController.gameCenterStateChanged), name: NSNotification.Name(rawValue: "GKPlayerAuthenticationDidChangeNotificationName"), object: nil)
                }
            }
        }
    }
    
    // Continue the Game, if GameCenter Authentication state
    // has been changed (login dialog is closed)
    func gameCenterStateChanged() {
        self.scene!.isPaused = false
        
    }
    
    // Show banner, if Ad is successfully loaded.
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        if(bannerVisible == false) {
            
            // Add banner Ad to the view
            if(iAdBanner.superview == nil) {
                self.view.addSubview(iAdBanner)
            }
            
            // Move banner into visible screen frame:
            UIView.beginAnimations("iAdBannerShow", context: nil)
            banner.frame = banner.frame.offsetBy(dx: 0, dy: -banner.frame.size.height)
            UIView.commitAnimations()
            
            bannerVisible = true
        }
        
    }
    
    // Hide banner, if Ad is not loaded.
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        if(bannerVisible == true) {
            // Move banner below screen frame:
            UIView.beginAnimations("iAdBannerHide", context: nil)
            banner.frame = banner.frame.offsetBy(dx: 0, dy: banner.frame.size.height)
            UIView.commitAnimations()
            bannerVisible = false
        }
        
    }
    func bannerViewWillLoadAd(_ banner: ADBannerView!) {
        
    }
    
    func bannerViewActionShouldBegin(_ banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
