//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class NSDefaultsManager {
  static let HIGHSCORE_KEY = "11ACI76k8B8H9RJ1Ml"
  static let BACKGROUND_MUSIC_KEY = "9EOwshviw7rXZlQXUV"
  static let PARTICLE_EFFECTS_KEY = "wNK7tf3IaF8lW57tVu"
  
  static func getHighscore() -> Double {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.doubleForKey(HIGHSCORE_KEY)
  }
  
  static func setHighscore(newHighscore: Double) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setDouble(newHighscore, forKey: HIGHSCORE_KEY)
  }
  
  static func setShouldPlayBG(shouldPlay: Bool) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setBool(shouldPlay, forKey: BACKGROUND_MUSIC_KEY)
  }
  
  static func shouldPlayBG() -> Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.boolForKey(BACKGROUND_MUSIC_KEY)
  }
  
  func setShouldShowParticleEffects(shouldShow: Bool) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setBool(shouldShow, forKey: NSDefaultsManager.PARTICLE_EFFECTS_KEY)
  }
  
  static func shouldShowParticleEffects() -> Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.boolForKey(PARTICLE_EFFECTS_KEY)
  }
}
