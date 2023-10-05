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

    public var currentLevel : Level!
    private var isColorBlind : Bool!
    internal var playerBoard : [[BoardCellShapeNode]]!


    internal var cellsSize : CGSize!
    internal var cellsSpacing : CGFloat!
    private var bottomSpacing : CGFloat!
    private var direction = Orientation.neutral
    private var row : Int!
    private var column : Int!
    private var boardDisplay : SKCropNode!
    private var boardContentNode : SKNode!

    private var sceneSize: CGSize!
    internal var boardDelegate : BoardDelegate?

    //MARK: - Touches in screen

    private var firstTouch : CGPoint!
    private var penultimateTouch : CGPoint!
    private var nextTouch : CGPoint!
    private var lastTouch : CGPoint!
    private var storeFirstNodePosition : CGPoint!

    internal var moves : Int!

    public var isMoving = false

    // MARK: - Methods

    init(with size: CGSize, board: Board, needsExtraCells extra: Bool) {
        super.init()
        sceneSize = size
        isColorBlind = UserDefaultsManager.shared.isColorblindEnabled

        boardDisplay = SKCropNode()
        boardDisplay.position = CGPoint(x: 0, y: (sceneSize.height)/2)

        calculateSizes(board)

        initCrop(board)

        setPlayerBoard(board: board)

        if extra {
            addExtraCells(board: board)
            if isColorBlind {
                addColorBlindSymbolsWithExtraCells(board: board)
            }
        } else {
            if isColorBlind {
                addColorBlindSymbols(board: board)
            }
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

        let widthOffset = CGFloat((sceneSize.width) * 0.1)
        let maxHeight = CGFloat((sceneSize.height) * CGFloat(0.6))
        let maxWidth = CGFloat((sceneSize.width) - (widthOffset * 2))
        let rowsCount = CGFloat(board.numRows)
        let columnsCount = CGFloat(board.numColumns)

        let horizontalLength = (maxWidth - (cellsSpacing * (columnsCount - 1.0))) / columnsCount
        let verticalLength = (maxHeight - (cellsSpacing * (rowsCount - 1))) / rowsCount

        let smallest: CGFloat
        if horizontalLength < verticalLength {
            smallest = horizontalLength
        } else {
            smallest = verticalLength
        }

        self.cellsSize = CGSize(width: smallest, height: smallest)
    }

    func setPlayerBoard(board: Board) {
        let columnsCount = Int((board.cellsMatrix.first?.count)!)
        let gap = (cellsSize.width/2.0) + (cellsSpacing/2.0)
        let cellSpace = cellsSize.width * (CGFloat(columnsCount) / 2.0)
        let spacementSpace = (cellsSpacing * (CGFloat(columnsCount)/2.0))

        var xHead = CGFloat()
        var yHead = CGFloat()

        if Int(columnsCount) % 2 == 0 {
            // even
            xHead = CGFloat(-(cellSpace + spacementSpace - gap))
        } else {
            // odd
            xHead = CGFloat(-(cellsSize.width + cellsSpacing) * CGFloat(columnsCount/2))
        }

        switch (board.numColumns, board.numRows) {
        case (3, 3):
            yHead = (sceneSize.height * 0.6) - (cellsSize.height * 0.5) - cellsSpacing
        case (3, 4), (4, _):
            yHead = (sceneSize.height * 0.6) - (cellsSize.height * 0.5)
        case (3, 5):
            yHead = (sceneSize.height * 0.6) - (cellsSize.height * 0.5) + cellsSpacing
        default:
            yHead = (sceneSize.height * 0.6) - (cellsSize.height * 0.5) + cellsSpacing
        }

        var xOffset = xHead
        var yOffset = yHead

        playerBoard = [[BoardCellShapeNode]]()
        for row in board.cellsMatrix.enumerated() {
            var elementsRow = [BoardCellShapeNode]()

            for cell in row.element.enumerated() {
                let boardCell = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
                if let color = cell.element?.color {
                    boardCell.fillColor = color
                    boardCell.strokeColor = color
                }
                boardCell.position = CGPoint(x: xOffset, y: yOffset)
                boardCell.name = "cell" + row.offset.description + cell.offset.description
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
        var newBeginningRow = [BoardCellShapeNode]()
        var newEndingRow = [BoardCellShapeNode]()

        for cell in replicatedRow.enumerated() {
            let newCell = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
            newCell.position = CGPoint(x: playerBoard[0][cell.offset].position.x, y: newY)
            newCell.fillColor = (replicatedRow[cell.offset]?.color)!
            newCell.strokeColor = (replicatedRow[cell.offset]?.color)!

            newBeginningRow.append(newCell)
            boardContentNode.addChild(newCell)
        }

        replicatedRow = board.cellsMatrix[0]
        newY = playerBoard[board.numRows - 1][0].position.y - newPos

        for cell in replicatedRow.enumerated() {
            let newCell = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
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
            let newCell = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
            newCell.position = CGPoint(x: xOffset, y: playerBoard[row.offset + 1][0].position.y)
            newCell.name = "cell" + (row.offset - 1).description + "-1"
            newCell.fillColor = (board.cellsMatrix[row.offset][board.numColumns - 1]?.color)!
            newCell.strokeColor = (board.cellsMatrix[row.offset][board.numColumns - 1]?.color)!

            playerBoard[row.offset + 1].insert(newCell, at: 0)
            boardContentNode.addChild(newCell)
        }

        xOffset = playerBoard[1][playerBoard[1].count - 1].position.x + newPos

        for row in board.cellsMatrix.enumerated() {
            let newCell = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
            newCell.position = CGPoint(x: xOffset, y: playerBoard[row.offset + 1][0].position.y)
            newCell.name = "cell" + (row.offset - 1).description + (playerBoard[1].count - 1).description
            newCell.fillColor = (board.cellsMatrix[row.offset][0]?.color)!
            newCell.strokeColor = (board.cellsMatrix[row.offset][0]?.color)!

            playerBoard[row.offset + 1].append(newCell)
            boardContentNode.addChild(newCell)
        }

        addCornerCells(newPos)
    }

    func addExtraCells(board: Board) {
        addExtraRows(board: board)
        addExtraColumns(board: board)
    }

    func addColorBlindSymbols(board: Board) {
        for row in playerBoard.enumerated() {
            for column in row.element.enumerated() {
                if let symbolName = board.cellsMatrix[row.offset][column.offset]?.symbol {
                    let cell = boardContentNode.childNode(withName: "cell" + row.offset.description + column.offset.description)
                    let symbol = SKSpriteNode(imageNamed: symbolName)
                    symbol.scale(to: CGSize(width: cellsSize.width/3, height: cellsSize.height/3))
                    cell?.addChild(symbol)
                }
            }
        }
    }

    func addColorBlindSymbolsWithExtraCells(board: Board) {
        addSymbolsToMatrix(to: playerBoard)
    }

    func addCornerCells(_ newPos: CGFloat) {
        let lastRow = playerBoard.count - 1

        let newCell1 = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
        newCell1.position = CGPoint(x: playerBoard[0][0].position.x - newPos, y: playerBoard[0][0].position.y)
        newCell1.fillColor = UIColor.clear
        newCell1.strokeColor = UIColor.red
        playerBoard[0].insert(newCell1, at: 0)
        boardContentNode.addChild(newCell1)

        let newCell2 = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
        newCell2.position = CGPoint(x: playerBoard[0][playerBoard[0].count - 1].position.x + newPos, y: playerBoard[0][0].position.y)
        newCell2.fillColor = UIColor.clear
        newCell2.strokeColor = UIColor.red
        playerBoard[0].append(newCell2)
        boardContentNode.addChild(newCell2)

        let newCell3 = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
        newCell3.position = CGPoint(x: playerBoard[playerBoard.count - 1][0].position.x - newPos, y: playerBoard[playerBoard.count - 1][0].position.y)
        newCell3.fillColor = UIColor.clear
        newCell3.strokeColor = UIColor.red
        playerBoard[lastRow].insert(newCell3, at: 0)
        boardContentNode.addChild(newCell3)

        let newCell4 = BoardCellShapeNode(rectOf: cellsSize, cornerRadius: (cellsSize.width * 0.20))
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
                if isColorBlind {
                    if newCell?.childNode(withName: "symbol") != nil {
                        newCell?.removeAllChildren()
                    }

                    let colorName = getSymbolNameFromColor(color: rowCopy[rowCopy.count-2].fillColor)
                    let newSymbol = SKSpriteNode(imageNamed: colorName.replacingOccurrences(of: "color", with: "cell"))
                    newSymbol.scale(to: CGSize(width: cellsSize.width/3, height: cellsSize.height/3))
                    newSymbol.name = "symbol"
                    newCell?.addChild(newSymbol)

                }

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
                if isColorBlind {
                    if newCell?.childNode(withName: "symbol") != nil {
                        newCell?.removeAllChildren()
                    }

                    let colorName = getSymbolNameFromColor(color: rowCopy[1].fillColor)
                    let newSymbol = SKSpriteNode(imageNamed: colorName.replacingOccurrences(of: "color", with: "cell"))
                    newSymbol.scale(to: CGSize(width: cellsSize.width/3, height: cellsSize.height/3))
                    newSymbol.name = "symbol"
                    newCell?.addChild(newSymbol)

                }

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
            var columnCopy = [BoardCellShapeNode](repeating: playerBoard[1][1], count:playerBoard.count)
            if positionYNode > storeFirstNodePosition.y {
                for index in 0..<playerBoard.count-1 {
                    columnCopy[index] = playerBoard[index+1][column]
                }


                let newCell = playerBoard.first![column]
                newCell.fillColor = columnCopy[1].fillColor
                newCell.strokeColor = columnCopy[1].strokeColor
                newCell.position = (playerBoard.last?[column].position)!
                newCell.position.y -= (cellsSize.width + cellsSpacing)
                if isColorBlind {
                    if newCell.childNode(withName: "symbol") != nil {
                        newCell.removeAllChildren()
                    }

                    let colorName = getSymbolNameFromColor(color: columnCopy[1].fillColor)
                    let newSymbol = SKSpriteNode(imageNamed: colorName.replacingOccurrences(of: "color", with: "cell"))
                    newSymbol.scale(to: CGSize(width: cellsSize.width/3, height: cellsSize.height/3))
                    newSymbol.name = "symbol"
                    newCell.addChild(newSymbol)
                }

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
                if isColorBlind {
                    if newCell.childNode(withName: "symbol") != nil {
                        newCell.removeAllChildren()
                    }
                    let colorName = getSymbolNameFromColor(color: columnCopy[columnCopy.count-2].fillColor)
                    let newSymbol = SKSpriteNode(imageNamed: colorName.replacingOccurrences(of: "color", with: "cell"))
                    newSymbol.scale(to: CGSize(width: cellsSize.width/3, height: cellsSize.height/3))
                    newSymbol.name = "symbol"
                    newCell.addChild(newSymbol)

                }

                columnCopy[0] = newCell
                moves = moves - 1

                for index in 0..<playerBoard.count{
                    playerBoard[index][column] = columnCopy[index]
                }

            }
        }
    }

    @objc
    func handlePan(recognizer:UIPanGestureRecognizer) {
        recognizer.maximumNumberOfTouches = 1

        guard let scene = self.scene else {
            return
        }

        if !isMoving {
            if recognizer.state == .began {
                firstTouch = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))
                penultimateTouch = firstTouch
                lastTouch = firstTouch
            } else if recognizer.state == .changed {
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

                            if isColorBlind {
                                addColorBlindSymbolToCell(from: playerBoard[row][playerBoard[row].count-2],
                                                          to: playerBoard[row][0])
                                addColorBlindSymbolToCell(from: playerBoard[row][1],
                                                          to: playerBoard[row][playerBoard[row].count-1])
                            }
                        }
                    } else {
                        direction = .vertical
                        self.column = getColumn(with: firstTouch)
                        if column >= 0 {
                            playerBoard.first![column].fillColor = playerBoard[playerBoard.count-2][column].fillColor
                            playerBoard.first![column].strokeColor = playerBoard[playerBoard.count-2][column].strokeColor

                            playerBoard.last![column].fillColor = playerBoard[1][column].fillColor
                            playerBoard.last![column].strokeColor = playerBoard[1][column].strokeColor

                            if isColorBlind {
                                addColorBlindSymbolToCell(from: playerBoard[playerBoard.count-2][column],
                                                          to: playerBoard.first![column])
                                addColorBlindSymbolToCell(from: playerBoard[1][column],
                                                          to: playerBoard.last![column])
                            }
                        }
                    }
                } else {

                    penultimateTouch = lastTouch
                    lastTouch = scene.convertPoint(fromView: recognizer.location(in: recognizer.view))

                    if direction == .horizontal && row >= 0 {
                        let differenceX = abs(lastTouch.x - penultimateTouch.x)

                        if lastTouch.x >= penultimateTouch.x {
                            //direita
                            for column in playerBoard[row] {
                                column.position.x += differenceX
                            }
                        } else {
                            for column in playerBoard[row] {
                                column.position.x -= differenceX
                            }
                        }
                        update(row: row)
                    } else if direction == .vertical && column >= 0 {
                        let differenceY = abs(lastTouch.y - penultimateTouch.y)

                        if lastTouch.y >= penultimateTouch.y {
                            //cima
                            for row in playerBoard {
                                row[column].position.y += differenceY
                            }
                        } else {
                            for row in playerBoard {
                                row[column].position.y -= differenceY
                            }
                        }

                        update(column: column)
                    }
                }
            } else if recognizer.state == .ended {
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
                    //maior e direita
                    } else if differenceX > (cellsSpacing/2 + cellsSize.width/2) && storeFirstNodePosition.x < playerBoard[row][1].position.x {
                        isMoving = true

                        for column in playerBoard[row]{
                            var newPoint = column.position
                            newPoint.x += (totalDistance - differenceX)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            column.run(move)
                        }

                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                        //menor e esquerda
                    } else if differenceX < (cellsSpacing/2 + cellsSize.width/2) && storeFirstNodePosition.x > playerBoard[row][1].position.x {
                        isMoving = true

                        for column in playerBoard[row]{
                            var newPoint = column.position
                            newPoint.x += (differenceX)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            column.run(move)
                        }

                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                        //maior e esquerda
                    } else if differenceX > (cellsSpacing/2 + cellsSize.width/2) && storeFirstNodePosition.x > playerBoard[row][1].position.x{
                        isMoving = true

                        for column in playerBoard[row]{
                            var newPoint = column.position
                            newPoint.x -= (totalDistance - differenceX)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            column.run(move)
                        }

                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                    }
                } else if direction == .vertical && column >= 0 {
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
                        //maior e direita
                    } else if differenceY > (cellsSpacing/2 + cellsSize.height/2) && storeFirstNodePosition.y < playerBoard[1][column].position.y {
                        isMoving = true

                        for row in playerBoard{
                            var newPoint = row[column].position
                            newPoint.y += (totalDistance - differenceY)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            row[column].run(move)
                        }

                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                        //menor e esquerda
                    } else if differenceY < (cellsSpacing/2 + cellsSize.height/2) && storeFirstNodePosition.y > playerBoard[1][column].position.y {
                        isMoving = true

                        for row in playerBoard{
                            var newPoint = row[column].position
                            newPoint.y += (differenceY)
                            let move = SKAction.move(to: newPoint, duration: 0.2)
                            row[column].run(move)
                        }

                        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.setNotMoving), userInfo: nil, repeats: false)
                        //maior e esquerda
                    } else if differenceY > (cellsSpacing/2 + cellsSize.height/2) && storeFirstNodePosition.y > playerBoard[1][column].position.y {
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
                } else if direction == .horizontal {
                    boardDelegate?.updateMatrixAction(orientation: direction, columnOrRow: row - 1, moves: moves)
                }

                moves = 0
                direction = .neutral
            }
        }
    }

    @objc
    func setNotMoving() {
        isMoving = false
    }

    func getRow(with position: CGPoint) -> Int {

        if (firstTouch.x < playerBoard[1][1].position.x - cellsSize.width/2) ||
            (firstTouch.x > playerBoard[1][playerBoard[1].count-2].position.x + cellsSize.height/2){
            return -1
        }

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

        if (firstTouch.y > playerBoard[1][1].position.y + cellsSize.height/2) ||
            (firstTouch.y < playerBoard[playerBoard.count-2][1].position.y - cellsSize.height/2){
            return -1
        }

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

        let mask = BoardCellShapeNode(rectOf: CGSize(width: (acumWidth + acumHSpacing + cellsSpacing), height: (acumHeight + acumVSpacing + cellsSpacing)))

        mask.fillColor = .black
        mask.position = CGPoint(x: 0, y: midNodeY)
        cropNode.maskNode = mask

        return cropNode
    }

    func blinkColor(from level: Level) {
        for (i, row) in playerBoard.dropFirst().dropLast().enumerated() {
            for (j, cell) in row.dropFirst().dropLast().enumerated() {
                if cell.fillColor.description == level.templateBoard.cellsMatrix[i][j]?.color.description {
                    cell.blinkColor()
                }
            }
        }
    }

    func blinkColor(inRow row: Int, level: Level) {
        for (j, cell) in playerBoard[row + 1].dropFirst().dropLast().enumerated() {
            if cell.fillColor.description == level.templateBoard.cellsMatrix[row][j]?.color.description {
                cell.blinkColor()
            }
        }
    }

    func blinkColor(inColumn column: Int, level: Level) {
        for (i, row) in playerBoard.dropFirst().dropLast().enumerated() {
            if row[column + 1].fillColor.description == level.templateBoard.cellsMatrix[i][column]?.color.description {
                row[column + 1].blinkColor()
            }
        }
    }

    func addSymbolsToMatrix(to matrix: [[BoardCellShapeNode]]) {
        for row in matrix {
            addMissingSymbols(to: row)
        }
    }

    func addMissingSymbols(to destination: [BoardCellShapeNode]) {
        for cell in destination {
            if cell.childNode(withName: "symbol") == nil {
                let symbolName = getSymbolNameFromColor(color: cell.fillColor)
                let newSymbol = SKSpriteNode(imageNamed: symbolName.replacingOccurrences(of: "color", with: "cell"))
                newSymbol.scale(to: CGSize(width: cellsSize.width/3, height: cellsSize.height/3))
                newSymbol.name = "symbol"
                newSymbol.zPosition = 0.01
                cell.addChild(newSymbol)
            }
        }
    }

    func getSymbolNameFromColor(color: UIColor) -> String {
        let newSymbol = color.description

        let nilBoard = Board(board: [[0]])
        for color in nilBoard.colors.values {
            if newSymbol == color.description {
                let keys = (nilBoard.colors as NSDictionary).allKeys(for: color)
                return keys.first as! String
            }
        }
        return "nil"
    }

    func addColorBlindSymbolToCell(from origin: BoardCellShapeNode, to dest: BoardCellShapeNode) {

        if dest.childNode(withName: "symbol") != nil {
            dest.removeAllChildren()
        }
        let colorName = getSymbolNameFromColor(color: origin.fillColor)
        let symbolName = colorName.replacingOccurrences(of: "color", with: "cell")
        let newSymbol = SKSpriteNode(imageNamed: symbolName)
        newSymbol.scale(to: CGSize(width: cellsSize.width/3, height: cellsSize.height/3))
        newSymbol.name = "symbol"
        dest.addChild(newSymbol)
    }
}
