//
//  TemplateBoard.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 19/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit


class TemplateBoard: SKSpriteNode {
    
    // MARK: - Properties
    
    private var smallBaloon1 = SKShapeNode(circleOfRadius: 100)
    private var smallBaloon2 = SKShapeNode(circleOfRadius: 100)
    private var templateBaloon = SKShapeNode()
    private var templateBoard : BoardNode!
    private var templateText : Label!
    private var touchNode : SKSpriteNode!

    private var smallBaloon1Size : CGSize!
    private var smallBaloon2Size : CGSize!
    private var baloonSize : CGSize!
    private var bottomSpacing : CGFloat!
    private let cornerRadius: CGFloat = 30
    
    private var cont = 0
    private var isTutorial = false
    
    // MARK: - Methods
    
    func setTemplate(from currentLevel: Level, view: SKView) {
        isUserInteractionEnabled = true
        isHidden = true
        anchorPoint = (view.scene?.anchorPoint)!
        zPosition = 2.0
        
        bottomSpacing = 0.045 * view.bounds.size.height
        
        let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.35)
        let backgroundScreen = SKSpriteNode(color: backgroundColor, size: view.bounds.size)
        backgroundScreen.run(SKAction.moveBy(x: 0.0, y: view.bounds.size.height / 2, duration: 0.0))
        backgroundScreen.zPosition = 0.1
        addChild(backgroundScreen)
        
        let roundedRect1 = CGRect(x: 0, y: 0,
                                  width: 0.05 * view.bounds.size.width,
                                  height: 0.05 * view.bounds.size.width)
        smallBaloon1Size = roundedRect1.size
        smallBaloon1.fillColor = UIColor.white
        smallBaloon1.path = UIBezierPath(roundedRect: roundedRect1, cornerRadius: cornerRadius).cgPath
        smallBaloon1.run(SKAction.moveBy(x: -0.2 * view.bounds.size.width,
                                         y: 0.83 * view.bounds.size.height,
                                         duration: 0.0))
        smallBaloon1.zPosition = 0.2
        addChild(smallBaloon1)
        
        let roundedRect2 = CGRect(x: 0, y: 0,
                                  width: 0.1 * view.bounds.size.width,
                                  height: 0.1 * view.bounds.size.width)
        smallBaloon2Size = roundedRect2.size
        smallBaloon2.fillColor = UIColor.white
        smallBaloon2.path = UIBezierPath(roundedRect: roundedRect2, cornerRadius: cornerRadius).cgPath
        smallBaloon2.run(SKAction.moveBy(x: -0.31 * view.bounds.size.width,
                                         y: 0.77 * view.bounds.size.height,
                                         duration: 0.0))
        smallBaloon2.zPosition = 0.2
        addChild(smallBaloon2)
        
