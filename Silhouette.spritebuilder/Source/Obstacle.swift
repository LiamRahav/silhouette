//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

// MARK: Glyph Enum
// Be sure to add new shapes to the Dictionary in Obstacle
enum Glyph {
  case Triangle
  case Z
  case L
  case V
  case Bolt

  // Convert to string by typing shape.toString
  var toString: String {
    switch self {
      case .Z: return "Z"
      case .Triangle: return "Triangle"
      case .L: return "L"
      case .V: return "V"
      case .Bolt: return "Bolt"
    }
  }
  
}

// MARK: Obstacle Class
class Obstacle: CCNode {
  weak var shapeImage: CCSprite!
  weak var blueBar: CCNodeColor!
  weak var towerRight: CCSprite!
  weak var wallRight: CCSprite!
  weak var ring: CCSprite!
  
  // Make sure the string always matches the shape
  var currentShape: Glyph =  .Triangle {
    didSet {
      shapeImage.spriteFrame = CCSpriteFrame(imageNamed: "assets/shapes/\(currentShape.toString.lowercaseString).png")
    }
  }
  
  // Add new shapes here and in the Enum
  static var glyphDict = [
    "Triangle" : Glyph.Triangle,
    "Z" : Glyph.Z,
    "L" :Glyph.L,
    "V" : Glyph.V,
    "Bolt": Glyph.Bolt
  ]
  
  func didLoadFromCCB() {
    towerRight.zOrder = 1
    wallRight.zOrder = 1
    shapeImage.zOrder = 3
    ring.zOrder = 2
  }
  
  func randomizeCurrentShape() {
    let keyList = Array(Obstacle.glyphDict.keys)
    let randomKey = keyList[Int(arc4random_uniform(UInt32(keyList.count)))]
    currentShape = Obstacle.glyphDict[randomKey]!
  }
  
  /**
  This function takes in a Glyph enum and spits back the matching JSON file (if it exists)
  
  - parameter Glyph:
  - returns: JSON data
  */
  static func convertGlyphToJSON(glyph: Glyph) -> NSData {
    let path = NSBundle.mainBundle().pathForResource("JSON/\((glyph.toString).lowercaseString)", ofType: "json")
    let data = NSData(contentsOfMappedFile: path!)
    return data!
  }
  
  static func convertNonGlyphToJSON(fileName: String) -> NSData {
    let path = NSBundle.mainBundle().pathForResource("JSON/\((fileName).lowercaseString)", ofType: "json")
    let data = NSData(contentsOfMappedFile: path!)
    return data!
  }
}