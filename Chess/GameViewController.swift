import UIKit
import SpriteKit
import GameplayKit
import RiveRuntime

class GameViewController: UIViewController {

//    var simpleVM = RiveViewModel(fileName: "pop")
//
//    override func viewWillAppear(_ animated: Bool) {
//        let riveView = simpleVM.createRiveView()
//        view.addSubview(riveView)
//        dump(riveView)
//        riveView.frame = view.frame
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(chessmanTouched(_:)), name: .chessmanTouched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chessBoardTouched(_:)), name: .chessBoardTouched, object: nil)

        let scene = GameScene.newGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    @objc func chessmanTouched(_ notification: Notification) {
        
        if let chessman = notification.object as? ChessMan {
            let possibleMoves = ChessMan.possibleMoves(for: chessman)
            highlightPossibleMoves(moves: possibleMoves)
            chessman.active = true
            ChessBoard.shared?.selectedPiece = chessman
        }
    }
    
    @objc func chessBoardTouched(_ notification: Notification) {
        if let selectedChessman = ChessBoard.shared?.selectedPiece , let square = notification.object as? ChessBoardSquare {
            if let (key, value) = square.deskPosition.first {
                if ChessMan.possibleMoves(for: selectedChessman).contains(where: { $0.0 == key && $0.1 == value }) {
                    selectedChessman.moveAt(letter: value, number: key)
                    ChessBoard.shared?.selectedPiece = nil
                } else {
                    ChessBoardSquare.removeHighlight()
                }
            }
        }
        ChessBoardSquare.removeHighlight()
    }


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func highlightPossibleMoves(moves : [(Int,String)]) {
        for (number, letter) in moves {
            if let square = ChessBoard.shared?.squares[number]?[letter] {
                square.highlight()
            }
        }
    }
}
