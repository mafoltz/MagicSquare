//
//  ResultsScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class ResultsScene: SKScene {
    
    // MARK: - Properties
    
    public var currentLevel : Level!
    private var fontSize = CGFloat(20)
    private var button: SKSpriteNode!
    private var starAngle = CGFloat(0)
    private var starsPosition: CGPoint!
    private var numberOfStars = 0
    
    private var time: TimeInterval!
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        currentLevel.updateRecord()
        
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
        
        let star = CoinSpriteNode()
        star.setCoinForCurrentGame(from: currentLevel)
        star.size = CGSize(width: 76, height: 76)
        star.zPosition = mascot.zPosition
        
        let movesBanner = SKSpriteNode(imageNamed: "movesBanner")
        movesBanner.zPosition = mascot.zPosition
        
        let numberOfMovesLabel = SKLabelNode(fontNamed: ".SFUIText-Bold")
        numberOfMovesLabel.text = "\(currentLevel.playerMoves)"
        numberOfMovesLabel.fontSize = 22
        numberOfMovesLabel.fontColor = UIColor(colorLiteralRed: 238.0/255.0, green: 161.0/255.0, blue: 48.0/255.0, alpha: 1)
        numberOfMovesLabel.zPosition = movesBanner.zPosition + 1
        
        let movesLabel = SKLabelNode(fontNamed: ".SFUIText-Regular")
        movesLabel.text = currentLevel.playerMoves>1 ? "moves" : "move"
        movesLabel.fontSize = 15
        movesLabel.fontColor = numberOfMovesLabel.fontColor
        movesLabel.zPosition = numberOfMovesLabel.zPosition
        
        let bestLabel = SKLabelNode(fontNamed: ".SFUIText-Italic")
        bestLabel.text = "BEST"
        bestLabel.fontSize = 12
        bestLabel.fontColor = UIColor.gray
        bestLabel.zPosition = numberOfMovesLabel.zPosition
        var distanceBestLabelY = CGFloat(0)
        
        let bestMovesLabel = SKLabelNode(fontNamed: ".SFUIText-Italic")
        
        var bestMoves = currentLevel.getRecord()
        if bestMoves == 0 {
            bestMoves = currentLevel.playerMoves
        }
        else if currentLevel.playerMoves < bestMoves{
            bestMoves = currentLevel.playerMoves
        }
        
        bestMovesLabel.text = "\(bestMoves)"
        bestMovesLabel.fontSize = bestLabel.fontSize
        bestMovesLabel.fontColor = bestLabel.fontColor
        bestMovesLabel.zPosition = numberOfMovesLabel.zPosition
        
        let congratulations = SKSpriteNode(imageNamed: "congratulations")
        congratulations.zPosition = mascot.zPosition
        
        let label1 = SKLabelNode(fontNamed: ".SFUIText-Regular")
        label1.fontSize = fontSize
        label1.zPosition = mascot.zPosition
        label1.text = "You won a \(currentLevel.getCoinNameForCurrentGame())"
        label1.fontColor = UIColor.black
        
        let label2 = SKLabelNode(fontNamed: ".SFUIText-Regular")
        label2.fontSize = fontSize
        label2.zPosition = mascot.zPosition
        label2.text = "You are now ready"
        label2.fontColor = UIColor.black
        
        let label3 = SKLabelNode(fontNamed: ".SFUIText-Regular")
        label3.fontSize = fontSize
        label3.zPosition = mascot.zPosition
        label3.text = "to begin level \(currentLevel!.number + 1)"
        label3.fontColor = UIColor.black
        
        button = SKSpriteNode(imageNamed: "buttonResultScene")
        button.zPosition = mascot.zPosition
        
        //Scales
        
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
            
            movesBanner.xScale += differenceScale
            movesBanner.yScale += differenceScale
            
            numberOfMovesLabel.fontSize += CGFloat(10)
            movesLabel.fontSize += CGFloat(10)
            bestLabel.fontSize += CGFloat(10)
            distanceBestLabelY = CGFloat(3)
            bestMovesLabel.fontSize += CGFloat(10)
            
            congratulations.xScale += differenceScale
            congratulations.yScale += differenceScale
            
            fontSize = CGFloat(40)
            
            label1.fontSize = fontSize
            label2.fontSize = fontSize
            label3.fontSize = fontSize
            
            button.xScale += differenceScale
            button.yScale += differenceScale
            
        }
        
        //Positions
        mascot.position.y += CGFloat(77)
        
        star.position.y = mascot.position.y + mascot.size.height/2 + star.size.height/2 + (size.height * 0.04)
        
        movesBanner.position.x = size.width/2 - movesBanner.size.width/2
        movesBanner.position.y = star.position.y + star.size.height/2 - movesBanner.size.height/2
        
        numberOfMovesLabel.position.x = (size.width*0.5) - (movesBanner.size.width) + (movesBanner.size.width*0.2)
        
        
        numberOfMovesLabel.position.y = movesBanner.position.y + (movesBanner.size.height*0.5) - (numberOfMovesLabel.frame.size.height) - 6
        
        movesLabel.position.x = numberOfMovesLabel.position.x + numberOfMovesLabel.frame.size.width/2 + movesLabel.frame.size.width/2 + movesBanner.size.width*0.05
        movesLabel.position.y = numberOfMovesLabel.position.y
        
        bestLabel.position.x = movesLabel.position.x + movesLabel.frame.size.width/2 - bestLabel.frame.size.width/2
        bestLabel.position.y = movesLabel.position.y - movesLabel.frame.size.height/2 - bestLabel.frame.size.height/2 - distanceBestLabelY
        
        bestMovesLabel.position.y = bestLabel.position.y
        bestMovesLabel.position.x = bestLabel.position.x - bestLabel.frame.size.width/2 - bestMovesLabel.frame.size.width/2
        
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
        addChild(movesBanner)
        addChild(numberOfMovesLabel)
        addChild(movesLabel)
        addChild(bestLabel)
        addChild(bestMovesLabel)
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
        
        
        self.starsPosition = mascot.position
        
        if currentLevel.number == JsonReader.openJson(named: "World")?.count{
            removeChildren(in: [label2, label3])
            
            button.position.y = label1.position.y - label1.frame.height/2 - button.size.height/2 - (size.height * 0.037)
        }
        
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self, selector: #selector(self.setClapsMusic), userInfo: nil, repeats: false)
    }
    
    func setClapsMusic() {
        MusicController.sharedInstance.backGroundMusic(music: "Kids Cheering", type: "caf")
    }
    
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
            } else {
                let scene: GameScene = GameScene()
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.size = (super.view?.bounds.size)!
                scene.scaleMode = .aspectFill
                scene.currentLevel = JsonReader.loadLevel(from: json, numberOfLevel: 1)
                super.view?.presentScene(scene)
            }
        }
    }
    
    func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * (CGFloat.pi / 180)
    }
    
    func getPoint(with angle: CGFloat) -> CGPoint {
        return CGPoint(x: position.x + cos(degreesToRadians(degrees: angle)) * self.size.height, y: position.y + sin(degreesToRadians(degrees: angle))*self.size.height)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if time == nil{
            time = currentTime
        }
        if currentTime - time > 1{
            let star = SKSpriteNode(imageNamed: "star")
            star.position = starsPosition
            star.zPosition = 1.5
            self.starAngle = CGFloat(arc4random_uniform(360) + 1)
            let move = SKAction.move(to: getPoint(with: self.starAngle), duration: 5)
            self.addChild(star)
            star.run(move)
            numberOfStars+=1
            
            if numberOfStars == 10 {
                time = currentTime
                numberOfStars = 0
            }
        }
    }
}

