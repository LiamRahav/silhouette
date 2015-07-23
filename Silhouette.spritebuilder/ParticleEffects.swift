//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class ParticleEffects {
  static func createParticleEffectAtTouch(touch: CCTouch, asChildOf parent: GameScene) {
    if NSDefaultsManager.shouldShowParticleEffects() {
      let touchParticle = CCBReader.load("TouchParticle") as! CCParticleSystem
      touchParticle.autoRemoveOnFinish = true
      touchParticle.position = CGPoint(x: touch.locationInWorld().x, y: touch.locationInWorld().y)
      touchParticle.zOrder = parent.obstacleNode.zOrder + 1
      parent.addChild(touchParticle)
    }
  }
}