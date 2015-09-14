//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class TutorialScene: CCNode, WTMGlyphDelegate {
  weak var leftObstacle: CCNode!
  weak var rightObstacle: Obstacle!
  var glyphDetector: WTMGlyphDetector!
  
  override func onEnter() {
    super.onEnter()
    
    rightObstacle.currentShape = Glyph.Triangle
    glyphDetector = WTMGlyphDetector.detector() as! WTMGlyphDetector
    glyphDetector.delegate = self
    // Remove any (if any) preloaded Glyphs
    glyphDetector.removeAllGlyphs()
    // Load up the triangle
    glyphDetector.addGlyphFromJSON(Obstacle.convertGlyphToJSON(Glyph.Triangle), name: "Triangle")
    glyphDetector.addGlyphFromJSON(Obstacle.convertNonGlyphToJSON("reversetriangle"), name: "ReverseTriangle")
    glyphDetector.addGlyphFromJSON(Obstacle.convertNonGlyphToJSON("trianglefromtop"), name: "TriangleFromTop")
    rightObstacle.animationManager.runAnimationsForSequenceNamed("Flash Repeating")
    self.userInteractionEnabled = true
  }
  
  func play() {
    NSDefaultsManager.setFirstTimePlaying(true)
    CCDirector.sharedDirector().replaceScene(CCBReader.loadAsScene("LoadingScene"))
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.addPoint(touch.locationInWorld())
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.addPoint(touch.locationInWorld())
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.addPoint(touch.locationInWorld())
    ParticleEffects.createParticleEffectAtTouch(touch, asChildOf: self)
    glyphDetector.detectGlyph()
    glyphDetector.removeAllPoints()
  }

  func glyphDetected(glyph: WTMGlyph!, withScore score: Float) {
    if score >= 2.5 {
      rightObstacle.animationManager.runAnimationsForSequenceNamed("Flash Green Repeating")
      leftObstacle.animationManager.runAnimationsForSequenceNamed("Gate Up")
      self.animationManager.runAnimationsForSequenceNamed("Run Through Castle")
    }
  }
}