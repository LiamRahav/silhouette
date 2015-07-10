//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class GameScene: CCNode, WTMGlyphDelegate {
  // MARK: Variables
  // Code Connections
  weak var line: CCNode!
  weak var character: CCSprite!
  weak var obstacleNode: CCNode!
  // Obstacle related logic
  var obstacleArray: [Obstacle] = []
  var currentObstacle: Obstacle!
  var glyphDetector: WTMGlyphDetector!
  let numberOfObstaclesInArray = 5
  // Scrolling related logic
  var shapeCorrect = false
  var scrollSpeed = 20
  
  // MARK: Setup Functions
  func didLoadFromCCB() {
    userInteractionEnabled = true
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
    for _ in 1...numberOfObstacles {
      let newObstacle = CCBReader.load("Obstacle") as! Obstacle
      newObstacle.randomizeCurrentShape()
      newObstacle.position = CGPoint(x: 350, y: 64)
      obstacleArray.append(newObstacle)
    }
    obstacleNode.addChild(obstacleArray[0])
  }
  
  // MARK: Update functions
  override func update(delta: CCTime) {
    super.update(delta)
    // Check if the player hits the obstacle in front of them
    if character.position.x + (character.contentSize.width / 2) == obstacleArray[0].position.x {
      if shapeCorrect {
        shapeCorrect = false
      } else {
        println("GAME OVER")
      }
    }
    moveWorld()
  }
  
  func moveWorld() {
    obstacleNode.position = ccp(obstacleNode.position.x - 5 , obstacleNode.position.y)
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
      shapeCorrect = true
    } else {
      println("FAIL")
    }
    glyphDetector.removeAllPoints()
    shuffleObstacleArray()
    for o in obstacleArray {
      println(o.currentShape.toString)
    }
  }
  
  func shuffleObstacleArray() {
    let o = obstacleArray[0]
    obstacleArray.removeAtIndex(0)
    o.randomizeCurrentShape()
    obstacleArray.append(o)
    obstacleNode.removeAllChildren()
    obstacleNode.addChild(obstacleArray[0])
  }

}
