//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class PauseScreen: CCNode {
  var parentNode: GameScene!
  
  func resume() {
    parentNode.animationManager.runAnimationsForSequenceNamed("Pause Reverse")
    parentNode.animationManager.runAnimationsForSequenceNamed("Default Timeline")
    parentNode.userInteractionEnabled = true
    parentNode.isPaused = false
    parentNode.shouldMove = true
    parentNode.shouldPause = true
  }
  
  func backToMenu() {
    Mixpanel.sharedInstance().track("Back To Menu From Pause Screen")
    if parentNode.score > NSDefaultsManager.getHighscore() {
      NSDefaultsManager.setHighscore(parentNode.score)
    }
    CCDirector.sharedDirector().replaceScene(CCBReader.loadAsScene("MenuScene"))
  }
}