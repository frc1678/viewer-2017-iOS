//
//  TeamDetailsTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/18/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import SDWebImage


class TeamDetailsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate, UIDocumentInteractionControllerDelegate, UINavigationControllerDelegate {
    
    var firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamNumberLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamSelectedImageView: UIImageView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seed: UILabel!
    @IBOutlet weak var predictedSeed: UILabel!
    
    var data: Team? = nil {
        didSet {
            num = self.data?.number?.integerValue
            updateTitleAndTopInfo()
            reload()
        }
    }
    
    var num: Int? = nil
    
    var shareController: UIDocumentInteractionController!
    
    var photos: [MWPhoto] = []
    
    let defaultKeys = [
        "matchDatas"
    ]
    
    let abilityKeys = [
        "calculatedData.firstPickAbility",
        "calculatedData.avgTorque",
        "calculatedData.avgEvasion",
        "calculatedData.avgSpeed",
        "calculatedData.numAutoPoints",
        "calculatedData.avgBallControl",
        "calculatedData.avgDefense",
        "calculatedData.numRPs",
        "calculatedData.predictedNumRPs"
    ]
    
    // Add carrying stability into stacking security
    
    let autoKeys = [
        //TODO: Add Avg. Num Shots in 2 ball Auto
        "calculatedData.numAutoPoints",
        "calculatedData.highShotAccuracyAuto",
        "calculatedData.lowShotAccuracyAuto",
        "calculatedData.avgBallsKnockedOffMidlineAuto",
        "calculatedData.avgMidlineBallsIntakedAuto"]
    
    let teleKeys = [
        "calculatedData.highShotAccuracyTele",
        "calculatedData.lowShotAccuracyTele",
        "calculatedData.avgHighShotsTele",
        "calculatedData.sdHighShotsTele",
        "calculatedData.avgLowShotsTele",
        "calculatedData.sdLowShotsTele"
    ]
    var obstacleKeys = [
        "calculatedData.cdfCrossed",
        "calculatedData.pcCrossed",
        "calculatedData.mtCrossed",
        "calculatedData.rpCrossed",
        "calculatedData.dbCrossed",
        "calculatedData.spCrossed",
        "calculatedData.rtCrossed",
        "calculatedData.rwCrossed",
        "calculatedData.lbCrossed"
    ]
    
    
    
    let superKeys = [
        "calculatedData.avgEvasion",
        "calculatedData.avgDefense"
    ]
    
    let statusKeys = [
        "calculatedData.challengePercentage",
        "calculatedData.disabledPercentage",
        "calculatedData.disfunctionalPercentage",
        "calculatedData.incapacitatedPercentage",
    ]
    
    let pitKeys = [
        "pitPotentialLowBarCapability",
        "pitPotentialMidlineBallCapability",
        "pitDriveBaseWidth",
        "pitDriveBaseLength",
        "pitBumperHeight",
        "pitPotentialShotBlockerCapability",
        "pitOrganization",
    ]
    
    
    let longTextCells = [
        "pitNotes"
    ]
    
    let unrankedCells = [
        "calculatedData.pitOrganization",
        "calculatedData.pitNotes" ]
    
    let percentageValues = [
        "calculatedData.challengePercentage",
        "calculatedData.disabledPercentage",
        "calculatedData.disfunctionalPercentage",
        "calculatedData.incapacitatedPercentage",
        "calculatedData.scalePercentage",
        "calculatedData.siegeConsistency"
        
    ]
    let addCommasBetweenCapitals = [
        "calculatedData.reconAcquisitionTypes"
    ]
    
    let boolValues = [
        "calculatedData.challengePercentage",
        "calculatedData.disabledPercentage",
        "calculatedData.incapacitatedPercentage",
    ]
    
    let moreInfoValues = [
        "matchDatas"
    ]
    let keySetNames = [
        "Information",
        "Ability - High Level",
        "Autonomous",
        "Defenses",
        "TeleOp",
        "Percentages",
        "Pit Scouting / Robot Design",
        "Additional Info",
    ]
    
