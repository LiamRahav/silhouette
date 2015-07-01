//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation
import UIKit

class GameScene: CCNode, WTMGlyphDelegate {
  weak var testObstacle: Obstacle!
  var glyphDetector: WTMGlyphDetector!
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    initGestureDetector()
  }
  
  func initGestureDetector() {
    glyphDetector = WTMGlyphDetector.detector() as! WTMGlyphDetector
//    glyphDetector.delegate = self
    glyphDetector.addGlyphFromJSON(testObstacle.convertGlyphToJSON(testObstacle.currentShape), name: testObstacle.currentShape.toString)
  }
  
  override func onEnter() {
    super.onEnter()
    glyphDetector.delegate = self
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.addPoint(touch.locationInView(touch.view))
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.addPoint(touch.locationInView(touch.view))
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.addPoint(touch.locationInView(touch.view))
    glyphDetector.detectGlyph()
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    glyphDetector.detectGlyph()
  }
  
  func glyphDetected(glyph: WTMGlyph!, withScore score: Float) {
    println("You drew a \((glyph.name).uppercaseString) with an accuracy score of: \(String(stringInterpolationSegment: score).uppercaseString)")
  }
  
}