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
    
    @IBOutlet weak var redDefenseOneLabel: UILabel!
    @IBOutlet weak var redDefenseTwoLabel: UILabel!
    @IBOutlet weak var redDefenseThreeLabel: UILabel!
    @IBOutlet weak var redDefenseFourLabel: UILabel!
    
    @IBOutlet weak var blueDefenseOneLabel: UILabel!
    @IBOutlet weak var blueDefenseTwoLabel: UILabel!
    @IBOutlet weak var blueDefenseThreeLabel: UILabel!
    @IBOutlet weak var blueDefenseFourLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkRes:", name: "updateLeftTable", object: nil)
        
        updateUI()
        print(self.match)
    }
    
    private func updateUI() {
        if redOfficialScoreLabel == nil {
            return
        }
        
        if let match = match {
            if match.number != nil {
                title = String(match.number!)
            } else {
                title = "???"
            }
            if let cd = match.calculatedData {
                if(match.calculatedData?.optimalBlueDefenses != nil) {
                    redDefenseOneLabel.text = String(cd.optimalRedDefenses![0])
                    redDefenseTwoLabel.text = String(cd.optimalRedDefenses![1])
                    redDefenseThreeLabel.text = String(cd.optimalRedDefenses![2])
                    redDefenseFourLabel.text = String(cd.optimalRedDefenses![3])
                    blueDefenseOneLabel.text = String(cd.optimalBlueDefenses![0])
                    blueDefenseTwoLabel.text = String(cd.optimalBlueDefenses![1])
                    blueDefenseThreeLabel.text = String(cd.optimalBlueDefenses![2])
                    blueDefenseFourLabel.text = String(cd.optimalBlueDefenses![3])
                }
                
                redOfficialScoreLabel.text = getLabelTitle(match.redScore?.integerValue)
                redPredictedScoreLabel.text = getLabelTitle(cd.predictedRedScore?.integerValue)
                redErrorPercentageLabel.text = percentageValueOf(cd.redWinChance?.integerValue)
            }
            
            let redTeams = firebaseFetcher.getTeamsFromNumbers(match.redAllianceTeamNumbers as? [Int])
            if redTeams.count > 0 {
                for index in 0...redTeams.count - 1 {
                    if index <= 2 {
                        (valueForKey("redTeam\(mapping[index])Button") as! UIButton).setTitle("\(match.redAllianceTeamNumbers![index])", forState: UIControlState.Normal)
                        if let cd = redTeams[index].calculatedData {
                            if cd.teleopShotAbility != nil {
                                (valueForKey("redTeam\(mapping[index])AbilityLabel") as! UILabel).text = roundValue(redTeams[index].calculatedData!.teleopShotAbility!, toDecimalPlaces: 4)
                            }
                        }
                    }
                }
            }
            
            blueOfficialScoreLabel.text = getLabelTitle(match.blueScore?.integerValue)
            bluePredictedScoreLabel.text = getLabelTitle(match.calculatedData?.predictedBlueScore?.integerValue)
            blueErrorPercentageLabel.text = percentageValueOf(match.calculatedData?.blueWinChance?.integerValue)
            
            let blueTeams = firebaseFetcher.getTeamsFromNumbers(match.blueAllianceTeamNumbers as? [Int])
            if blueTeams.count > 0 {
                for index in 0...(blueTeams.count - 1) {
                    if index <= 2 {
                        print(blueTeams[index].number)
                        (valueForKey("blueTeam\(mapping[index])Button") as! UIButton).setTitle("\(match.blueAllianceTeamNumbers![index])", forState: UIControlState.Normal)
                        if let cd = blueTeams[index].calculatedData {
                            if cd.teleopShotAbility != nil {
                                (valueForKey("blueTeam\(mapping[index])AbilityLabel") as! UILabel).text = roundValue(cd.teleopShotAbility!, toDecimalPlaces: 4)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func teamTapped(sender: UIButton) {
        print("WE STILL LOGGING")
        //        if let teamNumTapped = Int((sender.titleLabel?.text)!) {
        //            let match = firebaseFetcher.fetchTeamInMatchDataForTeam(firebaseFetcher.fetchTeam(teamNumTapped), inMatch: self.match!)
        //            if match.matchNumber > 0 {
        //                performSegueWithIdentifier("GoToTIMController", sender: sender)
        //            } else {
        performSegueWithIdentifier("GoToTeamController", sender: sender)
    }
    //  }
    //}
    private func getLabelTitle(value: NSNumber?) -> String {
        let unknown = "???"
        if value != nil {
            return "\(value!)"
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
                self.match = firebaseFetcher.matches[self.matchNumber - 2] //Why the -2???
            }
            self.updateUI()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let button = sender as? UIButton,
            teamNumTapped = Int((button.titleLabel?.text)!) {
                if let dest = segue.destinationViewController as? TeamInMatchDetailsTableViewController {
                    dest.data = firebaseFetcher.fetchTeam(teamNumTapped).TeamInMatchDatas[0]
                } else if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
                    dest.data = firebaseFetcher.fetchTeam(teamNumTapped)
                }
        }
    }
}
