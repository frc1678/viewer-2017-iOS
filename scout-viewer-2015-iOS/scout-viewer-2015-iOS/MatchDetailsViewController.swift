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
        NotificationCenter.default.addObserver(self, selector: #selector(MatchDetailsViewController.checkRes(_:)), name: NSNotification.Name(rawValue: "updateLeftTable"), object: nil)
        
        updateUI()
       // print(self.match)
    }
    
    fileprivate func updateUI() {
        if redOfficialScoreLabel == nil {
            return
        }
        
        if let match = match {
            if match.number != nil {
                title = String(describing: match.number!)
            } else {
                title = "???"
            }
            if let cd = match.calculatedData {
                
                //Remove Following Block to Enable Optimal Defenses
                redDefenseOneLabel.isHidden = true
                redDefenseTwoLabel.isHidden = true
                redDefenseThreeLabel.isHidden = true
                redDefenseFourLabel.isHidden = true
                blueDefenseOneLabel.isHidden = true
                blueDefenseTwoLabel.isHidden = true
                blueDefenseThreeLabel.isHidden = true
                blueDefenseFourLabel.isHidden = true
                
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
                
                redOfficialScoreLabel.text = getLabelTitle(match.redScore?.intValue)
                redPredictedScoreLabel.text = getLabelTitle(cd.predictedRedScore?.intValue)
                redErrorPercentageLabel.text = percentageValueOf(cd.redWinChance?.floatValue as AnyObject?)
            }
            
            let redTeams = firebaseFetcher?.getTeamsFromNumbers(match.redAllianceTeamNumbers as? [Int])
            if (redTeams?.count)! > 0 {
                for index in 0...(redTeams?.count)! - 1 {
                    if index <= 2 {
                        (value(forKey: "redTeam\(mapping[index])Button") as! UIButton).setTitle("\(match.redAllianceTeamNumbers![index])", for: UIControlState())
                        if let cd = redTeams?[index].calculatedData {
                            
                            (value(forKey: "R\(index+1)S") as! UILabel).text = "Seed: \(roundValue(cd.actualSeed, toDecimalPlaces: 0))"
                            (value(forKey: "R\(index+1)FP") as! UILabel).text = "1st Pick: \(roundValue(cd.firstPickAbility, toDecimalPlaces: 0))"
                            (value(forKey: "R\(index+1)TH") as! UILabel).text = "H.S.T.: \(roundValue(cd.avgHighShotsTele, toDecimalPlaces: 0))"
                            (value(forKey: "R\(index+1)TL") as! UILabel).text = "L.S.T.: \(roundValue(cd.avgLowShotsTele?.intValue as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "R\(index+1)D") as! UILabel).text = "R Drive: \(roundValue(cd.RScoreDrivingAbility, toDecimalPlaces: 2))"
                        }

                        
                    }
                }
            }
            
            blueOfficialScoreLabel.text = getLabelTitle(match.blueScore?.intValue)
            bluePredictedScoreLabel.text = getLabelTitle(match.calculatedData?.predictedBlueScore?.intValue)
            blueErrorPercentageLabel.text = percentageValueOf(match.calculatedData?.blueWinChance?.floatValue as AnyObject?)
            
            let blueTeams = firebaseFetcher?.getTeamsFromNumbers(match.blueAllianceTeamNumbers as? [Int])
            if (blueTeams?.count)! > 0 {
                for index in 1...((blueTeams?.count)! as Int) {
                    if index <= 3 {
                        //print(blueTeams[index].number)
                        (value(forKey: "blueTeam\(mapping[index - 1])Button") as! UIButton).setTitle("\(match.blueAllianceTeamNumbers![index - 1])", for: UIControlState())
                        if let cd = blueTeams?[index - 1].calculatedData {
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
                            
                            (value(forKey: "B\(index)S") as! UILabel).text = "Seed: \(roundValue(cd.actualSeed, toDecimalPlaces: 0))"
                            (value(forKey: "B\(index)FP") as! UILabel).text = "1st Pick: \(roundValue(cd.firstPickAbility, toDecimalPlaces: 0))"
                            (value(forKey: "B\(index)TH") as! UILabel).text = "H.S.T.: \(roundValue(cd.avgHighShotsTele?.intValue as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "B\(index)D") as! UILabel).text = "R Drive: \(roundValue(cd.RScoreDrivingAbility, toDecimalPlaces: 2))"
                            (value(forKey: "B\(index)TL") as! UILabel).text = "L.S.T.: \(roundValue(cd.avgLowShotsTele, toDecimalPlaces: 0))"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func teamTapped(_ sender: UIButton) {
        print("WE STILL LOGGING")
        //        if let teamNumTapped = Int((sender.titleLabel?.text)!) {
        //            let match = firebaseFetcher.getTeamInMatchDataForTeam(firebaseFetcher.getTeam(teamNumTapped), inMatch: self.match!)
        //            if match.matchNumber > 0 {
        //                performSegueWithIdentifier("GoToTIMController", sender: sender)
        //            } else {
        performSegue(withIdentifier: "GoToTeamController", sender: sender)
    }
    //  }
    //}
    fileprivate func getLabelTitle(_ value: Int?) -> String {
        let unknown = "???"
        if value != nil {
            return "\(value!)"
        }
        return unknown
    }
    
    fileprivate func getLabelTitle(_ v: Float?) -> String {
        let unknown = "???"
        if let value = v {
            if value != -1 {
                return "\(value)"
            }
        }
        return unknown
    }
    
    fileprivate func getErrorLabelText(_ officialScore: Int?, predictedScore: Float?) -> String {
        if let err = getError(officialScore, predictedScore: predictedScore) {
            return roundValue(NSNumber(value: err * 100.0), toDecimalPlaces: 2) + "%"
        }
        
        return "???"
    }
    
    fileprivate func getError(_ officialScore: Int?, predictedScore: Float?) -> Float? {
        if let officialScore = officialScore,
            let predictedScore = predictedScore {
                if officialScore != -1 {
                    return abs((Float(officialScore) - predictedScore) / Float(officialScore))
                }
        }
        
        return nil
    }
    func checkRes(_ notification:Notification) {
        if notification.name._rawValue == "updateLeftTable" {
            if self.match == nil {
                self.match = self.firebaseFetcher?.matches[self.matchNumber - 2] //Why the -2???
            }
            self.updateUI()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton,
            let teamNumTapped = Int((button.titleLabel?.text)!) {
                if let dest = segue.destination as? TeamInMatchDetailsTableViewController {
                    dest.data = firebaseFetcher?.getTeam(teamNumTapped).TeamInMatchDatas[0]
                } else if let dest = segue.destination as? TeamDetailsTableViewController {
                    dest.team = firebaseFetcher?.getTeam(teamNumTapped)
                }
        }
    }
}
