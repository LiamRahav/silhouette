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
      parent.addChild(touchParticle)
    }
  }
  
  static func createParticleEffectAtTouch(touch: CCTouch, asChildOf parent: TutorialScene) {
    if NSDefaultsManager.shouldShowParticleEffects() {
      let touchParticle = CCBReader.load("TouchParticle") as! CCParticleSystem
      touchParticle.autoRemoveOnFinish = true
      touchParticle.position = CGPoint(x: touch.locationInWorld().x, y: touch.locationInWorld().y)
      parent.addChild(touchParticle)
    }
  }
}