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
  public var actualRedRPs: Int = -1
  public var blueWinChance: Float?
  public var fortyKilopascalChanceBlue: Float?
  public var predictedRedScore: Float?
  public var sdPredictedRedScore: Float?
  public var redWinChance: Float?
  public var actualBlueRPs: Int = -1
  public var predictedRedRPs: Float?
  public var predictedBlueScore: Float?
  public var predictedBlueRPs: Float?
  public var fortyKilopascalChanceRed: Float?
  public var allRotorsTurningChanceRed: Float?
  public var allRotorsTurningChanceBlue: Float?
  public var sdPredictedBlueScore: Float?

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
    actualRedRPs = json[SerializationKeys.actualRedRPs].int!
    blueWinChance = json[SerializationKeys.blueWinChance].floatValue
    fortyKilopascalChanceBlue = json[SerializationKeys.fortyKilopascalChanceBlue].floatValue
    predictedRedScore = json[SerializationKeys.predictedRedScore].floatValue
    sdPredictedRedScore = json[SerializationKeys.sdPredictedRedScore].floatValue
    redWinChance = json[SerializationKeys.redWinChance].floatValue
    actualBlueRPs = json[SerializationKeys.actualBlueRPs].int!
    predictedRedRPs = json[SerializationKeys.predictedRedRPs].floatValue
    predictedBlueScore = json[SerializationKeys.predictedBlueScore].floatValue
    predictedBlueRPs = json[SerializationKeys.predictedBlueRPs].floatValue
    fortyKilopascalChanceRed = json[SerializationKeys.fortyKilopascalChanceRed].floatValue
    allRotorsTurningChanceRed = json[SerializationKeys.allRotorsTurningChanceRed].floatValue
    allRotorsTurningChanceBlue = json[SerializationKeys.allRotorsTurningChanceBlue].floatValue
    sdPredictedBlueScore = json[SerializationKeys.sdPredictedBlueScore].floatValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    dictionary[SerializationKeys.actualRedRPs] = actualRedRPs
    if let value = blueWinChance { dictionary[SerializationKeys.blueWinChance] = value }
    if let value = fortyKilopascalChanceBlue { dictionary[SerializationKeys.fortyKilopascalChanceBlue] = value }
    if let value = predictedRedScore { dictionary[SerializationKeys.predictedRedScore] = value }
    if let value = sdPredictedRedScore { dictionary[SerializationKeys.sdPredictedRedScore] = value }
    if let value = redWinChance { dictionary[SerializationKeys.redWinChance] = value }
    dictionary[SerializationKeys.actualBlueRPs] = actualBlueRPs
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
