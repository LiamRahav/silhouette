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
      // I think this line can be removed, but I'm not 100% sure
//      touchParticle.zOrder = parent.obstacleNode.zOrder + 1
      parent.addChild(touchParticle)
    }
  }
  
  static func createDeathParticles(sprite: CCSprite, asChildOf parent: GameScene) {
    if NSDefaultsManager.shouldShowParticleEffects() {
      let particle = CCBReader.load("FlashParticle") as! CCParticleSystem
      particle.autoRemoveOnFinish = true
      particle.position = sprite.position
      parent.addChild(particle)
    }
  }

}