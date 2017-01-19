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
  public var blueWinChance: Float = -1.0
  public var fortyKilopascalChanceBlue: Float = -1.0
  public var predictedRedScore: Float = -1.0
  public var sdPredictedRedScore: Float = -1.0
  public var redWinChance: Float = -1.0
  public var actualBlueRPs: Int = -1
  public var predictedRedRPs: Float = -1.0
  public var predictedBlueScore: Float = -1.0
  public var predictedBlueRPs: Float = -1.0
  public var fortyKilopascalChanceRed: Float = -1.0
  public var allRotorsTurningChanceRed: Float = -1.0
  public var allRotorsTurningChanceBlue: Float = -1.0
  public var sdPredictedBlueScore: Float = -1.0

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
    actualRedRPs = json[SerializationKeys.actualRedRPs].intValue
    blueWinChance = json[SerializationKeys.blueWinChance].floatValue
    fortyKilopascalChanceBlue = json[SerializationKeys.fortyKilopascalChanceBlue].floatValue
    predictedRedScore = json[SerializationKeys.predictedRedScore].floatValue
    sdPredictedRedScore = json[SerializationKeys.sdPredictedRedScore].floatValue
    redWinChance = json[SerializationKeys.redWinChance].floatValue
    actualBlueRPs = json[SerializationKeys.actualBlueRPs].intValue
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
    dictionary[SerializationKeys.blueWinChance] = blueWinChance
    dictionary[SerializationKeys.fortyKilopascalChanceBlue] = fortyKilopascalChanceBlue
    dictionary[SerializationKeys.predictedRedScore] = predictedRedScore
    dictionary[SerializationKeys.sdPredictedRedScore] = sdPredictedRedScore
    dictionary[SerializationKeys.redWinChance] = redWinChance
    dictionary[SerializationKeys.actualBlueRPs] = actualBlueRPs
    dictionary[SerializationKeys.predictedRedRPs] = predictedRedRPs
    dictionary[SerializationKeys.predictedBlueScore] = predictedBlueScore
    dictionary[SerializationKeys.predictedBlueRPs] = predictedBlueRPs
    dictionary[SerializationKeys.fortyKilopascalChanceRed] = fortyKilopascalChanceRed
    dictionary[SerializationKeys.allRotorsTurningChanceRed] = allRotorsTurningChanceRed
    dictionary[SerializationKeys.allRotorsTurningChanceBlue] = allRotorsTurningChanceBlue
    dictionary[SerializationKeys.sdPredictedBlueScore] = sdPredictedBlueScore
    return dictionary
  }

}
