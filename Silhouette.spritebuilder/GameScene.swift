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
  let numberOfObstaclesInArray = 5
  // Scrolling related logic
  var shouldMove = true
  var scrollSpeed = 2
  var offset = 350
  var startingObstaclePosition = 420 // Blaze it
  var lastObstaclePosition = 0
  // Other
  var audio = OALSimpleAudio.sharedInstance()
  let audioFiles = ["disquiet" : "Disquiet.mp3"]
  var score: Double = 0
  
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
    
    for (string, shape) in Obstacle.glyphDict {
      let json = Obstacle.convertGlyphToJSON(shape)
      glyphDetector.addGlyphFromJSON(json, name: string)
    }
  }
  
  func setUpObstacleArray(#numberOfObstacles: Int) {
    for offsetMultiplier in 0..<numberOfObstacles {
      let newObstacle = CCBReader.load("Obstacle") as! Obstacle
      newObstacle.physicsBody.sensor = true
      newObstacle.randomizeCurrentShape()
      newObstacle.position = CGPoint(x: startingObstaclePosition + (offsetMultiplier * offset), y: 64)
      obstacleArray.append(newObstacle)
      obstacleNode.addChild(newObstacle)
      lastObstaclePosition = Int(newObstacle.position.x)
    }
  }
  
  // MARK: Update functions
  override func update(delta: CCTime) {
    if shouldMove {
      obstacleNode.position = ccp(obstacleNode.position.x - CGFloat(scrollSpeed) , obstacleNode.position.y)
      score += 0.1
      let formattedString = NSString(format: "%.1f", score)
      scoreLabel.string = "\(formattedString)m"
    }
  }
  
  func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: CCNode!, obstacle: CCNode!) -> Bool {
    shouldMove = false
    let gameOverScreen = CCBReader.load("GameOverScreen") as! GameOverScreen
    self.addChild(gameOverScreen)
    return true
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.addPoint(touch.locationInWorld())
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.addPoint(touch.locationInWorld())
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.addPoint(touch.locationInWorld())
    glyphDetector.detectGlyph()
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.detectGlyph()
  }
  
  // MARK: Callbacks
  func glyphDetected(glyph: WTMGlyph!, withScore score: Float) {
    if score > 1.55  && glyph.name.lowercaseString == obstacleArray[0].currentShape.toString.lowercaseString {
      println("PASS")
      shuffleObstacleArray()
    } else {
      println("FAIL")
    }
    glyphDetector.removeAllPoints()
  }
  
  func shuffleObstacleArray() {
    // Randomize it
    obstacleArray[0].randomizeCurrentShape()
    // Set the current obstacle's position forward
    obstacleArray[0].position.x = CGFloat(lastObstaclePosition + offset)
    lastObstaclePosition = Int(obstacleArray[0].position.x)
    // Add it to the end of the array
    obstacleArray.append(obstacleArray[0])
    // Delete it from the front of the array
    obstacleArray.removeAtIndex(0)
  }

}