        let roundedRect = CGRect(x: (bottomSpacing - view.bounds.size.width) / 2,
                                 y: (bottomSpacing / 2),
                                 width: view.bounds.size.width - bottomSpacing,
                                 height: 0.75 * view.bounds.size.height - bottomSpacing / 2)
        baloonSize = roundedRect.size
        templateBaloon.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius).cgPath
        templateBaloon.fillColor = UIColor.white
        templateBaloon.zPosition = 0.2
        addChild(templateBaloon)
        
		templateBoard = BoardNode(with: view.bounds.size, board: currentLevel.templateBoard, needsExtraCells: false)
        templateBaloon.addChild(templateBoard)
        
        touchNode = SKSpriteNode(color: UIColor.clear, size: view.bounds.size)
        touchNode.zPosition = 2.0
        addChild(touchNode)
        
        if currentLevel.number == 1 {
            isTutorial = true
            setTemplateText(with: "Hi, I am octupus Esle!")
        } else {
            setTemplateText(with: "I doubt you'll find this!")
        }
        
    }
    
    func setTemplateText(with text: String) {
        if templateText != nil {
            templateBaloon.removeChildren(in: [templateText])
        }
        
        let fontColor = UIColor(colorLiteralRed: 47/256, green: 66/256, blue: 67/256, alpha: 1.0)
        templateText = Label(text: text, fontName: ".SFUIText-Medium", fontSize: 18.0, width: self.baloonSize.width*0.708, fontColor: fontColor)
        if UIDevice.current.userInterfaceIdiom == .pad {
            templateText = Label(text: text, fontName: ".SFUIText-Medium", fontSize: 30.0, width: self.baloonSize.width*0.708, fontColor: fontColor)
        }
        
        templateText.position = CGPoint(x: 0.0, y: self.baloonSize.height*0.95)
        templateText.zPosition = 0.1
        templateBaloon.addChild(templateText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = self.scene as! GameScene
        if isTutorial {
            cont = cont + 1
        }
        if cont == 1 {
            setTemplateText(with: "This is the right answer for passing level")
        }
        else if cont == 2 {
            setTemplateText(with: "I will be here to show you the answer, just tap me")
        }
        else {
            scene.answerAction()
        }
    }
    
    private func showSmallBaloon1(with speed: TimeInterval) {
        let moveUp = SKAction.moveBy(x: smallBaloon1Size.width / 2, y: smallBaloon1Size.height / 2, duration: 0.0)
        let moveDown = SKAction.moveBy(x: -smallBaloon1Size.width / 2, y: -smallBaloon1Size.height / 2, duration: speed)
        moveDown.timingMode = .easeInEaseOut
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let decrease = SKAction.scale(to: 0.0, duration: 0.0)
        let growUp = SKAction.scale(to: smallBaloon1Size, duration: speed)
        growUp.timingMode = .easeInEaseOut
        let actionsSequence = SKAction.sequence([decrease, growUp])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        smallBaloon1.run(actionsGroup)
    }
    
    private func showSmallBaloon2(with speed: TimeInterval) {
        let moveUp = SKAction.moveBy(x: smallBaloon2Size.width / 2, y: smallBaloon2Size.height / 2, duration: 0.0)
        let moveDown = SKAction.moveBy(x: -smallBaloon2Size.width / 2, y: -smallBaloon2Size.height / 2, duration: speed)
        moveDown.timingMode = .easeInEaseOut
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let decrease = SKAction.scale(to: 0.0, duration: 0.0)
        let growUp = SKAction.scale(to: smallBaloon2Size, duration: speed)
        growUp.timingMode = .easeInEaseOut
        let actionsSequence = SKAction.sequence([decrease, growUp])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        smallBaloon2.run(actionsGroup)
    }
    
    private func showTemplateBaloon(with speed: TimeInterval) {
        let moveUp = SKAction.moveBy(x: 0.0, y: baloonSize.height, duration: 0.0)
        let moveDown = SKAction.moveBy(x: 0.0, y: -baloonSize.height, duration: speed)
        moveDown.timingMode = .easeInEaseOut
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let decrease = SKAction.scale(to: 0.0, duration: 0.0)
        let growUp = SKAction.scale(to: baloonSize, duration: speed)
        growUp.timingMode = .easeInEaseOut
        let actionsSequence = SKAction.sequence([decrease, growUp])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        templateBaloon.run(actionsGroup)
    }
    
    func show() {
        isUserInteractionEnabled = false
        isHidden = false
        
        let speed = 0.3
        
        showSmallBaloon1(with: speed)
        showSmallBaloon2(with: speed)
        showTemplateBaloon(with: speed)
        
        Timer.scheduledTimer(timeInterval: speed + 0.1, target: self, selector: #selector(self.setUserInteractionEnabled), userInfo: nil, repeats: false)
    }
    
    private func hideSmallBaloon1(with speed: TimeInterval) {
        let moveUp = SKAction.moveBy(x: smallBaloon1Size.width / 2, y: smallBaloon1Size.height / 2, duration: speed)
        let moveDown = SKAction.moveBy(x: -smallBaloon1Size.width / 2, y: -smallBaloon1Size.height / 2, duration: 0.0)
        moveUp.timingMode = .easeInEaseOut
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let growUp = SKAction.scale(to: smallBaloon1Size, duration: 0.0)
        let decrease = SKAction.scale(to: 0.0, duration: 0.3)
        decrease.timingMode = .easeInEaseOut
        let actionsSequence = SKAction.sequence([growUp, decrease])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        smallBaloon1.run(actionsGroup)
    }
    
    private func hideSmallBaloon2(with speed: TimeInterval) {
        let moveUp = SKAction.moveBy(x: smallBaloon2Size.width / 2, y: smallBaloon2Size.height / 2, duration: speed)
        let moveDown = SKAction.moveBy(x: -smallBaloon2Size.width / 2, y: -smallBaloon2Size.height / 2, duration: 0.0)
        moveUp.timingMode = .easeInEaseOut
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let growUp = SKAction.scale(to: smallBaloon2Size, duration: 0.0)
        let decrease = SKAction.scale(to: 0.0, duration: 0.3)
        decrease.timingMode = .easeInEaseOut
        let actionsSequence = SKAction.sequence([growUp, decrease])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        smallBaloon2.run(actionsGroup)
    }
    
    private func hideTemplateBaloon(with speed: TimeInterval) {
        let moveUp = SKAction.moveBy(x: 0.0, y: baloonSize.height, duration: speed)
        let moveDown = SKAction.moveBy(x: 0.0, y: -baloonSize.height, duration: 0.0)
        moveUp.timingMode = .easeInEaseOut
        let moveSequence = SKAction.sequence([moveUp, moveDown])
        
        let growUp = SKAction.scale(to: baloonSize, duration: 0.0)
        let decrease = SKAction.scale(to: 0.0, duration: 0.3)
        decrease.timingMode = .easeInEaseOut
        let actionsSequence = SKAction.sequence([growUp, decrease])
        
        let actionsGroup = SKAction.group([moveSequence, actionsSequence])
        
        templateBaloon.run(actionsGroup)
    }
    
    func hide() {
        isUserInteractionEnabled = false
        
        let speed = 0.3
        
        hideSmallBaloon1(with: speed)
        hideSmallBaloon2(with: speed)
        hideTemplateBaloon(with: speed)
        
        Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.setHidden), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: speed + 0.1, target: self, selector: #selector(self.setUserInteractionEnabled), userInfo: nil, repeats: false)
    }
    
    func setHidden() {
        isHidden = true
    }
    
    func setUserInteractionEnabled() {
        isUserInteractionEnabled = true
    }
}
