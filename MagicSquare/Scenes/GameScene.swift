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
    
//MARK: - Touches in screen
    
    private var firstTouch : CGPoint!
    private var nextTouch : CGPoint!
    
	
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
		self.cellsSize = CGSize(width: ((self.scene?.size.height)! * CGFloat(0.122)),
		                        height: ((self.scene?.size.height)! * CGFloat(0.122)))
		self.cellsSpacing = ((self.scene?.size.height)! * CGFloat(0.0375))
	}
	
	func setPlayerBoard(board: Board) {
		let xHead = CGFloat(-(cellsSize.width + cellsSpacing) * CGFloat(board.cellsMatrix.count/2))
		let yHead = CGFloat((self.scene?.size.height)! * CGFloat(0.645) - (cellsSize.height/2))
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
                    print(getRow(with: firstTouch))
                } else {
                    
                    if firstTouch.y > nextTouch.y {
                        direction = .down
                    } else {
                        direction = .up
                    }
                }
            }
        }
        
        else if recognizer.state == .ended {
            print(direction)
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
    
//    func getColumn(with position: CGPoint) -> Int {
//        for 0..< playerBoard.count {
//            
//        }
//    }

}
