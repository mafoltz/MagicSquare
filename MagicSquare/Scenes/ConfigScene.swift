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
    
    var links = ["https://www.linkedin.com/in/arthur-giachini-11a03b141/",
                 "https://www.linkedin.com/in/athos-lagemann-60416599/",
                 "https://www.linkedin.com/in/eduardo-segura-fornari-a23728a7/",
                 "https://luisascaletsky.myportfolio.com",
                 "https://www.linkedin.com/in/marcelo-andrighetto-foltz-b238ba111/"]
	
	internal var isMusicOn: Bool!
	internal var isSoundsOn: Bool!
	internal var isColorBlind: Bool!
	
	internal var previousScene: SKScene!
	private var previousSceneChildren: SKSpriteNode!
	private var buttons = [SKSpriteNode]()
	private var labelButtons = [SKLabelNode]()
	
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
	private var configHUD: SKNode!
	
	private var bannerSize: CGSize!
	private var bannerSpacement: CGFloat!
	private var bottomSpacement: CGFloat!
	private var banner1Pos: CGPoint!
	private var banner2Pos: CGPoint!
	private var banner3Pos: CGPoint!
	private var banner4Pos: CGPoint!
	private var banner5Pos: CGPoint!
	private var ourInfo1Pos: CGPoint!
	private var ourInfo2Pos: CGPoint!
	private var ourTeamPos: CGPoint!
	
	private var firstTouchLocation: CGPoint?
	private var touchLocation: CGPoint?
	private var firstScreenTouch: CGPoint?
	private var screenTouch: CGPoint?
	private var isMoving = false
	private let moveTolerance = CGFloat(10.0)
	private var selectedButton: String!
	private var segment1X: CGFloat!
	private var segment2X: CGFloat!
	private var headLimit: CGFloat!
	private var segmentLimit: CGFloat!
	private var trailLimit: CGFloat!
	
	let font = ".SFUIText-Medium"
	let fontBold = ".SFUIText-Bold"
	let fontColor = UIColor.black
	
	// MARK: - Methods
	
	func prepareToGoBack() {
		
		previousSceneChildren = SKSpriteNode()
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
		
		self.anchorPoint = CGPoint(x: 0, y: 0)
        self.backgroundColor = .esleBackground
		initScene()
		
		addConfigHUD()

		screen = SKShapeNode()
		screen.name = "screen"
		let screenBackground = CGRect(x: 0, y: 0,
		                              width: self.size.width, height: self.size.height * 2)
		screen.path = UIBezierPath(rect: screenBackground).cgPath
		screen.fillColor = .esleBackground
		screen.zPosition = 1.1
		screen.position = CGPoint(x: 0, y: 0)
		self.addChild(screen)
		
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

		let touch: UITouch = touches.first!
		firstTouchLocation = touch.location(in: self)
		touchLocation = touch.location(in: self)
		firstScreenTouch = touch.location(in: screen)
		screenTouch = touch.location(in: screen)
		let hudTouch = touch.location(in: configHUD)
		
		selectedButton = "nil"
		for i in 0..<buttons.count {
			if buttons[i].contains(screenTouch!) {
				selectedButton = buttons[i].name
			}
		}
		if selectedButton == "nil" {
			for i in 0..<labelButtons.count {
				if labelButtons[i].contains(screenTouch!) {
					selectedButton = labelButtons[i].name
				}
			}
		}
		if selectedButton == "nil" && (configHUD.childNode(withName: "goBackButton")?.contains(hudTouch))! {
			selectedButton = "goBackButton"
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isMoving {
			
			let touch: UITouch = touches.first!
			let newTouchLocation = touch.location(in: self)
			screenTouch = touch.location(in: screen)
			
			if (screen.position.x < headLimit - (screen.scene?.size.width)! / 8) {
				screen.run(SKAction.moveBy(x: (newTouchLocation.x - (touchLocation?.x)!)/4, y: 0.0, duration: 0.0))
				touchLocation = newTouchLocation
			} else if (screen.position.x > trailLimit + (screen.scene?.size.width)! / 8) {
				screen.run(SKAction.moveBy(x: (newTouchLocation.x - (touchLocation?.x)!)/4, y: 0.0, duration: 0.0))
				touchLocation = newTouchLocation
			} else {
				screen.run(SKAction.moveBy(x: newTouchLocation.x - (touchLocation?.x)!, y: 0.0, duration: 0.0))
				touchLocation = newTouchLocation
			}
		}
		
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		isMoving = true
		
		if screen.position.x < segmentLimit {
			let moveTo1 = SKAction.moveTo(x: headLimit, duration: 0.2)
			moveTo1.timingMode = .easeOut
			
			let changeHudIndex1 = SKAction.fadeAlpha(to: 0.5, duration: 0.2)
			changeHudIndex1.timingMode = .easeOut
			
			let changeHudIndex2 = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
			changeHudIndex2.timingMode = .easeOut
			
			screen.run(moveTo1)
			configHUD.childNode(withName: "screen1")?.run(changeHudIndex1)
			configHUD.childNode(withName: "screen2")?.run(changeHudIndex2)
			
		}
		
		if screen.position.x > segmentLimit {
			let moveTo2 = SKAction.moveTo(x: trailLimit, duration: 0.2)
			moveTo2.timingMode = .easeOut
			
			let changeHudIndex1 = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
			changeHudIndex1.timingMode = .easeOut
			
			let changeHudIndex2 = SKAction.fadeAlpha(to: 0.5, duration: 0.2)
			changeHudIndex2.timingMode = .easeOut
			
			screen.run(moveTo2)
			configHUD.childNode(withName: "screen1")?.run(changeHudIndex1)
			configHUD.childNode(withName: "screen2")?.run(changeHudIndex2)
		}
		
        var link: Int!
		
		if selectedButton != "nil" && (abs((touchLocation?.x)! - (firstTouchLocation?.x)!) < moveTolerance) {
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
                link = 0
				break
			case "Athos":
                link = 1
				break
			case "Eduardo":
                link = 2
				break
			case "Luisa":
                link = 3
				break
			case "Marcelo":
                link = 4
				break
			default:
				break
			}
			
		}
        
        if link != nil {
            let url = URL(string: links[link])!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
		prepareToGoBack()
		if let scene = previousScene as? GameScene {
			super.view?.presentScene(scene, transition: .fade(withDuration: 0.5))
		}
	}
	
	func changeMusic() {
		if isMusicOn {
            MusicController.sharedInstance.music?.pause()
			isMusicOn = false
			if let musicButton = screen.childNode(withName: "musicButton") as? SKSpriteNode {
				musicButton.texture = SKTexture(imageNamed: "MusicOff")
			}
		} else {
            MusicController.sharedInstance.music?.play()
			isMusicOn = true
			if let musicButton = screen.childNode(withName: "musicButton") as? SKSpriteNode {
				musicButton.texture = SKTexture(imageNamed: "MusicOn")
			}
		}

        UserDefaultsManager.shared.setConfig(isMusicOn, forKey: .music)
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

        UserDefaultsManager.shared.setConfig(isSoundsOn, forKey: .sfx)
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

        UserDefaultsManager.shared.setConfig(isColorBlind, forKey: .colorBlind)
	}
	
	func initScene() {
        screenSize = CGSize(width: self.size.width * 2, height: self.size.height)
        bottomSpacement = CGFloat(screenSize.height * 0.0425)
        trailLimit = 0
        segmentLimit = -self.size.width / 2
        headLimit = -self.size.width

        goBackButtonSize = CGSize(width: screenSize.width * 0.0665, height: screenSize.width * 0.0665)
        goBackButtonPosition = CGPoint(x: screenSize.width * 0.0265 + goBackButtonSize.width / 2,
                                       y: screenSize.height * 0.9 - goBackButtonSize.height / 2)

        eslesIconSize = CGSize(width: screenSize.width * 0.34335, height: screenSize.width * 0.34335)
        eslesIconPosition = CGPoint(x: screenSize.width/4, y: screenSize.height - (screenSize.height * 0.096) - eslesIconSize.height/2)

        titleSize = CGSize(width: screenSize.width * 0.27335, height: screenSize.height * 0.03)
        titlePosition = CGPoint(x: screenSize.width/4, y: eslesIconPosition.y - eslesIconSize.height/2 - (screenSize.height * 0.04) - titleSize.height/2)

        buttonSize = CGSize(width: screenSize.width * 0.07465, height: screenSize.width * 0.07465)
        let titleBottom = titlePosition.y - titleSize.height/2
        let buttonSpacing = screenSize.height * 0.04
        musicButtonPosition = CGPoint(x: screenSize.width * 0.06265 + buttonSize.width/2, y: titleBottom - buttonSpacing - buttonSize.height/2)
        soundButtonPosition = CGPoint(x: screenSize.width * 0.06265 + buttonSize.width/2, y: musicButtonPosition.y - buttonSpacing - buttonSize.height)
        colorBlindButtonPosition = CGPoint(x: screenSize.width * 0.06265 + buttonSize.width/2, y: soundButtonPosition.y - buttonSpacing - buttonSize.height)

        buttonLabelsX = musicButtonPosition.x + buttonSize.width/2 + screenSize.width * 0.032

        let bannerExample = SKSpriteNode(imageNamed: "Arthur")
        let aspectRatio = bannerExample.size.width/bannerExample.size.height
        bannerSize = CGSize(width: screenSize.width * 0.45, height: (screenSize.width * 0.45)/aspectRatio)

        bannerSpacement = CGFloat(screenSize.height * 0.015)

        banner5Pos = CGPoint(x: screenSize.width * 0.75, y: bottomSpacement + (bannerSpacement * 2) + bannerSize.height/2)
        banner4Pos = CGPoint(x: screenSize.width * 0.75, y: banner5Pos.y + bannerSpacement + bannerSize.height)
        banner3Pos = CGPoint(x: screenSize.width * 0.75, y: banner4Pos.y + bannerSpacement + bannerSize.height)
        banner2Pos = CGPoint(x: screenSize.width * 0.75, y: banner3Pos.y + bannerSpacement + bannerSize.height)
        banner1Pos = CGPoint(x: screenSize.width * 0.75, y: banner2Pos.y + bannerSpacement + bannerSize.height)
        ourInfo2Pos = CGPoint(x: screenSize.width * 0.75, y: banner1Pos.y + (bannerSpacement * 3) + bannerSize.height/2)
        ourInfo1Pos = CGPoint(x: screenSize.width * 0.75, y: ourInfo2Pos.y + (bannerSpacement * 2))
        ourTeamPos = CGPoint(x: screenSize.width * 0.75, y: ourInfo1Pos.y + bannerSize.height/2)
	}
	
	func loadConfigs(root: SKShapeNode) {
		
		var musicStatus = "Music"
		var soundStatus = "Sound"
		var colorBlindStatus = "ColorBlind"
		
        isMusicOn = UserDefaultsManager.shared.isMusicEnabled
        isSoundsOn = UserDefaultsManager.shared.isSFXEnabled
        isColorBlind = UserDefaultsManager.shared.isColorblindEnabled

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
		
		let line1 = SKLabelNode(text: "We are students from Brazil hoping")
		line1.name = "line1"
		line1.verticalAlignmentMode = .center
		line1.horizontalAlignmentMode = .center
		line1.position = ourInfo1Pos
		line1.fontName = font
		line1.fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height)
		line1.fontColor = fontColor
		root.addChild(line1)
		
		let line2 = SKLabelNode(text: "to learn each day a little bit more :)")
		line2.name = "line2"
		line2.verticalAlignmentMode = .center
		line2.horizontalAlignmentMode = .center
		line2.position = ourInfo2Pos
		line2.fontName = font
		line2.fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height)
		line2.fontColor = fontColor
		root.addChild(line2)
		
		let ourTeamLabel = SKLabelNode(text: "OUR TEAM")
		ourTeamLabel.name = "OurTeam"
		ourTeamLabel.verticalAlignmentMode = .center
		ourTeamLabel.horizontalAlignmentMode = .center
		ourTeamLabel.position = ourTeamPos
		ourTeamLabel.fontName = fontBold
		ourTeamLabel.fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height)
		ourTeamLabel.fontColor = fontColor
		root.addChild(ourTeamLabel)
		
	}
	
	func initLabels(root: SKShapeNode) {
		let musicLabel = SKLabelNode(text: "MUSIC")
		musicLabel.name = "musicButton"
		musicLabel.verticalAlignmentMode = .center
		musicLabel.horizontalAlignmentMode = .left
		musicLabel.position = CGPoint(x: buttonLabelsX,
		                              y: musicButtonPosition.y)
		musicLabel.fontName = font
		musicLabel.fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height)
		musicLabel.fontColor = fontColor
		labelButtons.append(musicLabel)
		root.addChild(musicLabel)
		
		let soundLabel = SKLabelNode(text: "SOUND")
		soundLabel.name = "soundButton"
		soundLabel.verticalAlignmentMode = .center
		soundLabel.horizontalAlignmentMode = .left
		soundLabel.position = CGPoint(x: buttonLabelsX, y: soundButtonPosition.y)
		soundLabel.fontName = font
		soundLabel.fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height)
		soundLabel.fontColor = fontColor
		labelButtons.append(soundLabel)
		root.addChild(soundLabel)
		
		let colorBlindLabel = SKLabelNode(text: "COLORBLIND")
		colorBlindLabel.name = "colorBlindButton"
		colorBlindLabel.verticalAlignmentMode = .center
		colorBlindLabel.horizontalAlignmentMode = .left
		colorBlindLabel.position = CGPoint(x: buttonLabelsX,
		                                   y: colorBlindButtonPosition.y)
		colorBlindLabel.fontName = font
		colorBlindLabel.fontSize = getFontSize(fontSize: 18, screenHeight: self.size.height)
		colorBlindLabel.fontColor = fontColor
		labelButtons.append(colorBlindLabel)
		root.addChild(colorBlindLabel)
	}
	
	func addConfigHUD() {
		let circleRadius = self.size.height * 0.007875
		let circleSpacement = self.size.height * 0.007875 * 2
		
		configHUD = SKNode.init()
		configHUD.position = CGPoint(x: self.size.width/4, y: self.size.height * 0.02)
		configHUD.zPosition = 1.5
		self.addChild(configHUD)
		
		let goBackButton = SKSpriteNode(imageNamed: "goBack")
		goBackButton.name = "goBackButton"
		goBackButton.size = goBackButtonSize
		goBackButton.position = CGPoint(x: goBackButtonPosition.x - configHUD.position.x , y: goBackButtonPosition.y - configHUD.position.y)
		configHUD.addChild(goBackButton)
		buttons.append(goBackButton)
		
		let screen1 = SKShapeNode(circleOfRadius: circleRadius)
		screen1.name = "screen1"
		screen1.fillColor = UIColor.gray
		screen1.position = CGPoint(x: configHUD.position.x - circleSpacement, y: configHUD.position.y)
		configHUD.addChild(screen1)
		
		let screen2 = SKShapeNode(circleOfRadius: circleRadius)
		screen2.name = "screen2"
		screen2.fillColor = UIColor.gray
		screen2.position = CGPoint(x: configHUD.position.x + circleSpacement, y: configHUD.position.y)
		screen2.alpha = 0.5
		configHUD.addChild(screen2)
	}
}
