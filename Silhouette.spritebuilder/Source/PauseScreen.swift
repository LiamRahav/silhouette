//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class PauseScreen: CCNode {
  var parentNode: GameScene!
  
  func resume() {
    parentNode.userInteractionEnabled = true
    parentNode.shouldMove = true
    parentNode.removeChild(self)
  }
}