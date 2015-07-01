//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class MenuScene: CCNode {
  weak var buttonsBox: CCLayoutBox!
  func didLoadFromCCB() {
    userInteractionEnabled = true
    schedule("fadeInButtons", interval: 1.29)
  }
  
  func fadeInButtons() {
    buttonsBox.runAction(CCActionFadeIn(duration: 3))
    buttonsBox.visible = true
    unschedule("fadeInButtons")
  }
  
  func play() {
    let audio = OALSimpleAudio.sharedInstance()
    audio.stopBg()
    let nextScene = CCBReader.loadAsScene("GameScene")
    CCDirector.sharedDirector().replaceScene(nextScene)
  }
  
}