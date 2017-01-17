//
//  TeamInMatchData.swift
//
//  Created by Bryton Moeller on 1/16/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TeamInMatchData: NSObject, NSCoding, NSObject, Reflectable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kTeamInMatchDataDidBecomeIncapacitatedKey: String = "didBecomeIncapacitated"
	internal let kTeamInMatchDataRankGearControlKey: String = "rankGearControl"
	internal let kTeamInMatchDataRankDefenseKey: String = "rankDefense"
	internal let kTeamInMatchDataCalculatedDataKey: String = "calculatedData"
	internal let kTeamInMatchDataNumGearsPlacedAutoKey: String = "numGearsPlacedAuto"
	internal let kTeamInMatchDataDidStartDisabledKey: String = "didStartDisabled"
	internal let kTeamInMatchDataNumHoppersOpenedTeleKey: String = "numHoppersOpenedTele"
	internal let kTeamInMatchDataLowShotTimesForBoilerTeleKey: String = "lowShotTimesForBoilerTele"
	internal let kTeamInMatchDataNumGearsPlacedTeleKey: String = "numGearsPlacedTele"
	internal let kTeamInMatchDataRankSpeedKey: String = "rankSpeed"
	internal let kTeamInMatchDataMatchNumberKey: String = "matchNumber"
	internal let kTeamInMatchDataHighShotTimesForBoilerTeleKey: String = "highShotTimesForBoilerTele"
	internal let kTeamInMatchDataDidReachBaselineAutoKey: String = "didReachBaselineAuto"
	internal let kTeamInMatchDataHighShotTimesForBoilerAutoKey: String = "highShotTimesForBoilerAuto"
	internal let kTeamInMatchDataTeamNumberKey: String = "teamNumber"
	internal let kTeamInMatchDataDidPotentiallyConflictingAutoKey: String = "didPotentiallyConflictingAuto"
	internal let kTeamInMatchDataRankBallControlKey: String = "rankBallControl"
	internal let kTeamInMatchDataNumGearGroundIntakesTeleKey: String = "numGearGroundIntakesTele"
	internal let kTeamInMatchDataRankAgilityKey: String = "rankAgility"
	internal let kTeamInMatchDataLowShotTimesForBoilerAutoKey: String = "lowShotTimesForBoilerAuto"
	internal let kTeamInMatchDataDidLiftoffKey: String = "didLiftoff"
	internal let kTeamInMatchDataNumGearLoaderIntakesTeleKey: String = "numGearLoaderIntakesTele"
	internal let kTeamInMatchDataNumHoppersOpenedAutoKey: String = "numHoppersOpenedAuto"
	internal let kTeamInMatchDataScoutNameKey: String = "scoutName"


    // MARK: Properties
	public var didBecomeIncapacitated: Bool = false
	public var rankGearControl: Int?
	public var rankDefense: Int?
	public var calculatedData: CalculatedData?
	public var numGearsPlacedAuto: Int?
	public var didStartDisabled: Bool = false
	public var numHoppersOpenedTele: Int?
	public var lowShotTimesForBoilerTele: [ShotTimesForBoiler]?
	public var numGearsPlacedTele: Int?
	public var rankSpeed: Int?
	public var matchNumber: Int?
	public var highShotTimesForBoilerTele: [ShotTimesForBoiler]?
	public var didReachBaselineAuto: Bool = false
	public var highShotTimesForBoilerAuto: [ShotTimesForBoiler]?
	public var teamNumber: Int?
	public var didPotentiallyConflictingAuto: Bool = false
	public var rankBallControl: Int?
	public var numGearGroundIntakesTele: Int?
	public var rankAgility: Int?
	public var lowShotTimesForBoilerAuto: [ShotTimesForBoiler]?
	public var didLiftoff: Bool = false
	public var numGearLoaderIntakesTele: Int?
	public var numHoppersOpenedAuto: Int?
	public var scoutName: String?


    // MARK: SwiftyJSON Initalizers
    /**
    Initates the class based on the object
    - parameter object: The object of either Dictionary or Array kind that was passed.
    - returns: An initalized instance of the class.
    */
    convenience public init(object: AnyObject) {
        self.init(json: JSON(object))
    }

    /**
    Initates the class based on the JSON that was passed.
    - parameter json: JSON object from SwiftyJSON.
    - returns: An initalized instance of the class.
    */
    public init(json: JSON) {
		didBecomeIncapacitated = json[kTeamInMatchDataDidBecomeIncapacitatedKey].boolValue
		rankGearControl = json[kTeamInMatchDataRankGearControlKey].int
		rankDefense = json[kTeamInMatchDataRankDefenseKey].int
		calculatedData = CalculatedData(json: json[kTeamInMatchDataCalculatedDataKey])
		numGearsPlacedAuto = json[kTeamInMatchDataNumGearsPlacedAutoKey].int
		didStartDisabled = json[kTeamInMatchDataDidStartDisabledKey].boolValue
		numHoppersOpenedTele = json[kTeamInMatchDataNumHoppersOpenedTeleKey].int
		lowShotTimesForBoilerTele = []
		if let items = json[kTeamInMatchDataLowShotTimesForBoilerTeleKey].array {
			for item in items {
				lowShotTimesForBoilerTele?.append(LowShotTimesForBoilerTele(json: item))
			}
		} else {
			lowShotTimesForBoilerTele = nil
		}
		numGearsPlacedTele = json[kTeamInMatchDataNumGearsPlacedTeleKey].int
		rankSpeed = json[kTeamInMatchDataRankSpeedKey].int
		matchNumber = json[kTeamInMatchDataMatchNumberKey].int
		highShotTimesForBoilerTele = []
		if let items = json[kTeamInMatchDataHighShotTimesForBoilerTeleKey].array {
			for item in items {
				highShotTimesForBoilerTele?.append(HighShotTimesForBoilerTele(json: item))
			}
		} else {
			highShotTimesForBoilerTele = nil
		}
		didReachBaselineAuto = json[kTeamInMatchDataDidReachBaselineAutoKey].boolValue
		highShotTimesForBoilerAuto = []
		if let items = json[kTeamInMatchDataHighShotTimesForBoilerAutoKey].array {
			for item in items {
				highShotTimesForBoilerAuto?.append(HighShotTimesForBoilerAuto(json: item))
			}
		} else {
			highShotTimesForBoilerAuto = nil
		}
		teamNumber = json[kTeamInMatchDataTeamNumberKey].int
		didPotentiallyConflictingAuto = json[kTeamInMatchDataDidPotentiallyConflictingAutoKey].boolValue
		rankBallControl = json[kTeamInMatchDataRankBallControlKey].int
		numGearGroundIntakesTele = json[kTeamInMatchDataNumGearGroundIntakesTeleKey].int
		rankAgility = json[kTeamInMatchDataRankAgilityKey].int
		lowShotTimesForBoilerAuto = []
		if let items = json[kTeamInMatchDataLowShotTimesForBoilerAutoKey].array {
			for item in items {
				lowShotTimesForBoilerAuto?.append(LowShotTimesForBoilerAuto(json: item))
			}
		} else {
			lowShotTimesForBoilerAuto = nil
		}
		didLiftoff = json[kTeamInMatchDataDidLiftoffKey].boolValue
		numGearLoaderIntakesTele = json[kTeamInMatchDataNumGearLoaderIntakesTeleKey].int
		numHoppersOpenedAuto = json[kTeamInMatchDataNumHoppersOpenedAutoKey].int
		scoutName = json[kTeamInMatchDataScoutNameKey].string

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		dictionary.updateValue(didBecomeIncapacitated, forKey: kTeamInMatchDataDidBecomeIncapacitatedKey)
		if rankGearControl != nil {
			dictionary.updateValue(rankGearControl!, forKey: kTeamInMatchDataRankGearControlKey)
		}
		if rankDefense != nil {
			dictionary.updateValue(rankDefense!, forKey: kTeamInMatchDataRankDefenseKey)
		}
		if calculatedData != nil {
			dictionary.updateValue(calculatedData!.dictionaryRepresentation(), forKey: kTeamInMatchDataCalculatedDataKey)
		}
		if numGearsPlacedAuto != nil {
			dictionary.updateValue(numGearsPlacedAuto!, forKey: kTeamInMatchDataNumGearsPlacedAutoKey)
		}
		dictionary.updateValue(didStartDisabled, forKey: kTeamInMatchDataDidStartDisabledKey)
		if numHoppersOpenedTele != nil {
			dictionary.updateValue(numHoppersOpenedTele!, forKey: kTeamInMatchDataNumHoppersOpenedTeleKey)
		}
		if lowShotTimesForBoilerTele?.count > 0 {
			var temp: [AnyObject] = []
			for item in lowShotTimesForBoilerTele! {
				temp.append(item.dictionaryRepresentation())
			}
			dictionary.updateValue(temp, forKey: kTeamInMatchDataLowShotTimesForBoilerTeleKey)
		}
		if numGearsPlacedTele != nil {
			dictionary.updateValue(numGearsPlacedTele!, forKey: kTeamInMatchDataNumGearsPlacedTeleKey)
		}
		if rankSpeed != nil {
			dictionary.updateValue(rankSpeed!, forKey: kTeamInMatchDataRankSpeedKey)
		}
		if matchNumber != nil {
			dictionary.updateValue(matchNumber!, forKey: kTeamInMatchDataMatchNumberKey)
		}
		if highShotTimesForBoilerTele?.count > 0 {
			var temp: [AnyObject] = []
			for item in highShotTimesForBoilerTele! {
				temp.append(item.dictionaryRepresentation())
			}
			dictionary.updateValue(temp, forKey: kTeamInMatchDataHighShotTimesForBoilerTeleKey)
		}
		dictionary.updateValue(didReachBaselineAuto, forKey: kTeamInMatchDataDidReachBaselineAutoKey)
		if highShotTimesForBoilerAuto?.count > 0 {
			var temp: [AnyObject] = []
			for item in highShotTimesForBoilerAuto! {
				temp.append(item.dictionaryRepresentation())
			}
			dictionary.updateValue(temp, forKey: kTeamInMatchDataHighShotTimesForBoilerAutoKey)
		}
		if teamNumber != nil {
			dictionary.updateValue(teamNumber!, forKey: kTeamInMatchDataTeamNumberKey)
		}
		dictionary.updateValue(didPotentiallyConflictingAuto, forKey: kTeamInMatchDataDidPotentiallyConflictingAutoKey)
		if rankBallControl != nil {
			dictionary.updateValue(rankBallControl!, forKey: kTeamInMatchDataRankBallControlKey)
		}
		if numGearGroundIntakesTele != nil {
			dictionary.updateValue(numGearGroundIntakesTele!, forKey: kTeamInMatchDataNumGearGroundIntakesTeleKey)
		}
		if rankAgility != nil {
			dictionary.updateValue(rankAgility!, forKey: kTeamInMatchDataRankAgilityKey)
		}
		if lowShotTimesForBoilerAuto?.count > 0 {
			var temp: [AnyObject] = []
			for item in lowShotTimesForBoilerAuto! {
				temp.append(item.dictionaryRepresentation())
			}
			dictionary.updateValue(temp, forKey: kTeamInMatchDataLowShotTimesForBoilerAutoKey)
		}
		dictionary.updateValue(didLiftoff, forKey: kTeamInMatchDataDidLiftoffKey)
		if numGearLoaderIntakesTele != nil {
			dictionary.updateValue(numGearLoaderIntakesTele!, forKey: kTeamInMatchDataNumGearLoaderIntakesTeleKey)
		}
		if numHoppersOpenedAuto != nil {
			dictionary.updateValue(numHoppersOpenedAuto!, forKey: kTeamInMatchDataNumHoppersOpenedAutoKey)
		}
		if scoutName != nil {
			dictionary.updateValue(scoutName!, forKey: kTeamInMatchDataScoutNameKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.didBecomeIncapacitated = aDecoder.decodeBoolForKey(kTeamInMatchDataDidBecomeIncapacitatedKey)
		self.rankGearControl = aDecoder.decodeObjectForKey(kTeamInMatchDataRankGearControlKey) as? Int
		self.rankDefense = aDecoder.decodeObjectForKey(kTeamInMatchDataRankDefenseKey) as? Int
		self.calculatedData = aDecoder.decodeObjectForKey(kTeamInMatchDataCalculatedDataKey) as? CalculatedData
		self.numGearsPlacedAuto = aDecoder.decodeObjectForKey(kTeamInMatchDataNumGearsPlacedAutoKey) as? Int
		self.didStartDisabled = aDecoder.decodeBoolForKey(kTeamInMatchDataDidStartDisabledKey)
		self.numHoppersOpenedTele = aDecoder.decodeObjectForKey(kTeamInMatchDataNumHoppersOpenedTeleKey) as? Int
		self.lowShotTimesForBoilerTele = aDecoder.decodeObjectForKey(kTeamInMatchDataLowShotTimesForBoilerTeleKey) as? [ShotTimesForBoiler]
		self.numGearsPlacedTele = aDecoder.decodeObjectForKey(kTeamInMatchDataNumGearsPlacedTeleKey) as? Int
		self.rankSpeed = aDecoder.decodeObjectForKey(kTeamInMatchDataRankSpeedKey) as? Int
		self.matchNumber = aDecoder.decodeObjectForKey(kTeamInMatchDataMatchNumberKey) as? Int
		self.highShotTimesForBoilerTele = aDecoder.decodeObjectForKey(kTeamInMatchDataHighShotTimesForBoilerTeleKey) as? [ShotTimesForBoiler]
		self.didReachBaselineAuto = aDecoder.decodeBoolForKey(kTeamInMatchDataDidReachBaselineAutoKey)
		self.highShotTimesForBoilerAuto = aDecoder.decodeObjectForKey(kTeamInMatchDataHighShotTimesForBoilerAutoKey) as? [ShotTimesForBoiler]
		self.teamNumber = aDecoder.decodeObjectForKey(kTeamInMatchDataTeamNumberKey) as? Int
		self.didPotentiallyConflictingAuto = aDecoder.decodeBoolForKey(kTeamInMatchDataDidPotentiallyConflictingAutoKey)
		self.rankBallControl = aDecoder.decodeObjectForKey(kTeamInMatchDataRankBallControlKey) as? Int
		self.numGearGroundIntakesTele = aDecoder.decodeObjectForKey(kTeamInMatchDataNumGearGroundIntakesTeleKey) as? Int
		self.rankAgility = aDecoder.decodeObjectForKey(kTeamInMatchDataRankAgilityKey) as? Int
		self.lowShotTimesForBoilerAuto = aDecoder.decodeObjectForKey(kTeamInMatchDataLowShotTimesForBoilerAutoKey) as? [ShotTimesForBoiler]
		self.didLiftoff = aDecoder.decodeBoolForKey(kTeamInMatchDataDidLiftoffKey)
		self.numGearLoaderIntakesTele = aDecoder.decodeObjectForKey(kTeamInMatchDataNumGearLoaderIntakesTeleKey) as? Int
		self.numHoppersOpenedAuto = aDecoder.decodeObjectForKey(kTeamInMatchDataNumHoppersOpenedAutoKey) as? Int
		self.scoutName = aDecoder.decodeObjectForKey(kTeamInMatchDataScoutNameKey) as? String

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeBool(didBecomeIncapacitated, forKey: kTeamInMatchDataDidBecomeIncapacitatedKey)
		aCoder.encodeObject(rankGearControl, forKey: kTeamInMatchDataRankGearControlKey)
		aCoder.encodeObject(rankDefense, forKey: kTeamInMatchDataRankDefenseKey)
		aCoder.encodeObject(calculatedData, forKey: kTeamInMatchDataCalculatedDataKey)
		aCoder.encodeObject(numGearsPlacedAuto, forKey: kTeamInMatchDataNumGearsPlacedAutoKey)
		aCoder.encodeBool(didStartDisabled, forKey: kTeamInMatchDataDidStartDisabledKey)
		aCoder.encodeObject(numHoppersOpenedTele, forKey: kTeamInMatchDataNumHoppersOpenedTeleKey)
		aCoder.encodeObject(lowShotTimesForBoilerTele, forKey: kTeamInMatchDataLowShotTimesForBoilerTeleKey)
		aCoder.encodeObject(numGearsPlacedTele, forKey: kTeamInMatchDataNumGearsPlacedTeleKey)
		aCoder.encodeObject(rankSpeed, forKey: kTeamInMatchDataRankSpeedKey)
		aCoder.encodeObject(matchNumber, forKey: kTeamInMatchDataMatchNumberKey)
		aCoder.encodeObject(highShotTimesForBoilerTele, forKey: kTeamInMatchDataHighShotTimesForBoilerTeleKey)
		aCoder.encodeBool(didReachBaselineAuto, forKey: kTeamInMatchDataDidReachBaselineAutoKey)
		aCoder.encodeObject(highShotTimesForBoilerAuto, forKey: kTeamInMatchDataHighShotTimesForBoilerAutoKey)
		aCoder.encodeObject(teamNumber, forKey: kTeamInMatchDataTeamNumberKey)
		aCoder.encodeBool(didPotentiallyConflictingAuto, forKey: kTeamInMatchDataDidPotentiallyConflictingAutoKey)
		aCoder.encodeObject(rankBallControl, forKey: kTeamInMatchDataRankBallControlKey)
		aCoder.encodeObject(numGearGroundIntakesTele, forKey: kTeamInMatchDataNumGearGroundIntakesTeleKey)
		aCoder.encodeObject(rankAgility, forKey: kTeamInMatchDataRankAgilityKey)
		aCoder.encodeObject(lowShotTimesForBoilerAuto, forKey: kTeamInMatchDataLowShotTimesForBoilerAutoKey)
		aCoder.encodeBool(didLiftoff, forKey: kTeamInMatchDataDidLiftoffKey)
		aCoder.encodeObject(numGearLoaderIntakesTele, forKey: kTeamInMatchDataNumGearLoaderIntakesTeleKey)
		aCoder.encodeObject(numHoppersOpenedAuto, forKey: kTeamInMatchDataNumHoppersOpenedAutoKey)
		aCoder.encodeObject(scoutName, forKey: kTeamInMatchDataScoutNameKey)

    }

}
