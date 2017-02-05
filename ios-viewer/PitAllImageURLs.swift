//
//  PitAllImageURLs.swift
//
//  Created by Carter Luck on 2/4/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class PitAllImageURLs: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let kcAUhU7FV3a47VjomD7 = "-KcAUhU7FV3a47VjomD7"
  }

  // MARK: Properties
  public var kcAUhU7FV3a47VjomD7: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    kcAUhU7FV3a47VjomD7 = json[SerializationKeys.kcAUhU7FV3a47VjomD7].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = kcAUhU7FV3a47VjomD7 { dictionary[SerializationKeys.kcAUhU7FV3a47VjomD7] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.kcAUhU7FV3a47VjomD7 = aDecoder.decodeObject(forKey: SerializationKeys.kcAUhU7FV3a47VjomD7) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(kcAUhU7FV3a47VjomD7, forKey: SerializationKeys.kcAUhU7FV3a47VjomD7)
  }

}
