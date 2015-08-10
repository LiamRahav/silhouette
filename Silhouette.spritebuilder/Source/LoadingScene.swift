
import Foundation

class LoadingScene: CCNode {
  var gameScene: CCScene!
  
  func didLoadFromCCB() {
    schedule("goToGame", interval: 1)
    schedule("startLoading", interval: 0.5)
  }
  
  func startLoading() {
    gameScene = CCBReader.loadAsScene("GameScene")
    unschedule("startLoading")
  }
  
  func goToGame() {
    CCDirector.sharedDirector().replaceScene(gameScene)
  }
}