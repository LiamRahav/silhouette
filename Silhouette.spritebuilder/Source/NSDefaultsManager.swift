//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation
import GameKit

class NSDefaultsManager {
  static let HIGHSCORE_KEY = "11ACI76k8B8H9RJ1Ml"
  static let BACKGROUND_MUSIC_KEY = "9EOwshviw7rXZlQXUV"
  static let PARTICLE_EFFECTS_KEY = "wNK7tf3IaF8lW57tVu"
  static let FIRST_TIME_PLAYING_KEY = "wNK7dgkWMKfF8lW57tVu"
  
  static func setHighscore(newHighscore: Double) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setDouble(newHighscore, forKey: HIGHSCORE_KEY)
    // Save the high score to GameCenter as well
    var scoreReporter = GKScore(leaderboardIdentifier: "SilhouetteHighScoreLeaderboard")
    scoreReporter.value = Int64(newHighscore * 10)
    var scoreArray: [GKScore] = [scoreReporter]
    GKScore.reportScores(scoreArray, withCompletionHandler: {(error: NSError!) -> Void in
      if error != nil {
        println("Failed to save high score to Game Center")
      } else {
        println("Saved new score to Game Center succesfully")
      }
    })
  }
  
  static func getHighscore() -> Double {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.doubleForKey(HIGHSCORE_KEY)
  }
  
  static func setShouldPlayBG(shouldPlay: Bool) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setBool(shouldPlay, forKey: BACKGROUND_MUSIC_KEY)
  }
  
  static func shouldPlayBG() -> Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.boolForKey(BACKGROUND_MUSIC_KEY)
  }
  
  static func setShouldShowParticleEffects(shouldShow: Bool) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setBool(shouldShow, forKey: PARTICLE_EFFECTS_KEY)
  }
  
  static func shouldShowParticleEffects() -> Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.boolForKey(PARTICLE_EFFECTS_KEY)
  }
  
  static func setFirstTimePlaying(isFirstTime: Bool) {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setBool(isFirstTime, forKey: FIRST_TIME_PLAYING_KEY)
  }
  
  static func isFirstTimePlaying() -> Bool {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    return userDefaults.boolForKey(FIRST_TIME_PLAYING_KEY)
  }
}
