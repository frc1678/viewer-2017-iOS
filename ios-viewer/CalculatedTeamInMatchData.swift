//
//  CalculatedTeamInMatchData.swift
//
//  Created by Carter Luck on 1/21/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CalculatedTeamInMatchData: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let liftoffAbility = "liftoffAbility"
    static let numLowShotsAuto = "numLowShotsAuto"
    static let numHighShotsTele = "numHighShotsTele"
    static let numLowShotsTele = "numLowShotsTele"
    static let numHighShotsAuto = "numHighShotsAuto"
    static let numGearsPlacedAuto = "numGearsPlacedAuto"
    static let numGearsPlacedTele = "numGearsPlacedTele"
    static let drivingAbility = "drivingAbility"
    static let wasDisfunctional = "wasDisfunctional"
  }

  // MARK: Properties
  public var liftoffAbility: Float?
  public var numLowShotsAuto: Float?
  public var numHighShotsTele: Float?
  public var numLowShotsTele: Float?
  public var numHighShotsAuto: Float?
    public var numGearsPlacedAuto: Float?
    public var numGearsPlacedTele: Float?
    public var drivingAbility: Float?
    public var wasDisfunctional: Bool?


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
    liftoffAbility = json[SerializationKeys.liftoffAbility].float
    numLowShotsAuto = json[SerializationKeys.numLowShotsAuto].float
    numHighShotsTele = json[SerializationKeys.numHighShotsTele].float
    numLowShotsTele = json[SerializationKeys.numLowShotsTele].float
    numHighShotsAuto = json[SerializationKeys.numHighShotsAuto].float
    numGearsPlacedAuto = json[SerializationKeys.numGearsPlacedAuto].float
    numGearsPlacedTele = json[SerializationKeys.numGearsPlacedTele].float
    drivingAbility = json[SerializationKeys.drivingAbility].float
    wasDisfunctional = json[SerializationKeys.wasDisfunctional].bool
    
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
    if let value = numGearsPlacedAuto { dictionary[SerializationKeys.numGearsPlacedAuto] = value }
    if let value = numGearsPlacedTele { dictionary[SerializationKeys.numGearsPlacedTele] = value }
    if let value = drivingAbility { dictionary[SerializationKeys.drivingAbility] = value }
    if let value = wasDisfunctional { dictionary[SerializationKeys.wasDisfunctional] = value }
    
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.liftoffAbility = aDecoder.decodeObject(forKey: SerializationKeys.liftoffAbility) as? Float
    self.numLowShotsAuto = aDecoder.decodeObject(forKey: SerializationKeys.numLowShotsAuto) as? Float
    self.numHighShotsTele = aDecoder.decodeObject(forKey: SerializationKeys.numHighShotsTele) as? Float
    self.numLowShotsTele = aDecoder.decodeObject(forKey: SerializationKeys.numLowShotsTele) as? Float
    self.numHighShotsAuto = aDecoder.decodeObject(forKey: SerializationKeys.numHighShotsAuto) as? Float
    self.numGearsPlacedAuto = aDecoder.decodeObject(forKey: SerializationKeys.numGearsPlacedAuto) as? Float
    self.numGearsPlacedTele = aDecoder.decodeObject(forKey: SerializationKeys.numGearsPlacedTele) as? Float
    self.drivingAbility = aDecoder.decodeObject(forKey: SerializationKeys.drivingAbility) as? Float
    self.wasDisfunctional = aDecoder.decodeObject(forKey: SerializationKeys.wasDisfunctional) as? Bool
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(liftoffAbility, forKey: SerializationKeys.liftoffAbility)
    aCoder.encode(numLowShotsAuto, forKey: SerializationKeys.numLowShotsAuto)
    aCoder.encode(numHighShotsTele, forKey: SerializationKeys.numHighShotsTele)
    aCoder.encode(numLowShotsTele, forKey: SerializationKeys.numLowShotsTele)
    aCoder.encode(numHighShotsAuto, forKey: SerializationKeys.numHighShotsAuto)
    aCoder.encode(numGearsPlacedAuto, forKey: SerializationKeys.numGearsPlacedAuto)
    aCoder.encode(numGearsPlacedTele, forKey: SerializationKeys.numGearsPlacedTele)
    aCoder.encode(drivingAbility, forKey: SerializationKeys.drivingAbility)
    aCoder.encode(wasDisfunctional, forKey: SerializationKeys.wasDisfunctional)
  }
}
