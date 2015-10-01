//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class CreditsScene: CCNode {
  func backToSettings() {
    self.parent!.animationManager.runAnimationsForSequenceNamed("Credits Reverse")
    self.schedule("goBackToDefault", interval: 1)
  }
  
  func goBackToDefault() {
    animationManager.runAnimationsForSequenceNamed("Default Timeline")
    self.unschedule("goBackToDefault")
  }
}
