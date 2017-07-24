//
//  BoardNode.swift
//  MagicSquare
//
//  Created by Eduardo Fornari on 20/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

enum Orientation {
    case vertical
    case horizontal
    case neutral
}

enum Position {
	case beginning
	case ending
}

class BoardNode: SKNode {
    
    // MARK: - Properties
	
    private var playerBoard : [[SKShapeNode]]!
    
    private var cellsSize : CGSize!
    private var cellsSpacing : CGFloat!
    private var bottomSpacing : CGFloat!
    private var direction = Orientation.neutral
    private var row : Int!
    private var column : Int!
    private var boardDisplay : SKCropNode!
    private var boardContentNode : SKNode!
    
	private var sceneSize: CGSize!
	var boardDelegate : BoardDelegate?
		
    //MARK: - Touches in screen
    
    private var firstTouch : CGPoint!
    private var penultimateTouch : CGPoint!
    private var nextTouch : CGPoint!
    private var lastTouch : CGPoint!
    private var storeFirstNodePosition : CGPoint!
    private var moves : Int!
    public var isMoving = false
    
    // MARK: - Methods
	
	init(with size: CGSize, board: Board, needsExtraCells extra: Bool) {
        super.init()
        sceneSize = size
		
        boardDisplay = SKCropNode()
        boardDisplay.position = CGPoint(x: 0, y: (sceneSize.height)/2)
        
        calculateSizes(board)
        
        initCrop(board)
		
		setPlayerBoard(board: board)
		
		if extra {
			addExtraCells(board: board)
			
		}
		
		storeFirstNodePosition = playerBoard[1][1].position
		
        moves = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGestureRecognizer() {
        guard let scene = self.scene else {
            return
        }
        scene.view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:))))
    }
    
    func disableGestureRecognizer() {
        guard let scene = self.scene else {
            return
        }
        for gesture in (scene.view?.gestureRecognizers!)! {
            gesture.isEnabled = false
        }
    }
    
	func calculateSizes(_ board: Board) {
        self.bottomSpacing = ((sceneSize.height) * 0.045)
        self.cellsSpacing = ((sceneSize.height) * CGFloat(0.0375))
        let widthOffset = CGFloat((sceneSize.width) * 0.10667)
        let maxHeight = CGFloat((sceneSize.height) * CGFloat(0.6))
        let maxWidth = CGFloat((sceneSize.width) - (widthOffset * 2))
        let rowsCount = CGFloat(board.numRows)
        let columnsCount = CGFloat(board.numColumns)
        
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
        
        if rowsCount % 2 == 0 {
            yHead = (sceneSize.height * 0.6425) - (cellsSize.height * 0.5)
        } else {
            if rowsCount <= 3 {
                yHead = (sceneSize.height * 0.602) - (cellsSize.height * 0.5) - cellsSpacing
            } else {
                yHead = (sceneSize.height * 0.6225) - (cellsSize.height * 0.5)
            }
        }
        
        var xOffset = xHead
        var yOffset = yHead
        
        playerBoard = [[SKShapeNode]]()
        for row in board.cellsMatrix {
            var elementsRow = [SKShapeNode]()
			
            for cell in row {
                let boardCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
                if let color = cell?.color {
                    boardCell.fillColor = color
                    boardCell.strokeColor = color
                }
                boardCell.position = CGPoint(x: xOffset, y: yOffset)
                boardContentNode.addChild(boardCell)
                
                elementsRow.append(boardCell)
                
                xOffset += (cellsSize.width + cellsSpacing)
            }
            
            playerBoard.append(elementsRow)
            xOffset = xHead
            yOffset -= (cellsSize.height + cellsSpacing)
        }

		boardDisplay.addChild(boardContentNode)
        self.addChild(boardDisplay)
        storeFirstNodePosition = playerBoard[1][1].position
    }
	
	func addExtraRows(board: Board) {
		let lastPlayerRow = playerBoard.count - 1
		
		let newPos = cellsSpacing + cellsSize.height
		var replicatedRow = board.cellsMatrix[board.numRows - 1] // Replica a última coluna da matriz lógica
		var newY = playerBoard[0][0].position.y + newPos
		var newBeginningRow = [SKShapeNode]()
		var newEndingRow = [SKShapeNode]()
		
		for cell in replicatedRow.enumerated() {
			let newCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			newCell.position = CGPoint(x: playerBoard[0][cell.offset].position.x, y: newY)
			newCell.fillColor = (replicatedRow[cell.offset]?.color)!
			newCell.strokeColor = (replicatedRow[cell.offset]?.color)!
			newBeginningRow.append(newCell)
			boardContentNode.addChild(newCell)
		}
	
		replicatedRow = board.cellsMatrix[0]
		newY = playerBoard[board.numRows - 1][0].position.y - newPos
		
		for cell in replicatedRow.enumerated() {
			let newCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			newCell.position = CGPoint(x: playerBoard[lastPlayerRow][cell.offset].position.x, y: newY)
			newCell.fillColor = (replicatedRow[cell.offset]?.color)!
			newCell.strokeColor = (replicatedRow[cell.offset]?.color)!
			newEndingRow.append(newCell)
			boardContentNode.addChild(newCell)
		}
		
		playerBoard.insert(newBeginningRow, at: 0)
		playerBoard.append(newEndingRow)
		
	}
	
	func addExtraColumns(board: Board) {
		let newPos = cellsSpacing + cellsSize.width
		var xOffset = playerBoard[1][0].position.x - newPos
		
		for row in board.cellsMatrix.enumerated() {
			let newCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			newCell.position = CGPoint(x: xOffset, y: playerBoard[row.offset + 1][0].position.y)
			newCell.fillColor = (board.cellsMatrix[row.offset][board.numColumns - 1]?.color)!
			newCell.strokeColor = (board.cellsMatrix[row.offset][board.numColumns - 1]?.color)!
			playerBoard[row.offset + 1].insert(newCell, at: 0)
			boardContentNode.addChild(newCell)
		}
		
		xOffset = playerBoard[1][playerBoard[1].count - 1].position.x + newPos
		for row in board.cellsMatrix.enumerated() {
			let newCell = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
			newCell.position = CGPoint(x: xOffset, y: playerBoard[row.offset + 1][0].position.y)
			newCell.fillColor = (board.cellsMatrix[row.offset][1]?.color)!
			newCell.strokeColor = (board.cellsMatrix[row.offset][1]?.color)!
			playerBoard[row.offset + 1].append(newCell)
			boardContentNode.addChild(newCell)
		}
		
		addCornerCells(newPos)
	}
	
	func addExtraCells(board: Board) {
		addExtraRows(board: board)
		addExtraColumns(board: board)
	}
	
	func addCornerCells(_ newPos: CGFloat) {
		let lastRow = playerBoard.count - 1
		
		let newCell1 = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		newCell1.position = CGPoint(x: playerBoard[0][0].position.x - newPos, y: playerBoard[0][0].position.y)
		newCell1.fillColor = UIColor.clear
		newCell1.strokeColor = UIColor.red
		playerBoard[0].insert(newCell1, at: 0)
		boardContentNode.addChild(newCell1)
		
		let newCell2 = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		newCell2.position = CGPoint(x: playerBoard[0][playerBoard[0].count - 1].position.x + newPos, y: playerBoard[0][0].position.y)
		newCell2.fillColor = UIColor.clear
		newCell2.strokeColor = UIColor.red
		playerBoard[0].append(newCell2)
		boardContentNode.addChild(newCell2)
		
		let newCell3 = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		newCell3.position = CGPoint(x: playerBoard[playerBoard.count - 1][0].position.x - newPos, y: playerBoard[playerBoard.count - 1][0].position.y)
		newCell3.fillColor = UIColor.clear
		newCell3.strokeColor = UIColor.red
		playerBoard[lastRow].insert(newCell3, at: 0)
		boardContentNode.addChild(newCell3)
		
		let newCell4 = SKShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
		newCell4.position = CGPoint(x: playerBoard[playerBoard.count - 1][playerBoard[playerBoard.count - 1].count - 1].position.x + newPos, y: playerBoard[playerBoard.count - 1][0].position.y)
		newCell4.fillColor = UIColor.clear
		newCell4.strokeColor = UIColor.red
		playerBoard[lastRow].append(newCell4)
		boardContentNode.addChild(newCell4)
	}
	
    func update(row: Int) {
        let positionXNode = playerBoard[row][1].position.x
        let diff = abs(positionXNode - storeFirstNodePosition.x)
		
        if diff > (cellsSpacing/2 + cellsSize.width/2) {
            var rowCopy = playerBoard[row]
            if positionXNode > storeFirstNodePosition.x {
                for index in 0..<playerBoard[row].count-1 {
                    rowCopy[index+1] = playerBoard[row][index]
                }
                let newCell = playerBoard[row].last
                newCell?.fillColor = rowCopy[rowCopy.count-2].fillColor
                newCell?.strokeColor = rowCopy[rowCopy.count-2].strokeColor
                newCell?.position = rowCopy[1].position
                newCell?.position.x -= (cellsSize.width + cellsSpacing)
				
                rowCopy[0] = newCell!
                playerBoard[row] = rowCopy
                moves = moves + 1
				
            }
            else {
                for index in 1..<playerBoard[row].count {
                    rowCopy[index-1] = playerBoard[row][index]
                }
                let newCell = playerBoard[row].first
                newCell?.fillColor = rowCopy[1].fillColor
                newCell?.strokeColor = rowCopy[1].strokeColor
                newCell?.position = rowCopy[rowCopy.count-2].position
                newCell?.position.x += (cellsSize.width + cellsSpacing)
                
                rowCopy[rowCopy.count-1] = newCell!
                playerBoard[row] = rowCopy
                moves = moves - 1
                
                
            }
            
        }
    }
    
    func update(column: Int) {
        let positionYNode = playerBoard[1][column].position.y
        let diff =  abs(positionYNode - storeFirstNodePosition.y)
        if diff > (cellsSpacing/2 + cellsSize.height/2) {
            var columnCopy = [SKShapeNode](repeating: playerBoard[1][1], count:playerBoard.count)
            if positionYNode > storeFirstNodePosition.y {
                for index in 0..<playerBoard.count-1 {
                    columnCopy[index] = playerBoard[index+1][column]
                }
                
                
                let newCell = playerBoard.first![column]
                newCell.fillColor = columnCopy[1].fillColor
                newCell.strokeColor = columnCopy[1].strokeColor
                newCell.position = (playerBoard.last?[column].position)!
                newCell.position.y -= (cellsSize.width + cellsSpacing)
                
                columnCopy[columnCopy.count-1] = newCell
                moves = moves + 1
                
                for index in 0..<playerBoard.count{
                    playerBoard[index][column] = columnCopy[index]
                }
                
                
            }
            else {
                for index in 1..<playerBoard.count {
                    columnCopy[index] = playerBoard[index-1][column]
                }
                
                
                let newCell = playerBoard.last![column]
                newCell.fillColor = columnCopy[columnCopy.count-2].fillColor
                newCell.strokeColor = columnCopy[columnCopy.count-2].strokeColor
                newCell.position = playerBoard[0][column].position
                newCell.position.y += (cellsSize.width + cellsSpacing)
                
                columnCopy[0] = newCell
                moves = moves - 1
                
                for index in 0..<playerBoard.count{
                    playerBoard[index][column] = columnCopy[index]
                }
                
            }
        }
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        //recognizer.maximumNumberOfTouches = 1
        
        guard let scene = self.scene else {
            return
        }
        
        if !isMoving {
            if recognizer.state == .began {
                firstTouch = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))
                penultimateTouch = firstTouch
                lastTouch = firstTouch
            }
                
            else if recognizer.state == .changed {
                if direction == .neutral {
                    nextTouch = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))
                    lastTouch = nextTouch
                    
                    let difX = abs(firstTouch.x - nextTouch.x)
                    let difY = abs(firstTouch.y - nextTouch.y)
                    
                    if difX > difY {
                        direction = .horizontal
                        self.row = getRow(with: firstTouch)
                        if row >= 0 {
                            playerBoard[row][0].fillColor = playerBoard[row][playerBoard[row].count-2].fillColor
                            playerBoard[row][0].strokeColor = playerBoard[row][playerBoard[row].count-2].strokeColor
                            
                            playerBoard[row][playerBoard[row].count-1].fillColor = playerBoard[row][1].fillColor
                            playerBoard[row][playerBoard[row].count-1].strokeColor = playerBoard[row][1].strokeColor
                        }
                    } else {
                        direction = .vertical
                        self.column = getColumn(with: firstTouch)
                        if column >= 0 {
                            playerBoard.first![column].fillColor = playerBoard[playerBoard.count-2][column].fillColor //crashando
                            playerBoard.first![column].strokeColor = playerBoard[playerBoard.count-2][column].strokeColor
                            
                            playerBoard.last![column].fillColor = playerBoard[1][column].fillColor
                            playerBoard.last![column].strokeColor = playerBoard[1][column].strokeColor
                        }
                    }
                }
                else{
                    
                    penultimateTouch = lastTouch
                    lastTouch = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))
                    
                    if direction == .horizontal && row >= 0 {
                        
                        
                        
                        let differenceX = abs(lastTouch.x - penultimateTouch.x)
                        
                        if lastTouch.x >= penultimateTouch.x {
                            //direita
                            for column in playerBoard[row]{
                                column.position.x += differenceX
                            }
                        }
                        else{
                            for column in playerBoard[row]{
                                column.position.x -= differenceX
                            }
                        }
                        update(row: row)
                    }
                    else if direction == .vertical && column >= 0 {
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
                        update(column: column)
                    }
                }
            }
                
            else if recognizer.state == .ended {
                
                lastTouch = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))
                if direction == .horizontal && row >= 0 {
                    let totalDistance = cellsSize.width + cellsSpacing
                    let differenceX = abs(playerBoard[row][1].position.x - storeFirstNodePosition.x)
                    //menor e direita
                    if differenceX < (cellsSpacing/2 + cellsSize.width/2) && storeFirstNodePosition.x < playerBoard[row][1].position.x {
                        isMoving = true
                        
                        for column in playerBoard[row]{
                            var newPoint = column.position
                            newPoint.x -= (differenceX)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            column.run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                        //maior e direita
                    else if differenceX > (cellsSpacing/2 + cellsSize.width/2) && storeFirstNodePosition.x < playerBoard[row][1].position.x{
                        isMoving = true
                        
                        for column in playerBoard[row]{
                            var newPoint = column.position
                            newPoint.x += (totalDistance - differenceX)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            column.run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                        //menor e esquerda
                    else if differenceX < (cellsSpacing/2 + cellsSize.width/2) && storeFirstNodePosition.x > playerBoard[row][1].position.x {
                        isMoving = true
                        
                        for column in playerBoard[row]{
                            var newPoint = column.position
                            newPoint.x += (differenceX)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            column.run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                        //maior e esquerda
                    else if differenceX > (cellsSpacing/2 + cellsSize.width/2) && storeFirstNodePosition.x > playerBoard[row][1].position.x{
                        isMoving = true
                        
                        for column in playerBoard[row]{
                            var newPoint = column.position
                            newPoint.x -= (totalDistance - differenceX)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            column.run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                }
                else if direction == .vertical && column >= 0 {
                    let totalDistance = cellsSize.width + cellsSpacing
                    let differenceY = abs(playerBoard[1][column].position.y - storeFirstNodePosition.y)
                    //menor e direita
                    if differenceY < (cellsSpacing/2 + cellsSize.height/2) && storeFirstNodePosition.y < playerBoard[1][column].position.y {
                        isMoving = true
                        
                        for row in playerBoard{
                            var newPoint = row[column].position
                            newPoint.y -= (differenceY)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            row[column].run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                        //maior e direita
                    else if differenceY > (cellsSpacing/2 + cellsSize.height/2) && storeFirstNodePosition.y < playerBoard[1][column].position.y{
                        isMoving = true
                        
                        for row in playerBoard{
                            var newPoint = row[column].position
                            newPoint.y += (totalDistance - differenceY)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            row[column].run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                        //menor e esquerda
                    else if differenceY < (cellsSpacing/2 + cellsSize.height/2) && storeFirstNodePosition.y > playerBoard[1][column].position.y {
                        isMoving = true
                        
                        for row in playerBoard{
                            var newPoint = row[column].position
                            newPoint.y += (differenceY)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            row[column].run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                        //maior e esquerda
                    else if differenceY > (cellsSpacing/2 + cellsSize.height/2) && storeFirstNodePosition.y > playerBoard[1][column].position.y{
                        isMoving = true
                        
                        for row in playerBoard{
                            var newPoint = row[column].position
                            newPoint.y -= (totalDistance - differenceY)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            row[column].run(move)
                        }
                        
                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                }
			
			if direction == .vertical {
				boardDelegate?.updateMatrixAction(orientation: direction, columnOrRow: column - 1, moves: moves)
			} else {
				boardDelegate?.updateMatrixAction(orientation: direction, columnOrRow: row - 1, moves: moves)
			}
			
            moves = 0
            direction = .neutral
			}
        }
    }
    
    func setNotMoving() {
        isMoving = false
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
            
            if index > 0 && index < playerBoard[1].count-1{
                let newPoint = CGPoint(x: position.x, y: column.position.y)
                if column.contains(newPoint) {
                    return index
                }
            }
        }
        return -1
    }
    
	func initCrop(_ board: Board) {
        boardDisplay = cropBoard(board)
        boardContentNode = SKNode()
        boardContentNode.scene?.size = CGSize(width: sceneSize.width, height: sceneSize.height)
        boardContentNode.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        boardContentNode.position = CGPoint(x: 0, y: 0)
    }
    
	func cropBoard(_ board: Board) -> SKCropNode {
        
        let cropNode = SKCropNode()
        let acumWidth = cellsSize.width * CGFloat(board.cellsMatrix[0].count)
        let acumHSpacing = cellsSpacing * CGFloat(board.cellsMatrix[0].count - 1)
        let acumHeight = cellsSize.height * CGFloat(board.cellsMatrix.count)
        let acumVSpacing = cellsSpacing * CGFloat(board.cellsMatrix.count - 1)
        
        let midNodeY = (sceneSize.height * 0.345) - (CGFloat(board.cellsMatrix.count/2))
        
        let mask = SKShapeNode(rectOf: CGSize(width: (acumWidth + acumHSpacing + cellsSpacing), height: (acumHeight + acumVSpacing + cellsSpacing)))
        
        mask.fillColor = .black
        mask.position = CGPoint(x: 0, y: midNodeY)
        cropNode.maskNode = mask
        
        return cropNode
    }
    
}
