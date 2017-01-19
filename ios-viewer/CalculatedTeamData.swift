//
//  CalculatedData.swift
//
//  Created by Bryton Moeller on 1/18/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CalculatedTeamData: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let sdLiftoffAbility = "sdLiftoffAbility"
    static let incapacitatedPercentage = "incapacitatedPercentage"
    static let overallSecondPickAbility = "overallSecondPickAbility"
    static let avgHighShotsTele = "avgHighShotsTele"
    static let baselineReachedPercentage = "baselineReachedPercentage"
    static let avgGearsPlacedAuto = "avgGearsPlacedAuto"
    static let avgGearControl = "avgGearControl"
    static let actualSeed = "actualSeed"
    static let sdHighShotsTele = "sdHighShotsTele"
    static let liftoffPercentage = "liftoffPercentage"
    static let avgHighShotsAuto = "avgHighShotsAuto"
    static let avgAgility = "avgAgility"
    static let predictedSeed = "predictedSeed"
    static let avgGearsPlacedTele = "avgGearsPlacedTele"
    static let liftoffAbility = "liftoffAbility"
    static let sdGearsPlacedAuto = "sdGearsPlacedAuto"
    static let sdLowShotsAuto = "sdLowShotsAuto"
    static let avgKeyShotTime = "avgKeyShotTime"
    static let sdLowShotsTele = "sdLowShotsTele"
    static let sdGearsPlacedTele = "sdGearsPlacedTele"
    static let avgDefense = "avgDefense"
    static let avgLowShotsTele = "avgLowShotsTele"
    static let sdHighShotsAuto = "sdHighShotsAuto"
    static let avgSpeed = "avgSpeed"
    static let disabledPercentage = "disabledPercentage"
    static let avgLowShotsAuto = "avgLowShotsAuto"
    static let firstPickAbility = "firstPickAbility"
    static let avgBallControl = "avgBallControl"
  }

  // MARK: Properties
  public var sdLiftoffAbility: Int?
  public var incapacitatedPercentage: Int?
  public var overallSecondPickAbility: Int?
  public var avgHighShotsTele: Int?
  public var baselineReachedPercentage: Int?
  public var avgGearsPlacedAuto: Int?
  public var avgGearControl: Int?
  public var actualSeed: Int?
  public var sdHighShotsTele: Int?
  public var liftoffPercentage: Int?
  public var avgHighShotsAuto: Int?
  public var avgAgility: Int?
  public var predictedSeed: Int?
  public var avgGearsPlacedTele: Int?
  public var liftoffAbility: Int?
  public var sdGearsPlacedAuto: Int?
  public var sdLowShotsAuto: Int?
  public var avgKeyShotTime: Int?
  public var sdLowShotsTele: Int?
  public var sdGearsPlacedTele: Int?
  public var avgDefense: Int?
  public var avgLowShotsTele: Int?
  public var sdHighShotsAuto: Int?
  public var avgSpeed: Int?
  public var disabledPercentage: Int?
  public var avgLowShotsAuto: Int?
  public var firstPickAbility: Int?
  public var avgBallControl: Int?

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
    sdLiftoffAbility = json[SerializationKeys.sdLiftoffAbility].int
    incapacitatedPercentage = json[SerializationKeys.incapacitatedPercentage].int
    overallSecondPickAbility = json[SerializationKeys.overallSecondPickAbility].int
    avgHighShotsTele = json[SerializationKeys.avgHighShotsTele].int
    baselineReachedPercentage = json[SerializationKeys.baselineReachedPercentage].int
    avgGearsPlacedAuto = json[SerializationKeys.avgGearsPlacedAuto].int
    avgGearControl = json[SerializationKeys.avgGearControl].int
    actualSeed = json[SerializationKeys.actualSeed].int
    sdHighShotsTele = json[SerializationKeys.sdHighShotsTele].int
    liftoffPercentage = json[SerializationKeys.liftoffPercentage].int
    avgHighShotsAuto = json[SerializationKeys.avgHighShotsAuto].int
    avgAgility = json[SerializationKeys.avgAgility].int
    predictedSeed = json[SerializationKeys.predictedSeed].int
    avgGearsPlacedTele = json[SerializationKeys.avgGearsPlacedTele].int
    liftoffAbility = json[SerializationKeys.liftoffAbility].int
    sdGearsPlacedAuto = json[SerializationKeys.sdGearsPlacedAuto].int
    sdLowShotsAuto = json[SerializationKeys.sdLowShotsAuto].int
    avgKeyShotTime = json[SerializationKeys.avgKeyShotTime].int
    sdLowShotsTele = json[SerializationKeys.sdLowShotsTele].int
    sdGearsPlacedTele = json[SerializationKeys.sdGearsPlacedTele].int
    avgDefense = json[SerializationKeys.avgDefense].int
    avgLowShotsTele = json[SerializationKeys.avgLowShotsTele].int
    sdHighShotsAuto = json[SerializationKeys.sdHighShotsAuto].int
    avgSpeed = json[SerializationKeys.avgSpeed].int
    disabledPercentage = json[SerializationKeys.disabledPercentage].int
    avgLowShotsAuto = json[SerializationKeys.avgLowShotsAuto].int
    firstPickAbility = json[SerializationKeys.firstPickAbility].int
    avgBallControl = json[SerializationKeys.avgBallControl].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = sdLiftoffAbility { dictionary[SerializationKeys.sdLiftoffAbility] = value }
    if let value = incapacitatedPercentage { dictionary[SerializationKeys.incapacitatedPercentage] = value }
    if let value = overallSecondPickAbility { dictionary[SerializationKeys.overallSecondPickAbility] = value }
    if let value = avgHighShotsTele { dictionary[SerializationKeys.avgHighShotsTele] = value }
    if let value = baselineReachedPercentage { dictionary[SerializationKeys.baselineReachedPercentage] = value }
    if let value = avgGearsPlacedAuto { dictionary[SerializationKeys.avgGearsPlacedAuto] = value }
    if let value = avgGearControl { dictionary[SerializationKeys.avgGearControl] = value }
    if let value = actualSeed { dictionary[SerializationKeys.actualSeed] = value }
    if let value = sdHighShotsTele { dictionary[SerializationKeys.sdHighShotsTele] = value }
    if let value = liftoffPercentage { dictionary[SerializationKeys.liftoffPercentage] = value }
    if let value = avgHighShotsAuto { dictionary[SerializationKeys.avgHighShotsAuto] = value }
    if let value = avgAgility { dictionary[SerializationKeys.avgAgility] = value }
    if let value = predictedSeed { dictionary[SerializationKeys.predictedSeed] = value }
    if let value = avgGearsPlacedTele { dictionary[SerializationKeys.avgGearsPlacedTele] = value }
    if let value = liftoffAbility { dictionary[SerializationKeys.liftoffAbility] = value }
    if let value = sdGearsPlacedAuto { dictionary[SerializationKeys.sdGearsPlacedAuto] = value }
    if let value = sdLowShotsAuto { dictionary[SerializationKeys.sdLowShotsAuto] = value }
    if let value = avgKeyShotTime { dictionary[SerializationKeys.avgKeyShotTime] = value }
    if let value = sdLowShotsTele { dictionary[SerializationKeys.sdLowShotsTele] = value }
    if let value = sdGearsPlacedTele { dictionary[SerializationKeys.sdGearsPlacedTele] = value }
    if let value = avgDefense { dictionary[SerializationKeys.avgDefense] = value }
    if let value = avgLowShotsTele { dictionary[SerializationKeys.avgLowShotsTele] = value }
    if let value = sdHighShotsAuto { dictionary[SerializationKeys.sdHighShotsAuto] = value }
    if let value = avgSpeed { dictionary[SerializationKeys.avgSpeed] = value }
    if let value = disabledPercentage { dictionary[SerializationKeys.disabledPercentage] = value }
    if let value = avgLowShotsAuto { dictionary[SerializationKeys.avgLowShotsAuto] = value }
    if let value = firstPickAbility { dictionary[SerializationKeys.firstPickAbility] = value }
    if let value = avgBallControl { dictionary[SerializationKeys.avgBallControl] = value }
    return dictionary
  }

}
