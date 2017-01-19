//
//  Match.swift
//
//  Created by Bryton Moeller on 1/18/17
//  Copyright (c) Citrus Circuits. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Team: NSObject {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let pitOrganization = "pitOrganization"
    static let pitProgrammingLanguage = "pitProgrammingLanguage"
    static let number = "number"
    static let pitAvailableWeight = "pitAvailableWeight"
    static let calculatedData = "calculatedData"
    static let selectedImageURL = "selectedImageURL"
    static let allImageUrls = "allImageUrls"
    static let pitDidUseStandardTankDrive = "pitDidUseStandardTankDrive"
    static let pitDidDemonstrateCheesecakePotential = "pitDidDemonstrateCheesecakePotential"
  }

  // MARK: Properties
  public var name: String?
  public var pitOrganization: String?
  public var pitProgrammingLanguage: String?
  public var number: Int = -1
  public var pitAvailableWeight: Int = -1
  public var calculatedData: CalculatedTeamData?
  public var selectedImageURL: String?
    public var allImageUrls: [String]?
  public var pitDidUseStandardTankDrive: Bool? = false
  public var pitDidDemonstrateCheesecakePotential: Bool? = false

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
    name = json[SerializationKeys.name].string
    pitOrganization = json[SerializationKeys.pitOrganization].string
    pitProgrammingLanguage = json[SerializationKeys.pitProgrammingLanguage].string
    number = json[SerializationKeys.number].int!
    pitAvailableWeight = json[SerializationKeys.pitAvailableWeight].int!
    calculatedData = CalculatedTeamData(json: json[SerializationKeys.calculatedData])
    selectedImageURL = json[SerializationKeys.selectedImageURL].string
    allImageUrls = json[SerializationKeys.allImageUrls].arrayObject as! [String]?
    pitDidUseStandardTankDrive = json[SerializationKeys.pitDidUseStandardTankDrive].boolValue
    pitDidDemonstrateCheesecakePotential = json[SerializationKeys.pitDidDemonstrateCheesecakePotential].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = pitOrganization { dictionary[SerializationKeys.pitOrganization] = value }
    if let value = pitProgrammingLanguage { dictionary[SerializationKeys.pitProgrammingLanguage] = value }
    dictionary[SerializationKeys.number] = number
    dictionary[SerializationKeys.pitAvailableWeight] = pitAvailableWeight
    if let value = calculatedData { dictionary[SerializationKeys.calculatedData] = value.dictionaryRepresentation() }
    if let value = selectedImageURL { dictionary[SerializationKeys.selectedImageURL] = value }
    if let value = allImageUrls { dictionary[SerializationKeys.allImageUrls] = value }

    dictionary[SerializationKeys.pitDidUseStandardTankDrive] = pitDidUseStandardTankDrive
    dictionary[SerializationKeys.pitDidDemonstrateCheesecakePotential] = pitDidDemonstrateCheesecakePotential
    return dictionary
  }

}
