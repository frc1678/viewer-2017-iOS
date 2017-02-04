//
//  TeamInMatchData.swift
//
//  Created by Bryton Moeller on 1/16/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class TeamInMatchData: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let rankDefense = "rankDefense"
    static let rankGearControl = "rankGearControl"
    static let lowShotTimesForBoilerTele = "lowShotTimesForBoilerTele"
    static let numGearLoaderIntakesTele = "numGearLoaderIntakesTele"
    static let rankBallControl = "rankBallControl"
    static let highShotTimesForBoilerAuto = "highShotTimesForBoilerAuto"
    static let matchNumber = "matchNumber"
    static let highShotTimesForBoilerTele = "highShotTimesForBoilerTele"
    static let gearsPlacedByLiftAuto = "gearsPlacedByLiftAuto"
    static let numGearGroundIntakesTele = "numGearGroundIntakesTele"
    static let didStartDisabled = "didStartDisabled"
    static let didReachBaselineAuto = "didReachBaselineAuto"
    static let gearsPlacedByLiftTele = "gearsPlacedByLiftTele"
    static let rankSpeed = "rankSpeed"
    static let lowShotTimesForBoilerAuto = "lowShotTimesForBoilerAuto"
    static let rankAgility = "rankAgility"
    static let numGearsPlacedTele = "numGearsPlacedTele"
    static let teamNumber = "teamNumber"
    static let didBecomeIncapacitated = "didBecomeIncapacitated"
    static let didPotentiallyConflictingAuto = "didPotentiallyConflictingAuto"
    static let scoutName = "scoutName"
    static let didLiftoff = "didLiftoff"
    static let numGearsPlacedAuto = "numGearsPlacedAuto"
    static let calculatedData = "calculatedData"
    static let numHoppersOpenedAuto = "numHoppersOpenedAuto"
    static let numHoppersOpenedTele = "numHoppersOpenedTele"
  }

  // MARK: Properties
  public var rankDefense: Int? 
  public var rankGearControl: Int?
    public var numGearsPlacedAuto: Int?
  public var lowShotTimesForBoilerTele: [ShotTimesForBoiler]?
  public var numGearLoaderIntakesTele: Int? 
  public var rankBallControl: Int? 
  public var highShotTimesForBoilerAuto: [ShotTimesForBoiler]?
  public var numHoppersOpenedAuto: Int? 
  public var matchNumber: Int?
    public var gearsPlacedByLiftTele: Int?
    public var gearsPlacedByLiftAuto: Int?
  public var highShotTimesForBoilerTele: [ShotTimesForBoiler]?
    public var numGearsPlacedTele: Int?
  public var numGearGroundIntakesTele: Int? 
  public var didStartDisabled: Bool = false
  public var didReachBaselineAuto: Bool = false
  public var rankSpeed: Int?
  public var numHoppersOpenedTele: Int? 
  public var lowShotTimesForBoilerAuto: [ShotTimesForBoiler]?
  public var rankAgility: Int? 
  public var teamNumber: Int? 
  public var didBecomeIncapacitated: Bool = false
  public var didPotentiallyConflictingAuto: Bool = false
  public var scoutName: String?
  public var didLiftoff: Bool = false
    public var calculatedData : CalculatedTeamInMatchData?

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
    rankDefense = json[SerializationKeys.rankDefense].intValue
    rankGearControl = json[SerializationKeys.rankGearControl].intValue
    if let items = json[SerializationKeys.lowShotTimesForBoilerTele].array { lowShotTimesForBoilerTele = items.map { ShotTimesForBoiler(json: $0) } }
    numGearLoaderIntakesTele = json[SerializationKeys.numGearLoaderIntakesTele].intValue
    rankBallControl = json[SerializationKeys.rankBallControl].intValue
    if let items = json[SerializationKeys.highShotTimesForBoilerAuto].array { highShotTimesForBoilerAuto = items.map { ShotTimesForBoiler(json: $0) } }
    matchNumber = json[SerializationKeys.matchNumber].intValue
    if let items = json[SerializationKeys.highShotTimesForBoilerTele].array { highShotTimesForBoilerTele = items.map { ShotTimesForBoiler(json: $0) } }
    gearsPlacedByLiftAuto = json[SerializationKeys.gearsPlacedByLiftAuto].int
    numGearsPlacedAuto = json[SerializationKeys.numGearsPlacedAuto].intValue
    numGearGroundIntakesTele = json[SerializationKeys.numGearGroundIntakesTele].intValue
    didStartDisabled = json[SerializationKeys.didStartDisabled].boolValue
    didReachBaselineAuto = json[SerializationKeys.didReachBaselineAuto].boolValue
    numGearsPlacedTele = json[SerializationKeys.numGearsPlacedTele].intValue
    rankSpeed = json[SerializationKeys.rankSpeed].intValue

    if let items = json[SerializationKeys.lowShotTimesForBoilerAuto].array { lowShotTimesForBoilerAuto = items.map { ShotTimesForBoiler(json: $0) } }
    rankAgility = json[SerializationKeys.rankAgility].intValue
    teamNumber = json[SerializationKeys.teamNumber].intValue
    didBecomeIncapacitated = json[SerializationKeys.didBecomeIncapacitated].boolValue
    didPotentiallyConflictingAuto = json[SerializationKeys.didPotentiallyConflictingAuto].boolValue
    scoutName = json[SerializationKeys.scoutName].string
    didLiftoff = json[SerializationKeys.didLiftoff].boolValue
    calculatedData = CalculatedTeamInMatchData(json: json[SerializationKeys.calculatedData])
    numHoppersOpenedAuto = json[SerializationKeys.numHoppersOpenedAuto].int
    numHoppersOpenedTele = json[SerializationKeys.numHoppersOpenedTele].int
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = rankDefense { dictionary[SerializationKeys.rankDefense] = value }
    if let value = rankGearControl { dictionary[SerializationKeys.rankGearControl] = value }
    if let value = lowShotTimesForBoilerTele { dictionary[SerializationKeys.lowShotTimesForBoilerTele] = value.map { $0.dictionaryRepresentation() } }
    if let value = numGearLoaderIntakesTele { dictionary[SerializationKeys.numGearLoaderIntakesTele] = value }
    if let value = rankBallControl { dictionary[SerializationKeys.rankBallControl] = value }
    if let value = highShotTimesForBoilerAuto { dictionary[SerializationKeys.highShotTimesForBoilerAuto] = value.map { $0.dictionaryRepresentation() } }
    if let value = matchNumber { dictionary[SerializationKeys.matchNumber] = value }
    if let value = highShotTimesForBoilerTele { dictionary[SerializationKeys.highShotTimesForBoilerTele] = value.map { $0.dictionaryRepresentation() } }
    if let value = gearsPlacedByLiftAuto { dictionary[SerializationKeys.gearsPlacedByLiftAuto] = value }
    if let value = numGearGroundIntakesTele { dictionary[SerializationKeys.numGearGroundIntakesTele] = value }
    dictionary[SerializationKeys.didStartDisabled] = didStartDisabled
    dictionary[SerializationKeys.didReachBaselineAuto] = didReachBaselineAuto
    if let value = gearsPlacedByLiftTele { dictionary[SerializationKeys.gearsPlacedByLiftTele] = value }
    if let value = rankSpeed { dictionary[SerializationKeys.rankSpeed] = value }
    if let value = lowShotTimesForBoilerAuto { dictionary[SerializationKeys.lowShotTimesForBoilerAuto] = value.map { $0.dictionaryRepresentation() } }
    if let value = rankAgility { dictionary[SerializationKeys.rankAgility] = value }
    if let value = teamNumber { dictionary[SerializationKeys.teamNumber] = value }
    dictionary[SerializationKeys.didBecomeIncapacitated] = didBecomeIncapacitated
    dictionary[SerializationKeys.didPotentiallyConflictingAuto] = didPotentiallyConflictingAuto
    if let value = scoutName { dictionary[SerializationKeys.scoutName] = value }
    dictionary[SerializationKeys.didLiftoff] = didLiftoff
    if let value = calculatedData { dictionary[SerializationKeys.calculatedData] = value.dictionaryRepresentation() }
    if let value = numHoppersOpenedAuto { dictionary[SerializationKeys.numHoppersOpenedAuto] = value }
    if let value = numHoppersOpenedTele { dictionary[SerializationKeys.numHoppersOpenedTele] = value }

    return dictionary
  }

}
