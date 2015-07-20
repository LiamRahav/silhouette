//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class CreditsScene: CCNode {
  func backToSettings() {
    let scene = CCBReader.loadAsScene("SettingsScene")
    CCDirector.sharedDirector().replaceScene(scene)
  }
}
