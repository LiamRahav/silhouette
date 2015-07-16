//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class NSDefaultsManager {
  static let HIGHSCORE_KEY = "11ACI76k8B8H9RJ1Ml"
  
  static func getHighscore() -> Double {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let highscore = userDefaults.doubleForKey(HIGHSCORE_KEY)
    return highscore
  }
  
  static func setHighscore(newHighscore: Double) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setDouble(newHighscore, forKey: HIGHSCORE_KEY)
  }
}