    let calculatedTeamInMatchDataHumanReadableKeys = [
        "First Pick Ability",
        "R Score Torque",
        "R Score Evasion",
        "R Score Speed",
        "High Shot Accuracy Auto",
        "Low Shot Accuracy Auto",
        "High Shot Accuracy Tele",
        "Low Shot Accuracy Tele",
        "Avg. High Shots in Tele",
        "Siege Ability",
        "Siege Power",
        "Number of RPs",
        "Number of Auto Points",
        "Number of Scale And Challenge Points",
        "R Score Defense",
        "R Score Ball Control",
        "R Score Driving Ability",
        "Citrus DPR",
        "Second Pick Ability",
        "Overall Second Pick Ability",
        "Score Contribution"
    ]
    
    
    
    var keySets: [[String]] {
        return [ defaultKeys,
            abilityKeys,
            autoKeys,
            obstacleKeys,
            teleKeys,
            percentageValues,
            pitKeys,
            longTextCells
        ]
    }
    
    func reload() {
        tableView?.reloadData()
        tableViewHeightConstraint?.constant = (tableView.contentSize.height)
        if let team = data,
            let imageView = teamSelectedImageView {
                self.firebaseFetcher.LoadImageForTeam(team)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"checkRes:", name:"updateLeftTable", object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotTeamImage:", name: "gotTeamImage", object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotTeamImageToAdd:", name: "gotTeamImageToAdd", object: nil);
        
        tableView.registerNib(UINib(nibName: "MultiCellTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiCellTableViewCell")
        tableView.delegate = self
        navigationController?.delegate = self
        updateTitleAndTopInfo()
        photos = []
        reload()
        // self.firebaseFetcher.getAverageDefenseValuesForDict((data?.calculatedData.avgSuccessfulTimesCrossedDefensesTele)!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.delegate = nil
        
        super.viewWillDisappear(animated)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let willShow = viewController as? GraphViewController {
            //Do nothing
        } else if let willShow = viewController as? MWPhotoBrowser {
            //Do nothing
        } else if let willShow = viewController as? TeamDetailsTableViewController {
            //Do nothing
        } else {
            navigationController.immediatelyCancelSGProgress()
        }
    }
    
    func gotTeamImage(notification: NSNotification) {
        self.photos = []
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let image = notification.object as? UIImage {
                self.teamSelectedImageView.image = image
                self.imageViewHeightConstraint.constant = (image.size.height / image.size.width) * self.teamSelectedImageView.frame.width
                self.teamSelectedImageView.alpha = 1.0
            } else {
                self.imageViewHeightConstraint.constant = 0
            }
            
            if let team = self.data {
                self.teamSelectedImageView.userInteractionEnabled = false;
                self.navigationController?.setSGProgressPercentage(1.0)
                //                self.firebaseFetcher.getTeamImagesForTeam(team, callBack: {
                //                    (progress: Float, done: Bool, teamDownloaded: Int)->() in
                //                    if teamDownloaded == self.num {
                //                        self.navigationController?.setSGProgressPercentage(progress * 100);
                ////                        self.lastProgress = progress
                //                    }
                ////
                //                    if done {
                //                        self.teamSelectedImageView.userInteractionEnabled = true;
                //                    }
                //                })
                //                firebaseFetcher.getTeamImagesForTeam(team.number)
            }
        })
    }
    
    @IBAction func exportTeamPDFs(sender: UIBarButtonItem) {
        sender.enabled = false
        let dir: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let pdfPath = dir.stringByAppendingPathComponent("team_cards.pdf")
        let pdfURL = NSURL(fileURLWithPath: pdfPath)
        print("Rendering PDF...")
        
        PDFRenderer.renderPDFToPath(pdfPath) {(progress: Float, done: Bool) -> () in
            self.navigationController?.setSGProgressPercentage(progress * 100)
            
            if(done) {
                print("Done rendering PDF")
                
                self.shareController = self.setupControllerWithURL(pdfURL, usingDelegate: self)
                self.shareController.presentPreviewAnimated(true)
                sender.enabled = true
            }
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func gotTeamImageToAdd(notification: NSNotification) {
        let objArr = notification.object as! [AnyObject]
        let numOfImage = objArr[1] as! Int
        if let currentNumber = self.num {
            if numOfImage == currentNumber {
                photos.append(objArr[0] as! MWPhoto)
            }
        }
        
        
        // Filter to a unique array
        photos = photos.filter { photo in
            for p in self.photos {
                if UIImagePNGRepresentation(p.underlyingImage)!.isEqualToData(UIImagePNGRepresentation(photo.underlyingImage)!) && photo != p {
                    return false
                }
            }
            return true
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if data == nil {
            return 44
        }
        
        let dataKey: String = keySets[indexPath.section][indexPath.row]
        if longTextCells.contains(dataKey) {
            let dataPoint: AnyObject = data!.valueForKeyPath(dataKey) ?? ""
            
            let titleText = humanReadableNames[dataKey]
            let notesText = "\(roundValue(dataPoint, toDecimalPlaces: 2))"
            
            let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16)]
            return (titleText! as NSString).sizeWithAttributes(attrs).height + (notesText as NSString).sizeWithAttributes(attrs).height + 44
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data == nil ? nil : keySetNames[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data == nil ? 1 : keySets.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 1 : keySets[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if data!.number == nil {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailStringCell", forIndexPath: indexPath) 
            cell.textLabel?.text = "No data yet..."
            cell.accessoryType = UITableViewCellAccessoryType.None
            return cell
        }
        
        let dataKey: String = keySets[indexPath.section][indexPath.row]
        if dataKey == "calculatedData.numAutoPoints" {
            
        }
        if !moreInfoValues.contains(dataKey) {
            let dataPoint: AnyObject? = data!.valueForKeyPath(dataKey) ?? ""
            if dataPoint == nil {
                print(dataKey)
            }
            if longTextCells.contains(dataKey) {
                let notesCell: ResizableNotesTableViewCell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailStringCell", forIndexPath: indexPath) as! ResizableNotesTableViewCell
                
                notesCell.titleLabel?.text = humanReadableNames[dataKey]
                //            notesCell.notesLabel?.text = "\(roundDataPoint(dataPoint))"
                
                if "\(dataPoint)".isEmpty {
                    notesCell.notesLabel?.text = "none"
                } else {
                    notesCell.notesLabel?.text = "\(roundValue(dataPoint!, toDecimalPlaces: 2))"
                }
                notesCell.selectionStyle = UITableViewCellSelectionStyle.None
                cell = notesCell
            } else if unrankedCells.contains(dataKey) {
                let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCellWithIdentifier("UnrankedCell", forIndexPath: indexPath) as! UnrankedTableViewCell
                
                unrankedCell.titleLabel.text = humanReadableNames[dataKey]
                
                if "\(dataPoint)".isEmpty || isZero(dataPoint!) {
                    unrankedCell.detailLabel.text = "-"
                } else if addCommasBetweenCapitals.contains(dataKey) {
                    unrankedCell.detailLabel.text = "\(insertCommasAndSpacesBetweenCapitalsInString(roundValue(dataPoint!, toDecimalPlaces: 2)))"
                } else if boolValues.contains(dataKey) {
                    unrankedCell.detailLabel.text = "\(boolToBoolString(dataPoint as! Bool))"
                } else {
                    unrankedCell.detailLabel.text = "\(roundValue(dataPoint!, toDecimalPlaces: 2))"
                }
                
                unrankedCell.selectionStyle = UITableViewCellSelectionStyle.None
                cell = unrankedCell
            } else {
                let multiCell: MultiCellTableViewCell = tableView.dequeueReusableCellWithIdentifier("MultiCellTableViewCell", forIndexPath: indexPath) as! MultiCellTableViewCell
                
                multiCell.teamLabel!.text = humanReadableNames[dataKey]
                
                if percentageValues.contains(dataKey) {
                    multiCell.scoreLabel!.text = "\(percentageValueOf(dataPoint!))"
                } else {
                    multiCell.scoreLabel!.text = "\(roundValue(dataPoint!, toDecimalPlaces: 2))"
                }
                
                multiCell.rankLabel!.text = "\(firebaseFetcher.rankOfTeam(data!, withCharacteristic: dataKey))"
                
                //                multiCell.selectionStyle = UITableViewCellSelectionStyle.None
                cell = multiCell
            }
        } else {
            let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCellWithIdentifier("UnrankedCell", forIndexPath: indexPath) as! UnrankedTableViewCell
            
            unrankedCell.titleLabel.text = humanReadableNames[dataKey]
            unrankedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            cell = unrankedCell
        }
        
        return cell
    }
    
    func updateTitleAndTopInfo() {
        let numText: String
        let nameText: String
        switch (data?.number, data?.name) {
        case (.Some(let num), .Some(let name)):
            title = "\(num)"
            numText = "\(num)"
            nameText = "\(name)"
        case (.Some(let num), .None):
            title = "\(num)"
            numText = "\(num)"
            nameText = "Unknown name..."
        case (.None, .Some(let name)):
            title = "Unkown Number"
            numText = "????"
            nameText = "\(name)"
        default:
            title = "Unknown Number"
            numText = "????"
            nameText = "Unknown name..."
        }
        
        var seedText = "?"
        var predSeedText = "?"
        if let seed = data?.calculatedData!.actualSeed where seed.integerValue > 0 {
            seedText = "\(seed)"
        }
        
        if let predSeed = data?.calculatedData!.predictedSeed where predSeed.integerValue > 0 {
            predSeedText = "\(predSeed)"
        }
        
        teamNameLabel?.text = nameText
        teamNumberLabel?.text = numText
        seed?.text = seedText
        predictedSeed?.text = seedText
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(photos.count) {
            return photos[Int(index)]
        }
        
        return nil;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.teamSelectedImageView.userInteractionEnabled = true;
        //        self.n
        navigationController?.setSGProgressPercentage(50.0)
        if segue.identifier == "defenseCrossedSegue" {
            let indexPath = sender as? NSIndexPath
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as? MultiCellTableViewCell
            let dest = segue.destinationViewController as? DefenseTableViewController
            if let teamNumbah = data?.number {
                dest!.teamNumber = teamNumbah.integerValue
                dest!.relevantDefense = cell!.teamLabel!.text!
            }
        }
        else if segue.identifier == "Photos" {
            let browser = segue.destinationViewController as! MWPhotoBrowser;
            
            browser.delegate = self;
            
            browser.displayActionButton = true; // Show action button to allow sharing, copying, etc (defaults to YES)
            browser.displayNavArrows = false; // Whether to display left and right nav arrows on toolbar (defaults to NO)
            browser.displaySelectionButtons = false; // Whether selection buttons are shown on each image (defaults to NO)
            browser.zoomPhotosToFill = true; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
            browser.alwaysShowControls = false; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
            browser.enableGrid = false; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
            
            SDImageCache.sharedImageCache().maxCacheSize = 20 * 1024 * 1024;
        } else if segue.identifier == "Matches" {
            let matchesForTeamController = segue.destinationViewController as! TeamScheduleTableViewController
            
            if let teamNum = data?.number {
                matchesForTeamController.teamNumber = teamNum.integerValue
            }
        } else if segue.identifier == "CTIMDGraph" {
            let graphViewController = segue.destinationViewController as! GraphViewController
            
            
            if let teamNum = data?.number {
                let indexPath = sender as! NSIndexPath
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MultiCellTableViewCell {
                    graphViewController.graphTitle = "\(cell.teamLabel!.text!)"
                    graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                    let i = self.calculatedTeamInMatchDataHumanReadableKeys.indexOf(graphViewController.graphTitle)
                    let key = self.firebaseFetcher.calculatedTeamInMatchDataKeys[i!]
                    //print("This is the key:")
                    //print(keySets[indexPath.section][indexPath.row])
                    let values = firebaseFetcher.getMatchValuesForTeamForPath(key, forTeam: data!)
                    print("These are the data points being passed:")
                    print(values)
                    graphViewController.values = values as NSArray as! [CGFloat]
                    graphViewController.subDisplayLeftTitle = "Match: "
                    graphViewController.subValuesLeft = nsNumArrayToIntArray(firebaseFetcher.ranksOfTeamsWithCharacteristic(keySets[indexPath.section][indexPath.row]))
                    print("Here are the subValues")
                    print(graphViewController.subValuesLeft)
                    /*if let d = data {
                    graphViewController.subValuesRight =
                        nsNumArrayToIntArray(firebaseFetcher.ranksOfTeamInMatchDatasWithCharacteristic(keySets[indexPath.section][indexPath.row], forTeam:firebaseFetcher.fetchTeam(d.number!.integerValue)))
                    
                    let i = ((graphViewController.subValuesLeft as NSArray).indexOfObject("\(teamNum)"))
                    graphViewController.highlightIndex = i
                    
                    }*/
                    graphViewController.subDisplayRightTitle = "Team: "
                    graphViewController.subValuesRight = [teamNum,teamNum,teamNum,teamNum,teamNum]
                    
                    
                }
            }
        }
        else if segue.identifier == "TGraph" {
            let graphViewController = segue.destinationViewController as! GraphViewController
            
            if let teamNum = data?.number {
                let indexPath = sender as! NSIndexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! MultiCellTableViewCell
                graphViewController.graphTitle = "\(cell.teamLabel!.text!)"
                graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                if let values = firebaseFetcher.valuesInCompetitionOfPathForTeams(keySets[indexPath.section][indexPath.row]) as? [CGFloat] {
                    graphViewController.values = values
                    graphViewController.subValuesLeft = firebaseFetcher.valuesInCompetitionOfPathForTeams("number") as [AnyObject]
                    graphViewController.subDisplayLeftTitle = "Team "
                    graphViewController.subValuesRight = nsNumArrayToIntArray(firebaseFetcher.ranksOfTeamsWithCharacteristic(keySets[indexPath.section][indexPath.row]) )
                    graphViewController.subDisplayRightTitle = "Rank: "
                    if let i = ((graphViewController.subValuesLeft as! [Int]).indexOf(teamNum.integerValue)) {
                        graphViewController.highlightIndex = i
                    }
                }
                //                graphViewController.heights =]
                //                graphViewController.teamNumber = Int32(teamNum)
                //                graphViewController.graphInfo = nil;
            }
        }
    }
    
    func boolToBoolString(b: Bool) -> String {
        let strings = [false : "No", true : "Yes"]
        return strings[b]!
    }
    
    func setupControllerWithURL(fileURL: NSURL, usingDelegate: UIDocumentInteractionControllerDelegate) -> UIDocumentInteractionController {
        var interactionController = UIDocumentInteractionController(URL: fileURL)
        interactionController.delegate = usingDelegate
        
        return interactionController
    }
    
    //    - (UIDocumentInteractionController *) setupControllerWithURL: (NSURL *)fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    //    
    //    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    //    interactionController.delegate = interactionDelegate;
    //    
    //    return interactionController;
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? UnrankedTableViewCell {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if cell.titleLabel.text == "Matches" {
                performSegueWithIdentifier("Matches", sender: nil)
            }
        } else if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MultiCellTableViewCell {
            let cs = cell.teamLabel!.text
            print(cs)
            if (cs!.containsString("Times Crossed"))  {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                performSegueWithIdentifier("defenseCrossedSegue", sender:indexPath)
                
            }
            else if(self.calculatedTeamInMatchDataHumanReadableKeys.contains(cs!)) {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                performSegueWithIdentifier("CTIMDGraph", sender: indexPath)
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                performSegueWithIdentifier("TGraph", sender: indexPath)
            }
            
        }
        func checkRes(notification:NSNotification) {
            if notification.name == "updateLeftTable" {
                self.reload()
            }
        }
        
    }
}
