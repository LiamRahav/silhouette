//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class GameSceneCopy: CCNode, WTMGlyphDelegate {
  weak var line: CCNode!
  weak var obstacleNode: CCNode!
  var currentObstacle: Obstacle!
  var glyphDetector: WTMGlyphDetector!
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    setUpGlyphDetector()
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
    
  }

}
