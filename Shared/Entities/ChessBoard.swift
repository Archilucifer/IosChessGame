//
//  ChessBoard.swift
//  Chess iOS
//
//  Created by Алина Дзюба on 18.05.2023.
//

import SpriteKit

class ChessBoard: SKNode {

    static var shared: ChessBoard!

    var desk: [Int:[String:ChessMan]] = [:]
    var squares: [Int:[String:ChessBoardSquare]] = [:]
    let rows = 8
    let columns = 8
    var squareSize: CGFloat = 0
    var width : CGFloat = 0
    let letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
    var selectedPiece: ChessMan?
    var currentTurnCollor = "white"
    
    public init(size: CGSize) {
        print("Initializing ChessBoard.shared...")
        super.init()
        
        for i in 1...rows {
            desk[i] = [:]
            squares[i] = [:]
        }
        
        width = size.width
        self.squareSize = min(size.width, size.height) / CGFloat(rows)
        self.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        drawChessBoard()
        drawLabels()
        drawChessMans()
        
        printDesk()
//        print(ChessMan.possibleMoves(for: drawOneChessman(letter: "h", number: 2, type: PieceName.pawn(color: "black"))))
//        printSuares()
    }
    
    static func createSharedInstance(size: CGSize) {
        print("ChessBoard.shared is now initialized.")
        self.shared = ChessBoard(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawChessBoard() {
        for row in 0..<rows {
            for column in 0..<columns {
                let square = ChessBoardSquare(color: (row + column) % 2 == 0 ? #colorLiteral(red: 0.9107439518, green: 0.9293574691, blue: 0.9769852757, alpha: 1) : #colorLiteral(red: 0.7155439258, green: 0.75275141, blue: 0.8476842046, alpha: 1), size: CGSize(width: squareSize, height: squareSize))
                square.position = CGPoint(x: -CGFloat(column) * squareSize - (CGFloat(width) - CGFloat(rows) * squareSize) / 2 - squareSize / 2, y: -CGFloat(row) * squareSize - CGFloat(rows) / 2 * squareSize - squareSize / 2)
                            
                square.isUserInteractionEnabled = true
                square.deskPosition[rows-row] = letters[7-column]
                self.squares[rows-row, default: [:]][letters[7-column]] = square
                self.addChild(square)
            }
        }
    }
    
    private func drawLabels() {
        let numbers = ["1", "2", "3", "4", "5", "6", "7", "8"]
        
            for row in 0..<rows {
                let letterLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
                letterLabel.text = letters[7-row]
                letterLabel.fontSize = CGFloat(squareSize / 4)
                letterLabel.position = CGPoint(x: -CGFloat(row) * squareSize - (CGFloat(width) - CGFloat(rows) * squareSize) / 2 - squareSize / CGFloat(rows), y: -CGFloat(rows) / 2 * squareSize - width + squareSize / CGFloat(rows) - 3)
                letterLabel.fontColor =  (row + 2) % 2 == 0 ? #colorLiteral(red: 0.9107439518, green: 0.9293574691, blue: 0.9769852757, alpha: 1) : #colorLiteral(red: 0.7155439258, green: 0.75275141, blue: 0.8476842046, alpha: 1)
                self.addChild(letterLabel)
                
                let numberLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
                numberLabel.text = numbers[7-row]
                numberLabel.fontSize = CGFloat(squareSize / 4)
                numberLabel.position = CGPoint(x: -squareSize * CGFloat(rows) + squareSize / CGFloat(rows), y: -CGFloat(row) * squareSize - width / 2 - squareSize / CGFloat(rows) - CGFloat(rows))
                numberLabel.fontColor =  (row + 2) % 2 == 0 ? #colorLiteral(red: 0.9107439518, green: 0.9293574691, blue: 0.9769852757, alpha: 1) : #colorLiteral(red: 0.7155439258, green: 0.75275141, blue: 0.8476842046, alpha: 1)
                self.addChild(numberLabel)
            }
        }
    
    private func drawChessMans() {
        let sides = ["white", "black"]
        let bottomSide = sides[Int.random(in: 0...1)]
        let topSide: String = (bottomSide == "white") ? "black" : "white"
        
        for row in 1...rows {
            for column in 1...columns {

                let currentSide: String = (row > 4) ? topSide : bottomSide
                if row == 2 || row == 7 {
                    let chessMan = ChessMan(piece: PieceName.pawn(color: currentSide))
                    buildChessman(row : row, column: column, chessMan: chessMan)
                } else if row == 1 || row == 8 {
                    switch column {
                    case 1, 8:
                        let chessMan = ChessMan(piece: PieceName.rook(color: currentSide))
                        buildChessman(row : row, column: column, chessMan: chessMan)
                    case 2, 7:
                        let chessMan = ChessMan(piece: PieceName.knight(color: currentSide))
                        buildChessman(row : row, column: column, chessMan: chessMan)
                    case 3, 6:
                        let chessMan = ChessMan(piece: PieceName.bishop(color: currentSide))
                        buildChessman(row : row, column: column, chessMan: chessMan)
                    case 4:
                        if (row + column) % 2 == 0 {
                            let chessMan = ChessMan(piece: (currentSide == "white") ? .queen(color: currentSide) : .king(color: currentSide))
                            buildChessman(row : row, column: column, chessMan: chessMan)
                        } else {
                            let chessMan = ChessMan(piece: (currentSide == "black") ? .queen(color: currentSide) : .king(color: currentSide))
                            buildChessman(row : row, column: column, chessMan: chessMan)
                        }
                    case 5:
                        if (row + column) % 2 == 0 {
                            let chessMan = ChessMan(piece: (currentSide == "white") ? .queen(color: currentSide) : .king(color: currentSide))
                            buildChessman(row : row, column: column, chessMan: chessMan)
                        } else {
                            let chessMan = ChessMan(piece: (currentSide == "black") ? .queen(color: currentSide) : .king(color: currentSide))
                            buildChessman(row : row, column: column, chessMan: chessMan)
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    
    subscript(alpha: String, number: Int) -> ChessMan? {
        get{
            if let chessman = desk[number]?[alpha] {
                return chessman
            }
            return nil
        }
    }
    
    private func buildChessman(row : Int, column : Int, chessMan: ChessMan) {
        let letter =  letters[column-1]
        let square = squares[row]?[letter]
//        print("\(row)\(letter): \(square?.position)")
        chessMan.deskPosition = [row : letter]
        chessMan.position = CGPoint(x: 0, y: 0)
        chessMan.size = CGSize(width: (square?.size.width)! / 1.3, height: (square?.size.height)! / 1.3)
        
        chessMan.isUserInteractionEnabled = true
        self.desk[row, default: [:]][letters[column-1]] = chessMan
        square?.addChild(chessMan)
    }
    
    //delete
    public func printDesk(){
        for row in 1...8 {
            var rowDesc = "Row \(row): "
            for column in ["a", "b", "c", "d", "e", "f", "g", "h"] {
                let chessman = desk[row]?[column]
                let chessManName = chessman?.description ?? "-"
                rowDesc += "[\(column): \(chessManName)]"
            }
            print(rowDesc)
        }
    }
    
    //delete
    public func printSuares(){
        for row in 1...8 {
            var rowDesc = "Row \(row): "
            for column in ["a", "b", "c", "d", "e", "f", "g", "h"] {
                let square = squares[row]?[column]!
                rowDesc += "[\(column): \(square?.position.x),\(square?.position.y)] "
            }
            print(rowDesc)
        }
    }
    
    //delete
    public func drawOneChessman(letter: String, number: Int, type: PieceName) -> ChessMan{
        let chessMan = ChessMan(piece: type)
        buildChessman(row : number, column: letters.firstIndex(of: letter)! + 1, chessMan: chessMan)
        return chessMan
    }
}

enum PieceName {
    case king(color: String)
      case queen(color: String)
      case rook(color: String)
      case bishop(color: String)
      case knight(color: String)
      case pawn(color: String)
      
      var color: String {
          switch self {
          case .king(let color), .queen(let color), .rook(let color), .bishop(let color), .knight(let color), .pawn(let color):
              return color
          }
      }
}

enum Side {
    case white
    case black
}
