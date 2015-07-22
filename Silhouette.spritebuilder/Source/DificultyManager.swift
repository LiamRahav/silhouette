//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class DificultyManager {
  static func increaseDificulty(game: GameScene, score: Double, randomIncreaseArea: Int) {
    var randomIncreaseArea = Double(randomIncreaseArea)
    
    if score > 15 && score < 15.1 {
      game.scrollSpeed += 0.015
    }
    
    else if score > 20 && score < 20.1 {
      game.totalTime -= 0.025
    }
    
    else if score > 30 && score < 30.1 {
      game.scrollSpeed += 0.015
      game.totalTime -= 0.025
    }
    
    else if score > randomIncreaseArea - 10 && score < randomIncreaseArea - 9.9 {
      game.scrollSpeed += 0.3
      game.totalTime -= 0.05
    }
      
    else if score > randomIncreaseArea && score < randomIncreaseArea + 0.1 {
      game.scrollSpeed += 0.3
      game.totalTime -= 0.05
    }
  }
}