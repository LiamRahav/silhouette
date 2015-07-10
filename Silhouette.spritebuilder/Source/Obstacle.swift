//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

// Be sure to add new shapes to the Dictionary in Obstacle
enum Glyph {
  case Triangle
  case Z
  case L
  
  // Convert to string by typing shape.toString
  var toString: String {
    switch self {
      case .Z: return "Z"
      case .Triangle: return "Triangle"
      case .L: return "L"
    }
  }
  
}

class Obstacle: CCNode {
  weak var shapeImage: CCSprite!
  
  // Make sure the string always matches the shape
  var currentShape: Glyph =  .Triangle {
    didSet {
      shapeImage.spriteFrame = CCSpriteFrame(imageNamed: "assets/\(currentShape.toString.lowercaseString).png")
    }
  }
  
  // Add new shapes here and in the Enum
  static var glyphDict = [
    "Triangle" : Glyph.Triangle,
    "Z" : Glyph.Z,
    "L" :Glyph.L
  ]
  
  func randomizeCurrentShape() {
    let keyList = Obstacle.glyphDict.keys.array
    let randomKey = keyList[Int(arc4random_uniform(UInt32(keyList.count)))]
    currentShape = Obstacle.glyphDict[randomKey]!
  }
  
  /**
  This function takes in a Glyph enum and spits back the matching JSON file (if it exists)
  
  :param: Glyph
  :returns: JSON data
  */
  static func convertGlyphToJSON(glyph: Glyph) -> NSData {
    let path = NSBundle.mainBundle().pathForResource("JSON/\((glyph.toString).lowercaseString)", ofType: "json")
    let data = NSData(contentsOfMappedFile: path!)
    return data!
  }
}