//
//  CalculatedTeamInMatchData.swift
//
//  Created by Carter Luck on 1/21/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CalculatedTeamInMatchData: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let liftoffAbility = "liftoffAbility"
    static let numLowShotsAuto = "numLowShotsAuto"
    static let numHighShotsTele = "numHighShotsTele"
    static let numLowShotsTele = "numLowShotsTele"
    static let numHighShotsAuto = "numHighShotsAuto"
  }

  // MARK: Properties
  public var liftoffAbility: Int?
  public var numLowShotsAuto: Int?
  public var numHighShotsTele: Int?
  public var numLowShotsTele: Int?
  public var numHighShotsAuto: Int?

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
    liftoffAbility = json[SerializationKeys.liftoffAbility].int
    numLowShotsAuto = json[SerializationKeys.numLowShotsAuto].int
    numHighShotsTele = json[SerializationKeys.numHighShotsTele].int
    numLowShotsTele = json[SerializationKeys.numLowShotsTele].int
    numHighShotsAuto = json[SerializationKeys.numHighShotsAuto].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = liftoffAbility { dictionary[SerializationKeys.liftoffAbility] = value }
    if let value = numLowShotsAuto { dictionary[SerializationKeys.numLowShotsAuto] = value }
    if let value = numHighShotsTele { dictionary[SerializationKeys.numHighShotsTele] = value }
    if let value = numLowShotsTele { dictionary[SerializationKeys.numLowShotsTele] = value }
    if let value = numHighShotsAuto { dictionary[SerializationKeys.numHighShotsAuto] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.liftoffAbility = aDecoder.decodeObject(forKey: SerializationKeys.liftoffAbility) as? Int
    self.numLowShotsAuto = aDecoder.decodeObject(forKey: SerializationKeys.numLowShotsAuto) as? Int
    self.numHighShotsTele = aDecoder.decodeObject(forKey: SerializationKeys.numHighShotsTele) as? Int
    self.numLowShotsTele = aDecoder.decodeObject(forKey: SerializationKeys.numLowShotsTele) as? Int
    self.numHighShotsAuto = aDecoder.decodeObject(forKey: SerializationKeys.numHighShotsAuto) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(liftoffAbility, forKey: SerializationKeys.liftoffAbility)
    aCoder.encode(numLowShotsAuto, forKey: SerializationKeys.numLowShotsAuto)
    aCoder.encode(numHighShotsTele, forKey: SerializationKeys.numHighShotsTele)
    aCoder.encode(numLowShotsTele, forKey: SerializationKeys.numLowShotsTele)
    aCoder.encode(numHighShotsAuto, forKey: SerializationKeys.numHighShotsAuto)
  }

}
