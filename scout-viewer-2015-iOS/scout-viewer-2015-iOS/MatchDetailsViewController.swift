//
//  MatchDetailsViewController.blue
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/16/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import UIKit

class MatchDetailsViewController: UIViewController {
    
    var firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher;
    
    var matchNumber = -1
    
    
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
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        updateUI()
        print(self.match)
    }
    
    private func updateUI() {
        if redOfficialScoreLabel == nil {
            return
        }
        
        if let match = match {
            title = String(match.number)
            
            redOfficialScoreLabel.text = getLabelTitle(match.redScore)
            redPredictedScoreLabel.text = getLabelTitle(Int(match.calculatedData.predictedRedScore))
            redErrorPercentageLabel.text = getErrorLabelText(match.redScore, predictedScore: Float(match.calculatedData.predictedRedScore))
            
            let redTeams = firebaseFetcher.getTeamsFromNumbers(match.redAllianceTeamNumbers)
            if redTeams.count > 0 {
                for index in 0...redTeams.count - 1 {
                    if index <= 2 {
                        (valueForKey("redTeam\(mapping[index])Button") as! UIButton).setTitle("\(match.redAllianceTeamNumbers[index])", forState: UIControlState.Normal)
                        
                        (valueForKey("redTeam\(mapping[index])AbilityLabel") as! UILabel).text = roundValue(redTeams[index].calculatedData.driverAbility, toDecimalPlaces: 4)
                    }
                }
            }
            
            blueOfficialScoreLabel.text = getLabelTitle(match.blueScore)
            bluePredictedScoreLabel.text = getLabelTitle(match.calculatedData.predictedBlueScore)
            blueErrorPercentageLabel.text = getErrorLabelText(match.blueScore, predictedScore: Float(match.calculatedData.predictedBlueScore))

            let blueTeams = firebaseFetcher.getTeamsFromNumbers(match.blueAllianceTeamNumbers)
            if blueTeams.count > 0 {
                for index in 0...(blueTeams.count - 1) {
                    if index <= 2 {
                        print(blueTeams[index].number)
                        (valueForKey("blueTeam\(mapping[index])Button") as! UIButton).setTitle("\(match.blueAllianceTeamNumbers[index])", forState: UIControlState.Normal)
                        
                        (valueForKey("blueTeam\(mapping[index])AbilityLabel") as! UILabel).text = roundValue(blueTeams[index].calculatedData.driverAbility, toDecimalPlaces: 4)
                    }
                }
            }
        }
    }
    
    @IBAction func teamTapped(sender: UIButton) {
        if let teamNumTapped = Int((sender.titleLabel?.text)!) {
            let match = firebaseFetcher.fetchTeamInMatchDataForTeam(firebaseFetcher.fetchTeam(teamNumTapped), inMatch: self.match!)
            if match.matchNumber > 0 {
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
    func checkRes(notification:NSNotification) {
        if notification.name == "updateLeftTable" {
            if self.match == nil {
                self.match = firebaseFetcher.matches[self.matchNumber-2] as? Match
            }
            self.updateUI()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let button = sender as? UIButton,
               teamNumTapped = Int((button.titleLabel?.text)!) {
            if let dest = segue.destinationViewController as? TeamInMatchDetailsTableViewController {
                dest.data = firebaseFetcher.fetchTeamInMatchDataForTeam(firebaseFetcher.fetchTeam(teamNumTapped), inMatch: match!)
            } else if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
                dest.data = firebaseFetcher.fetchTeam(teamNumTapped) as? Team
            }
        }
    }
}
