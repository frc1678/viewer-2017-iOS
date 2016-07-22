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
    @IBOutlet weak var R1S: UILabel!
    @IBOutlet weak var R1FP: UILabel!
    @IBOutlet weak var R1TH: UILabel!
    @IBOutlet weak var R1TL: UILabel!
    @IBOutlet weak var R1D: UILabel!
    
   
    
    @IBOutlet weak var redTeamTwoButton: UIButton!
    @IBOutlet weak var R2S: UILabel!
    @IBOutlet weak var R2FP: UILabel!
    @IBOutlet weak var R2TH: UILabel!
    @IBOutlet weak var R2TL: UILabel!
    @IBOutlet weak var R2D: UILabel!
    
    @IBOutlet weak var redTeamThreeButton: UIButton!
    @IBOutlet weak var R3FP: UILabel!
    @IBOutlet weak var R3S: UILabel!
    @IBOutlet weak var R3TH: UILabel!
    @IBOutlet weak var R3TL: UILabel!
    @IBOutlet weak var R3D: UILabel!
    
    @IBOutlet weak var blueTeamOneButton: UIButton!
    @IBOutlet weak var B1FP: UILabel!
    @IBOutlet weak var B1S: UILabel!
    @IBOutlet weak var B1TH: UILabel!
    @IBOutlet weak var B1TL: UILabel!
    @IBOutlet weak var B1D: UILabel!
    
    @IBOutlet weak var blueTeamTwoButton: UIButton!
    @IBOutlet weak var B2FP: UILabel!
    @IBOutlet weak var B2S: UILabel!
    @IBOutlet weak var B2TH: UILabel!
    @IBOutlet weak var B2TL: UILabel!
    @IBOutlet weak var B2D: UILabel!
    
    @IBOutlet weak var blueTeamThreeButton: UIButton!
    @IBOutlet weak var B3FP: UILabel!
    @IBOutlet weak var B3S: UILabel!
    @IBOutlet weak var B3TH: UILabel!
    @IBOutlet weak var B3TL: UILabel!
    @IBOutlet weak var B3D: UILabel!
    
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MatchDetailsViewController.checkRes(_:)), name: "updateLeftTable", object: nil)
        
        updateUI()
       // print(self.match)
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
                
                //Remove Following Block to Enable Optimal Defenses
                redDefenseOneLabel.hidden = true
                redDefenseTwoLabel.hidden = true
                redDefenseThreeLabel.hidden = true
                redDefenseFourLabel.hidden = true
                blueDefenseOneLabel.hidden = true
                blueDefenseTwoLabel.hidden = true
                blueDefenseThreeLabel.hidden = true
                blueDefenseFourLabel.hidden = true
                
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
                redErrorPercentageLabel.text = percentageValueOf(cd.redWinChance?.floatValue)
            }
            
            let redTeams = firebaseFetcher.getTeamsFromNumbers(match.redAllianceTeamNumbers as? [Int])
            if redTeams.count > 0 {
                for index in 0...redTeams.count - 1 {
                    if index <= 2 {
                        (valueForKey("redTeam\(mapping[index])Button") as! UIButton).setTitle("\(match.redAllianceTeamNumbers![index])", forState: UIControlState.Normal)
                        if let cd = redTeams[index].calculatedData {
                            
                            (valueForKey("R\(index+1)S") as! UILabel).text = "Seed: \(roundValue(cd.actualSeed, toDecimalPlaces: 0))"
                            (valueForKey("R\(index+1)FP") as! UILabel).text = "1st Pick: \(roundValue(cd.firstPickAbility, toDecimalPlaces: 0))"
                            (valueForKey("R\(index+1)TH") as! UILabel).text = "H.S.T.: \(roundValue(cd.avgHighShotsTele, toDecimalPlaces: 0))"
                            (valueForKey("R\(index+1)TL") as! UILabel).text = "L.S.T.: \(roundValue(cd.avgLowShotsTele?.integerValue, toDecimalPlaces: 0))"
                            (valueForKey("R\(index+1)D") as! UILabel).text = "R Drive: \(roundValue(cd.RScoreDrivingAbility, toDecimalPlaces: 2))"
                        }

                        
                    }
                }
            }
            
            blueOfficialScoreLabel.text = getLabelTitle(match.blueScore?.integerValue)
            bluePredictedScoreLabel.text = getLabelTitle(match.calculatedData?.predictedBlueScore?.integerValue)
            blueErrorPercentageLabel.text = percentageValueOf(match.calculatedData?.blueWinChance?.floatValue)
            
            let blueTeams = firebaseFetcher.getTeamsFromNumbers(match.blueAllianceTeamNumbers as? [Int])
            if blueTeams.count > 0 {
                for index in 1...(blueTeams.count) {
                    if index <= 3 {
                        //print(blueTeams[index].number)
                        (valueForKey("blueTeam\(mapping[index - 1])Button") as! UIButton).setTitle("\(match.blueAllianceTeamNumbers![index - 1])", forState: UIControlState.Normal)
                        if let cd = blueTeams[index - 1].calculatedData {
                            /*let match = firebaseFetcher.getMatch(matchNumber)
                            let TIMDatas = blueTeams[index-1].TeamInMatchDatas
                            var teamInMatchData = TeamInMatchData()
                            for TIMData in TIMDatas {
                                print(TIMData.matchNumber!.integerValue)
                                print(matchNumber)
                                if TIMData.matchNumber?.integerValue == matchNumber {
                                    print("We made it")
                                    teamInMatchData = TIMData
                                }
                            }*/
                            
                            (valueForKey("B\(index)S") as! UILabel).text = "Seed: \(roundValue(cd.actualSeed, toDecimalPlaces: 0))"
                            (valueForKey("B\(index)FP") as! UILabel).text = "1st Pick: \(roundValue(cd.firstPickAbility, toDecimalPlaces: 0))"
                            (valueForKey("B\(index)TH") as! UILabel).text = "H.S.T.: \(roundValue(cd.avgHighShotsTele?.integerValue, toDecimalPlaces: 0))"
                            (valueForKey("B\(index)D") as! UILabel).text = "R Drive: \(roundValue(cd.RScoreDrivingAbility, toDecimalPlaces: 2))"
                            (valueForKey("B\(index)TL") as! UILabel).text = "L.S.T.: \(roundValue(cd.avgLowShotsTele, toDecimalPlaces: 0))"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func teamTapped(sender: UIButton) {
        print("WE STILL LOGGING")
        //        if let teamNumTapped = Int((sender.titleLabel?.text)!) {
        //            let match = firebaseFetcher.getTeamInMatchDataForTeam(firebaseFetcher.getTeam(teamNumTapped), inMatch: self.match!)
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
                    dest.data = firebaseFetcher.getTeam(teamNumTapped).TeamInMatchDatas[0]
                } else if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
                    dest.team = firebaseFetcher.getTeam(teamNumTapped)
                }
        }
    }
}
