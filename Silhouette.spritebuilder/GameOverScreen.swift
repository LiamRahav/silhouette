//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.


import Foundation

class GameOverScreen: CCNode {
  weak var highscoreLabel: CCLabelTTF!
  weak var scoreLabel: CCLabelTTF!
  var parentGameScene: GameScene!
  
  func playAgain() {
    let newScene = CCBReader.loadAsScene("GameScene")
    CCDirector.sharedDirector().replaceScene(newScene)
  }
  
  func returnToMenu() {
    let newScene = CCBReader.loadAsScene("MenuScene")
    CCDirector.sharedDirector().replaceScene(newScene)
  }
  
  func share() {
    let formattedScore = NSString(format: "%.1f", self.parentGameScene.score)
    // String that goes in the share function
    SharingManager.sharedInstance.share("I just got \(formattedScore)m on Silhouette! Think you can beat it? Click this link to find out! " + SharingManager.sharedInstance.defaultURL)
  }
}