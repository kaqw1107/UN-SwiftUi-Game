
import Foundation
import SpriteKit

public class GameOverScene: SKScene{
    let ggSprite = SKLabelNode(text:"GAME OVER - FISH IS DEAD")
    
    public override func didMove(to view: SKView){
        backgroundColor = .systemBlue
        ggSprite.fontSize = 28
        ggSprite.position = CGPoint(x:250,y:250)
        self.addChild(ggSprite)
        
    }
    
    
}
