import SpriteKit

class ChessMan : SKSpriteNode {
    var sideColor : String = ""
    var deskPosition : [Int:String] = [:]
    var piece : PieceName?
    var active = false
    var firstMove = true

    var imageNamed: String {
        if let piece = piece {
            switch piece {
            case .rook(let color):
                return "rook.\(color)"
            case .knight(let color):
                return "knight.\(color)"
            case .bishop(let color):
                return "bishop.\(color)"
            case .queen(let color):
                return "queen.\(color)"
            case .king(let color):
                return "king.\(color)"
            case .pawn(let color):
                return "pawn.\(color)"
            }
        } else {
            return "defaultImage"
        }
    }
    
    init(piece: PieceName?) {
        print("Trying to access ChessBoard.shared...")
        self.piece = piece
        var imageNamed: String {
            if let piece = piece {
                switch piece {
                case .rook(let color):
                    return "rook.\(color)"
                case .knight(let color):
                    return "knight.\(color)"
                case .bishop(let color):
                    return "bishop.\(color)"
                case .queen(let color):
                    return "queen.\(color)"
                case .king(let color):
                    return "king.\(color)"
                case .pawn(let color):
                    return "pawn.\(color)"
                }
            } else {
                return "defaultImage"
            }
        }
        let texture = SKTexture(imageNamed: imageNamed)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStringValue(pieceName: PieceName) -> String {
        switch pieceName {
        case .king(let value):
            return value
        case .queen(let value):
            return value
        case .rook(let value):
            return value
        case .bishop(let value):
            return value
        case .knight(let value):
            return value
        case .pawn(let value):
            return value
        }
    }
    
    class func possibleMoves(for chessman: ChessMan) -> [(Int, String)] {
        guard chessman.deskPosition.count == 1,
              let letter = chessman.deskPosition.first?.value,
              let number = Int(String(chessman.deskPosition.first!.key)) else {
            print("Invalid chessman position.")
            return []
        }
        
        let letters = ["a", "b", "c", "d", "e", "f", "g", "h"]
        var possibleMoves: [(Int, String)] = []
        
        //need to do the Taking on the pass and after 3 moves displayin the backwards moves!!!
        switch chessman.piece {
        case .pawn(let color):
            let direction: Int
            let homeRank: Int
            if number <= 4 {
                direction = 1
                homeRank = 2
            } else {
                direction = -1
                homeRank = 7
            }
            
            let isFirstMove = number == homeRank
            
            possibleMoves.append((number + direction, String(letter)))

            if isFirstMove {
                possibleMoves.append((number + 2 * direction, String(letter)))
            }

            if let leftDiagonalIndex = letters.firstIndex(of: letter), leftDiagonalIndex != 0 {
                let leftDiagonal = String(letters[leftDiagonalIndex - 1])
                
                if let pieceIsEnemy = isEnemyPieceAt(letter: leftDiagonal, number: number+direction, color: color), pieceIsEnemy == true {
                    possibleMoves.append((number + direction, leftDiagonal))
                }
            }
            if let rightDiagonalIndex = letters.firstIndex(of: letter), rightDiagonalIndex != letters.count - 1 {
                let rightDiagonal = String(letters[rightDiagonalIndex + 1])

                if let pieceIsEnemy = isEnemyPieceAt(letter: rightDiagonal, number: number+direction, color: color), pieceIsEnemy == true {
                    possibleMoves.append((number + direction, rightDiagonal))
                }
            }
        case .knight(let color):
            let knightMoves = [(2, 1), (2, -1), (-2, 1), (-2, -1), (1, 2), (1, -2), (-1, 2), (-1, -2)]
              for move in knightMoves {
                  let y = number + move.1
                  let x = Int(letters.firstIndex(of: letter)!) + move.0
                  if ((y < 0 || y > 8) || (x < 0 || x > 7)){
                      continue
                  } else if (letters[x] == nil  || y == 0) {
                      continue
                  }
                  let pieceIsEnemy = isEnemyPieceAt(letter: letters[x], number: y, color: color)
                  if pieceIsEnemy == nil || pieceIsEnemy == true {
                      possibleMoves.append((y, letters[x]))
                  }
              }
        case .bishop(let color):
            for direction in [(1, 1), (1, -1), (-1, 1), (-1, -1)] {
                for i in 1...7 {
                    let newNumber = number + i * direction.0
                    if let fileIndex = letters.firstIndex(of: letter), fileIndex + i * direction.1 >= 0 && fileIndex + i * direction.1 < letters.count {
                        let newLetter = String(letters[fileIndex + i * direction.1])
                        if newNumber >= 1 && newNumber <= 8 {
                            let pieceIsEnemy = isEnemyPieceAt(letter: newLetter, number:newNumber, color: color)
                            if pieceIsEnemy == nil {
                                possibleMoves.append((newNumber, newLetter))
                            } else if pieceIsEnemy == true {
                                possibleMoves.append((newNumber, newLetter))
                                break
                            } else if pieceIsEnemy == false {
                                break
                            }
                        }
                    }
                }
            }
        case .rook(let color):
            for direction in [(1, 0), (0, 1), (-1, 0), (0, -1)] {
                for i in 1...7 {
                    let newNumber = number + i * direction.0
                    if let fileIndex = letters.firstIndex(of: letter), fileIndex + i * direction.1 >= 0 && fileIndex + i * direction.1 < letters.count {
                        let newLetter = String(letters[fileIndex + i * direction.1])
                        if newNumber >= 1 && newNumber <= 8 {
                            let pieceIsEnemy = isEnemyPieceAt(letter: newLetter, number:newNumber, color: color)
                            if pieceIsEnemy == nil {
                                possibleMoves.append((newNumber, newLetter))
                            } else if pieceIsEnemy == true {
                                possibleMoves.append((newNumber, newLetter))
                                break
                            } else if pieceIsEnemy == false {
                                break
                            }
                        }
                    }
                }
            }
        case .queen(let color):
            let queenMoves = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
            for move in queenMoves {
                var i = 1
                while true {
                    let newRank = number + i * move.0
                    let newFileIndex = letters.firstIndex(of: letter)! + i * move.1
                    if newRank >= 1 && newRank <= 8 && newFileIndex >= 0 && newFileIndex < 8 {
                        let newLetter = String(letters[newFileIndex])
                        let pieceIsEnemy = isEnemyPieceAt(letter: newLetter, number:newRank, color: color)
                        if pieceIsEnemy == nil {
                            possibleMoves.append((newRank, newLetter))
                        } else if pieceIsEnemy == true {
                            possibleMoves.append((newRank, newLetter))
                            break
                        } else if pieceIsEnemy == false {
                            break
                        }
                        possibleMoves.append((newRank, newLetter))
                        i += 1
                    } else {
                        break
                    }
                }
            }
        //make castling
        case .king(let color):
            let kingMoves = [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)]
            for move in kingMoves {
                let newRank = number + move.0
                let newFileIndex = letters.firstIndex(of: letter)! + move.1
                if newRank >= 1 && newRank <= 8 && newFileIndex >= 0 && newFileIndex < 8 {
                    let newLetter = String(letters[newFileIndex])
                    dump(isEnemyPieceAt(letter: newLetter, number: newRank, color: color))
                    let pieceIsEnemy = isEnemyPieceAt(letter: newLetter, number: newRank, color: color)
                    if pieceIsEnemy == nil {
                        possibleMoves.append((newRank, newLetter))
                    } else if pieceIsEnemy == true {
                        possibleMoves.append((newRank, newLetter))
                    }
                }
            }
        case .none:
            print("none")
        }
        
        return possibleMoves
    }
    
