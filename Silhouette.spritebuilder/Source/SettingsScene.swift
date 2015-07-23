//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class SettingsScene: CCNode {
  weak var onButton: CCButton!
  weak var offButton: CCButton!
  
  func didLoadFromCCB() {
    if NSDefaultsManager.shouldPlayBG() {
      offButton.label.opacity = 0.5
    } else {
      onButton.label.opacity = 0.5
    }
  }
  
  func turnOnBackgroundMusic() {
    offButton.label.opacity = 0.5
    onButton.label.opacity = 1
    NSDefaultsManager.setShouldPlayBG(true)
    OALSimpleAudio.sharedInstance().playBg()
  }
  
  func turnOffBackgroundMusic() {
    onButton.label.opacity = 0.5
    offButton.label.opacity = 1
    NSDefaultsManager.setShouldPlayBG(false)
    OALSimpleAudio.sharedInstance().stopBg()
  }
  
  func turnOnParticlesEffects() {
    
  }
  
  func turnOffParticleEffects() {
    
  }
  
  func backToMenu() {
    self.parent.animationManager.runAnimationsForSequenceNamed("Settings Reverse")
  }
  
  func goToCredits() {
    self.parent.animationManager.runAnimationsForSequenceNamed("Credits")
  }
}