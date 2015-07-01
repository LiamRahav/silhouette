//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

// Be sure to add new shapes to the Dictionary in Obstacle
enum Glyph {
  case Square
  case Triangle
  case Circle
  case Diamond
  
  // Convert to string by typing shape.toString
  var toString: String {
    switch self {
      case .Circle: return "Circle"
      case .Triangle: return "Triangle"
      case .Diamond: return "Diamond"
      case .Square: return "Square"
    }
  }
  
}

class Obstacle: CCNode {
  weak var shapeLabel: CCLabelTTF!
  
  // Make sure the string always matches the shape
  var currentShape: Glyph =  .Triangle {
    didSet {
      shapeLabel.string = currentShape.toString
    }
  }
  
  // Add new shapes here and in the Enum
  var glyphDict = [
    "Square" : Glyph.Square,
    "Triangle" : Glyph.Triangle,
    "Circle" : Glyph.Circle,
    "Diamond" :Glyph.Diamond
  ]
  
  /**
  This function takes in a Glyph enum and spits back the matching JSON file (if it exists)
  
  :param: Glyph
  :returns: JSON data
  */
  func convertGlyphToJSON(glyph: Glyph) -> NSData {
    let path = NSBundle.mainBundle().pathForResource("JSON/\((glyph.toString).lowercaseString)", ofType: "json")
    
    // DEBUG
    // println("\nSHAPE: \(glyph.toString)")
    // println("\nPATH: \(path)")
    
    let data = NSData(contentsOfMappedFile: path!)
    return data!
  }
}