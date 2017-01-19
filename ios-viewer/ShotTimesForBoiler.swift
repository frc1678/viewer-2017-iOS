//
//  ShotTimesForBoiler.swift
//
//  Created by Bryton Moeller on 1/16/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ShotTimesForBoiler: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let position = "position"
    static let time = "time"
    static let numShots = "numShots"
  }

  // MARK: Properties
  public var position: String?
  public var time: Int?
  public var numShots: Int?

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
    position = json[SerializationKeys.position].string
    time = json[SerializationKeys.time].int
    numShots = json[SerializationKeys.numShots].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = position { dictionary[SerializationKeys.position] = value }
    if let value = time { dictionary[SerializationKeys.time] = value }
    if let value = numShots { dictionary[SerializationKeys.numShots] = value }
    return dictionary
  }

}
