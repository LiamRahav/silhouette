import Foundation

class MainScene: CCNode {
  var dict: [Int:Int] = [0:0]
  var dictString: String = ""
  
  func didLoadFromCCB() {
    userInteractionEnabled = true
  }
  
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    dict[Int(touch.locationInWorld().x)] = Int(touch.locationInWorld().y)
    particles(touch)
    format(dict)
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    dict[Int(touch.locationInWorld().x)] = Int(touch.locationInWorld().y)
    particles(touch)
    format(dict)
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    dict[Int(touch.locationInWorld().x)] = Int(touch.locationInWorld().y)
    particles(touch)
    format(dict)
    println(dictString)
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    dict[Int(touch.locationInWorld().x)] = Int(touch.locationInWorld().y)
    format(dict)
    particles(touch)
    println(dictString)
  }
  
  func format(dict: [Int:Int]) {
    dictString = dict.description
    dictString = "[\n[\n" + (dictString) + "\n]\n]"
    dictString = dictString.stringByReplacingOccurrencesOfString(",",
      withString: "], [",
      options: NSStringCompareOptions.LiteralSearch,
      range: nil)
    dictString = dictString.stringByReplacingOccurrencesOfString(":",
      withString: ",",
      options: NSStringCompareOptions.LiteralSearch,
      range: nil)
  }
  
  func particles(touch: CCTouch) {
    var p = CCBReader.load("TouchParticle") as! CCParticleSystem
    p.autoRemoveOnFinish = true
    p.position = touch.locationInWorld()
  }
  
  
  /*
  [
  [
  [ 3,1], [378,2], [376,358], [4,360], [4,1]
  ]
  ]
  */
}
