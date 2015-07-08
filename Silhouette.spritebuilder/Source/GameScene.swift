//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class GameScene: CCNode, WTMGlyphDelegate {
  // Sample obstalce used to test shape recognition
  weak var line: CCNode!
  weak var obstacleNode: CCNode!
  var currentObstacle: Obstacle!
  var obstacleList: [Obstacle] = [] {
    didSet {
      currentObstacle = obstacleList[0]
    }
  }
  var distanceBetweenObstacles: CGFloat = 320
  
  var glyphDetector: WTMGlyphDetector!
  var jsonDict: [String:NSData] = ["":NSData()]
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    
    // Populate obstacle list 
    obstacleList.append(CCBReader.load("Obstacle") as! Obstacle)
    for _ in 0...4 {
      addNewObstacle()
    }
    
    initGestureDetector()
  }
  
  func addNewObstacle() {
    var previousObstaclePosition = currentObstacle.position.x
    if obstacleList.count > 0 {
      previousObstaclePosition = obstacleList.last!.position.x
    }
    
    let obstacle = CCBReader.load("Obstacle") as! Obstacle
    obstacle.position = ccp(previousObstaclePosition + distanceBetweenObstacles, line.position.y)
    obstacleNode.addChild(obstacle)
    obstacleList.append(obstacle)
  }
  
  func initGestureDetector() {
    // Load up a glyphDetector from Obj-C lib
    glyphDetector = WTMGlyphDetector.detector() as! WTMGlyphDetector
    glyphDetector.delegate = self
    // Just to be safe, make sure the Glyph detector is empty when they load in
    glyphDetector.removeAllGlyphs()
    
    for (str, shape) in currentObstacle.glyphDict {
      let json = currentObstacle.convertGlyphToJSON(shape)
      
      // This line is for only having 1 glyph loaded at a time
//      jsonDict[str] = json
      
      // This line is for having all glyphs loaded at the same time
      glyphDetector.addGlyphFromJSON(json, name: shape.toString)
    }
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
    
    // Add a single glyph to test against when their touch ends
//    glyphDetector.addGlyphFromJSON(jsonDict[testObstacle.currentShape.toString], name: testObstacle.currentShape.toString)
    
    glyphDetector.detectGlyph()
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    
    // Add a single glyph to test against when their touch ends
//    glyphDetector.addGlyphFromJSON(jsonDict[testObstacle.currentShape.toString], name: testObstacle.currentShape.toString)
    
    glyphDetector.detectGlyph()
  }
  
  func touchParticleEffect(touch: CCTouch) {
    let touchParticle = CCBReader.load("TouchParticle") as! CCParticleSystem
    touchParticle.autoRemoveOnFinish = true
    touchParticle.position = CGPoint(x: touch.locationInWorld().x, y: touch.locationInWorld().y)
    self.addChild(touchParticle)
  }
  
  func glyphDetected(glyph: WTMGlyph!, withScore score: Float) {
    
    println("\nUSER'S POINTS: \(glyphDetector.points)")
    println("\nSHAPE: \(glyph.name)")
    println("\nSCORE: \(score)")
    
    if score >= 1.5 && glyph.name.lowercaseString == currentObstacle.shapeLabel.string.lowercaseString {
      println("\nPASS\n\n")
    } else {
      println("\nFAIL\n")
    }
    
    var glyphDict = currentObstacle.glyphDict
    glyphDict.removeValueForKey(currentObstacle.currentShape.toString)
    let keysArray = glyphDict.keys.array
    currentObstacle.currentShape = glyphDict[keysArray[Int(arc4random_uniform(UInt32(keysArray.count)))]]!
    
    // Remove all glyphs to make sure only 1 will be loaded at a time
//    glyphDetector.removeAllGlyphs()
    
    glyphDetector.removeAllPoints()
  }
  
}