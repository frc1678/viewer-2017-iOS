//
//  Match.swift
//
//  Created by Bryton Moeller on 1/18/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Match: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let redAllianceTeamNumbers = "redAllianceTeamNumbers"
    static let blueDidReachFortyKilopascals = "blueDidReachFortyKilopascals"
    static let blueScore = "blueScore"
    static let redDidReachFortyKilopascals = "redDidReachFortyKilopascals"
    static let blueAllianceTeamNumbers = "blueAllianceTeamNumbers"
    static let number = "number"
    static let calculatedData = "calculatedData"
    static let foulPointsGainedRed = "foulPointsGainedRed"
    static let blueDidStartAllRotors = "blueDidStartAllRotors"
    static let foulPointsGainedBlue = "foulPointsGainedBlue"
    static let redScore = "redScore"
    static let redDidStartAllRotors = "redDidStartAllRotors"
  }

  // MARK: Properties
  public var redAllianceTeamNumbers: [Int]?
  public var blueDidReachFortyKilopascals: Bool? = false
  public var blueScore: Int?
  public var redDidReachFortyKilopascals: Bool? = false
  public var blueAllianceTeamNumbers: [Int]?
  public var number: Int?
  public var calculatedData: CalculatedMatchData?
  public var foulPointsGainedRed: Int?
  public var blueDidStartAllRotors: Bool? = false
  public var foulPointsGainedBlue: Int?
  public var redScore: Int?
  public var redDidStartAllRotors: Bool? = false

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
    if let items = json[SerializationKeys.redAllianceTeamNumbers].array { redAllianceTeamNumbers = items.map { $0.intValue } }
    blueDidReachFortyKilopascals = json[SerializationKeys.blueDidReachFortyKilopascals].boolValue
    blueScore = json[SerializationKeys.blueScore].int
    redDidReachFortyKilopascals = json[SerializationKeys.redDidReachFortyKilopascals].boolValue
    if let items = json[SerializationKeys.blueAllianceTeamNumbers].array { blueAllianceTeamNumbers = items.map { $0.intValue } }
    number = json[SerializationKeys.number].int
    calculatedData = CalculatedMatchData(json: json[SerializationKeys.calculatedData])
    foulPointsGainedRed = json[SerializationKeys.foulPointsGainedRed].int
    blueDidStartAllRotors = json[SerializationKeys.blueDidStartAllRotors].boolValue
    foulPointsGainedBlue = json[SerializationKeys.foulPointsGainedBlue].int
    redScore = json[SerializationKeys.redScore].int
    redDidStartAllRotors = json[SerializationKeys.redDidStartAllRotors].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = redAllianceTeamNumbers { dictionary[SerializationKeys.redAllianceTeamNumbers] = value }
    dictionary[SerializationKeys.blueDidReachFortyKilopascals] = blueDidReachFortyKilopascals
    if let value = blueScore { dictionary[SerializationKeys.blueScore] = value }
    dictionary[SerializationKeys.redDidReachFortyKilopascals] = redDidReachFortyKilopascals
    if let value = blueAllianceTeamNumbers { dictionary[SerializationKeys.blueAllianceTeamNumbers] = value }
    if let value = number { dictionary[SerializationKeys.number] = value }
    if let value = calculatedData { dictionary[SerializationKeys.calculatedData] = value.dictionaryRepresentation() }
    if let value = foulPointsGainedRed { dictionary[SerializationKeys.foulPointsGainedRed] = value }
    dictionary[SerializationKeys.blueDidStartAllRotors] = blueDidStartAllRotors
    if let value = foulPointsGainedBlue { dictionary[SerializationKeys.foulPointsGainedBlue] = value }
    if let value = redScore { dictionary[SerializationKeys.redScore] = value }
    dictionary[SerializationKeys.redDidStartAllRotors] = redDidStartAllRotors
    return dictionary
  }

}
