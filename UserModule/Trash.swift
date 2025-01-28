
import SpriteKit


public class Trash: SKSpriteNode {
    
    //let platformHeight:CGFloat = 10.0
    let trashsize:CGFloat = 20.0
    public init(){
        super.init(texture:SKTexture(imageNamed:"biggarbage.png"), color:.clear, size:CGSize(width: trashsize, height: trashsize))
        
        let trashDimensions = CGSize(width: self.size.width, height: self.size.height)
        self.physicsBody = SKPhysicsBody(rectangleOf: trashDimensions)
        self.name = "trash"
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
