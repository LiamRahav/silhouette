//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class SettingsScene: CCNode {
  weak var backgroundMusicOnButton: CCButton!
  weak var backgroundMusicOffButton: CCButton!
  weak var particleEffectsOnButton: CCButton!
  weak var particleEffectsOffButton: CCButton!
  var parentNode: MenuScene!
  
  func didLoadFromCCB() {
    if NSDefaultsManager.shouldPlayBG() {
      backgroundMusicOffButton.label.opacity = 0.5
    } else {
      backgroundMusicOnButton.label.opacity = 0.5
    }
    
    if NSDefaultsManager.shouldShowParticleEffects() {
      particleEffectsOffButton.label.opacity = 0.5
    } else {
      particleEffectsOnButton.label.opacity = 0.5
    }
  }
  
  func turnOnBackgroundMusic() {
    backgroundMusicOffButton.label.opacity = 0.5
    backgroundMusicOnButton.label.opacity = 1
    NSDefaultsManager.setShouldPlayBG(true)
    OALSimpleAudio.sharedInstance().playBg()
  }
  
  func turnOffBackgroundMusic() {
    backgroundMusicOnButton.label.opacity = 0.5
    backgroundMusicOffButton.label.opacity = 1
    NSDefaultsManager.setShouldPlayBG(false)
    OALSimpleAudio.sharedInstance().stopBg()
  }
  
  func turnOnParticleEffects() {
    particleEffectsOnButton.label.opacity = 1
    particleEffectsOffButton.label.opacity = 0.5
    NSDefaultsManager.setShouldShowParticleEffects(true)
  }
  
  func turnOffParticleEffects() {
    particleEffectsOnButton.label.opacity = 0.5
    particleEffectsOffButton.label.opacity = 1
    NSDefaultsManager.setShouldShowParticleEffects(false)
  }
  
  func backToMenu() {
    self.parent.animationManager.runAnimationsForSequenceNamed("Settings Reverse")
  }
  
  func goToCredits() {
    self.parent.animationManager.runAnimationsForSequenceNamed("Credits")
    self.parentNode.creditsScene.animationManager.runAnimationsForSequenceNamed("Credits Scroll")
  }
}