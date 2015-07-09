//
//  MatchDetailsViewController.blue
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/16/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import UIKit

class MatchDetailsViewController: UIViewController {
    var match: Match? = nil {
        didSet {
            updateUI()
        }
    }
    
    let mapping = ["One", "Two", "Three"]
    
    @IBOutlet weak var redOfficialScoreLabel: UILabel!
    @IBOutlet weak var blueOfficialScoreLabel: UILabel!
    @IBOutlet weak var redPredictedScoreLabel: UILabel!
    @IBOutlet weak var bluePredictedScoreLabel: UILabel!
    @IBOutlet weak var redErrorPercentageLabel: UILabel!
    @IBOutlet weak var blueErrorPercentageLabel: UILabel!
    
    @IBOutlet weak var redTeamOneButton: UIButton!
    @IBOutlet weak var redTeamOneAbilityLabel: UILabel!
    
    @IBOutlet weak var redTeamTwoButton: UIButton!
    @IBOutlet weak var redTeamTwoAbilityLabel: UILabel!
    
    @IBOutlet weak var redTeamThreeButton: UIButton!
    @IBOutlet weak var redTeamThreeAbilityLabel: UILabel!
    
    @IBOutlet weak var blueTeamOneButton: UIButton!
    @IBOutlet weak var blueTeamOneAbilityLabel: UILabel!
    
    @IBOutlet weak var blueTeamTwoButton: UIButton!
    @IBOutlet weak var blueTeamTwoAbilityLabel: UILabel!
    
    @IBOutlet weak var blueTeamThreeButton: UIButton!
    @IBOutlet weak var blueTeamThreeAbilityLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        if redOfficialScoreLabel == nil {
            return
        }
        
        if let match = match {
            title = match.match
            
            redOfficialScoreLabel.text = getLabelTitle(match.officialRedScore)
            redPredictedScoreLabel.text = getLabelTitle(match.calculatedData.predictedRedScore)
            redErrorPercentageLabel.text = getErrorLabelText(match.officialRedScore, predictedScore: Float(match.calculatedData.predictedRedScore))
            
            let redTeams = ScoutDataFetcher.realmArrayToArray(match.redTeams) as! [Team]
            if count(redTeams) > 0 {
                for index in 0...(count(redTeams) - 1) {
                    if index <= 2 {
                        (valueForKey("redTeam\(mapping[index])Button") as! UIButton).setTitle("\(redTeams[index].number)", forState: UIControlState.Normal)
                        
                        (valueForKey("redTeam\(mapping[index])AbilityLabel") as! UILabel).text = roundValue(redTeams[index].calculatedData.stackingAbility, toDecimalPlaces: 4)
                    }
                }
            }
            
            blueOfficialScoreLabel.text = getLabelTitle(match.officialBlueScore)
            bluePredictedScoreLabel.text = getLabelTitle(match.calculatedData.predictedBlueScore)
            blueErrorPercentageLabel.text = getErrorLabelText(match.officialBlueScore, predictedScore: Float(match.calculatedData.predictedBlueScore))

            let blueTeams = ScoutDataFetcher.realmArrayToArray(match.blueTeams) as! [Team]
            if count(blueTeams) > 0 {
                for index in 0...(count(blueTeams) - 1) {
                    if index <= 2 {
                        (valueForKey("blueTeam\(mapping[index])Button") as! UIButton).setTitle("\(blueTeams[index].number)", forState: UIControlState.Normal)
                        
                        (valueForKey("blueTeam\(mapping[index])AbilityLabel") as! UILabel).text = roundValue(blueTeams[index].calculatedData.stackingAbility, toDecimalPlaces: 4)
                    }
                }
            }
        }
    }
    
    @IBAction func teamTapped(sender: UIButton) {
        if let teamNumTapped = sender.titleLabel?.text?.toInt() {
            if let match = ScoutDataFetcher.fetchTeamInMatchDataForTeam(ScoutDataFetcher.fetchTeam(teamNumTapped), inMatch: match) where match.uploadedData.maxFieldToteHeight > 0 {
                performSegueWithIdentifier("GoToTIMController", sender: sender)
            } else {
                performSegueWithIdentifier("GoToTeamController", sender: sender)
            }
        }
    }
    private func getLabelTitle(value: Int?) -> String {
        let unknown = "???"
        if let value = value {
            if value != -1 {
                return "\(value)"
            }
        }
        return unknown
    }
    
    private func getLabelTitle(v: Float?) -> String {
        let unknown = "???"
        if let value = v {
            if value != -1 {
                return "\(value)"
            }
        }
        return unknown
    }
    
    private func getErrorLabelText(officialScore: Int?, predictedScore: Float?) -> String {
        if let err = getError(officialScore, predictedScore: predictedScore) {
            return roundValue(err * 100, toDecimalPlaces: 2) + "%"
        }
        
        return "???"
    }
    
    private func getError(officialScore: Int?, predictedScore: Float?) -> Float? {
        if let officialScore = officialScore,
            let predictedScore = predictedScore {
                if officialScore != -1 {
                    return abs((Float(officialScore) - predictedScore) / Float(officialScore))
                }
        }
        
        return nil
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let button = sender as? UIButton,
               teamNumTapped = button.titleLabel?.text?.toInt() {
            if let dest = segue.destinationViewController as? TeamInMatchDetailsTableViewController {
                dest.data = ScoutDataFetcher.fetchTeamInMatchDataForTeam(ScoutDataFetcher.fetchTeam(teamNumTapped), inMatch: match)
            } else if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
                dest.data = ScoutDataFetcher.fetchTeam(teamNumTapped)
            }
        }
    }
}
