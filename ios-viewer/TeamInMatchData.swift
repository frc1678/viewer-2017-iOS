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
    static let numGearsFumbledTele = "numGearsFumbledTele"
    static let numGearsEjectedTele = "numGearsEjectedTele"
    static let superNotes = "superNotes"
  }

  // MARK: Properties
  public var rankDefense: Int? 
  public var rankGearControl: Int?
  public var lowShotTimesForBoilerTele: [ShotTimesForBoiler]?
  public var numGearLoaderIntakesTele: Float? //sdf
  public var rankBallControl: Int? 
  public var highShotTimesForBoilerAuto: [ShotTimesForBoiler]?
  public var numHoppersOpenedAuto: Float?
  public var matchNumber: Int?
  public var highShotTimesForBoilerTele: [ShotTimesForBoiler]?
  public var numGearGroundIntakesTele: Float?
  public var didStartDisabled: Bool?
  public var didReachBaselineAuto: Bool?
  public var rankSpeed: Int?
  public var numHoppersOpenedTele: Float?
  public var lowShotTimesForBoilerAuto: [ShotTimesForBoiler]?
  public var rankAgility: Int?
  public var teamNumber: Int? 
  public var didBecomeIncapacitated: Bool?
  public var didPotentiallyConflictingAuto: Bool = false
  public var scoutName: String?
  public var didLiftoff: Bool?
    public var numGearsFumbledTele: Float?
    public var numGearsEjectedTele: Float?
    public var calculatedData : CalculatedTeamInMatchData?
    public var superNotes: String?


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
    rankDefense = json[SerializationKeys.rankDefense].int
    rankGearControl = json[SerializationKeys.rankGearControl].int
    if let items = json[SerializationKeys.lowShotTimesForBoilerTele].array { lowShotTimesForBoilerTele = items.map { ShotTimesForBoiler(json: $0) } }
    numGearLoaderIntakesTele = json[SerializationKeys.numGearLoaderIntakesTele].float
    rankBallControl = json[SerializationKeys.rankBallControl].int
    if let items = json[SerializationKeys.highShotTimesForBoilerAuto].array { highShotTimesForBoilerAuto = items.map { ShotTimesForBoiler(json: $0) } }
    matchNumber = json[SerializationKeys.matchNumber].intValue
    if let items = json[SerializationKeys.highShotTimesForBoilerTele].array { highShotTimesForBoilerTele = items.map { ShotTimesForBoiler(json: $0) } }
    numGearGroundIntakesTele = json[SerializationKeys.numGearGroundIntakesTele].float
    didStartDisabled = json[SerializationKeys.didStartDisabled].bool
    didReachBaselineAuto = json[SerializationKeys.didReachBaselineAuto].bool
    rankSpeed = json[SerializationKeys.rankSpeed].int

    if let items = json[SerializationKeys.lowShotTimesForBoilerAuto].array { lowShotTimesForBoilerAuto = items.map { ShotTimesForBoiler(json: $0) } }
    rankAgility = json[SerializationKeys.rankAgility].int
    teamNumber = json[SerializationKeys.teamNumber].intValue
    didBecomeIncapacitated = json[SerializationKeys.didBecomeIncapacitated].bool
    didPotentiallyConflictingAuto = json[SerializationKeys.didPotentiallyConflictingAuto].boolValue
    scoutName = json[SerializationKeys.scoutName].string
    didLiftoff = json[SerializationKeys.didLiftoff].bool
    calculatedData = CalculatedTeamInMatchData(json: json[SerializationKeys.calculatedData])
    numHoppersOpenedAuto = json[SerializationKeys.numHoppersOpenedAuto].float
    numHoppersOpenedTele = json[SerializationKeys.numHoppersOpenedTele].float
    numGearsEjectedTele = json[SerializationKeys.numGearsEjectedTele].float
    numGearsFumbledTele = json[SerializationKeys.numGearsFumbledTele].float
    superNotes = json[SerializationKeys.superNotes].string
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
    if let value = numGearGroundIntakesTele { dictionary[SerializationKeys.numGearGroundIntakesTele] = value }
    if let value = didStartDisabled { dictionary[SerializationKeys.didStartDisabled] = value }
    if let value = didReachBaselineAuto { dictionary[SerializationKeys.didReachBaselineAuto] = value }
    if let value = rankSpeed { dictionary[SerializationKeys.rankSpeed] = value }
    if let value = lowShotTimesForBoilerAuto { dictionary[SerializationKeys.lowShotTimesForBoilerAuto] = value.map { $0.dictionaryRepresentation() } }
    if let value = rankAgility { dictionary[SerializationKeys.rankAgility] = value }
    if let value = teamNumber { dictionary[SerializationKeys.teamNumber] = value }
    if let value = didBecomeIncapacitated { dictionary[SerializationKeys.didBecomeIncapacitated] = value }
    dictionary[SerializationKeys.didPotentiallyConflictingAuto] = didPotentiallyConflictingAuto
    if let value = scoutName { dictionary[SerializationKeys.scoutName] = value }
    if let value = didLiftoff { dictionary[SerializationKeys.didLiftoff] = value }
    if let value = calculatedData { dictionary[SerializationKeys.calculatedData] = value.dictionaryRepresentation() }
    if let value = numHoppersOpenedAuto { dictionary[SerializationKeys.numHoppersOpenedAuto] = value }
    if let value = numHoppersOpenedTele { dictionary[SerializationKeys.numHoppersOpenedTele] = value }
    if let value = numGearsFumbledTele { dictionary[SerializationKeys.numGearsFumbledTele] = value }
    if let value = numGearsEjectedTele { dictionary[SerializationKeys.numGearsEjectedTele] = value }
    if let value = numGearsEjectedTele { dictionary[SerializationKeys.superNotes] = value }

    return dictionary
  }

}
