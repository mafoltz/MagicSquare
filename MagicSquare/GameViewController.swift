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
			let scene = GameScene()
            let json: [[String: Any]] = JsonReader.openJson(named: "World")!
            scene.currentLevel = JsonReader.loadLevel(from: json, numberOfLevel: 1)!
			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			scene.size = self.view.bounds.size
			scene.scaleMode = .aspectFill
			view.presentScene(scene)
			
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
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
