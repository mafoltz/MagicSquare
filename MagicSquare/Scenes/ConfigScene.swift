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
	
	internal var previousScene: SKScene!
	private var previousSceneChildren: SKSpriteNode!
	private var buttons = [SKSpriteNode]()
	
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
	
	private var bannerSize: CGSize!
	private var bannerSpacement: CGFloat!
	private var bottomSpacement: CGFloat!
	private var banner1Pos: CGPoint!
	private var banner2Pos: CGPoint!
	private var banner3Pos: CGPoint!
	private var banner4Pos: CGPoint!
	private var banner5Pos: CGPoint!
	private var ourTeamPos: CGPoint!
	
	private var firstTouchLocation: CGPoint?
	private var touchLocation: CGPoint?
	private var firstScreenTouch: CGPoint?
	private var screenTouch: CGPoint?
	private var isMoving = false
	private let moveTolerance = CGFloat(10.0)
	private var selectedButton: String!
	
	let font = ".SFUIText-Medium"
	let fontColor = UIColor.black
	
	// MARK: - Methods
	
	func prepareToGoBack() {
		
		previousSceneChildren = SKSpriteNode(color: UIColor.white, size: (previousScene.view?.bounds.size)!)
		previousSceneChildren.name = "Previous Scene Children"
		previousSceneChildren.zPosition = 0.0
		previousScene.removeAllChildren()
		previousScene.removeAllActions()
		
		for child in previousScene.children {
			child.removeFromParent()
			previousSceneChildren.addChild(child)
		}
	}
	
	override func didMove(to view: SKView) {
		
		initScene()
		prepareToGoBack()
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
		goBackButton.name = "goBackButton"
		goBackButton.size = goBackButtonSize
		goBackButton.position = goBackButtonPosition
		screen.addChild(goBackButton)
		buttons.append(goBackButton)
		
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
		loadInfos(root: screen)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		isUserInteractionEnabled = false

		let touch: UITouch = touches.first as UITouch!
		firstTouchLocation = touch.location(in: self)
		touchLocation = touch.location(in: self)
		firstScreenTouch = touch.location(in: screen)
		screenTouch = touch.location(in: screen)
		
		selectedButton = "nil"
		for i in 0..<buttons.count {
			if buttons[i].contains(screenTouch!) {
				selectedButton = buttons[i].name
			}
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isMoving {
			let upperLimit = -bottomSpacement!
			let lowerLimit = -self.size.height
			
			if screen.position.y < lowerLimit {
				let moveBack = SKAction.moveTo(y: lowerLimit, duration: 0.0)
				moveBack.timingMode = .easeOut
				screen.run(moveBack)
			}
			
			if screen.position.y > upperLimit {
				let moveBack = SKAction.moveTo(y: upperLimit, duration: 0.0)
				moveBack.timingMode = .easeOut
				screen.run(moveBack)
			}
			
			let touch: UITouch = touches.first as UITouch!
			let newTouchLocation = touch.location(in: self)
			screenTouch = touch.location(in: screen)
			
			screen.run(SKAction.moveBy(x: 0, y: newTouchLocation.y - (touchLocation?.y)!, duration: 0.0))
			touchLocation = newTouchLocation
		}
		
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		isMoving = true
		let upperLimit = -bottomSpacement!
		let lowerLimit = -self.size.height
		
		if screen.position.y < lowerLimit {
			let moveBack = SKAction.moveTo(y: lowerLimit, duration: 0.2)
			moveBack.timingMode = .easeOut
			screen.run(moveBack)
		}
		
		if screen.position.y > upperLimit {
			let moveBack = SKAction.moveTo(y: upperLimit, duration: 0.2)
			moveBack.timingMode = .easeOut
			screen.run(moveBack)
		}
		
		if selectedButton != "nil" && (abs((touchLocation?.y)! - (firstTouchLocation?.y)!) < moveTolerance) {
			switch selectedButton {
			case "goBackButton":
				goBackClicked()
				break
			case "musicButton":
				changeMusic()
				break
			case "soundButton":
				changeSound()
				break
			case "colorBlindButton":
				changeColorBlind()
				break
			case "Arthur":
				print("Arthur")
				break
			case "Athos":
				print("Athos")
				break
			case "Eduardo":
				print("Eduardo")
				break
			case "Luisa":
				print("Luisa")
				break
			case "Marcelo":
				print("Marcelo")
				break
			default:
				break
			}
			
		}
		
		isUserInteractionEnabled = true
	}
	
	override func update(_ currentTime: TimeInterval) {
		if !screen.hasActions() {
			if isMoving {
				isMoving = false
			}
		}
		
	}
	
	func goBackClicked() {
		if let scene = previousScene as? GameScene {
			super.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
		}
	}
	
	func changeMusic() {
		if isMusicOn {
			isMusicOn = false
			if let musicButton = screen.childNode(withName: "musicButton") as? SKSpriteNode {
				musicButton.texture = SKTexture(imageNamed: "MusicOff")
			}
		} else {
			isMusicOn = true
			if let musicButton = screen.childNode(withName: "musicButton") as? SKSpriteNode {
				musicButton.texture = SKTexture(imageNamed: "MusicOn")
			}
		}
	}
	
	func changeSound() {
		if isSoundsOn {
			isSoundsOn = false
			if let soundButton = screen.childNode(withName: "soundButton") as? SKSpriteNode {
				soundButton.texture = SKTexture(imageNamed: "SoundOff")
			}
		} else {
			isSoundsOn = true
			if let soundButton = screen.childNode(withName: "soundButton") as? SKSpriteNode {
				soundButton.texture = SKTexture(imageNamed: "SoundOn")
			}
		}
	}
	
	func changeColorBlind() {
		if isColorBlind {
			isColorBlind = false
			if let colorBlindButton = screen.childNode(withName: "colorBlindButton") as? SKSpriteNode {
				colorBlindButton.texture = SKTexture(imageNamed: "ColorBlindOff")
			}
		} else {
			isColorBlind = true
			if let colorBlindButton = screen.childNode(withName: "colorBlindButton") as? SKSpriteNode {
				colorBlindButton.texture = SKTexture(imageNamed: "ColorBlindOn")
			}
		}
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
		
		let bannerExample = SKSpriteNode(imageNamed: "Arthur")
		let aspectRatio = bannerExample.size.width/bannerExample.size.height
		bannerSize = CGSize(width: screenSize.width * 0.9, height: (screenSize.width * 0.9)/aspectRatio)
		
		bannerSpacement = CGFloat(screenSize.height * 0.0157)
		bottomSpacement = CGFloat(screenSize.height * 0.1)
		banner5Pos = CGPoint(x: screenSize.width/2, y: bottomSpacement + bannerSpacement + bannerSize.height/2)
		banner4Pos = CGPoint(x: screenSize.width/2, y: banner5Pos.y + bannerSpacement + bannerSize.height)
		banner3Pos = CGPoint(x: screenSize.width/2, y: banner4Pos.y + bannerSpacement + bannerSize.height)
		banner2Pos = CGPoint(x: screenSize.width/2, y: banner3Pos.y + bannerSpacement + bannerSize.height)
		banner1Pos = CGPoint(x: screenSize.width/2, y: banner2Pos.y + bannerSpacement + bannerSize.height)
		ourTeamPos = CGPoint(x: screenSize.width/2, y: banner1Pos.y + (bannerSpacement * 1.5) + bannerSize.height/2)
		
	}
	
	func loadConfigs(root: SKShapeNode) {
		
		var musicStatus = "Music"
		var soundStatus = "Sound"
		var colorBlindStatus = "ColorBlind"
		
		isMusicOn = true
		isSoundsOn = true
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
		musicButton.name = "musicButton"
		musicButton.size = buttonSize
		musicButton.position = musicButtonPosition
		root.addChild(musicButton)
		buttons.append(musicButton)
		
		let soundButton = SKSpriteNode(imageNamed: soundStatus)
		soundButton.name = "soundButton"
		soundButton.size = buttonSize
		soundButton.position = soundButtonPosition
		root.addChild(soundButton)
		buttons.append(soundButton)
		
		let colorBlindButton = SKSpriteNode(imageNamed: colorBlindStatus)
		colorBlindButton.name = "colorBlindButton"
		colorBlindButton.size = buttonSize
		colorBlindButton.position = colorBlindButtonPosition
		root.addChild(colorBlindButton)
		buttons.append(colorBlindButton)
		
	}
	
	func loadInfos(root: SKShapeNode) {
		let banner1 = SKSpriteNode(imageNamed: "Arthur")
		banner1.name = "Arthur"
		banner1.size = bannerSize
		banner1.position = banner1Pos
		root.addChild(banner1)
		buttons.append(banner1)
		
		let banner2 = SKSpriteNode(imageNamed: "Athos")
		banner2.name = "Athos"
		banner2.size = bannerSize
		banner2.position = banner2Pos
		root.addChild(banner2)
		buttons.append(banner2)
		
		let banner3 = SKSpriteNode(imageNamed: "Eduardo")
		banner3.name = "Eduardo"
		banner3.size = bannerSize
		banner3.position = banner3Pos
		root.addChild(banner3)
		buttons.append(banner3)
		
		let banner4 = SKSpriteNode(imageNamed: "Luisa")
		banner4.name = "Luisa"
		banner4.size = bannerSize
		banner4.position = banner4Pos
		root.addChild(banner4)
		buttons.append(banner4)
		
		let banner5 = SKSpriteNode(imageNamed: "Marcelo")
		banner5.name = "Marcelo"
		banner5.size = bannerSize
		banner5.position = banner5Pos
		root.addChild(banner5)
		buttons.append(banner5)
		
		let ourTeamLabel = SKLabelNode(text: "OUR TEAM")
		ourTeamLabel.name = "OurTeam"
		ourTeamLabel.verticalAlignmentMode = .center
		ourTeamLabel.horizontalAlignmentMode = .center
		ourTeamLabel.position = ourTeamPos
		ourTeamLabel.fontName = font
		ourTeamLabel.fontSize = floor(18 * screenSize.height/1334)
		ourTeamLabel.fontColor = fontColor
		root.addChild(ourTeamLabel)
		
	}
	
	func initLabels(root: SKShapeNode) {
		
		let musicLabel = SKLabelNode(text: "MUSIC")
		musicLabel.verticalAlignmentMode = .center
		musicLabel.horizontalAlignmentMode = .left
		musicLabel.position = CGPoint(x: buttonLabelsX,
		                              y: musicButtonPosition.y)
		musicLabel.fontName = font
		musicLabel.fontSize = floor(18 * screenSize.height/1334)
		musicLabel.fontColor = fontColor
		root.addChild(musicLabel)
		
		let soundLabel = SKLabelNode(text: "SOUND")
		soundLabel.verticalAlignmentMode = .center
		soundLabel.horizontalAlignmentMode = .left
		soundLabel.position = CGPoint(x: buttonLabelsX, y: soundButtonPosition.y)
		soundLabel.fontName = font
		soundLabel.fontSize = floor(18 * screenSize.height/1334)
		soundLabel.fontColor = fontColor
		root.addChild(soundLabel)
		
		let colorBlindLabel = SKLabelNode(text: "COLORBLIND")
		colorBlindLabel.verticalAlignmentMode = .center
		colorBlindLabel.horizontalAlignmentMode = .left
		colorBlindLabel.position = CGPoint(x: buttonLabelsX,
		                                   y: colorBlindButtonPosition.y)
		colorBlindLabel.fontName = font
		colorBlindLabel.fontSize = floor(18 * screenSize.height/1334)
		colorBlindLabel.fontColor = fontColor
		root.addChild(colorBlindLabel)
	}
	
}
