//
//  MatchDetailsViewController.blue
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/16/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class MatchDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher;
    
    var matchNumber = -1
    
    
    var match: Match? = nil {
        didSet {
            updateUI()
        }
    }
    
    let mapping = ["One", "Two", "Three"]
    //keys for the tables

    let tableKeys = ["disfunctionalPercentage","avgGearsPlacedTele","avgGearGroundIntakesTele","liftoffPercentage"]
    
    
    
    @IBOutlet weak var redOfficialScoreLabel: UILabel!
    @IBOutlet weak var blueOfficialScoreLabel: UILabel!
    @IBOutlet weak var redPredictedScoreLabel: UILabel!
    @IBOutlet weak var bluePredictedScoreLabel: UILabel!
    @IBOutlet weak var redErrorPercentageLabel: UILabel!
    @IBOutlet weak var blueErrorPercentageLabel: UILabel!
    
    @IBOutlet weak var redTeamOneButton: UIButton!
    @IBOutlet weak var r1TableView: UITableView!
    
    @IBOutlet weak var redTeamTwoButton: UIButton!
    @IBOutlet weak var r2TableView: UITableView!
    
    @IBOutlet weak var redTeamThreeButton: UIButton!
    @IBOutlet weak var r3TableView: UITableView!
    
    @IBOutlet weak var blueTeamOneButton: UIButton!
    @IBOutlet weak var b1TableView: UITableView!
    
    @IBOutlet weak var blueTeamTwoButton: UIButton!
    @IBOutlet weak var b2TableView: UITableView!
    
    @IBOutlet weak var blueTeamThreeButton: UIButton!
    @IBOutlet weak var b3TableView: UITableView!
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        //can't select
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let redTeams = firebaseFetcher?.getTeamsFromNumbers(match?.redAllianceTeamNumbers!)
        let blueTeams = firebaseFetcher?.getTeamsFromNumbers(match?.blueAllianceTeamNumbers!)
        
        //get cell
        let cell : TIMDTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TIMDTableCell", for: indexPath) as! TIMDTableViewCell
        
        //set datapointLabel to tableKeys
        if indexPath.row != tableKeys.count {
            cell.datapointLabel.text = Utils.humanReadableNames["calculatedData.\(tableKeys[indexPath.row])"]
        }
        
        //setup the label stuff
        cell.datapointLabel.font = cell.datapointLabel.font.withSize(12)
        cell.valueLabel.font = cell.valueLabel.font.withSize(12)
        cell.datapointLabel.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        cell.datapointLabel.numberOfLines = 0
        cell.valueLabel.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        cell.valueLabel.numberOfLines = 0
        //cell.datapointLabel.preferredMaxLayoutWidth = 50
        //cell.valueLabel.preferredMaxLayoutWidth = 50
        
        //detect which tableView it is
        switch tableView {
        case r1TableView :
            /* if indexPath.row == tableKeys.count {
                //set final row to Future Match Status
                cell.datapointLabel.text = "Future Match Status"
                cell.valueLabel.attributedText = withAgainstAttributedStringForTeam(number: (redTeams?[0].number)!)
            } else { */
                //set valueLabel to the appropriate value
                if Utils.teamDetailsKeys.percentageValues.contains("calculatedData.\(tableKeys[indexPath.row])") {
                    //If the value is a percentage, multiply float by 100 and add %
                    cell.valueLabel.text = "\(String(describing: Utils.roundValue(((Utils.unwrap(any: redTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]) as! Float) * 100), toDecimalPlaces: 2)))%"
                } else {
                    cell.valueLabel.text = String(describing: Utils.unwrap(any: redTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]))
                }
            //}
        case r2TableView :
            /*if indexPath.row == tableKeys.count {
                cell.datapointLabel.text = "Future Match Status"
                cell.valueLabel.attributedText = withAgainstAttributedStringForTeam(number: (redTeams?[1].number)!)
            } else { */
                if Utils.teamDetailsKeys.percentageValues.contains("calculatedData.\(tableKeys[indexPath.row])") {
                    //If the value is a percentage, multiply float by 100 and add %
                    cell.valueLabel.text = "\(String(describing: Utils.roundValue(((Utils.unwrap(any: redTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]) as! Float) * 100), toDecimalPlaces: 2)))%"
                } else {
                    cell.valueLabel.text = String(describing: Utils.unwrap(any: redTeams?[1].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]))
                }
            //}
        case r3TableView :
            /*if indexPath.row == tableKeys.count {
                cell.datapointLabel.text = "Future Match Status"
                cell.valueLabel.attributedText = withAgainstAttributedStringForTeam(number: (redTeams?[2].number)!)
            } else { */
                if Utils.teamDetailsKeys.percentageValues.contains("calculatedData.\(tableKeys[indexPath.row])") {
                    //If the value is a percentage, multiply float by 100 and add %
                    cell.valueLabel.text = "\(String(describing: Utils.roundValue(((Utils.unwrap(any: redTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]) as! Float) * 100), toDecimalPlaces: 2)))%"
                } else {
                    cell.valueLabel.text = String(describing: Utils.unwrap(any: redTeams?[2].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]))
                }
            //}
        case b1TableView :
            /*if indexPath.row == tableKeys.count {
                cell.datapointLabel.text = "Future Match Status"
                cell.valueLabel.attributedText = withAgainstAttributedStringForTeam(number: (blueTeams?[0].number)!)
            } else { */
                if Utils.teamDetailsKeys.percentageValues.contains("calculatedData.\(tableKeys[indexPath.row])") {
                    //If the value is a percentage, multiply float by 100 and add %
                    cell.valueLabel.text = "\(String(describing: Utils.roundValue(((Utils.unwrap(any: redTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]) as! Float) * 100), toDecimalPlaces: 2)))%"
                } else {
                    cell.valueLabel.text = String(describing: Utils.unwrap(any: blueTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]))
                }
            //}
        case b2TableView :
            /*if indexPath.row == tableKeys.count {
                cell.datapointLabel.text = "Future Match Status"
                cell.valueLabel.attributedText = withAgainstAttributedStringForTeam(number: (blueTeams?[1].number)!)
            } else { */
                if Utils.teamDetailsKeys.percentageValues.contains("calculatedData.\(tableKeys[indexPath.row])") {
                    //If the value is a percentage, multiply float by 100 and add %
                    cell.valueLabel.text = "\(String(describing: Utils.roundValue(((Utils.unwrap(any: redTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]) as! Float) * 100), toDecimalPlaces: 2)))%"
                } else {
                    cell.valueLabel.text = String(describing: Utils.unwrap(any: blueTeams?[1].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]))
                }
            //}
        case b3TableView :
            /*if indexPath.row == tableKeys.count {
                cell.datapointLabel.text = "Future Match Status"
                cell.valueLabel.attributedText = withAgainstAttributedStringForTeam(number: (blueTeams?[2].number)!)
            } else { */
                if Utils.teamDetailsKeys.percentageValues.contains("calculatedData.\(tableKeys[indexPath.row])") {
                    //If the value is a percentage, multiply float by 100 and add %
                    cell.valueLabel.text = "\(String(describing: Utils.roundValue(((Utils.unwrap(any: redTeams?[0].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]) as! Float) * 100), toDecimalPlaces: 2)))%"
                } else {
                    cell.valueLabel.text = String(describing: Utils.unwrap(any: blueTeams?[2].calculatedData?.dictionaryRepresentation()[tableKeys[indexPath.row]]))
                }
            //}
        default :
            break
        }
        
        if let valueLabelFloat = Float(cell.valueLabel.text!) {
            cell.valueLabel.text = Utils.roundValue(Float(cell.valueLabel.text!)!, toDecimalPlaces: 2)
        }
        
        return cell
    }
    
    //how many rows are there (all the keys and (currently not) future match status)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableKeys.count
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MatchDetailsViewController.checkRes(_:)), name: NSNotification.Name(rawValue: "updateLeftTable"), object: nil)
        
        updateUI()
       // print(self.match)
        self.r1TableView.register(UINib(nibName: "TIMDTableViewCell", bundle: nil), forCellReuseIdentifier: "TIMDTableCell")
        self.r2TableView.register(UINib(nibName: "TIMDTableViewCell", bundle: nil), forCellReuseIdentifier: "TIMDTableCell")
        self.r3TableView.register(UINib(nibName: "TIMDTableViewCell", bundle: nil), forCellReuseIdentifier: "TIMDTableCell")
        self.b1TableView.register(UINib(nibName: "TIMDTableViewCell", bundle: nil), forCellReuseIdentifier: "TIMDTableCell")
        self.b2TableView.register(UINib(nibName: "TIMDTableViewCell", bundle: nil), forCellReuseIdentifier: "TIMDTableCell")
        self.b3TableView.register(UINib(nibName: "TIMDTableViewCell", bundle: nil), forCellReuseIdentifier: "TIMDTableCell")
        self.r1TableView.delegate = self
        self.r1TableView.dataSource = self
        self.r1TableView.reloadData()
        self.r2TableView.delegate = self
        self.r2TableView.dataSource = self
        self.r2TableView.reloadData()
        self.r3TableView.delegate = self
        self.r3TableView.dataSource = self
        self.r3TableView.reloadData()
        self.b1TableView.delegate = self
        self.b1TableView.dataSource = self
        self.b1TableView.reloadData()
        self.b2TableView.delegate = self
        self.b2TableView.dataSource = self
        self.b2TableView.reloadData()
        self.b3TableView.delegate = self
        self.b3TableView.dataSource = self
        self.b3TableView.reloadData()
    }
    
    fileprivate func updateUI() {
        if redOfficialScoreLabel == nil {
            return
        }
        
        
        if let match = match {
            if match.number != -1 {
                //setting title
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
                //setting labels
                redOfficialScoreLabel.text = "Score: \(getLabelTitle(match.redScore))"
                redPredictedScoreLabel.text = "Pred. Score: \(getLabelTitle(cd.predictedRedScore))"
                redErrorPercentageLabel.text = "Win Chance: \(percentageValueOf(cd.redWinChance as AnyObject?))"
            }
            
            let redTeams = firebaseFetcher?.getTeamsFromNumbers(match.redAllianceTeamNumbers!)
            if (redTeams?.count)! > 0 {
                //Index goes from 1 to 3, because thats the way the ui labels are named.
                for index in 1...(redTeams?.count)! {
                    if index <= 3 {
                        //setting the titles of the team button numbers
                        (value(forKey: "redTeam\(mapping[index-1])Button") as! UIButton).setTitle("\(match.redAllianceTeamNumbers![index-1])", for: UIControlState())

                        
                    }
                }
            }
            
            //setting labels
            blueOfficialScoreLabel.text = "Score: \(getLabelTitle(match.blueScore))"
            bluePredictedScoreLabel.text = "Pred. Score: \(getLabelTitle(match.calculatedData?.predictedBlueScore))"
            blueErrorPercentageLabel.text = "Win Chance: \(percentageValueOf(match.calculatedData?.blueWinChance as AnyObject?))"
            
            let blueTeams = firebaseFetcher?.getTeamsFromNumbers(match.blueAllianceTeamNumbers)
            if (blueTeams?.count)! > 0 {
                for index in 1...(blueTeams?.count)! {
                    if index <= 3 {
                        //print(blueTeams[index].number)
                        //setting team button titles
                        (value(forKey: "blueTeam\(mapping[index - 1])Button") as! UIButton).setTitle("\(match.blueAllianceTeamNumbers![index - 1])", for: UIControlState())
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
    
    //returns whether you are playing against, with, both, or neither a team
    func playWithAgainstOrBothWithTeam(number: Int) -> PlayRelationship {
        var playWith = false
        var playAgainst = false
        let ourMatches = firebaseFetcher?.getMatchesForTeam(1678)
        let futureMatches = ourMatches?.filter { $0.number >= firebaseFetcher?.currentMatchManager.currentMatch ?? 0 }
        for match in futureMatches! {
            if (match.redAllianceTeamNumbers?.contains(1678))! {
                if (match.redAllianceTeamNumbers?.contains(number))! {
                    playWith = true
                } else if (match.blueAllianceTeamNumbers?.contains(number))! {
                    playAgainst = true
                }
            } else if (match.blueAllianceTeamNumbers?.contains(1678))! {
                if (match.blueAllianceTeamNumbers?.contains(number))! {
                    playWith = true
                } else if (match.redAllianceTeamNumbers?.contains(number))! {
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
    
    //prepare to segue to appropriate vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton,
            let teamNumTapped = Int((button.titleLabel?.text)!) {
                if let dest = segue.destination as? TeamDetailsTableViewController {
                    dest.team = firebaseFetcher?.getTeam(teamNumTapped)
                }
        }
    }
}
