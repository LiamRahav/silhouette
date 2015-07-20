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
    if !audio.bgPlaying {
      audio.playBg()
    }
  }
  
  func play() {
    let audio = OALSimpleAudio.sharedInstance()
    audio.stopBg()
    let nextScene = CCBReader.loadAsScene("GameScene")
    CCDirector.sharedDirector().replaceScene(nextScene)
  }
  
  func settings() {
    // TODO: Add a settings scene
    println("Settings button pressed")
  }
  
  func leaderboards() {
    // TODO: Add a leaderboard scene
    println("Leaderboard button pressed")
  }
  
}