//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class GameScene: CCNode, WTMGlyphDelegate {
  weak var line: CCNode!
  weak var obstacleNode: CCNode!
  var obstacleArray: [Obstacle] = []
  var currentObstacle: Obstacle!
  var glyphDetector: WTMGlyphDetector!
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    setUpGlyphDetector()
    setUpObstacleArray(numberOfObstacles: 5)
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
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    touchParticleEffect(touch)
    glyphDetector.addPoint(touch.locationInWorld())
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    touchParticleEffect(touch)
    glyphDetector.addPoint(touch.locationInWorld())
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    touchParticleEffect(touch)
    glyphDetector.addPoint(touch.locationInWorld())
    glyphDetector.detectGlyph()
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.detectGlyph()
  }
  
  func touchParticleEffect(touch: CCTouch) {
    let touchParticle = CCBReader.load("TouchParticle") as! CCParticleSystem
    touchParticle.autoRemoveOnFinish = true
    touchParticle.position = CGPoint(x: touch.locationInWorld().x, y: touch.locationInWorld().y)
    self.addChild(touchParticle)
  }
  
  func glyphDetected(glyph: WTMGlyph!, withScore score: Float) {
    if score > 1.75  && glyph.name.lowercaseString == obstacleArray[0].currentShape.toString.lowercaseString {
      println("PASS")
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
