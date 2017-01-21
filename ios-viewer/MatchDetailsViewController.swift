//
//  MatchDetailsViewController.blue
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/16/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
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
    
    @IBOutlet weak var R1WA: UILabel!
    @IBOutlet weak var R2WA: UILabel!
    @IBOutlet weak var R3WA: UILabel!
    @IBOutlet weak var B1WA: UILabel!
    @IBOutlet weak var B2WA: UILabel!
    @IBOutlet weak var B3WA: UILabel!
    
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
            if match.number != -1 {
                title = String(describing: match.number)
            } else {
                title = "???"
            }
            if let cd = match.calculatedData {
               /*
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
                */
                redOfficialScoreLabel.text = getLabelTitle(match.redScore)
                redPredictedScoreLabel.text = getLabelTitle(cd.predictedRedScore)
                redErrorPercentageLabel.text = percentageValueOf(cd.redWinChance as AnyObject?)
            }
            
            let redTeams = firebaseFetcher?.getTeamsFromNumbers(match.redAllianceTeamNumbers!)
            if (redTeams?.count)! > 0 {
                //Index goes from 1 to 3, because thats the way the ui labels are named.
                for index in 1...(redTeams?.count)! {
                    if index <= 3 {
                        (value(forKey: "redTeam\(mapping[index-1])Button") as! UIButton).setTitle("\(match.redAllianceTeamNumbers![index-1])", for: UIControlState())
                        if let cd = redTeams?[index-1].calculatedData {
                            
                            (value(forKey: "R\(index)S") as! UILabel).text = "Seed: \(roundValue(cd.actualSeed as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "R\(index)FP") as! UILabel).text = "Pred. Seed: \(roundValue(cd.predictedSeed as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "R\(index)TH") as! UILabel).text = "1st Pick: \(roundValue(cd.firstPickAbility as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "R\(index)TL") as! UILabel).text = "2nd Pick: \(roundValue(cd.overallSecondPickAbility as AnyObject?, toDecimalPlaces: 2))"
                            (value(forKey: "R\(index)D") as! UILabel).text =  "Disfunc.: \(roundValue(cd.disfunctionalPercentage*100.0 as AnyObject?, toDecimalPlaces: 0))%"
                            (value(forKey: "R\(index)WA") as! UILabel).attributedText = withAgainstAttributedStringForTeam(number: (match.redAllianceTeamNumbers! as [Int])[index-1])

                        }

                        
                    }
                }
            }
            
            blueOfficialScoreLabel.text = getLabelTitle(match.blueScore)
            bluePredictedScoreLabel.text = getLabelTitle(match.calculatedData?.predictedBlueScore)
            blueErrorPercentageLabel.text = percentageValueOf(match.calculatedData?.blueWinChance as AnyObject?)
            
            let blueTeams = firebaseFetcher?.getTeamsFromNumbers(match.blueAllianceTeamNumbers)
            if (blueTeams?.count)! > 0 {
                for index in 1...(blueTeams?.count)! {
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
                            
                            (value(forKey: "B\(index)S") as! UILabel).text = "Seed: \(roundValue(cd.actualSeed as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "B\(index)FP") as! UILabel).text = "Pred. Seed: \(roundValue(cd.predictedSeed as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "B\(index)TH") as! UILabel).text = "1st Pick: \(roundValue(cd.firstPickAbility as AnyObject?, toDecimalPlaces: 0))"
                            (value(forKey: "B\(index)TL") as! UILabel).text = "2nd Pick: \(roundValue(cd.overallSecondPickAbility as AnyObject?, toDecimalPlaces: 2))"
                            (value(forKey: "B\(index)D") as! UILabel).text =  "Disfunc.: \(roundValue(cd.disfunctionalPercentage*100.0 as AnyObject?, toDecimalPlaces: 0))%"
                            (value(forKey: "B\(index)WA") as! UILabel).attributedText = withAgainstAttributedStringForTeam(number: (match.blueAllianceTeamNumbers! as [Int])[index-1])

                        }
                    }
                }
            }
        }
    }
    
    enum PlayRelationship : String {
        case With = "With"
        case Against = "Against"
        case Both = "Both"
        case Neither = "Neither"
    }
    
    func playWithAgainstOrBothWithTeam(number: Int) -> PlayRelationship {
        var playWith = false
        var playAgainst = false
        for match in (firebaseFetcher?.getMatchesForTeam(1678))! {
            if (match.redAllianceTeamNumbers?.contains(1678))! {
                if (match.redAllianceTeamNumbers?.contains(Int(number)))! {
                    playWith = true
                } else if (match.blueAllianceTeamNumbers?.contains(Int(number)))! {
                    playAgainst = true
                }
            } else if (match.blueAllianceTeamNumbers?.contains(1678))! {
                if (match.blueAllianceTeamNumbers?.contains(Int(number)))! {
                    playWith = true
                } else if (match.redAllianceTeamNumbers?.contains(Int(number)))! {
                    playAgainst = true
                }
            }
        }
        if playWith && playAgainst {
            return .Both
        } else if playWith {
            return .With
        } else if playAgainst {
            return .Against
        } else {
            return .Neither
        }
    }
    
    func withAgainstAttributedStringForTeam(number: Int) -> NSAttributedString {
        var attString : NSAttributedString
        let withOrAgainst = playWithAgainstOrBothWithTeam(number: number)
        switch withOrAgainst {
        case .With : attString = NSAttributedString(string: withOrAgainst.rawValue, attributes: [NSForegroundColorAttributeName: UIColor.green])
        case .Against : attString = NSAttributedString(string: withOrAgainst.rawValue, attributes: [NSForegroundColorAttributeName: UIColor.orange])
        case .Both : attString = NSAttributedString(string: withOrAgainst.rawValue, attributes: [NSForegroundColorAttributeName: UIColor.brown])
        case .Neither : attString = NSAttributedString(string: withOrAgainst.rawValue, attributes: [NSForegroundColorAttributeName: UIColor.gray])

        }
        return attString
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
                if let dest = segue.destination as? TeamDetailsTableViewController {
                    dest.team = firebaseFetcher?.getTeam(teamNumTapped)
                }
        }
    }
}
