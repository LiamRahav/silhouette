//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class LoadingScene: CCNode {
  var gameScene: CCScene!
  var sceneToLoad = "GameScene"
  
  func didLoadFromCCB() {
    schedule("goToGame", interval: 1)
    schedule("startLoading", interval: 0.5)
    if !NSDefaultsManager.isFirstTimePlaying() {
      sceneToLoad = "TutorialScene"
    }
  }
  
  func startLoading() {
    gameScene = CCBReader.loadAsScene(sceneToLoad)
    unschedule("startLoading")
  }
  
  func goToGame() {
    CCDirector.sharedDirector().replaceScene(gameScene)
  }
}