//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.


import Foundation

class GameOverScreen: CCNode {
  func playAgain() {
    let newScene = CCBReader.loadAsScene("GameScene")
    CCDirector.sharedDirector().replaceScene(newScene)
  }
}