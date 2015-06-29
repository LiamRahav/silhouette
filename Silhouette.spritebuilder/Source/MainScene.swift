//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

class MainScene: CCNode {
    weak var liamRahav: CCLabelTTF!
    weak var presents: CCLabelTTF!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func onEnter() {
        var action = CCActionFadeIn(duration: 2)
        var audio = OALSimpleAudio.sharedInstance()
        
        audio.playBg("Audio/Disquiet.mp3", volume: 0.5, pan: 0, loop: true)
        liamRahav.runAction(action)
        presents.runAction(action)
    }
    
    override func update(delta: CCTime) {
        println("Opactiy: \(liamRahav.opacity)")
    }
}
