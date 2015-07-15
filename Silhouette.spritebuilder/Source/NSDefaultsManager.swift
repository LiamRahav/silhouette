//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class NSDefaultsManager {
  static let key = "highscore"
  
  static func getHighscore() -> Double {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let highscore = userDefaults.doubleForKey(key)
    return highscore
  }
  
  static func setHighscore(newHighscore: Double) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setDouble(newHighscore, forKey: key)
  }
}
