
import PlaygroundSupport
import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //Set variables for different images, Category, and texts
    let backSprite = SKSpriteNode(imageNamed:"background.png")
    let mainSprite = SKSpriteNode(imageNamed:"subR.png")
    let mainCategory:UInt32 = 0b00011
    
    let fishSprite = SKSpriteNode(imageNamed:"FishR.png")
    var fishSpriteSpeed:CGFloat = 40.0
    let fishCategory:UInt32 = 0b00001
    
    let bigtrashSprite = SKSpriteNode(imageNamed:"biggarbage.png")
    
    let buttonU = SKSpriteNode(imageNamed:"up.png")
    let buttonD = SKSpriteNode(imageNamed:"down.png")
    let buttonL = SKSpriteNode(imageNamed:"left.png")
    let buttonR = SKSpriteNode(imageNamed:"right.png")
    
    let border = SKSpriteNode()
    let border1 = SKSpriteNode()
    
    var currentScore:Int = 0
    let scoreLabel = SKLabelNode(text: "Score: 0")
    var frameCount = 0
    
    let trash1 = Trash()
    let trashCategory:UInt32 = 0b00111
    
    let TrashTimeLeft = SKLabelNode(text: "Time Left: ")
    var trashTime:Int = 25
    
 //If you want collisions between sprites to result in something happening, you need to make sure their contactBitMask is the same.
    
    //This function runs at the start of the game. Use this to set up your scene.
    override func didMove(to view: SKView) {
        
        //This code sets up some physics for the game, including a boundary to the scene so that things don't leave it.
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.3)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        
        //Draws the background of the game
        backSprite.size = CGSize(width: 500, height:500)
        backSprite.color = UIColor.blue
        backSprite.position.x = 250
        backSprite.position.y = 250
        
        self.addChild(backSprite)
        
        //Where all the draw functions are called
        drawSprite()
        drawBorder()
        drawButtons()
        drawScoreLabel()
        drawtrash()
        
        
    } //End didMove
    //These 4 variables makes it so the the sprite changes on the fish and the submarine
    let leftAniFish: SKAction = {
        let leftAniFrames = [SKTexture(imageNamed:"FishL.png")]
        
        return SKAction.animate(with: leftAniFrames, timePerFrame: 0.2, resize: false, restore: true)
    }()
    
    let rightAniFish: SKAction = {
        let rightAniFrames = [SKTexture(imageNamed:"FishR.png")]
        
        return SKAction.animate(with: rightAniFrames, timePerFrame: 0.2, resize: false, restore: true)
    }()
    
    
    let rightAnimationAction: SKAction = {
        
        let rightAnimationFrames = [SKTexture(imageNamed:"subL.png")]
        
        return SKAction.animate(with: rightAnimationFrames, timePerFrame: 0.2, resize: false, restore: true)
        
    }()
    
    let leftAnimationAction: SKAction = {
        
        let leftAnimationFrames = [SKTexture(imageNamed:"subR.png")]
        
        return SKAction.animate(with: leftAnimationFrames, timePerFrame: 0.2, resize: false, restore: true)
        
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //When there is a touch in the scene, do something at the location of the touch.
        //This algorithm would detect whether the user has touched the screen or not
        //The touch would then be put into a complex conditional and checks if the user's input is at the buttons
        //If it is within the buttons bounderies then the submarine would move accordingly
        if let location = touches.first?.location(in: self){ 
            if(location.x > 35 && location.x < 65 && location.y < 470 && location.y > 440){
                mainSprite.physicsBody?.velocity.dy = 70
            }
            
            if(location.x < 40 && location.x > 10 && location.y < 440 && location.y > 410) {
                mainSprite.physicsBody?.velocity.dx = -70
                //mainSprite.run(SKAction.repeatForever(leftAnimationAction))
            }
            
            if(location.x > 60 && location.x < 90 && location.y < 440 && location.y > 410){
                mainSprite.physicsBody?.velocity.dx = 70
                //mainSprite.run(SKAction.repeatForever(rightAnimationAction))
            }
            
            if(location.x > 35 && location.x < 65 && location.y < 410 && location.y > 380) {
                mainSprite.physicsBody?.velocity.dy = -70
            }
            
            
            
        }//end location code
        
        
    } //end touchesBegan
    
    //This function runs when a touch is dragged across the screen.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in:self)
            
        }
        
        
    }// end touchesMoved
    
    //This function runs at the end of a touch of the screen.
    //This algorithm would create a drift effect on the submarine
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in:self)
            //if the mainSprite is moving right and the mouse is released then the velocity decreases to 20
            if(mainSprite.physicsBody!.velocity.dx > 0){
                mainSprite.physicsBody?.velocity.dx = 20
            }//if the mainSprite is moving left and the mouse is released then the velocity decreases to 20
            if(mainSprite.physicsBody!.velocity.dx < 0){
                mainSprite.physicsBody?.velocity.dx = -20
            }//if the mainSprite is moving down and the mouse is released then the velocity decreases to 20
            if(mainSprite.physicsBody!.velocity.dy < 0){
                mainSprite.physicsBody?.velocity.dy = -20
            }//if the mainSprite is moving up and the mouse is released then the velocity decreases to 20
            if(mainSprite.physicsBody!.velocity.dy > 0){
                mainSprite.physicsBody?.velocity.dy = 20
            }
        }
    } //end touchesEnded
    
    //This function runs during every frame of the game. Use this to do things that might happen at specific times in your game.
    override func didFinishUpdate() {
        //This if statement changes the fish's sprite (Left and Right sprites)
        
        //This if statement allows the fish to move on it's own when it touches x:425 and x:75
        if(fishSprite.position.x > 425 || fishSprite.position.x <= 75){
            fishSpriteSpeed *= -1
        }
        fishSprite.physicsBody?.velocity.dx = fishSpriteSpeed
        
        
        //The code below will do something every 500 frames of your game.
        //Every 50 frames(1 second) the trashTime var would -1 and print out the remaining time
        while(frameCount > 50){
            frameCount = 0
            TrashTimeLeft.text = "Time Left: \(trashTime)"
            //if the trashTime is 0 then a new set of trash spawns and resets timer
            if(trashTime == 0){
                drawtrash()
                trashTime = 25
            }
            else{
                trashTime -= 1 
            }
        }
            frameCount += 1
            
        
    }// end didFinishUpdate
    
    //This function runs any time two sprites are in contact with each other.
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        //print("Contact \(bodyA) and \(bodyB)")
        
        //If the fish contacts either the main or the trash sprite then game over screen plays
        if((bodyA == "fish") && (bodyB == "trash")) || ((bodyA == "main") && (bodyB == "fish")){
            fishSprite.removeFromParent()
            gameOver()
        } 
        //If the main sprite contacts the trash sprite then +1 to the Score
        else if((bodyA == "main") && (bodyB == "trash")){
            contact.bodyB.node?.removeFromParent()
            currentScore += 1
            scoreLabel.text = "Score: \(currentScore)"
        }
        
    }// end didBegin
    
    //This function draws the 2 main sprite which is The Submarine and The Fish.
    //Inputs: None, Outputs: Submarine Sprite and Fish Sprite
    //The Submarine Sprite has width of 120 and height of 70 at x:250 and y:155
    //The Fish Sprite has width of 50 and height of 20 at x:250 and y:70
    //Both Sprites are dynamic and not affected by gravity
    func drawSprite(){
        mainSprite.size = CGSize(width:120,height:70)
        mainSprite.position = CGPoint(x:250,y:155)
        mainSprite.physicsBody = SKPhysicsBody(rectangleOf:mainSprite.size)
        mainSprite.physicsBody?.allowsRotation = false
        mainSprite.physicsBody?.isDynamic = true
        mainSprite.name = "main"
        mainSprite.physicsBody?.categoryBitMask = mainCategory
        mainSprite.physicsBody?.contactTestBitMask = fishCategory | trashCategory 
        mainSprite.physicsBody?.affectedByGravity = false
        
        self.addChild(mainSprite)
        
        fishSprite.size = CGSize(width:50,height:20)
        fishSprite.position = CGPoint(x:250,y:70)
        
        fishSprite.physicsBody = SKPhysicsBody(rectangleOf:mainSprite.size)
        fishSprite.physicsBody?.allowsRotation = false
        fishSprite.name = "fish"
        fishSprite.physicsBody?.categoryBitMask = fishCategory
        fishSprite.physicsBody?.contactTestBitMask = mainCategory | trashCategory
        fishSprite.physicsBody?.isDynamic = true
        fishSprite.physicsBody?.affectedByGravity = false
        
        
        self.addChild(fishSprite)
    }
    //This function creates the top border so that the submarine can't go above the sea
    //Inputs: None, Outputs: Draws invisible rectangle
    //This Sprite is not dynamic and has no color
    func drawBorder(){
        border.size = CGSize(width: 500, height: 5)
        border.position.x = 250
        border.position.y = 350
        
        let borderDimensions = CGSize(width: border.size.width, height: border.size.height)
        border.physicsBody = SKPhysicsBody(rectangleOf: borderDimensions)
        border.physicsBody?.isDynamic = false
        
        self.addChild(border)
        
    }
    //This function creates the movement buttons in the game
    //Inputs: None, Outputs: Draws 4 buttons
    //This function creates 4 buttons on the corresponding coordinates
    func drawButtons(){
        buttonU.size = CGSize(width:30,height:30)
        buttonU.position = CGPoint(x:50,y:455)
        
        buttonU.physicsBody?.allowsRotation = false
        buttonU.physicsBody?.isDynamic = false
        
        self.addChild(buttonU)
        
        buttonD.size = CGSize(width:30,height:30)
        buttonD.position = CGPoint(x:50,y:395)
        buttonD.physicsBody?.allowsRotation = false
        buttonD.physicsBody?.isDynamic = false
        
        self.addChild(buttonD)
        
        buttonL.size = CGSize(width:30,height:30)
        buttonL.position = CGPoint(x:25,y:425)
        buttonL.physicsBody?.allowsRotation = false
        buttonL.physicsBody?.isDynamic = false
        
        self.addChild(buttonL)
        
        buttonR.size = CGSize(width:30,height:30)
        buttonR.position = CGPoint(x:75,y:425)
        buttonR.physicsBody?.allowsRotation = false
        buttonR.physicsBody?.isDynamic = false
        
        self.addChild(buttonR)
        
    }
    
    //This function creates 2 text labels
    //One, being the the user's score and the other being the time
    //Inputs: None, Outputs: Draw 2 text labels
    func drawScoreLabel(){
        
        scoreLabel.fontSize = 20.0
        scoreLabel.fontName = "Helvetica Neue Bold"
        scoreLabel.fontColor = .red
        scoreLabel.position = CGPoint(x:400,y:450)
        self.addChild(scoreLabel)
        
        TrashTimeLeft.fontSize = 20.0
        TrashTimeLeft.fontName = "Helvetica Neue Bold"
        TrashTimeLeft.fontColor = .blue
        TrashTimeLeft.position = CGPoint(x:250,y:450)
        self.addChild(TrashTimeLeft)
        
        trashTime -= 1
        
    }
    //This function draws the trash
    //Inputs: None, Outputs: Draws a random amount of trash across the screen everytime it is called
    //This function uses a For loop to draw the trash sprite at a random interval
    func drawtrash(){
        for i in stride(from:20.0, to:480.0, by:CGFloat(Int.random(in: 60...100))){
            let newtrash = Trash()
            newtrash.position = CGPoint(x:i,y:330.0)
            newtrash.physicsBody?.categoryBitMask = trashCategory
            self.addChild(newtrash)
        }
        
    }
    //This function displays the GameOver game scene
    //Inputs: None, Outputs: display game over screen
    //This function is called when the fish dies and would replace the game screen with the game over screen
    func gameOver(){
        let gameOver = GameOverScene(size: self.size)
        let transition = SKTransition.flipHorizontal(withDuration: 3)
        self.view?.presentScene(gameOver,transition: transition)
        
    }
    
}

//Set up the view in the playground.

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 500, height: 500))
let scene = GameScene(size:CGSize(width:500,height:500))
// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFit

// Present the scene
sceneView.presentScene(scene)


PlaygroundSupport.PlaygroundPage.current.liveView = sceneView


