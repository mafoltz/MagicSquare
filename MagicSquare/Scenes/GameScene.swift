//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Orientation {
    case vertical
    case horizontal
    case neutral
}

class GameScene: SKScene {
// MARK: - Properties
	
	public var currentLevel : Level!
	private var playerBoard : [[SKShapeNode]]!
	private var templateBoard : [[SKShapeNode]]!
    private var infosCellNode : SKSpriteNode!
    private var levelsButton : SKSpriteNode!
    private var infosCellSize : CGSize!
	private var cellsSize : CGSize!
	private var cellsSpacing : CGFloat!
	private var bottomSpacing : CGFloat!
	private var numPositionMoved : Int!
    private var direction = Orientation.neutral
    private var row : Int! 
    private var column : Int!
    
//MARK: - Touches in screen
    
    private var firstTouch : CGPoint!
    private var penultimateTouch : CGPoint!
    private var nextTouch : CGPoint!
    private var lastTouch : CGPoint!
    
	
// MARK: - Methods
	
	override func didMove(to view: SKView) {
		
		self.scene?.backgroundColor = UIColor.white
		self.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
        
		calculateSizes()
        setInfosCell()
		setPlayerBoard(board: currentLevel.playerBoard)
		addWhiteFrame()
	}
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLocation = touches.first?.location(in: self)
        if levelsButton.contains(CGPoint(x: (touchLocation?.x)! - infosCellNode.position.x,
                                         y: (touchLocation?.y)! - infosCellNode.position.y)) {
            for g in (self.view?.gestureRecognizers)! {
                g.isEnabled = false
            }
            
            openLevelsScreen()
        }
    }
    
    func openLevelsScreen() {
        let scene: LevelsScene = LevelsScene()
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.size = (super.view?.bounds.size)!
        scene.scaleMode = .aspectFill
        scene.prepareScene(from: self.scene!)
        super.view?.presentScene(scene)
    }

	override func update(_ currentTime: TimeInterval) {
		
	}
	
	func calculateSizes() {
        self.infosCellSize = CGSize(width: (super.view?.bounds.size.width)!,
                                    height: 0.225 * (super.view?.bounds.size.height)!)
        
		self.bottomSpacing = ((self.scene?.size.height)! * 0.045)
		self.cellsSpacing = ((self.scene?.size.height)! * CGFloat(0.0375))
		let widthOffset = CGFloat((self.scene?.size.width)! * 0.10667)
		let maxHeight = CGFloat((self.scene?.size.height)! * CGFloat(0.6))
		let maxWidth = CGFloat((self.scene?.size.width)! - (widthOffset * 2))
		let rowsCount = CGFloat(currentLevel.playerBoard.cellsMatrix.count)
		let columnsCount = CGFloat((currentLevel.playerBoard.cellsMatrix.first?.count)!)
		
		let horizontalLength = (maxWidth - (cellsSpacing * (columnsCount - 1.0))) / columnsCount
		let verticalLength = (maxHeight - (cellsSpacing * (rowsCount - 1))) / rowsCount
		
		var smallest = CGFloat()
		if horizontalLength < verticalLength {
			smallest = horizontalLength
		} else {
			smallest = verticalLength
		}
		
		self.cellsSize = CGSize(width: smallest, height: smallest)
	}
	
    func setInfosCell() {
        infosCellNode = SKSpriteNode(color: UIColor(red: 174/256, green: 210/256, blue: 214/256, alpha: 1.0) , size: infosCellSize)
        infosCellNode.zPosition = 1.2
        addChild(infosCellNode)
        infosCellNode.run(SKAction.moveTo(y: (self.view?.bounds.size.height)! - infosCellSize.height / 2, duration: 0.0))
        
        levelsButton = SKSpriteNode(imageNamed: "levelsButton")
        levelsButton.size = CGSize(width: infosCellSize.height / 3, height: infosCellSize.height / 3)
        levelsButton.zPosition = 1.3
        infosCellNode.addChild(levelsButton)
    }
    
	func setPlayerBoard(board: Board) {
		let rowsCount = board.cellsMatrix.count
		let columnsCount = Int((board.cellsMatrix.first?.count)!)
		let folga = (cellsSize.width/2.0) + (cellsSpacing/2.0)
		let cellSpace = cellsSize.width * (CGFloat(columnsCount) / 2.0)
		let spacementSpace = (cellsSpacing * (CGFloat(columnsCount)/2.0))
		
		var xHead = CGFloat()
		var yHead = CGFloat()
		
		if Int(columnsCount) % 2 == 0 {
			// par
			xHead = CGFloat(-(cellSpace + spacementSpace - folga))
		} else {
			// impar
			xHead = CGFloat(-(cellsSize.width + cellsSpacing) * CGFloat(columnsCount/2))
		}
		
		if rowsCount == columnsCount && rowsCount <= 3 {
			yHead = CGFloat((self.scene?.size.height)! * CGFloat(0.645) - (cellsSize.height*1.5) - cellsSpacing)
		} else {
			yHead = CGFloat((self.scene?.size.height)! * CGFloat(0.645) - (cellsSize.height/2.0))
		}
		
		var xOffset = xHead
		var yOffset = yHead
        
        
		playerBoard = [[SKShapeNode]]()
		// adiciona uma linha acima da matriz
		yOffset += (cellsSize.height + cellsSpacing)
		var zerothRow = [SKShapeNode]()
		
		// adiciona uma celula extra no inicio da linha
		xOffset -= (cellsSize.width + cellsSpacing)
		let boardCell0 = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		if let color = board.cellsMatrix[board.cellsMatrix.count - 1].first??.color {
			boardCell0.fillColor = color
			boardCell0.strokeColor = color
			boardCell0.alpha = 0.5
		}
		boardCell0.position = CGPoint(x: xOffset, y: yOffset)
		zerothRow.append(boardCell0)
		xOffset += (cellsSize.width + cellsSpacing)
		
		// adiciona as demais celulas
		for cell in board.cellsMatrix[board.cellsMatrix.count - 1] {
			let boardCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			if let color = cell?.color {
				boardCell.fillColor = color
				boardCell.strokeColor = color
				boardCell.alpha = 0.5
			}
			boardCell.position = CGPoint(x: xOffset, y: yOffset)
			self.addChild(boardCell)
			
			zerothRow.append(boardCell)
			
			xOffset += (cellsSize.width + cellsSpacing)
		}
		
		// adiciona uma celula extra no final da linha
		let boardCellF = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		if let color = board.cellsMatrix[board.cellsMatrix.count - 1].last??.color {
			boardCellF.fillColor = color
			boardCellF.strokeColor = color
			boardCellF.alpha = 0.5
		}
		boardCellF.position = CGPoint(x: xOffset, y: yOffset)
		zerothRow.append(boardCellF)
		
		playerBoard.append(zerothRow)
		yOffset -= (cellsSize.height + cellsSpacing)
		xOffset = xHead
		
		// adiciona as demais linhas
		for row in board.cellsMatrix {
            var elementsRow = [SKShapeNode]()
			
			// adiciona uma celula extra no inicio da linha
			xOffset -= (cellsSize.width + cellsSpacing)
			let boardCell0 = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			if let color = row.last??.color {
				boardCell0.fillColor = color
				boardCell0.strokeColor = color
				boardCell0.alpha = 0.5
			}
			boardCell0.position = CGPoint(x: xOffset, y: yOffset)
			self.addChild(boardCell0)
            elementsRow.append(boardCell0)
			xOffset += (cellsSize.width + cellsSpacing)
			
			// adiciona o resto das celulas
			for cell in row {
				let boardCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
				if let color = cell?.color {
					boardCell.fillColor = color
					boardCell.strokeColor = color
				}
				boardCell.position = CGPoint(x: xOffset, y: yOffset)
				self.addChild(boardCell)
                
                elementsRow.append(boardCell)
                
				xOffset += (cellsSize.width + cellsSpacing)
			}
			
			// adiciona uma celula extra no final da linha
			let boardCellF = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			if let color = row.first??.color {
				boardCellF.fillColor = color
				boardCellF.strokeColor = color
				boardCellF.alpha = 0.5
			}
			boardCellF.position = CGPoint(x: xOffset, y: yOffset)
			self.addChild(boardCellF)
            elementsRow.append(boardCellF)
			
            playerBoard.append(elementsRow)
			xOffset = xHead
			yOffset -= (cellsSize.height + cellsSpacing)
		}
		
		// adiciona a última linha ao final da matriz
		var lastRow = [SKShapeNode]()
		
		// adiciona uma celula extra no inicio da linha
		xOffset -= (cellsSize.width + cellsSpacing)
		let boardCell0F = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		if let color = board.cellsMatrix[board.cellsMatrix.count - 1].first??.color {
			boardCell0F.fillColor = color
			boardCell0F.strokeColor = color
			boardCell0F.alpha = 0.5
		}
		boardCell0F.position = CGPoint(x: xOffset, y: yOffset)
		xOffset += (cellsSize.width + cellsSpacing)
		lastRow.append(boardCell0F)
		
		for cell in board.cellsMatrix[board.cellsMatrix.count - 1] {
			let boardCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			if let color = cell?.color {
				boardCell.fillColor = color
				boardCell.strokeColor = color
				boardCell.alpha = 0.5
			}
			boardCell.position = CGPoint(x: xOffset, y: yOffset)
			self.addChild(boardCell)
			
			lastRow.append(boardCell)
			
			xOffset += (cellsSize.width + cellsSpacing)
		}
		// adiciona uma celula extra no final da linha
		let boardCellG = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		if let color = board.cellsMatrix[board.cellsMatrix.count - 1].last??.color {
			boardCellG.fillColor = color
			boardCellG.strokeColor = color
			boardCellG.alpha = 0.5
		}
		boardCellG.position = CGPoint(x: xOffset, y: yOffset)
		lastRow.append(boardCellG)
		
		playerBoard.append(lastRow)
	}
	
	func addWhiteFrame() {
		
		addWhiteBorder(orientation: "horizontal", position: CGPoint(x: 0, y: (playerBoard[0].first?.position.y)!))
		addWhiteBorder(orientation: "horizontal", position: CGPoint(x: 0, y: (playerBoard[playerBoard.count-1].first?.position.y)!))
		addWhiteBorder(orientation: "vertical", position: CGPoint(x: (playerBoard[0].first?.position.x)!, y: (playerBoard[Int(playerBoard.count/2)].first?.position.y)!))
		addWhiteBorder(orientation: "vertical", position: CGPoint(x: (playerBoard[0].last?.position.x)!, y: (playerBoard[Int(playerBoard.count/2)].first?.position.y)!))

	}
	
	func addWhiteBorder(orientation: String, position: CGPoint) {
		
		if orientation == "horizontal" {
			let cellWidth = cellsSize.width * CGFloat(playerBoard[0].count)
			let cellSpc = cellsSpacing * CGFloat(playerBoard[0].count)
			let horizontalBorder = SKShapeNode(rectOf: CGSize(width: (cellWidth + cellSpc), height: cellsSize.height + cellsSpacing/2),
			                                   cornerRadius: 0)
			horizontalBorder.position = position
			horizontalBorder.fillColor = UIColor.white
			horizontalBorder.alpha = 0.8
			horizontalBorder.zPosition = 1.1
			addChild(horizontalBorder)
		}
		
		if orientation == "vertical" {
			let cellHeight = cellsSize.height * CGFloat(playerBoard.count)
			let cellSpc = cellsSpacing * CGFloat(playerBoard.count - 3)
			let verticalBorder = SKShapeNode(rectOf: CGSize(width: (cellsSize.width + cellsSpacing/2),
			                                                height: (cellHeight + cellSpc)), cornerRadius: 0)
			verticalBorder.position = position
			verticalBorder.fillColor = UIColor.white
			verticalBorder.alpha = 0.8
			verticalBorder.zPosition = 1.1
			addChild(verticalBorder)
		}
		
	}
	
	func update(row: Int) {
		
	}
	
	func update(column: Int) {
		
	}
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == .began {
            firstTouch = convertPoint(fromView: recognizer.location(in: recognizer.view))
            penultimateTouch = firstTouch
            lastTouch = firstTouch
        }
            
        else if recognizer.state == .changed {
            if direction == .neutral {
                nextTouch = convertPoint(fromView: recognizer.location(in: recognizer.view))
                lastTouch = nextTouch
                
                let difX = abs(firstTouch.x - nextTouch.x)
                let difY = abs(firstTouch.y - nextTouch.y)
                
                if difX > difY {
                    direction = .horizontal
                    self.row = getRow(with: firstTouch)
                } else {
                    direction = .vertical
                    self.column = getColumn(with: firstTouch)
                }
            }
            else{
                
                penultimateTouch = lastTouch
                lastTouch = convertPoint(fromView: recognizer.location(in: recognizer.view))
                
                if direction == .horizontal && row >= 0{
                    
                    let differenceX = abs(lastTouch.x - penultimateTouch.x)
                    
                    if lastTouch.x >= penultimateTouch.x {
                        for column in playerBoard[row]{
                            column.position.x += differenceX
                        }
                    }
                    else{
                        for column in playerBoard[row]{
                            column.position.x -= differenceX
                        }
                    }
                }
                else if direction == .vertical && column >= 0{
                    let differenceY = abs(lastTouch.y - penultimateTouch.y)
                    
                    if lastTouch.y >= penultimateTouch.y {
                        //cima
                        for row in playerBoard{
                            row[column].position.y += differenceY
                        }
                    }
                    else {
                        for row in playerBoard{
                            row[column].position.y -= differenceY
                        }
                    }
                }
                
            }
        }
            
        else if recognizer.state == .ended {
            
            lastTouch = convertPoint(fromView: recognizer.location(in: recognizer.view))
            let distanceX = abs(lastTouch.x - firstTouch.x)
            let distanceY = abs(lastTouch.y - firstTouch.y)
            
            if distanceX > distanceY {
                direction = .horizontal
                self.row = getRow(with: firstTouch)
                print(self.row)
            } else {
                direction = .vertical
                self.column = getColumn(with: firstTouch)
                print(self.column)
            }
            
            
            if direction == .vertical && firstTouch.y < lastTouch.y && column >= 0 {
//                currentLevel.moveUpPlayerBoard(column: column, moves: calculateMoves(with: distanceY))
            } else if direction == .vertical && firstTouch.y > lastTouch.y && column >= 0{
//                currentLevel.moveDownPlayerBoard(column: column, moves: calculateMoves(with: distanceY))
            } else if direction == .horizontal && firstTouch.x < lastTouch.x && row >= 0 {
//                currentLevel.moveRightPlayerBoard(row: row, moves: calculateMoves(with: distanceX))
            } else if direction == .horizontal && firstTouch.x > lastTouch.x && row >= 0 {
//                currentLevel.moveLeftPlayerBoard(row: row, moves: calculateMoves(with: distanceX))
            }
            direction = .neutral
        }
    }
    
    func getRow(with position: CGPoint) -> Int {
        for (index, row) in playerBoard.enumerated() {
            
            if index > 0 && index < playerBoard.count-1{
                let newPoint = CGPoint(x: row[1].position.x, y: position.y)
                if row[1].contains(newPoint) {
                    return index
                }
            }
            
            
        }
        return -1
    }
    
    func getColumn(with position: CGPoint) -> Int {
        for (index, column) in playerBoard[1].enumerated() {
            
//            if index > 0 && index < playerBoard[1].count-1{
                let newPoint = CGPoint(x: position.x, y: column.position.y)
                if column.contains(newPoint) {
                    return index
                }
//            }
        }
        return -1
    }
    
    func calculateMoves(with distance: CGFloat) -> Int { //ainda falta ajeitar esta funçao
        var moves = 0
        let movimentSize = cellsSize.width/2 + cellsSpacing/2
    
        moves = Int(distance.truncatingRemainder(dividingBy: movimentSize))
        
        return abs(moves)
    }
    
}
