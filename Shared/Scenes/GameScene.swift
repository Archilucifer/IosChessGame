import SpriteKit

class GameScene: SKScene {
    
    
    fileprivate var label : SKLabelNode?
    fileprivate var spinnyNode : SKShapeNode?
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        ChessBoard.createSharedInstance(size: UIScreen.main.bounds.size)
        addChild(ChessBoard.shared!)
        
//        print(ChessMan.possibleMoves(for: ChessBoard.shared.drawOneChessman(letter: "e", number: 1, type: PieceName.king(color: "black"))))

    }

    func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
