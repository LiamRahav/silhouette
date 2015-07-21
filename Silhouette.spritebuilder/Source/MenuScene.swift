//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class MenuScene: CCNode {
  weak var buttonsBox: CCLayoutBox!
  let audio = OALSimpleAudio.sharedInstance()
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    if !audio.bgPlaying && NSDefaultsManager.shouldPlayBG() {
      audio.playBg()
    } else if !NSDefaultsManager.shouldPlayBG() {
      audio.stopBg()
    }
  }
  
  func play() {
    let audio = OALSimpleAudio.sharedInstance()
    audio.stopBg()
    let nextScene = CCBReader.loadAsScene("GameScene")
    CCDirector.sharedDirector().replaceScene(nextScene)
  }
  
  func settings() {
    animationManager.runAnimationsForSequenceNamed("Settings")
  }
  
  func shop() {
    // TODO: Add a shop scene
    println("Shopping button pressed")
  }
  
}