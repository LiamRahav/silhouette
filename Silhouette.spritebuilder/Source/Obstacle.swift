//
// Silhouette (c) by Liam Rahav
//
// Silhouette is licensed under a
// Creative Commons Attribution-NonCommercial 4.0 International License.

import Foundation

enum Glyph {
  case Square
  case Triangle
  case Cirlce
  case Diamond
  
  // Convert to string by typing shape.toString
  var toString: String {
    switch self {
      case .Cirlce: return "Cirlce"
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
  
  /**
  This function takes in a Glyph enum and spits back the matching JSON file (if it exists)
  
  :param: Glyph
  :returns: JSON data
  */
  func convertGlyphToJSON(glyph: Glyph) -> NSData {
    let path = NSBundle.mainBundle().pathForResource("JSON/\((glyph.toString).lowercaseString)", ofType: "json")
    let data = NSData(contentsOfMappedFile: path!)
    return data!
  }
}