//
//  GameScene.swift
//  MagicSquare
//
//  Created by Marcelo Andrighetto Foltz on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Direction {
    case up
    case down
    case left
    case right
    case neutral
}

class GameScene: SKScene {
// MARK: - Properties
	
	private var currentLevel : Level!
	private var playerBoard : [[SKSpriteNode]]!
	private var templateBoard : [[SKSpriteNode]]!
	private var cellsSize : CGSize!
	private var cellsSpacing : CGFloat!
	private var bottomSpacing : CGFloat!
	private var numPositionMoved : Int!
    private var direction = Direction.neutral
    private var row : Int!
    private var column : Int!
    
//MARK: - Touches in screen
    
    private var firstTouch : CGPoint!
    private var nextTouch : CGPoint!
    private var lastTouch : CGPoint!
    
	
// MARK: - Methods
	
	override func didMove(to view: SKView) {
		
		self.scene?.backgroundColor = UIColor.white
		self.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        self.view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
		currentLevel = World.loadLevel(numberOfLevel: 1)
		calculateSizes()

		setPlayerBoard(board: currentLevel.playerBoard)
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		
	}
	
	func calculateSizes() {
		self.bottomSpacing = ((self.scene?.size.height)! * 0.045)
		self.cellsSpacing = ((self.scene?.size.height)! * CGFloat(0.0375))
		let maxHeight = CGFloat((self.scene?.size.height)! * CGFloat(0.6))
		let maxWidth = CGFloat((self.scene?.size.width)!)
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
	
	func setPlayerBoard(board: Board) {
		let columnsCount = Int((board.cellsMatrix.first?.count)!)
		let folga = (cellsSize.width/2.0) + (cellsSpacing/2.0)
		let cellSpace = cellsSize.width * (CGFloat(columnsCount) / 2.0)
		let spacementSpace = (cellsSpacing * (CGFloat(columnsCount)/2.0))
		
		var xHead = CGFloat()
		
		if Int(columnsCount) % 2 == 0 {
			// par
			xHead = CGFloat(-(cellSpace + spacementSpace - folga))
		} else {
			// impar
			xHead = CGFloat(-(cellsSize.width + cellsSpacing) * CGFloat(columnsCount/2))
		}
		
		print(xHead)
		let yHead = CGFloat((self.scene?.size.height)! * CGFloat(0.645) - (cellsSize.height/2.0))
		var xOffset = xHead
		var yOffset = yHead
		
		for row in board.cellsMatrix {
			for cell in row {
				let boardCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
				if let color = cell?.color {
					boardCell.fillColor = color
					boardCell.strokeColor = color
				}
				boardCell.position = CGPoint(x: xOffset, y: yOffset)
				self.addChild(boardCell)
				xOffset += (cellsSize.width + cellsSpacing)
			}
			xOffset = xHead
			yOffset -= (cellsSize.height + cellsSpacing)
		}
	}
	
	func update(row: Int) {
		
	}
	
	func update(column: Int) {
		
	}
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == .began {
            firstTouch = convertPoint(fromView: recognizer.location(in: recognizer.view))
        }
            
        else if recognizer.state == .changed {
            if direction == .neutral {
                nextTouch = convertPoint(fromView: recognizer.location(in: recognizer.view))
                
                let difX = abs(firstTouch.x - nextTouch.x)
                let difY = abs(firstTouch.y - nextTouch.y)
                
                if difX > difY {
                    if firstTouch.x > nextTouch.x {
                        direction = .left
                    } else {
                        direction = .right
                    }
                    //print(getRow(with: firstTouch))
                    row = getRow(with: firstTouch)
                } else {
                    
                    if firstTouch.y > nextTouch.y {
                        direction = .down
                    } else {
                        direction = .up
                    }
                    column = getColumn(with: firstTouch)
                }
            }
        }
        
        else if recognizer.state == .ended {
            
            print(direction)
            
            lastTouch = convertPoint(fromView: recognizer.location(in: recognizer.view))
            let distanceX = lastTouch.x - firstTouch.x
            let distanceY = lastTouch.y - firstTouch.y
            
            if direction == .up {
                currentLevel.moveUpPlayerBoard(column: column, moves: calculateMoves(with: distanceY))
            } else if direction == .down {
                currentLevel.moveDownPlayerBoard(column: column, moves: calculateMoves(with: distanceY))
            } else if direction == .right {
                currentLevel.moveRightPlayerBoard(row: row, moves: calculateMoves(with: distanceX))
            } else if direction == .left {
                currentLevel.moveLeftPlayerBoard(row: row, moves: calculateMoves(with: distanceX))
            }
            direction = .neutral
        }
    }
    
    func getRow(with position: CGPoint) -> Int {
        for (index, row) in playerBoard[0].enumerated() {
            let newPoint = CGPoint(x: row.position.x, y: position.y)
            if row.contains(newPoint) {
                return index
            }
        }
        return -1
    }
    
    func getColumn(with position: CGPoint) -> Int {
        for index in 0..<playerBoard.count {
            let newPoint = CGPoint(x: position.x, y: playerBoard[0][index].position.y)
            if playerBoard[0][index].contains(newPoint) {
                return index
            }
        }
        return -1
    }
    
    func calculateMoves(with distance: CGFloat) -> Int { //ainda falta ajeitar esta funçao
        var moves = 0
        let squareSize = cellsSize.width
    
        moves = Int(distance.truncatingRemainder(dividingBy: squareSize))
        
        return moves
    }
    
}
