//
//  ChessBoardSquare.swift
//  Chess iOS
//
//  Created by Алина Дзюба on 18.05.2023.
//

import SpriteKit

class ChessBoardSquare : SKSpriteNode {
    let colorBlackOrWhite : UIColor
    var deskPosition: [Int:String] = [:]
    
    init(color: UIColor, size: CGSize) {
        colorBlackOrWhite = color
        super.init(texture: nil, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight() {
        self.color = SKColor.yellow // Use any color you like
    }
    
    static func removeHighlight() {
        let squares = ChessBoard.shared?.squares
        if let squares = squares {
            for (_, stringSquareDict) in squares {
                for (_, square) in stringSquareDict {
                    if square.color != square.colorBlackOrWhite {
                        square.color = square.colorBlackOrWhite
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: .chessBoardTouched, object: self)
    }
}
