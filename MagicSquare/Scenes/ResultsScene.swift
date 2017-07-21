//
//  ResultsScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

class ResultsScene: SKScene {
    
    // MARK: - Properties
    
    public var currentLevel : Level?
    private let fontSize = CGFloat(20)
    private var button: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        var backgroung: SKSpriteNode!
        
        self.backgroundColor = UIColor.white
        if let backgroundResultScene = SKScene(fileNamed: "ResultsScene"){
            backgroung = backgroundResultScene.childNode(withName: "background") as! SKSpriteNode
        }
        backgroung.removeFromParent()
        backgroung.position = CGPoint.zero
        backgroung.zPosition = 1
        
        
        let mascot = SKSpriteNode(imageNamed: "mascot")
        mascot.zPosition = backgroung.zPosition + 1
        
        let star = SKSpriteNode(imageNamed: "goldenLevel")
        star.zPosition = mascot.zPosition
        
        let congratulations = SKSpriteNode(imageNamed: "congratulations")
        congratulations.zPosition = mascot.zPosition
        
        let label1 = SKLabelNode()
        label1.fontSize = fontSize
        label1.zPosition = mascot.zPosition
        label1.text = "You won a Golden Star"
        label1.fontColor = UIColor.black
        
        let label2 = SKLabelNode()
        label2.fontSize = fontSize
        label2.zPosition = mascot.zPosition
        label2.text = "You are now ready"
        label2.fontColor = UIColor.black
        
        let label3 = SKLabelNode()
        label3.fontSize = fontSize
        label3.zPosition = mascot.zPosition
        label3.text = "to begin level \(currentLevel!.number + 1)"
        label3.fontColor = UIColor.black
        
        button = SKSpriteNode(imageNamed: "buttonResultScene")
        button.zPosition = mascot.zPosition
        
        //Scales
        
        star.xScale = 1.5
        star.yScale = 1.5
        
        congratulations.xScale = 0.8
        congratulations.yScale = 0.8
        
        button.xScale = 1.5
        button.yScale = 1.5
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let differenceScale = CGFloat(0.5)
            
            mascot.xScale += differenceScale
            mascot.yScale += differenceScale
            
            star.xScale += differenceScale
            star.yScale += differenceScale
            
            congratulations.xScale += differenceScale
            congratulations.yScale += differenceScale
            
            label1.xScale += differenceScale
            label1.yScale += differenceScale
            
            label2.xScale += differenceScale
            label2.yScale += differenceScale
            
            label3.xScale += differenceScale
            label3.yScale += differenceScale
            
            button.xScale += differenceScale
            button.yScale += differenceScale
            
        }
        
        //Positions
        mascot.position.y += CGFloat(77)
        
        star.position.y = mascot.position.y + mascot.size.height/2 + star.size.height/2 + (size.height * 0.04)
        
        congratulations.position.y = mascot.position.y - mascot.size.height/2 - congratulations.size.height/2 - (size.height * 0.04)
        
        label1.position.y = congratulations.position.y - congratulations.size.height/2 - label1.frame.height/2 - (size.height * 0.04)
        
        label2.position = label1.position
        label2.position.y -= label1.frame.height
        
        label3.position = label2.position
        label3.position.y -= label2.frame.height
        
        button.position.y = label3.position.y - label3.frame.height/2 - button.size.height/2 - (size.height * 0.037)
        
        
        
        
        addChild(backgroung)
        addChild(mascot)
        addChild(star)
        addChild(congratulations)
        addChild(label1)
        addChild(label2)
        addChild(label3)
        addChild(button)
        
        let moveDown = SKAction.moveBy(x: 0.0, y: -10.0, duration: 0.5)
        moveDown.timingMode = .easeInEaseOut
        let moveUp = SKAction.moveBy(x: 0.0, y: 10.0, duration: 0.4)
        moveUp.timingMode = .easeInEaseOut
        let sequence = SKAction.sequence([moveDown, moveUp])
        mascot.run(SKAction.repeatForever(sequence))
        
    }
    
    // MARK: - Methods
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if button.contains(touch!.location(in: self)){
            let json: [[String: Any]] = JsonReader.openJson(named: "World")!
            if (currentLevel?.number)! < json.count {
                let scene: GameScene = GameScene()
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.size = (super.view?.bounds.size)!
                scene.scaleMode = .aspectFill
                scene.currentLevel = JsonReader.loadLevel(from: json, numberOfLevel: (currentLevel?.number)! + 1)
                super.view?.presentScene(scene)
            }
            else {
                let scene: LevelsScene = LevelsScene()
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.size = (super.view?.bounds.size)!
                scene.scaleMode = .aspectFill
                scene.prepareScene(from: self.scene!)
                super.view?.presentScene(scene)
            }
        }
    }
}
