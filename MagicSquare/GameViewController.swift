//
//  GameViewController.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 10/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
			/*let scene = SplashScreenScene()
			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			scene.size = self.view.bounds.size
			scene.scaleMode = .aspectFill
			view.presentScene(scene)*/
            
            goToGameScene(from: view)
			
            view.ignoresSiblingOrder = true
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }

    func goToGameScene(from view: SKView) {
        let scene = GameScene()
        
        var world = UserDefaults.standard.string(forKey: "world")
        let level = UserDefaults.standard.integer(forKey: "level")
        
        if world != nil {
            // Replace old pack save data
            let oldWorld = "World4x3"
            if world == oldWorld {
                world = "4x3 Esle's Starter Pack"
                UserDefaults.standard.set(world, forKey: "world")
                
                if let recordsDictionary = UserDefaults.standard.dictionary(forKey: oldWorld) {
                    UserDefaults.standard.set(recordsDictionary, forKey: world!)
                    UserDefaults.standard.removeObject(forKey: oldWorld)
                }
            }
            
            let json: [[String: Any]] = JsonReader.openJson(named: world!)!
            scene.currentLevel = JsonReader.loadLevel(from: json, worldName: world!, numberOfLevel: level)!
        } else {
            let initialWorld = "4x3 Esle's Starter Pack"
            let json: [[String: Any]] = JsonReader.openJson(named: initialWorld)!
            scene.currentLevel = JsonReader.loadLevel(from: json, worldName: initialWorld, numberOfLevel: 1)!
        }
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (self.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