    func moveAt(letter: String, number: Int) {
        if let chessBoard = ChessBoard.shared, let square = chessBoard.squares[number]?[letter] {
            if let color = self.piece?.color, color == chessBoard.currentTurnCollor {
                let currentPositionInBoard = self.convert(self.position, to: chessBoard)
                
                self.removeFromParent()
                
                chessBoard.addChild(self)
                
                self.position = currentPositionInBoard
                
                let targetPositionInBoard = square.position
                
                let moveAction = SKAction.move(to: targetPositionInBoard, duration: 0.6)
                
                let reparentPiece = SKAction.run {
                    self.removeFromParent()
                    square.addChild(self)
                    self.position = CGPoint(x: 0, y: 0)
                }
                
                let sequence = SKAction.sequence([moveAction, reparentPiece])
                
                if let (key,value) = self.deskPosition.first {
                    ChessBoard.shared?.desk[key]?[value] = nil
                    ChessBoard.shared?.desk[number]?[letter] = self
                    self.deskPosition[key] = nil
                    self.deskPosition[number] = letter
                    self.firstMove = false
                    chessBoard.currentTurnCollor = color == "white" ? "black" : "white"
                }
                self.run(sequence)
            }
        }
    }
    
    static func isEnemyPieceAt(letter: String, number: Int, color: String) -> Bool? {
        if let chessman = ChessBoard.shared?.desk[number]?[letter] {
            if chessman.piece!.color != color {
                return true
            }
            return false
        }
        return nil
    }
        
            
    override var description: String {
        if let piece = piece {
            switch piece {
            case .rook(let color):
                return "Rook \(color)"
            case .knight(let color):
                return "Knight \(color)"
            case .bishop(let color):
                return "Bishop \(color)"
            case .queen(let color):
                return "Queen \(color)"
            case .king(let color):
                return "King \(color)"
            case .pawn(let color):
                return "Pawn \(color)"
            }
        } else {
            return "-"
        }
    }
    
    static func isAnyChessmanActive() -> Bool {
        let chessmans = ChessBoard.shared?.desk
        if let chessmans = chessmans {
            for (_, stringChessmanDict) in chessmans {
                for (_, chessman) in stringChessmanDict {
                    if (chessman.active == true){
                        return true
                    }
                }
            }
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ChessMan.isAnyChessmanActive() == true {
            NotificationCenter.default.post(name: .chessBoardTouched, object: self)
        }
        NotificationCenter.default.post(name: .chessmanTouched, object: self)
    }
}
