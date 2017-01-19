//
//  CalculatedMatchData.swift
//
//  Created by Bryton Moeller on 1/18/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class CalculatedMatchData: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let actualRedRPs = "actualRedRPs"
    static let blueWinChance = "blueWinChance"
    static let fortyKilopascalChanceBlue = "fortyKilopascalChanceBlue"
    static let predictedRedScore = "predictedRedScore"
    static let sdPredictedRedScore = "sdPredictedRedScore"
    static let redWinChance = "redWinChance"
    static let actualBlueRPs = "actualBlueRPs"
    static let predictedRedRPs = "predictedRedRPs"
    static let predictedBlueScore = "predictedBlueScore"
    static let predictedBlueRPs = "predictedBlueRPs"
    static let fortyKilopascalChanceRed = "fortyKilopascalChanceRed"
    static let allRotorsTurningChanceRed = "allRotorsTurningChanceRed"
    static let allRotorsTurningChanceBlue = "allRotorsTurningChanceBlue"
    static let sdPredictedBlueScore = "sdPredictedBlueScore"
  }

  // MARK: Properties
  public var actualRedRPs: Int?
  public var blueWinChance: Int?
  public var fortyKilopascalChanceBlue: Int?
  public var predictedRedScore: Int?
  public var sdPredictedRedScore: Int?
  public var redWinChance: Int?
  public var actualBlueRPs: Int?
  public var predictedRedRPs: Int?
  public var predictedBlueScore: Int?
  public var predictedBlueRPs: Int?
  public var fortyKilopascalChanceRed: Int?
  public var allRotorsTurningChanceRed: Int?
  public var allRotorsTurningChanceBlue: Int?
  public var sdPredictedBlueScore: Int?

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
    actualRedRPs = json[SerializationKeys.actualRedRPs].int
    blueWinChance = json[SerializationKeys.blueWinChance].int
    fortyKilopascalChanceBlue = json[SerializationKeys.fortyKilopascalChanceBlue].int
    predictedRedScore = json[SerializationKeys.predictedRedScore].int
    sdPredictedRedScore = json[SerializationKeys.sdPredictedRedScore].int
    redWinChance = json[SerializationKeys.redWinChance].int
    actualBlueRPs = json[SerializationKeys.actualBlueRPs].int
    predictedRedRPs = json[SerializationKeys.predictedRedRPs].int
    predictedBlueScore = json[SerializationKeys.predictedBlueScore].int
    predictedBlueRPs = json[SerializationKeys.predictedBlueRPs].int
    fortyKilopascalChanceRed = json[SerializationKeys.fortyKilopascalChanceRed].int
    allRotorsTurningChanceRed = json[SerializationKeys.allRotorsTurningChanceRed].int
    allRotorsTurningChanceBlue = json[SerializationKeys.allRotorsTurningChanceBlue].int
    sdPredictedBlueScore = json[SerializationKeys.sdPredictedBlueScore].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = actualRedRPs { dictionary[SerializationKeys.actualRedRPs] = value }
    if let value = blueWinChance { dictionary[SerializationKeys.blueWinChance] = value }
    if let value = fortyKilopascalChanceBlue { dictionary[SerializationKeys.fortyKilopascalChanceBlue] = value }
    if let value = predictedRedScore { dictionary[SerializationKeys.predictedRedScore] = value }
    if let value = sdPredictedRedScore { dictionary[SerializationKeys.sdPredictedRedScore] = value }
    if let value = redWinChance { dictionary[SerializationKeys.redWinChance] = value }
    if let value = actualBlueRPs { dictionary[SerializationKeys.actualBlueRPs] = value }
    if let value = predictedRedRPs { dictionary[SerializationKeys.predictedRedRPs] = value }
    if let value = predictedBlueScore { dictionary[SerializationKeys.predictedBlueScore] = value }
    if let value = predictedBlueRPs { dictionary[SerializationKeys.predictedBlueRPs] = value }
    if let value = fortyKilopascalChanceRed { dictionary[SerializationKeys.fortyKilopascalChanceRed] = value }
    if let value = allRotorsTurningChanceRed { dictionary[SerializationKeys.allRotorsTurningChanceRed] = value }
    if let value = allRotorsTurningChanceBlue { dictionary[SerializationKeys.allRotorsTurningChanceBlue] = value }
    if let value = sdPredictedBlueScore { dictionary[SerializationKeys.sdPredictedBlueScore] = value }
    return dictionary
  }

}
