//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class GameScene: CCNode, WTMGlyphDelegate, CCPhysicsCollisionDelegate {
  // MARK: - Variables
  // Code Connections
  weak var line: CCNode!
  weak var character: CCSprite!
  weak var obstacleNode: CCNode!
  weak var gamePhysicsNode: CCPhysicsNode!
  weak var scoreLabel: CCLabelTTF!
  weak var pauseScreen: PauseScreen!
  weak var gameOverScreen: GameOverScreen!
  weak var flash: CCNodeColor!
  // Obstacle related logic
  var obstacleArray: [Obstacle] = []
  var glyphDetector: WTMGlyphDetector!
  let numberOfObstaclesInArray = 15
  var shouldCollide = true
  // Scrolling related logic
  var shouldMove = true
  var scrollSpeed: Double = 3
  let offset = 600
  let startingObstaclePosition = 640
  var lastObstaclePosition = 0
  var lastObstacleNodePosition: CGFloat = 0
  var timeBeforeMoveToFront: Double = 7.5
  // Timer related logic
  var timer: Double = 0
  var totalTime: Double = 1
  var timerStarted = false
  var timeElapsed: CGFloat = 0.1
  var isPaused = false
  let randomIncreaseArea = arc4random_uniform(10) + 40
  let howOftenForIncrease = 15
  var timesOccurred = 0
  let timeForFadeOut = 0.5
  // Other variables
  var audio = OALSimpleAudio.sharedInstance()
  let audioFiles = ["disquiet" : "Disquiet.mp3"]
  var score: Double = 0
  var lastObstacleForDisappear: Obstacle?
  var shouldPause = true
  
  // MARK: - Setup Functions
  func didLoadFromCCB() {
    userInteractionEnabled = true
    gamePhysicsNode.collisionDelegate = self
    gameOverScreen.parentGameScene = self
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
    // Load the reverse triangle to make the triangle detection work properly
    glyphDetector.addGlyphFromJSON(Obstacle.convertNonGlyphToJSON("reversetriangle"), name: "ReverseTriangle")
  }

  func setUpObstacleArray(#numberOfObstacles: Int) {
    // Spawn the set number of obstacles
    for offsetMultiplier in 0..<numberOfObstacles {
      let newObstacle = CCBReader.load("Obstacle") as! Obstacle
      // Make the obstacle a physics sensor so it can detect collisions but not stop the sprite
      newObstacle.physicsBody.sensor = true
      newObstacle.randomizeCurrentShape()
      // Each obstacle's position is equal to the last's plus the offset
      newObstacle.position = CGPoint(x: startingObstaclePosition + (offsetMultiplier * offset), y: 33)
      obstacleArray.append(newObstacle)
      obstacleNode.addChild(newObstacle)
      lastObstaclePosition = Int(newObstacle.position.x)
    }
  }
  
  // MARK: - Update functions
  override func update(delta: CCTime) {
    if shouldMove {
      // Move the node that spawns the obstacles left to simulate movement
      obstacleNode.position = ccp(obstacleNode.position.x - CGFloat(scrollSpeed) , obstacleNode.position.y)
      // The score is equal to the difference of the obstacle node's movement divided by 100 to make it digestible
      score += abs(Double(obstacleNode.position.x - lastObstacleNodePosition) / 100)
      let formattedString = NSString(format: "%.1f", score)
      scoreLabel.string = "\(formattedString)m"
      // Set the last position equal to the current one
      lastObstacleNodePosition = obstacleNode.position.x
      // Set everything according to time
      checkForTimer(Double(delta))
      timeElapsed += CGFloat(delta)
      DificultyManager.increaseDificulty(self, score: score, randomIncreaseArea: Int(randomIncreaseArea), often: howOftenForIncrease, timesOccured: timesOccurred)
      }
  }

  func checkForTimer(delta: Double) {
    if timerStarted && !isPaused {
      timer += delta
      if timer > totalTime - timeForFadeOut {
        lastObstacleForDisappear!.shapeImage.runAction(CCActionFadeOut(duration: timeForFadeOut))
        lastObstacleForDisappear = nil
        timerStarted = false
        timer = 0
      }
    }
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.addPoint(touch.locationInWorld())
    if !timerStarted {
      timerStarted = true
      lastObstacleForDisappear = obstacleArray[0]
    }
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

  // MARK: - Callbacks
  func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: CCNode!, obstacle: CCNode!) -> ObjCBool {
    if shouldCollide {
     triggerGameOver()
    } else {
      shouldCollide = true
    }
    return true
  }

  func triggerGameOver() {
    // Stop the sprite from moving and shapes from being detected
    shouldMove = false
    glyphDetector.removeAllGlyphs()
    // Stop the pause button from working
    shouldPause = false
    // Check if the high score should be updated
    var highscore = NSDefaultsManager.getHighscore()
    if score > highscore {
      highscore = score
      NSDefaultsManager.setHighscore(highscore)
    }
    // TODO: Actually solve this bug rather than use this hacky solution
    schedule("gameOverHackSolution", interval: 0.1)
  }
  
  func gameOverHackSolution() {
    // Move the gameOverScreen to the middle
    animationManager.runAnimationsForSequenceNamed("Game Over")
    schedule("makeFlashInvisible", interval: 0.5)
    let formattedString = NSString(format: "%.1f", NSDefaultsManager.getHighscore())
    gameOverScreen.highscoreLabel.string = "High Score: \(formattedString)m"
    gameOverScreen.scoreLabel.string = "Score: \(scoreLabel.string)"
    userInteractionEnabled = false
    
    unschedule("gameOverHackSolution")
  }
  
  func makeFlashInvisible() {
    flash.visible = false
    unschedule("makeFlashInvisible")
  }
  
  func glyphDetected(glyph: WTMGlyph!, withScore score: Float) {
    // The glyph is a match if score is over 1.55 and the glyph returned is the same as the intended glyph
    if score > 1.8  && glyph.name.lowercaseString == obstacleArray[0].currentShape.toString.lowercaseString {
      obstacleArray[0].animationManager.runAnimationsForSequenceNamed("Gate Up")
      shuffleObstacleArray()
    } else if score > 1.8 && glyph.name.lowercaseString == "reversetriangle" && obstacleArray[0].currentShape.toString.lowercaseString == "triangle" {
      obstacleArray[0].animationManager.runAnimationsForSequenceNamed("Gate Up")
      shuffleObstacleArray()
    }
  }
  
  func shuffleObstacleArray() {
    obstacleArray[0].shapeImage.spriteFrame = nil
    // Add current obstacle to the end of the array
    obstacleArray.append(obstacleArray[0])
    // Delete it from the front of the array
    obstacleArray.removeAtIndex(0)
    // Schedule the movement of the last one to the front so that the sprite can move through
    self.schedule("moveLastObstacleToFront", interval: CCTime(timeBeforeMoveToFront))
    shouldCollide = false
    timer = 0
  }
  
  func moveLastObstacleToFront() {
    // Set the current obstacle's position forward
    obstacleArray[obstacleArray.count - 1].position.x = CGFloat(lastObstaclePosition + offset)
    lastObstaclePosition = Int(obstacleArray[obstacleArray.count - 1].position.x)
    // Randomize current obstacle
    obstacleArray[obstacleArray.count - 1].randomizeCurrentShape()
    // Make sure that all obstacles have an image loaded
    obstacleArray[obstacleArray.count - 1].animationManager.runAnimationsForSequenceNamed("Default Timeline")
    for o in obstacleArray {
      if o.shapeImage.spriteFrame == nil {
        o.shapeImage.spriteFrame = CCSpriteFrame(imageNamed: "assets/shapes/\(o.currentShape.toString.lowercaseString).png")
      }
    }
    self.unschedule("moveLastObstacleToFront")
  }
  
  func pause() {
    if shouldPause {
      shouldMove = false
      isPaused = true
      shouldPause = false
      userInteractionEnabled = false
      // Move in the pause screen
      pauseScreen.parentNode = self
      animationManager.runAnimationsForSequenceNamed("Pause")
    }
  }
}
