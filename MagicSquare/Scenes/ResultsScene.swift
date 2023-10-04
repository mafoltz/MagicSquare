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
    
    var currentLevel: Level

    private var starAngle = CGFloat(0)
    private var starsPosition: CGPoint = .zero
    private var numberOfStars = 0

    var buttonRetray = SKSpriteNode()
    var secondButton = SKSpriteNode()
    
    var isLastLevel = false
    
    private var time: TimeInterval!
    
    // MARK: - Inits

    init(currentLevel: Level) {
        self.currentLevel = currentLevel
        super.init(size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        currentLevel.updateRecord()

        let json: [[String: Any]] = JsonReader.openJson(named: currentLevel.world)!
        if currentLevel.number == json.count {
            isLastLevel = true
        }
        
        var bestMoves = currentLevel.recordMoves
        if bestMoves <= 0 {
            bestMoves = currentLevel.playerMoves
        }
        else if currentLevel.playerMoves < bestMoves {
            bestMoves = currentLevel.playerMoves
        }

        let medalType = currentLevel.getMedalNameForCurrentGame()
        var buttonRetraySize: CGFloat = size.width*0.227
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonRetraySize = size.width*0.1
        }
        
        guard let backgroundResultScene = SKScene(fileNamed: "ResultsScene") else { return }
        let background: SKSpriteNode = (backgroundResultScene.childNode(withName: "background") as! SKSpriteNode)

        background.removeFromParent()
        background.position = CGPoint.zero
        background.zPosition = 1
        
        let medal = SKSpriteNode(imageNamed: medalType)
        medal.zPosition = background.zPosition + 1
        
        let medalScale = (size.width*0.504)/medal.size.width
        medal.xScale = medalScale
        medal.yScale = medalScale
        
        let levelUpBanner = SKSpriteNode(imageNamed: "levelUpBanner")
        levelUpBanner.zPosition = medal.zPosition + 1
        
        let levelUpBannerScale = (size.width*0.554)/levelUpBanner.size.width
        levelUpBanner.xScale = levelUpBannerScale
        levelUpBanner.yScale = levelUpBannerScale
        
        let numberOfMovesLabel = SKLabelNode(fontNamed: ".SFUIText-Heavy")
        numberOfMovesLabel.zPosition = medal.zPosition
        numberOfMovesLabel.fontColor = UIColor(red: 240.0/155.0, green: 162.0/255.0, blue: 25.0/255.0, alpha: 1)
        numberOfMovesLabel.text = "\(currentLevel.playerMoves)"
		numberOfMovesLabel.fontSize = getFontSize(fontSize: 80, screenHeight: self.size.height)
		
        let totalMovesLabel = SKLabelNode(fontNamed: ".SFUIText-Bold")
        totalMovesLabel.zPosition = numberOfMovesLabel.zPosition
        totalMovesLabel.fontColor = numberOfMovesLabel.fontColor
        totalMovesLabel.text = "TOTAL MOVES"
        totalMovesLabel.fontSize = getFontSize(fontSize: 22, screenHeight: self.size.height)
        
        let bestMovesLabel = SKLabelNode(fontNamed: ".SFUIText-Italic")
        bestMovesLabel.zPosition = numberOfMovesLabel.zPosition
        bestMovesLabel.fontColor = UIColor(red: 115.0/255.0, green: 134.0/255.0, blue: 145.0/255.0, alpha: 1)
        bestMovesLabel.text = "Best score: \(bestMoves) \(bestMoves > 1 ? "moves" : "move")"
        bestMovesLabel.fontSize = getFontSize(fontSize: 22, screenHeight: self.size.height)
        
        
        buttonRetray.size = CGSize(width: buttonRetraySize, height: buttonRetraySize)
        
        buttonRetray.color = UIColor(red: 0, green: 152.0/255.0, blue: 156.0/255.0, alpha: 1)
        buttonRetray.zPosition = medal.zPosition
        
        let retryImage = SKSpriteNode(imageNamed: "retry")
        retryImage.zPosition = buttonRetray.zPosition + 1
        retryImage.size.width = buttonRetray.size.width*0.506
        retryImage.size.height = buttonRetray.size.width*0.506
        
        secondButton.size = CGSize(width: size.width - buttonRetray.size.width - 4, height: buttonRetray.size.height)
        secondButton.color = buttonRetray.color
        secondButton.zPosition = medal.zPosition
        
        let secondButtonLabel = SKLabelNode(fontNamed: ".SFUIText-Medium")
        secondButtonLabel.zPosition = secondButton.zPosition + 1
        secondButtonLabel.fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height)
        secondButtonLabel.fontColor = UIColor.white
        
        if isLastLevel {
            secondButtonLabel.text = "GO TO NEXT PACK"
        }
        else{
            secondButtonLabel.text = "GO TO LEVEL \(currentLevel.number + 1)"
        }
		
        //Positions
        
        medal.position.y = size.height*0.5 - medal.size.height*0.5
        
        levelUpBanner.position.y = medal.position.y - medal.size.height*0.5
        
        numberOfMovesLabel.position.y = levelUpBanner.position.y - size.height*0.158 - numberOfMovesLabel.frame.size.height
        
        totalMovesLabel.position.y = numberOfMovesLabel.position.y + numberOfMovesLabel.frame.size.height + totalMovesLabel.frame.size.height
        
        bestMovesLabel.position.y = numberOfMovesLabel.position.y - bestMovesLabel.frame.size.height*2
        
        buttonRetray.position.x = -(size.width*0.5) + buttonRetray.size.width*0.5
        buttonRetray.position.y = -(size.height*0.5) + buttonRetray.size.height*0.5
        
        secondButton.position.x = size.width*0.5 - secondButton.size.width*0.5
        secondButton.position.y = buttonRetray.position.y
        
        secondButtonLabel.position.y -= secondButtonLabel.frame.size.height/2
        
        starsPosition = medal.position
        
        //Add Children
        addChild(background)
        addChild(medal)
        addChild(levelUpBanner)
        addChild(numberOfMovesLabel)
        addChild(totalMovesLabel)
        addChild(bestMovesLabel)
        addChild(buttonRetray)
        buttonRetray.addChild(retryImage)
        addChild(secondButton)
        secondButton.addChild(secondButtonLabel)
        
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.setClapsMusic), userInfo: nil, repeats: false)
    }

    @objc
    func setClapsMusic() {
        if UserDefaultsManager.shared.isSFXEnabled {
            MusicController.sharedInstance.play(sound: "Kids Cheering", type: "caf")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        var json: [[String: Any]] = JsonReader.openJson(named: currentLevel.world)!
        if buttonRetray.contains(touch!.location(in: self)){
            let scene: GameScene = GameScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.size = (super.view?.bounds.size)!
            scene.scaleMode = .aspectFill
            scene.currentLevel = JsonReader.loadLevel(from: json, worldName: currentLevel.world, numberOfLevel: currentLevel.number)
            super.view?.presentScene(scene)
        }
        else if secondButton.contains(touch!.location(in: self)){
            if !isLastLevel {
                let scene: GameScene = GameScene()
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.size = (super.view?.bounds.size)!
                scene.scaleMode = .aspectFill
                scene.currentLevel = JsonReader.loadLevel(from: json, worldName: currentLevel.world, 
                                                          numberOfLevel: currentLevel.number + 1)
                super.view?.presentScene(scene)
            } else {
                let nextWorld: String!
                let nextLevel: Int!
                let currentWorldIndex = World.packNames.firstIndex(of: currentLevel.world)!
                
                if currentWorldIndex < World.packNames.count - 1 {
                    nextWorld = World.packNames[currentWorldIndex + 1]
                    nextLevel = 1
                    json = JsonReader.openJson(named: nextWorld)!
                } else {
                    nextWorld = currentLevel.world
                    nextLevel = currentLevel.number
                }
                
                let scene: GameScene = GameScene()
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.size = (super.view?.bounds.size)!
                scene.scaleMode = .aspectFill
                scene.currentLevel = JsonReader.loadLevel(from: json, worldName: nextWorld, numberOfLevel: nextLevel)
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
            star.xScale = 0.5
            star.yScale = 0.5
            star.position = starsPosition
            star.zPosition = 1.5
            self.starAngle = CGFloat(arc4random_uniform(360) + 1)
            
            star.zRotation = starAngle
            
            let move = SKAction.move(to: getPoint(with: self.starAngle), duration: 5)
            let alpha = SKAction.fadeAlpha(to: 0, duration: 5)
            let scale = SKAction.scale(by: 5, duration: 5)
            
            self.addChild(star)
            star.run(move)
            star.run(alpha)
            star.run(scale)
            numberOfStars+=1
            
            if numberOfStars == 10 {
                time = currentTime
                numberOfStars = 0
            }
        }
    }
}

