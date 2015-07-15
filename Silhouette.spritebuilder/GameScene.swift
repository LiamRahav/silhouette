//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class GameScene: CCNode, WTMGlyphDelegate, CCPhysicsCollisionDelegate {
  // MARK: Variables
  // Code Connections
  weak var line: CCNode!
  weak var character: CCSprite!
  weak var obstacleNode: CCNode!
  weak var gamePhysicsNode: CCPhysicsNode!
  weak var scoreLabel: CCLabelTTF!
  // Obstacle related logic
  var obstacleArray: [Obstacle] = []
  var currentObstacle: Obstacle!
  var glyphDetector: WTMGlyphDetector!
  let numberOfObstaclesInArray = 4
  // Scrolling related logic
  var shouldMove = true
  var scrollSpeed = 2
  let offset = 420 // Blaze it
  let startingObstaclePosition = 420 // Blaze it
  var lastObstaclePosition = 0
  var lastObstacleNodePosition: CGFloat = 0
  // Other
  var audio = OALSimpleAudio.sharedInstance()
  let audioFiles = ["disquiet" : "Disquiet.mp3"]
  var score: Double = 0
  var timer: Double = 0
  var totalTime = 0.8
  // Every time the timer for the shape to disappear is added or removed, set time back to 0
  var timerStarted = false {
    didSet {
      timer = 0
    }
  }
  
  // MARK: Setup Functions
  func didLoadFromCCB() {
    userInteractionEnabled = true
    gamePhysicsNode.collisionDelegate = self
    setUpGlyphDetector()
    setUpObstacleArray(numberOfObstacles: numberOfObstaclesInArray)
  }
  
  func setUpGlyphDetector() {
    glyphDetector = WTMGlyphDetector.detector() as! WTMGlyphDetector
    glyphDetector.delegate = self
    // Remove any (if any) preloaded Glyphs
    glyphDetector.removeAllGlyphs()
    // Load up all of the JSON objects
    for (string, shape) in Obstacle.glyphDict {
      let json = Obstacle.convertGlyphToJSON(shape)
      glyphDetector.addGlyphFromJSON(json, name: string)
    }
  }

  func setUpObstacleArray(#numberOfObstacles: Int) {
    // Spawn the set number of obstacles
    for offsetMultiplier in 0..<numberOfObstacles {
      let newObstacle = CCBReader.load("Obstacle") as! Obstacle
      // Make the obstacle a physics sensor so it can detect collisions but not stop the sprite
      newObstacle.physicsBody.sensor = true
      newObstacle.randomizeCurrentShape()
      // Each obstacle's position is equal to the last's plus the offset
      newObstacle.position = CGPoint(x: startingObstaclePosition + (offsetMultiplier * offset), y: 64)
      obstacleArray.append(newObstacle)
      obstacleNode.addChild(newObstacle)
      lastObstaclePosition = Int(newObstacle.position.x)
    }
  }
  
  // MARK: Update functions
  override func update(delta: CCTime) {
    if shouldMove {
      // Move the node that spawns the obstacles left to simulate movement
      obstacleNode.position = ccp(obstacleNode.position.x - CGFloat(scrollSpeed) , obstacleNode.position.y)
      // The score is equal to the difference of the obstacle node's movement divided by 100 to make it digestible
      score += abs(Double(obstacleNode.position.x - lastObstacleNodePosition) / 100)
      let formattedString = NSString(format: "%.1f", score)
      scoreLabel.string = "\(formattedString)m"
      // If the score is high enough, increase the speed
      if score % 10 == 0 {
        scrollSpeed += 30
      }
      // Set the last position equal to the current one
      lastObstacleNodePosition = obstacleNode.position.x
      // Check for the timer and run the appropriate code
      if timerStarted {
        println(delta)
        timer += Double(delta)
        if timer > totalTime {
          obstacleArray[0].shapeImage.spriteFrame = nil
          timerStarted = false
          // Line below resets the next obstacle's spriteframe for a hacky solution (doesn't work?)
          // obstacleArray[1].shapeImage.spriteFrame = CCSpriteFrame(imageNamed: "assets/\(obstacleArray[1].currentShape.toString.lowercaseString).png")
        }
      }
    }
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.addPoint(touch.locationInWorld())
    timerStarted = true
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.addPoint(touch.locationInWorld())
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.addPoint(touch.locationInWorld())
    glyphDetector.detectGlyph()
    glyphDetector.removeAllPoints()
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.detectGlyph()
    glyphDetector.removeAllPoints()
  }

  // MARK: Callbacks
  func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: CCNode!, obstacle: CCNode!) -> Bool {
    // Stop the sprite from moving
    shouldMove = false
    // Check if the high score should be updated
    var highscore = NSDefaultsManager.getHighscore()
    if score > highscore {
      highscore = score
      NSDefaultsManager.setHighscore(highscore)
    }
    // Load up the game over screen
    let gameOverScreen = CCBReader.load("GameOverScreen") as! GameOverScreen
    let formattedString = NSString(format: "%.1f", highscore)
    gameOverScreen.highscoreLabel.string = "High Score: \(formattedString)m"
    self.addChild(gameOverScreen)
    return true
  }
  
  func glyphDetected(glyph: WTMGlyph!, withScore score: Float) {
    // The glyph is a match if score is over 1.55 and the glyph returned is the same as the intended glyph
    if score > 1.55  && glyph.name.lowercaseString == obstacleArray[0].currentShape.toString.lowercaseString {
      shuffleObstacleArray()
    }
  }
  
  func shuffleObstacleArray() {
    // Randomize current obstacle
    obstacleArray[0].randomizeCurrentShape()
    // Set the current obstacle's position forward
    obstacleArray[0].position.x = CGFloat(lastObstaclePosition + offset)
    lastObstaclePosition = Int(obstacleArray[0].position.x)
    // Add current obstacle to the end of the array
    obstacleArray.append(obstacleArray[0])
    // Delete it from the front of the array
    obstacleArray.removeAtIndex(0)
    // Reset the sprite frame
  }
}
