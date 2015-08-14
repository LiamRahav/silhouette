//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation
import GameKit

class MenuScene: CCNode {
  weak var buttonsBox: CCLayoutBox!
  weak var creditsScene: CreditsScene!
  weak var settingsScene: SettingsScene!
  let audio = OALSimpleAudio.sharedInstance()
  var shouldRestart = false
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
    audio.preloadBg("Disquiet.mp3")
    audio.preloadEffect("flash.wav")
    if !audio.bgPlaying && NSDefaultsManager.shouldPlayBG() {
      audio.playBg()
    }
    audio.bgVolume = 1.0
    setUpGameCenter()
    
    if !NSDefaultsManager.isFirstTimePlaying() {
      NSDefaultsManager.setShouldShowParticleEffects(true)
      NSDefaultsManager.setShouldPlayBG(true)
    }
  }
  
  func setUpGameCenter() {
    let gameCenterInteractor = GameCenterInteractor.sharedInstance
    gameCenterInteractor.authenticationCheck()
  }
  
  func play() {
    Mixpanel.sharedInstance().track("Play Button Pressed")
    audio.bgVolume = 0.25
    let loadingScreen = CCBReader.loadAsScene("LoadingScene")
    CCDirector.sharedDirector().replaceScene(loadingScreen)
  }
  
  func settings() {
    Mixpanel.sharedInstance().track("Settings Button Pressed")
    animationManager.runAnimationsForSequenceNamed("Settings")
    settingsScene.parentNode = self
  }
  
  func leaderboard() {
     Mixpanel.sharedInstance().track("Leaderboard Button Pressed")
    showLeaderboard()
  }
  
}

// MARK: Game Center Handling 
extension MenuScene: GKGameCenterControllerDelegate {
  func showLeaderboard() {
    var viewController = CCDirector.sharedDirector().parentViewController!
    var gameCenterViewController = GKGameCenterViewController()
    gameCenterViewController.gameCenterDelegate = self
    viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
  }

  // Delegate methods
  func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
    gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
  }
}