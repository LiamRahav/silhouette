//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class MainScene: CCNode {
  weak var introTextBox: CCLayoutBox!
  
  func didLoadFromCCB() {
    // Create an OALSimpleAudio object and play Disquiet as bg song
    let audioHandler = OALSimpleAudio.sharedInstance()
    audioHandler.playBg("Audio/Disquiet.mp3", volume: 0.5, pan: 0, loop: true)
    
    // Play the fadeInText function in 1 second
    schedule("fadeInText", interval: CCTime(1))
  }
  
  func fadeInText() {
    // Start fading the text in and making it visible
    let action = CCActionFadeIn(duration: 1.5)
    introTextBox.runAction(CCActionEase(action: action))
    introTextBox.visible = true
    
    // Get ready to move to the MenuScene in 3 seconds
    schedule("moveToNextScene", interval: CCTime(3))
    
    // Start fading the text out + remove this function
    introTextBox.runAction(CCActionFadeOut(duration: 1.5))
    unschedule("fadeInText")
  }
  
  func moveToNextScene() {
    // Load up the next scene and remove this function from the scheduler
    let newScene = CCBReader.loadAsScene("MenuScene")
    CCDirector.sharedDirector().replaceScene(newScene)
    
    unschedule("moveToNextScene")
  }
}
