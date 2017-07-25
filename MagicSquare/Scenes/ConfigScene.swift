//
//  ConfigScene.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 25/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class ConfigScene: SKScene {
	
	// MARK: - Properties
	
	internal var isMusicOn: Bool!
	internal var isSoundsOn: Bool!
	internal var isColorBlind: Bool!
	
	// MARK: - Screen Properties
	
	private var screen: SKShapeNode!
	private var screenSize: CGSize!
	private var goBackButtonPosition: CGPoint!
	private var goBackButtonSize: CGSize!
	private var eslesIconPosition: CGPoint!
	private var eslesIconSize: CGSize!
	private var titlePosition: CGPoint!
	private var titleSize: CGSize!
	private var buttonSize: CGSize!
	private var musicButtonPosition: CGPoint!
	private var soundButtonPosition: CGPoint!
	private var colorBlindButtonPosition: CGPoint!
	private var buttonLabelsX: CGFloat!
	
	// MARK: - Methods
	
	override func didMove(to view: SKView) {
		initScene()
		screen = SKShapeNode()
		screen.name = "screen"
		let screenBackground = CGRect(x: 0, y: 0,
		                              width: self.size.width, height: self.size.height * 2)
		screen.path = UIBezierPath(rect: screenBackground).cgPath
		screen.fillColor = UIColor.white
		screen.zPosition = 2.0
		screen.position = CGPoint(x: 0, y: -self.size.height)
		self.addChild(screen)
		
		let goBackButton = SKSpriteNode(imageNamed: "goBack")
		goBackButton.size = goBackButtonSize
		goBackButton.position = goBackButtonPosition
		screen.addChild(goBackButton)
		
		let eslesIcon = SKSpriteNode(imageNamed: "EsleConfig")
		eslesIcon.size = eslesIconSize
		eslesIcon.position = eslesIconPosition
		screen.addChild(eslesIcon)
		
		let title = SKSpriteNode(imageNamed: "EsleTitle")
		title.size = titleSize
		title.position = titlePosition
		screen.addChild(title)
		
		loadConfigs(root: screen)
		initLabels(root: screen)
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		
		
	}
	
	func initScene() {
		self.backgroundColor = UIColor.white
		screenSize = CGSize(width: self.size.width, height: self.size.height * 2)
		
		goBackButtonSize = CGSize(width: screenSize.width * 0.133, height: screenSize.width * 0.133)
		goBackButtonPosition = CGPoint(x: screenSize.width * 0.053 + goBackButtonSize.width/2,
		                               y: screenSize.height - (screenSize.width * 0.053) - goBackButtonSize.height/2)
		
		eslesIconSize = CGSize(width: screenSize.width * 0.6867, height: screenSize.width * 0.6867)
		eslesIconPosition = CGPoint(x: screenSize.width/2, y: screenSize.height - (screenSize.height * 0.048) - eslesIconSize.height/2)
		
		titleSize = CGSize(width: screenSize.width * 0.5467, height: screenSize.height * 0.015)
		titlePosition = CGPoint(x: screenSize.width/2, y: eslesIconPosition.y - eslesIconSize.height/2 - (screenSize.height * 0.02) - titleSize.height/2)
		
		buttonSize = CGSize(width: screenSize.width * 0.1493, height: screenSize.width * 0.1493)
		let titleBottom = titlePosition.y - titleSize.height/2
		let buttonSpacing = screenSize.height * 0.02
		musicButtonPosition = CGPoint(x: screenSize.width * 0.1253 + buttonSize.width/2, y: titleBottom - buttonSpacing - buttonSize.height/2)
		soundButtonPosition = CGPoint(x: screenSize.width * 0.1253 + buttonSize.width/2, y: musicButtonPosition.y - buttonSpacing - buttonSize.height)
		colorBlindButtonPosition = CGPoint(x: screenSize.width * 0.1253 + buttonSize.width/2, y: soundButtonPosition.y - buttonSpacing - buttonSize.height)
		
		buttonLabelsX = musicButtonPosition.x + buttonSize.width/2 + screenSize.width * 0.032
	}
	
	func loadConfigs(root: SKShapeNode) {
		
		var musicStatus = "Music"
		var soundStatus = "Sound"
		var colorBlindStatus = "ColorBlind"
		
		isMusicOn = false
		isSoundsOn = false
		isColorBlind = false
		
		if isMusicOn {
			musicStatus.append("On")
		} else {
			musicStatus.append("Off")
		}
		
		if isSoundsOn {
			soundStatus.append("On")
		} else {
			soundStatus.append("Off")
		}
		
		if isColorBlind {
			colorBlindStatus.append("On")
		} else {
			colorBlindStatus.append("Off")
		}
		
		let musicButton = SKSpriteNode(imageNamed: musicStatus)
		musicButton.size = buttonSize
		musicButton.position = musicButtonPosition
		root.addChild(musicButton)
		
		let soundButton = SKSpriteNode(imageNamed: soundStatus)
		soundButton.size = buttonSize
		soundButton.position = soundButtonPosition
		root.addChild(soundButton)
		
		let colorBlindButton = SKSpriteNode(imageNamed: colorBlindStatus)
		colorBlindButton.size = buttonSize
		colorBlindButton.position = colorBlindButtonPosition
		root.addChild(colorBlindButton)
		
	}
	
	func initLabels(root: SKShapeNode) {
		
		let musicLabel = SKLabelNode(text: "MUSIC")
		musicLabel.verticalAlignmentMode = .center
		musicLabel.horizontalAlignmentMode = .left
		musicLabel.position = CGPoint(x: buttonLabelsX,
		                              y: musicButtonPosition.y)
		musicLabel.fontName = "SFUIText-Medium"
		musicLabel.fontSize = floor(18 * screenSize.height/1334)
		musicLabel.fontColor = UIColor.black
		root.addChild(musicLabel)
		
		let soundLabel = SKLabelNode(text: "SOUND")
		soundLabel.verticalAlignmentMode = .center
		soundLabel.horizontalAlignmentMode = .left
		soundLabel.position = CGPoint(x: buttonLabelsX, y: soundButtonPosition.y)
		soundLabel.fontName = "SFUIText-Medium"
		soundLabel.fontSize = floor(18 * screenSize.height/1334)
		soundLabel.fontColor = UIColor.black
		root.addChild(soundLabel)
		
		let colorBlindLabel = SKLabelNode(text: "COLORBLIND")
		colorBlindLabel.verticalAlignmentMode = .center
		colorBlindLabel.horizontalAlignmentMode = .left
		colorBlindLabel.position = CGPoint(x: buttonLabelsX,
		                                   y: colorBlindButtonPosition.y)
		colorBlindLabel.fontName = "SFUIText-Medium"
		colorBlindLabel.fontSize = floor(18 * screenSize.height/1334)
		colorBlindLabel.fontColor = UIColor.black
		root.addChild(colorBlindLabel)
	}
	
}
