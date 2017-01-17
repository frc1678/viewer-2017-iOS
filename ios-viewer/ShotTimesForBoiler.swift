//
//  ShotTimesForBoiler.swift
//
//  Created by Bryton Moeller on 1/16/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public class ShotTimesForBoiler: NSObject, NSCoding, NSObject, Reflectable {

    // MARK: Declaration for string constants to be used to decode and also serialize.
	internal let kShotTimesForBoilerPositionKey: String = "position"
	internal let kShotTimesForBoilerNumShotsKey: String = "numShots"
	internal let kShotTimesForBoilerTimeKey: String = "time"


    // MARK: Properties
	public var position: String?
	public var numShots: Int?
	public var time: Int?


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
		position = json[kShotTimesForBoilerPositionKey].string
		numShots = json[kShotTimesForBoilerNumShotsKey].int
		time = json[kShotTimesForBoilerTimeKey].int

    }


    /**
    Generates description of the object in the form of a NSDictionary.
    - returns: A Key value pair containing all valid values in the object.
    */
    public func dictionaryRepresentation() -> [String : AnyObject ] {

        var dictionary: [String : AnyObject ] = [ : ]
		if position != nil {
			dictionary.updateValue(position!, forKey: kShotTimesForBoilerPositionKey)
		}
		if numShots != nil {
			dictionary.updateValue(numShots!, forKey: kShotTimesForBoilerNumShotsKey)
		}
		if time != nil {
			dictionary.updateValue(time!, forKey: kShotTimesForBoilerTimeKey)
		}

        return dictionary
    }

    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
		self.position = aDecoder.decodeObjectForKey(kShotTimesForBoilerPositionKey) as? String
		self.numShots = aDecoder.decodeObjectForKey(kShotTimesForBoilerNumShotsKey) as? Int
		self.time = aDecoder.decodeObjectForKey(kShotTimesForBoilerTimeKey) as? Int

    }

    public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(position, forKey: kShotTimesForBoilerPositionKey)
		aCoder.encodeObject(numShots, forKey: kShotTimesForBoilerNumShotsKey)
		aCoder.encodeObject(time, forKey: kShotTimesForBoilerTimeKey)

    }

}
