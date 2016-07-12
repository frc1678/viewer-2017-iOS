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
import Haneke


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
    
    var team: Team? = nil {
        didSet {
            num = self.team?.number?.integerValue
            updateTitleAndTopInfo()
            reload()
        }
    }
    
    var num: Int? = nil
    var showMinimalistTeamDetails = true
    var shareController: UIDocumentInteractionController!
    var photoBrowser = MWPhotoBrowser()
    var photos: [MWPhoto] = []
    
    func reload() {
        if data != nil {
            if data?.number != nil {
                tableView?.reloadData()
                self.updateTitleAndTopInfo()
                tableViewHeightConstraint?.constant = (tableView.contentSize.height)
                
                self.reloadImage()
            }
        }
        
    }
    
    func reloadImage() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let team = self.data,
                let imageView = self.teamSelectedImageView {
                    if team.selectedImageUrl != nil {
                        self.firebaseFetcher.getImageForTeam(self.data?.number as! Int, fetchedCallback: { (image) -> () in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                imageView.image = image
                            })
                            }, couldNotFetch: {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    imageView.hnk_setImageFromURL(NSURL(string: team.selectedImageUrl!)!)
                                })
                        })
                    }
                    let noRobotPhoto = UIImage(named: "SorryNoRobotPhoto")
                    if self.teamSelectedImageView.image != noRobotPhoto {
                        self.photos.append(MWPhoto(image: self.teamSelectedImageView.image))
                    }
                    if let urls = self.data?.otherImageUrls {
                        for (_, url) in urls {
                            self.photos.append(MWPhoto(URL: NSURL(string: url as! String)))
                        }
                    }
                    if self.teamSelectedImageView.image == noRobotPhoto && self.photos.count > 0 {
                        if self.photos[0].underlyingImage != noRobotPhoto && (self.photos[0].underlyingImage ?? UIImage()).size.height > 0 {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.teamSelectedImageView.image = self.photos[0].underlyingImage
                            })
                        }
                    }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableView:", name:"updateLeftTable", object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotTeamImage:", name: "gotTeamImage", object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gotTeamImageToAdd:", name: "gotTeamImageToAdd", object: nil);
        tableView.registerNib(UINib(nibName: "MultiCellTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiCellTableViewCell")
        tableView.delegate = self
        self.navigationController?.delegate = self
        self.photoBrowser.delegate = self
        photos = []
        let longPress = UILongPressGestureRecognizer(target: self, action: "rankingDetailsSegue:")
        self.view.addGestureRecognizer(longPress)
        let longPressForMoreDetail = UILongPressGestureRecognizer(target: self, action: "didLongPressForMoreDetail:")
        self.teamNumberLabel.addGestureRecognizer(longPressForMoreDetail)
        let tap = UITapGestureRecognizer(target: self, action: "didTapImage:")
        self.teamSelectedImageView.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        reloadImage()
    }
    
    func normalizeImageOrientationIfNeeded(image: UIImage) -> UIImage {
        return image.imageRotatedByDegrees(90, flip: false)
    }
    
    func didLongPressForMoreDetail(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Recognized {
            self.showMinimalistTeamDetails = !self.showMinimalistTeamDetails
            self.reload()
            self.teamNumberLabel.textColor = UIColor.blackColor()
        } else if recognizer.state == UIGestureRecognizerState.Began {
            self.teamNumberLabel.textColor = UIColor.greenColor()
        } 
    }
    
    func didTapImage(recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Recognized {
            let nav = UINavigationController(rootViewController: self.photoBrowser)
            nav.delegate = self
            self.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.delegate = nil
        super.viewWillDisappear(animated)
    }
    
    @IBAction func exportTeamPDFs(sender: UIBarButtonItem) {
        sender.enabled = false
        let dir: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        let pdfPath = dir.stringByAppendingPathComponent("team_cards.pdf")
        _ = NSURL(fileURLWithPath: pdfPath)
        print("Rendering PDF...")
        
        /*PDFRenderer.renderPDFToPath(pdfPath) {(progress: Float, done: Bool) -> () in
        self.navigationController?.setSGProgressPercentage(progress * 100)
        
        if(done) {
        print("Done rendering PDF")
        
        self.shareController = self.setupControllerWithURL(pdfURL, usingDelegate: self)
        self.shareController.presentPreviewAnimated(true)
        sender.enabled = true
        }
        }*/
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if data == nil {
            return 44
        }
        
        let dataKey: String = Utils.teamDetailsKeys.keySets[indexPath.section][indexPath.row]
        if Utils.teamDetailsKeys.longTextCells.contains(dataKey) {
            let dataPoint: AnyObject = data!.valueForKeyPath(dataKey) ?? ""
            
            let titleText = Utils.humanReadableNames[dataKey]
            let notesText = "\(roundValue(dataPoint, toDecimalPlaces: 2))"
            
            let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16)]
            return (titleText! as NSString).sizeWithAttributes(attrs).height + (notesText as NSString).sizeWithAttributes(attrs).height + 44
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data == nil ? nil : Utils.teamDetailsKeys.keySetNames[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data == nil ? 1 : Utils.teamDetailsKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 1 : Utils.teamDetailsKeys.keySets[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if data != nil {
            if data!.number == nil {
                cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailStringCell", forIndexPath: indexPath)
                cell.textLabel?.text = "No data yet..."
                cell.accessoryType = UITableViewCellAccessoryType.None
                return cell
            }
            
            let dataKey: String = Utils.teamDetailsKeys.keySets[indexPath.section][indexPath.row]
            
            if !Utils.teamDetailsKeys.defaultKeys.contains(dataKey) { //Default keys are currently just 'matches'
                var dataPoint = AnyObject?()
                var secondDataPoint = AnyObject?()
                
                dataPoint = data!.valueForKeyPath(dataKey) ?? ""
                
                if obstacleKeys.contains(dataKey) {
                    secondDataPoint = data!.valueForKeyPath(dataKey.stringByReplacingOccurrencesOfString("Auto", withString: "Tele"))
                    
                    if let sf = secondDataPoint as? Float? {
                        secondDataPoint = "\(roundValue(sf, toDecimalPlaces: 1))"
                    }
                }
                
                if secondDataPoint as? String == "" {
                    secondDataPoint = nil
                }
                
                if Utils.teamDetailsCells.longTextCells.contains(dataKey) {
                    let notesCell: ResizableNotesTableViewCell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailStringCell", forIndexPath: indexPath) as! ResizableNotesTableViewCell
                    
                    notesCell.titleLabel?.text = Utils.humanReadableNames[dataKey]
                    
                    if "\(dataPoint)".isEmpty {
                        notesCell.notesLabel?.text = "None"
                    } else {
                        notesCell.notesLabel?.text = "\(dataPoint!)"
                    }
                    notesCell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell = notesCell
                } else if Utils.teamDetailsCells.unrankedCells.contains(dataKey) || dataKey.containsString("pit") {
                    let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCellWithIdentifier("UnrankedCell", forIndexPath: indexPath) as! UnrankedTableViewCell
                    
                    unrankedCell.titleLabel.text = Utils.humanReadableNames[dataKey]
                    
                    if "\(dataPoint)".isEmpty || isZero(dataPoint!) {
                        unrankedCell.detailLabel.text = ""
                    } else if dataKey == "pitOrganization" { //In the pit scout, the selector is indexed 0 to 4, this translates it back in to what those numbers mean.
                        unrankedCell.detailLabel!.text! = pitOrgForNumberString(unrankedCell.detailLabel!.text!)
                    } else if dataKey == "pitProgrammingLanguage" {
                        unrankedCell.detailLabel!.text! = pitProgrammingLanguageForNumberString(unrankedCell.detailLabel!.text!)
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
                    
                    multiCell.teamLabel!.text = Utils.humanReadableNames[dataKey]
                    
                    if secondDataPoint != nil { //This means that it is a defense crossing
                        if secondDataPoint as? String != "" && dataPoint as? String != "" {
                            if let ff = dataPoint as? Float {
                                dataPoint = roundValue(ff, toDecimalPlaces: 1) ?? ""
                            }
                            multiCell.scoreLabel?.text = "A: \(dataPoint!) T: \(secondDataPoint!)"
                        }
                    } else { //Its not a defense crossing
                        
                        if percentageValues.contains(dataKey) {
                            multiCell.scoreLabel!.text = "\(percentageValueOf(dataPoint!))"
                        } else {
                            if dataPoint as? String != "" {
                                if Utils.teamDetailsKeys.plus1Keys.contains(dataKey) { //Something ranked with a 1-5 selector, but the indecles that would come back from such a selector are 0-4
                                    multiCell.scoreLabel?.text = "\(roundValue(dataPoint! as! Float + 1.00, toDecimalPlaces: 2))"
                                } else if yesNoKeys.contains(dataKey) {
                                    if dataPoint! as! Bool == true {
                                        multiCell.scoreLabel?.text = "Yes"
                                    } else {
                                        multiCell.scoreLabel?.text = "No"
                                    }
                                } else { // it is neither a yes/no or a +1 key.
                                    multiCell.scoreLabel!.text = "\(roundValue(dataPoint!, toDecimalPlaces: 2))"
                                }
                            } else {
                                multiCell.scoreLabel?.text = ""
                            }
                        }
                        if multiCell.teamLabel?.text?.rangeOfString("Accuracy") != nil || multiCell.teamLabel?.text?.rangeOfString("Consistency") != nil { //Anything with the words "Accuracy" or "Consistency" should be a percentage
                            multiCell.scoreLabel!.text = percentageValueOf(dataPoint!)
                        }
                        
                        /*//Low Shots Attempted Tele
                        if multiCell.teamLabel?.text?.rangeOfString("Accuracy") != nil && multiCell.teamLabel?.text?.rangeOfString("Low") != nil {
                        var counter = 0
                        for TIM in (data?.TeamInMatchDatas)! {
                        if TIM.calculatedData?.lowShotsAttemptedTele != nil {
                        counter += (TIM.calculatedData!.lowShotsAttemptedTele?.integerValue)!
                        }
                        }
                        if counter == 0 {
                        multiCell.scoreLabel!.text = "0 Attempted"
                        }
                        }
                        if multiCell.teamLabel?.text?.rangeOfString("Accuracy") != nil && multiCell.teamLabel?.text?.rangeOfString("High") != nil {
                        var counter = 0
                        for TIM in (data?.TeamInMatchDatas)! {
                        if TIM.calculatedData?.highShotsAttemptedTele != nil {
                        counter += (TIM.calculatedData!.highShotsAttemptedTele?.integerValue)!
                        }
                        }
                        if(counter == 0) {
                        multiCell.scoreLabel!.text = "0 Attempted"
                        }
                        }*/
                        
                        
                        
                        //                multiCell.selectionStyle = UITableViewCellSelectionStyle.None
                        
                    }
                    cell = multiCell
                    multiCell.rankLabel!.text = "\(firebaseFetcher.rankOfTeam(data!, withCharacteristic: dataKey))"
                }
            } else {
                let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCellWithIdentifier("UnrankedCell", forIndexPath: indexPath) as! UnrankedTableViewCell
                
                unrankedCell.titleLabel.text = Utils.humanReadableNames[dataKey]
                unrankedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                if dataKey == "matchDatas" {
                    unrankedCell.titleLabel.text = unrankedCell.titleLabel.text?.stringByAppendingString(" - (\(firebaseFetcher.matchesUntilTeamNextMatch(data?.number as! Int) ?? "NA"))".stringByAppendingString(" Remaining: \(firebaseFetcher.remainingMatchesForTeam((data?.number?.integerValue)!))"))
                }
                cell = unrankedCell
            }
            
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailStringCell", forIndexPath: indexPath)
            cell.textLabel?.text = "No data yet..."
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    /**
     Translates numbers into what it actually means.
     
     - parameter numString: e.g. "0" -> "Terrible"
     
     - returns: A string with the human readable pit org
     */
    func pitOrgForNumberString(numString: String) -> String {
        let translated = ""
        switch numString {
        case "0": translated = "Terrible"
        case "1": translated = "Bad"
        case "2": translated = "OK"
        case "3": translated = "Good"
        case "4": translated = "Great"
        default: break
        return translated
        }
    }
    /**
     Translates numbers into what it actually means.
     
     - parameter numString: e.g. "0" -> "C++"
     
     - returns: A string with the human readable prog lang name.
     */
    func pitProgrammingLanguageForNumberString(numString: String) -> String {
        let translated = ""
        switch numString {
        case "0": translated = "C++"
        case "1": translated = "Java"
        case "2": translated = "Labview"
        case "3": translated = "Other"
        default: break
        return translated
        }
    }
    
    func updateTitleAndTopInfo() {
        if self.teamNameLabel != nil {
            if self.teamNameLabel.text == "" || self.teamNameLabel.text == "Unknown name..." {
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
                
                teamNameLabel?.text = nameText
                teamNumberLabel?.text = numText
            }
            
            
            var seedText = "?"
            var predSeedText = "?"
            if let seed = data?.calculatedData!.actualSeed where seed.integerValue > 0 {
                seedText = "\(seed)"
            }
            
            if let predSeed = data?.calculatedData!.predictedSeed where predSeed.integerValue > 0 {
                predSeedText = "\(predSeed)"
            }
            
            
            seed?.text = seedText
            predictedSeed?.text = predSeedText
        }
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
        //navigationController?.setSGProgressPercentage(50.0)
        if segue.identifier == "sortedRankSegue" {
            if let dest = segue.destinationViewController as? sortedRankTableViewController {
                dest.keyPath = sender as! String
            }
        }
        if segue.identifier == "defenseCrossedSegue" {
            let indexPath = sender as? NSIndexPath
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as? MultiCellTableViewCell
            let dest = segue.destinationViewController as? DefenseTableViewController
            if let teamNumbah = data?.number {
                dest!.teamNumber = teamNumbah.integerValue
                dest!.relevantDefense = cell!.teamLabel!.text!
                dest!.defenseKey = Utils.getKeyForHumanReadableName(dest!.relevantDefense)!.characters.split{$0 == "."}.map(String.init)[2]
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
            let matchesForTeamController = segue.destinationViewController as! SpecificTeamScheduleTableViewController
            
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
                    var key = Utils.getKeyForHumanReadableName(graphViewController.graphTitle)
                    
                    
                    key = key?.stringByReplacingOccurrencesOfString("calculatedData.", withString: "")
                    switch key! { // Should really just be a dictionary
                    case "reachPercentage": key = "didReachAuto"
                    case "scalePercentage": key = "didScaleTele"
                    case "incapacitatedPercentage": key = "didGetIncapacitated"
                    case "disabledPercentage": key = "didGetDisabled"
                    case "challengePercentage": key = "didChallengeTele"
                    case "avgShotsBlocked": key = "numShotsBlockedTele"
                    case "avgLowShotsTele": key = "numLowShotsMadeTele"
                    case "avgHighShotsTele": key = "numHighShotsMadeTele"
                    case "avgBallsKnockedOffMidlineAuto": key = "numBallsKnockedOffMidlineAuto"
                    case "avgMidlineBallsIntakedAuto": key = "calculatedData.numBallsIntakedOffMidlineAuto"
                    case "avgSpeed": key = "rankSpeed"
                    case "avgAgility": key = "rankAgility"
                    case "avgTorque": key = "rankTorque"
                    case "avgBallControl": key = "rankBallControl"
                    case "avgLowShotsAttemptedTele": key = "calculatedData.lowShotsAttemptedTele"
                    case "avgHighShotsAttemptedAuto": key = "calculatedData.highShotsAttemptedAuto"
                    case "avgHighShotsAttemptedTele": key = "calculatedData.highShotsAttemptedTele"
                    case "RScoreDrivingAbility": key = "calculatedData.drivingAbility"
                    case "RScoreBallControl": key = "rankBallControl"
                    case "RScoreAgility": key = "rankAgility"
                    case "RScoreDefense": key = "rankDefense"
                    case "RScoreSpeed": key = "rankSpeed"
                    case "RScoreTorque": key = "rankTorque"
                    case "avgGroundIntakes": key = "numGroundIntakesTele"
                    case "avgDefense": key = "rankDefense"
                    case "actualNumRPs": key = "calculatedData.numRPs"
                    case "siegeConsistency": key = "calculatedData.siegeConsistency"
                    case "teleopShotAbility": key = "calculatedData.teleopShotAbility"
                    case "lowShotAccuracyTele": key = "calculatedData.lowShotAccuracyTele"
                    case "highShotAccuracyTele": key = "calculatedData.highShotAccuracyTele"
                    case "lowShotAccuracyAuto": key = "calculatedData.lowShotAccuracyAuto"
                    case "highShotAccuracyAuto": key = "calculatedData.highShotAccuracyAuto"
                    case "numAutoPoints": key = "calculatedData.numAutoPoints"
                    case "disfunctionalPercentage": key = "calculatedData.wasDisfunctional"
                    case "avgNumTimesCrossedDefensesAuto": key = "calculatedData.totalNumTimesCrossedDefensesAuto"
                    case "avgHighShotsAuto": key = "numHighShotsMadeAuto"
                    case "avgLowShotsAuto": key = "numLowShotsMadeAuto"
                    default: break
                    }
                    
                    
                    var values: [Float]
                    let altMapping : [CGFloat: String]?
                    if key == "calculatedData.predictedNumRPs" {
                        
                        (values, altMapping) = firebaseFetcher.getMatchDataValuesForTeamForPath(key!, forTeam: data!)
                    } else {
                        (values, altMapping) = firebaseFetcher.getMatchValuesForTeamForPath(key!, forTeam: data!)
                    }
                    if key?.rangeOfString("Accuracy") != nil {
                        graphViewController.isPercentageGraph = true
                    }
                    /*if values.reduce(0, combine: +) == 0 || values.count == 0 {
                    graphViewController.graphTitle = "Data Is All 0s"
                    graphViewController.values = [CGFloat]()
                    graphViewController.subValuesLeft = [CGFloat]()
                    if altMapping != nil {
                    graphViewController.zeroAndOneReplacementValues = altMapping!
                    }
                    } else {
                    //print(values)*/
                    var nilValueIndecies = [Int]()
                    for i in 0..<values.count {
                        if values[i] == -1111.1 {
                            nilValueIndecies.append(i)
                        }
                    }
                    for i in nilValueIndecies.reverse() {
                        values.removeAtIndex(i)
                    }
                    
                    graphViewController.values = values as NSArray as! [CGFloat]
                    graphViewController.subDisplayLeftTitle = "Match: "
                    graphViewController.subValuesLeft = nsNumArrayToIntArray(firebaseFetcher.matchNumbersForTeamNumber(data?.number as! Int))
                    for i in nilValueIndecies.reverse() {
                        graphViewController.subValuesLeft.removeAtIndex(i)
                    }
                    
                    if altMapping != nil {
                        graphViewController.zeroAndOneReplacementValues = altMapping!
                    }
                    //print("Here are the subValues \(graphViewController.values.count)::\(graphViewController.subValuesLeft.count)")
                    //print(graphViewController.subValuesLeft)
                    //}
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
        } else if segue.identifier == "NotesSegue" {
            let notesTableViewController = segue.destinationViewController as! NotesTableViewController
            if let teamNum = data?.number  {
                if let p = data?.pitNotes {
                    notesTableViewController.data.append(["Pit Notes: ": p])
                } else {
                    notesTableViewController.data.append(["Pit Notes: ": "None"])
                }
                for TIMD in firebaseFetcher.getTIMDataForTeam(data!) {
                    if let note = TIMD.superNotes {
                        notesTableViewController.data.append(["Match \(TIMD.matchNumber!.integerValue)":"\(note)"])
                    } else {
                        notesTableViewController.data.append(["Match \(TIMD.matchNumber!.integerValue)":"None"])
                    }
                }
                notesTableViewController.title = "\(teamNum) Notes"
            }
        }
    }
    
    func boolToBoolString(b: Bool) -> String {
        let strings = [false : "No", true : "Yes"]
        return strings[b]!
    }
    
    func setupControllerWithURL(fileURL: NSURL, usingDelegate: UIDocumentInteractionControllerDelegate) -> UIDocumentInteractionController {
        let interactionController = UIDocumentInteractionController(URL: fileURL)
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
            if cell.titleLabel.text?.rangeOfString("Matches") != nil {
                performSegueWithIdentifier("Matches", sender: nil)
            }
        } else if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MultiCellTableViewCell {
            let cs = cell.teamLabel!.text
            if ((cs ?? "").containsString("Times Crossed"))  {
                performSegueWithIdentifier("defenseCrossedSegue", sender:indexPath)
            } else if((Utils.getKeyForHumanReadableName(cs!)) != nil) {
                if !notGraphingValues.contains(cs!) && !cs!.containsString("σ") { performSegueWithIdentifier("CTIMDGraph", sender: indexPath) }
            } else {
                performSegueWithIdentifier("TGraph", sender: indexPath)
            }
            
        } else if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ResizableNotesTableViewCell {
            //Currently the only one is pit notes. We want it to segue to super notes per match
            if cell.textLabel?.text == "Pit Notes" {
                performSegueWithIdentifier("NotesSegue", sender: indexPath)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func reloadTableView(note: NSNotification) {
        if note.name == "updateLeftTable" {
            if let t = note.object as? Team {
                if t.number == data?.number {
                    self.data = t
                    self.reload()
                }
            }
            
        }
    }
    
    func rankingDetailsSegue(gesture: UIGestureRecognizer) {
        
        if(gesture.state == UIGestureRecognizerState.Began) {
            let p = gesture.locationInView(self.tableView)
            let indexPath = self.tableView.indexPathForRowAtPoint(p)
            if let index = indexPath {
                if let cell = self.tableView.cellForRowAtIndexPath(index) as? MultiCellTableViewCell {
                    if cell.teamLabel!.text!.containsString("Crossed") == false {
                        performSegueWithIdentifier("sortedRankSegue", sender: cell.teamLabel!.text)
                    }
                }
            }
            
            
        }
    }
}


