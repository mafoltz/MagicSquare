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
            let scene = SplashScreenScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.size = self.view.bounds.size
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
