//
//  TeamDetailsTableViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/18/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import MWPhotoBrowser
import SDWebImage
import Haneke

//TableViewDataSource/Delegate allows vc to contain a table view/pass in info.
class TeamDetailsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate, UIDocumentInteractionControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    var firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    //setup visuals
    @IBOutlet weak var scrollView: UIScrollView!
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
            num = self.team?.number
            updateTitleAndTopInfo()
            reload()
        }
    }
    
    var num: Int? = nil
    var showMinimalistTeamDetails = false
    var shareController: UIDocumentInteractionController!
    var photoBrowser = MWPhotoBrowser()
    var photos: [MWPhoto] = []
    
    func reload() {
        if team != nil {
            if team?.number != nil {
                tableView?.reloadData()
                self.updateTitleAndTopInfo()
                //tableViewHeightConstraint?.constant = (tableView.contentSize.height)
                
                self.reloadImage()
            }
        }
        
    }
    
    //this is a really big function that just sets selectedImage... i think
    func reloadImage() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if let team = self.team,
                let imageView = self.teamSelectedImageView {
                    if team.pitSelectedImageName != nil {
                        self.firebaseFetcher?.getImageForTeam((self.team?.number)!, fetchedCallback: { (image) -> () in
                            DispatchQueue.main.async(execute: { () -> Void in
                                imageView.image = image
                                self.resetTableViewHeight()
                            })
                            }, couldNotFetch: {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if team.pitAllImageURLs != nil {
                                        if team.pitSelectedImageName != nil && team.pitSelectedImageName != "" {
                                            let url = URL(string: (Array(Array(team.pitAllImageURLs!.values)).filter { $0.contains((team.pitSelectedImageName!).replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "+", with: "%2B")) } )[0])!
                                            imageView.hnk_setImageFromURL(url, success: { _ in
                                                self.resetTableViewHeight()
                                                })
                                        }
                                    }
                                })
                        })
                    }
                    let noRobotPhoto = UIImage(named: "SorryNoRobotPhoto")
                    if let urls = self.team?.pitAllImageURLs {
                        for url in urls.values {
                            if self.photos.count < self.team!.pitAllImageURLs!.count {
                                self.photos.append(MWPhoto(url: URL(string: url)))
                            }
                        }
                    }
                
                if self.team?.pitSelectedImageName != nil {
                    if self.teamSelectedImageView.image != MWPhoto(url: URL(string: (self.team?.pitSelectedImageName)!)) && self.photos.count > 0 {
                        if self.photos.count > 0 && self.photos[0].underlyingImage != noRobotPhoto && (self.photos[0].underlyingImage ?? UIImage()).size.height > 0 {
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                self.teamSelectedImageView.image = self.photos[0].underlyingImage
                                self.resetTableViewHeight()
                               

                            })
                            
                        }
                        self.resetTableViewHeight()
                    }
                }
            }
        }
        self.resetTableViewHeight()
    }
    
    func resetTableViewHeight() {
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableViewHeightConstraint?.constant = (self.tableView.contentSize.height)
            if self.scrollView != nil && self.tableView != nil {
                self.scrollView.contentSize.height = self.tableViewHeightConstraint.constant + self.tableView.frame.origin.y
                //self.tableView.setNeedsUpdateConstraints()
                //self.scrollView.setNeedsUpdateConstraints()
                self.scrollView.setNeedsDisplay()
                self.tableView.setNeedsDisplay()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
        NotificationCenter.default.addObserver(self, selector: #selector(TeamDetailsTableViewController.reloadTableView(_:)), name:NSNotification.Name(rawValue: "updateLeftTable"), object:nil)
        
       //set up the tableView
        tableView.register(UINib(nibName: "MultiCellTableViewCell", bundle: nil), forCellReuseIdentifier: "MultiCellTableViewCell")
        tableView.delegate = self
        
        self.navigationController?.delegate = self
        self.photoBrowser.delegate = self
        self.scrollView.delegate = self
        
        //array of all photos
        photos = []
        
        //longpress recognizer
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(TeamDetailsTableViewController.rankingDetailsSegue(_:)))
        self.view.addGestureRecognizer(longPress)
        //let longPressForMoreDetail = UILongPressGestureRecognizer(target: self, action: #selector(TeamDetailsTableViewController.didLongPressForMoreDetail(_:)))
        //self.teamNumberLabel.addGestureRecognizer(longPressForMoreDetail)
        let tap = UITapGestureRecognizer(target: self, action: #selector(TeamDetailsTableViewController.didTapImage(_:)))
        self.teamSelectedImageView.addGestureRecognizer(tap)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.reload()
        reloadImage()

           }
    
    
    
    //Not used in 2017
    func didLongPressForMoreDetail(_ recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.recognized {
            self.showMinimalistTeamDetails = !self.showMinimalistTeamDetails
            self.reload()
            self.teamNumberLabel.textColor = UIColor.black
        } else if recognizer.state == UIGestureRecognizerState.began {
            self.teamNumberLabel.textColor = UIColor.green
        } 
    }
    
    //Image is tapped
    func didTapImage(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.recognized {
            //navigate to image browser
            let nav = UINavigationController(rootViewController: self.photoBrowser)
            nav.delegate = self
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.delegate = nil
        super.viewWillDisappear(animated)
    }
    
    @IBAction func exportTeamPDFs(_ sender: UIBarButtonItem) {
        //sender.isEnabled = false
        //let pdfPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("team_cards.pdf")
        
        //let pdfPath = dir.appendingPathComponent("team_cards.pdf")
        //_ = URL(fileURLWithPath: pdfPath)
        //print("Rendering PDF...")
        
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
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if team == nil {
            return 44
        }
        
        //get key
        let dataKey: String = Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
        //no longTextCells
        if Utils.teamDetailsKeys.TIMDLongTextCells.contains(dataKey) {
            
            var text = ""
            for timd in (self.firebaseFetcher?.getTIMDataForTeam(self.team!))! {
                if let data = timd.value(forKey: dataKey) {
                    text.append("\nQ\(timd.matchNumber!): \(data)")
                }
            }
            
            let titleText = Utils.humanReadableNames[dataKey]
            
            let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 16)]
            return (titleText! as NSString).size(attributes: attrs).height + (text as NSString).size(attributes: attrs).height + 44
        } else {
            return 44
        }
    }*/
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return team == nil ? nil : Utils.teamDetailsKeys.keySetNames(self.showMinimalistTeamDetails)[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return team == nil ? 1 : Utils.teamDetailsKeys.keySetNames(self.showMinimalistTeamDetails).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Utils.teamDetailsKeys.keySetNames(self.showMinimalistTeamDetails)[section] != "super" {
            return team == nil ? 1 : Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[section].count
        } else {
            return team == nil ? 1 : Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[section].count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if team != nil {
            if team!.number == -1 {
                //no team number
                cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath)
                cell.textLabel?.text = "No team yet..."
                cell.accessoryType = UITableViewCellAccessoryType.none
                return cell
            }
            
            let dataKey: String = Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            
            if !Utils.teamDetailsKeys.defaultKeys.contains(dataKey) { //Default keys are currently just 'matchDatas' and 'TeamInMatchDatas'... if NOT a default key
                var dataPoint = AnyObject?.init(nilLiteral: ())
                var secondDataPoint = AnyObject?.init(nilLiteral: ())
                if dataKey.contains("calculatedData.avgGearsPlacedByLiftAuto") {
                    dataPoint = team?.calculatedData?.avgGearsPlacedByLiftAuto?[dataKey.components(separatedBy: ".")[2]] as AnyObject
                } else if dataKey.contains("calculatedData") {
                    dataPoint = team!.value(forKeyPath: dataKey) as AnyObject
                } else {
                    dataPoint = (team!.dictionaryRepresentation() as NSDictionary).object(forKey: dataKey) as AnyObject
                }
                
                if secondDataPoint as? String == "" {
                    secondDataPoint = nil
                }
                
                //notes
                if Utils.teamDetailsKeys.TIMDLongTextCells.contains(dataKey) {
                    let notesCell: ResizableNotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath) as! ResizableNotesTableViewCell
                    
                    notesCell.titleLabel?.text = Utils.humanReadableNames[dataKey]
                    
                    let TIMDs = firebaseFetcher?.getTIMDataForTeam(self.team!).sorted { $0.matchNumber! < $1.matchNumber! }
                    var datas = [String]()
                    for TIMD in TIMDs! {
                        if let data = TIMD.value(forKey: dataKey) {
                            let dataString = "Q\(TIMD.matchNumber!): \(data)"
                            datas.append(dataString)
                        }
                    }
                    
                    notesCell.notesLabel.text = datas.reduce(String()) { previous, new in "\(previous)\n\(new)" }
                    //notesCell.heightAnchor
                    notesCell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell = notesCell
                    
                } else if Utils.teamDetailsKeys.unrankedCells.contains(dataKey) || dataKey.contains("pit") { //pit keys
                    let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UnrankedCell", for: indexPath) as! UnrankedTableViewCell
                    
                    //titleLabel is the humanReadable version of dataKey
                    unrankedCell.titleLabel.text = Utils.humanReadableNames[dataKey]
                    
                    if "\(dataPoint)".isEmpty || (dataPoint as? Float != nil && dataPoint as! Float == 0.0) {
                        unrankedCell.detailLabel.text = ""
                    } else if dataKey == "pitOrganization" { //In the pit scout, the selector is indexed 0 to 4, this translates it back in to what those numbers mean.
                        unrankedCell.detailLabel!.text! = (team?.pitOrganization) ?? ""
                    } else if dataKey == "pitProgrammingLanguage" {
                        unrankedCell.detailLabel!.text! = (team?.pitProgrammingLanguage) ?? ""
                    } else if dataKey == "pitDriveTrain" {
                        unrankedCell.detailLabel!.text! = (team?.pitDriveTrain) ?? ""
                    } else if Utils.teamDetailsKeys.addCommasBetweenCapitals.contains(dataKey) {
                        unrankedCell.detailLabel.text = "\(insertCommasAndSpacesBetweenCapitalsInString(roundValue(dataPoint!, toDecimalPlaces: 2)))"
                    } else if Utils.teamDetailsKeys.boolValues.contains(dataKey) {
                        unrankedCell.detailLabel.text = "\(boolToBoolString(dataPoint as! Bool))"
                    } else {
                        unrankedCell.detailLabel.text = "\(roundValue(dataPoint!, toDecimalPlaces: 2))"
                    }
                    
                    unrankedCell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell = unrankedCell
                } else {
                    //get cell
                    let multiCell: MultiCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MultiCellTableViewCell", for: indexPath) as! MultiCellTableViewCell
                    
                    //label is humanReadable version of dataKey
                    multiCell.teamLabel!.text = Utils.humanReadableNames[dataKey]
                    
                    if secondDataPoint != nil { //This means that it is a defense crossing (Deprecated)
                        if secondDataPoint as? String != "" && dataPoint as? String != "" {
                            if let ff = dataPoint as? Float {
                                dataPoint = roundValue(ff as AnyObject?, toDecimalPlaces: 1) as AnyObject?? ?? "" as AnyObject?
                            }
                            multiCell.scoreLabel?.text = "A: \(dataPoint!) T: \(secondDataPoint!)"
                        }
                    } else {
                        
                        if Utils.teamDetailsKeys.percentageValues.contains(dataKey) {
                            //value needs to be displayed as a percentage
                            multiCell.scoreLabel!.text = "\(percentageValueOf(dataPoint!))"
                        } else {
                            if dataPoint as? String != "" {
                                 if Utils.teamDetailsKeys.yesNoKeys.contains(dataKey) {
                                    //value needs to be displayed as Yes or No
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
                        if multiCell.teamLabel?.text?.range(of: "Accuracy") != nil || multiCell.teamLabel?.text?.range(of: "Consistency") != nil { //Anything with the words "Accuracy" or "Consistency" should be a percentage
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
                    multiCell.rankLabel!.text = "\((firebaseFetcher?.rankOfTeam(team!, withCharacteristic: dataKey))! as Int)"
                }
            } else { //is a defaultKey
                let unrankedCell: UnrankedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UnrankedCell", for: indexPath) as! UnrankedTableViewCell
                
                //title is humanReadable dataKey
                unrankedCell.titleLabel.text = Utils.humanReadableNames[dataKey]
                
                unrankedCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                if dataKey == "matchDatas" {
                    let matchesUntilNextMatch : String = firebaseFetcher?.matchesUntilTeamNextMatch((team?.number)!) ?? "NA"
                    
                    //label: "Matches - #  Remaining
                    unrankedCell.titleLabel.text = (unrankedCell.titleLabel.text)! + " - (\(matchesUntilNextMatch))  Remaining: \(Utils.sp(thing: firebaseFetcher?.remainingMatchesForTeam((team?.number)!)))"
                }
                cell = unrankedCell
            }
            
            
        } else {
            //get empty cell
            cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath)
            cell.textLabel?.text = "No team yet..."
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //
    }
    
    /*func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        //
    }*/
    
    /**
     Translates numbers into what it actually means.
     
     - parameter numString: e.g. "0" -> "Terrible"
     
     - returns: A string with the human readable pit org
     */
    /*func pitOrgForNumberString(_ numString: String) -> String {
        var translated = ""
        switch numString {
        case "0": translated = "Terrible"
        case "1": translated = "Bad"
        case "2": translated = "OK"
        case "3": translated = "Good"
        case "4": translated = "Great"
        default: break
        }
        return translated

    }*/ 
    /**
     Translates numbers into what it actually means.
     
     - parameter numString: e.g. "0" -> "C++"
     
     - returns: A string with the human readable prog lang name.
     */
    func pitProgrammingLanguageForNumberString(_ numString: String) -> String {
        var translated = ""
        switch numString {
        case "0": translated = "C++"
        case "1": translated = "Java"
        case "2": translated = "Labview"
        case "3": translated = "Other"
        default: break
        }
        return translated

    }
    
    func updateTitleAndTopInfo() {
        if self.teamNameLabel != nil {
            if self.teamNameLabel.text == "" || self.teamNameLabel.text == "Unknown name..." {
                let numText: String
                let nameText: String
                switch (team?.number, team?.name) {
                case (.some(let num), .some(let name)):
                    title = "\(num)"
                    numText = "\(num)"
                    nameText = "\(name)"
                case (.some(let num), .none):
                    title = "\(num)"
                    numText = "\(num)"
                    nameText = "Unknown name..."
                case (.none, .some(let name)):
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
            if let seed = team?.calculatedData!.actualSeed, seed > 0 {
                seedText = "Seed: \(seed)"
            }
            
            if let predSeed = team?.calculatedData!.predictedSeed, predSeed > 0 {
                predSeedText = "Pred. Seed: \(predSeed)"
            }
            
            
            seed?.text = seedText
            predictedSeed?.text = predSeedText
        }
    }
    
    /**
     Returns the number of photos in a PhotoBrowser.
     
    - parameter photoBrowser: PhotoBrowser you want the function to count.
    */
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    
    /**
    Initializes the photoBrowser.
     
    - parameter photoBrowser: The photoBrowser you want to initialize.
     
    - parameter photoAt: The index at which the photo you're initializing is located.
     
    - returns: The photo at the index you requested.
    */
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if index < UInt(photos.count) {
            return photos[Int(index)]
        }
        return nil;
    }
    
    //preparing to change viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.teamSelectedImageView.isUserInteractionEnabled = true;
        //        self.n
        //navigationController?.setSGProgressPercentage(50.0)
        if segue.identifier == "sortedRankSegue" {
            if let dest = segue.destination as? SortedRankTableViewController {
                dest.keyPath = sender as! String
            }
        } else if segue.identifier == "Photos" {
            let browser = segue.destination as! MWPhotoBrowser;
            
            browser.delegate = self;
            
            browser.displayActionButton = true; // Show action button to allow sharing, copying, etc (defaults to YES)
            browser.displayNavArrows = false; // Whether to display left and right nav arrows on toolbar (defaults to NO)
            browser.displaySelectionButtons = false; // Whether selection buttons are shown on each image (defaults to NO)
            browser.zoomPhotosToFill = true; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
            browser.alwaysShowControls = false; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
            browser.enableGrid = false; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
            
            SDImageCache.shared().maxCacheSize = UInt(20 * 1024 * 1024);
        } else if segue.identifier == "Matches" {
            let matchesForTeamController = segue.destination as! SpecificTeamScheduleTableViewController
            
            if let teamNum = team?.number {
                matchesForTeamController.teamNumber = teamNum
            }
        } else if segue.identifier == "TIMDs" {
            //Navigate to a vc to pick which match, then to TIMD vc
            let TIMDScheduleForTeamController = segue.destination as! TIMDScheduleViewController
            
            if let teamNum = team?.number {
                TIMDScheduleForTeamController.teamNumber = teamNum
            }
        } else if segue.identifier == "CTIMDGraph" {
            //this is called for every timd graph, not just ctimds
            let graphViewController = segue.destination as! GraphViewController
            if let teamNum = team?.number {
                let indexPath = sender as! IndexPath
                if let cell = tableView.cellForRow(at: indexPath) as? MultiCellTableViewCell {
                    graphViewController.graphTitle = "\(cell.teamLabel!.text!)"
                    graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                    var key = Utils.getKeyForHumanReadableName(graphViewController.graphTitle)
                    
                    
                    key = key?.replacingOccurrences(of: "calculatedData.", with: "")
                    key = Utils.teamDetailsKeys.teamDetailsToTIMD[key!]
                    
                    var values: [Float]
                    let altMapping : [CGFloat: String]?
                    if key == "calculatedData.predictedNumRPs" {
                        
                        (values, altMapping) = (firebaseFetcher!.getMatchDataValuesForTeamForPath(key!, forTeam: team!))
                    } else {
                        (values, altMapping) = (firebaseFetcher?.getMatchValuesForTeamForPath(key!, forTeam: team!))!
                    }
                    if key?.range(of: "Accuracy") != nil {
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
                    for i in nilValueIndecies.reversed() {
                        values.remove(at: i)
                    }
                    
                    graphViewController.values = (values as NSArray).map { CGFloat($0 as! Float) }
                    graphViewController.subDisplayLeftTitle = "Match: "
                    graphViewController.subValuesLeft = nsNumArrayToIntArray(firebaseFetcher!.matchNumbersForTeamNumber((team?.number)!) as [NSNumber]) as [AnyObject]
                    for i in nilValueIndecies.reversed() {
                        graphViewController.subValuesLeft.remove(at: i)
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
                    graphViewController.subValuesRight = [teamNum as AnyObject,teamNum as AnyObject,teamNum as AnyObject,teamNum as AnyObject,teamNum as AnyObject]
                    
                    
                }
            }
        }
        else if segue.identifier == "TGraph" {
            let graphViewController = segue.destination as! GraphViewController
            
            if let teamNum = team?.number {
                let indexPath = sender as! IndexPath
                let cell = tableView.cellForRow(at: indexPath) as! MultiCellTableViewCell
                graphViewController.graphTitle = "\(cell.teamLabel!.text!)"
                graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                /*if let values = firebaseFetcher?.valuesInCompetitionOfPathForTeams(Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]) as? [CGFloat] {
                    graphViewController.values = values
                    graphViewController.subValuesLeft = firebaseFetcher!.valuesInCompetitionOfPathForTeams("number") as [AnyObject]
                    graphViewController.subDisplayLeftTitle = "Team "
                    graphViewController.subValuesRight = nsNumArrayToIntArray(firebaseFetcher!.ranksOfTeamsWithCharacteristic(Utils.teamDetailsKeys.keySets(self.showMinimalistTeamDetails)[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row] as NSString) as [NSNumber] ) as [AnyObject]
                    graphViewController.subDisplayRightTitle = "Rank: "
                    if let i = ((graphViewController.subValuesLeft as! [Int]).index(of: teamNum)) {
                        graphViewController.highlightIndex = i
                    }
                }*/
                //keys that don't graph right: Incap, disabled, baseline, liftoff percentage, defense, agility, all super except driving ability- none of these are CTIMDs, but some normal timds work
                var values: [Float]
                let altMapping : [CGFloat: String]?
                var key = Utils.getKeyForHumanReadableName(graphViewController.graphTitle)
                key = Utils.teamDetailsKeys.teamDetailsToTIMD[key!]
                (values, altMapping) = (firebaseFetcher?.getMatchValuesForTeamForPath(key!, forTeam: team!))!
                //var nilValueIndecies = [Int]()
                /* for i in 0..<values.count {
                    if values[i] == -1111.1 {
                        nilValueIndecies.append(i)
                    }
                }
                for i in nilValueIndecies.reversed() {
                    values.remove(at: i)
                } */
                graphViewController.values = (values as NSArray).map { CGFloat($0 as! Float) }
                //                graphViewController.heights =]
                //                graphViewController.teamNumber = Int32(teamNum)
                //                graphViewController.graphInfo = nil;
            }
        } /*else if segue.identifier == "NotesSegue" {
            let notesTableViewController = segue.destination as! NotesTableViewController
            if let teamNum = team?.number  {
                if let p = team?.pitNotes {
                    notesTableViewController.data.append(["Pit Notes: ": p])
                } else {
                    notesTableViewController.data.append(["Pit Notes: ": "None"])
                }
                for TIMD in (firebaseFetcher?.getTIMDataForTeam(team!))! {
                    if let note = TIMD.superclass {
                        notesTableViewController.data.append(["Match \(TIMD.matchNumber!.intValue)":"\(note)"])
                    } else {
                        notesTableViewController.data.append(["Match \(TIMD.matchNumber!.intValue)":"None"])
                    }
                }
                notesTableViewController.title = "\(teamNum) Notes"
            }
        }*/
    }
    
    /** 
    Converts a boolean value to a string value.
     
    - parameter b: Bool to be converted.
     
    - returns: Yes or No for inputted true or false respectively.
     */
    func boolToBoolString(_ b: Bool) -> String {
        let strings = [false : "No", true : "Yes"]
        return strings[b]!
    }
    
    func setupControllerWithURL(_ fileURL: URL, usingDelegate: UIDocumentInteractionControllerDelegate) -> UIDocumentInteractionController {
        let interactionController = UIDocumentInteractionController(url: fileURL)
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
    
    //Row has been selected, perform segue to appropriate vc
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UnrankedTableViewCell {
            if cell.titleLabel.text?.range(of: "Matches") != nil {
                performSegue(withIdentifier: "Matches", sender: nil)
            } else if cell.titleLabel.text?.range(of: "TIMDs") != nil {
                performSegue(withIdentifier: "TIMDs", sender: nil)
            }
        } else if let cell = tableView.cellForRow(at: indexPath) as? MultiCellTableViewCell {
            let cs = cell.teamLabel!.text
            if((Utils.getKeyForHumanReadableName(cs!)) != nil) {
                if !Utils.teamDetailsKeys.notGraphingValues.contains(cs!) && !cs!.contains("σ") { performSegue(withIdentifier: "CTIMDGraph", sender: indexPath) }
            } else {
                performSegue(withIdentifier: "TGraph", sender: indexPath)
            }
            
        } else if let cell = tableView.cellForRow(at: indexPath) as? ResizableNotesTableViewCell {
            //Currently the only one is pit notes. We want it to segue to super notes per match
            if cell.textLabel?.text == "Pit Notes" {
                performSegue(withIdentifier: "NotesSegue", sender: indexPath)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func reloadTableView(_ note: Notification) {
        if note.name.rawValue == "updateLeftTable" {
            if let t = note.object as? Team {
                if t.number == team?.number {
                    self.team = t
                    self.reload()
                }
            }
            
        }
    }
    
    //Rankable row has been long-pressed, perform segue
    func rankingDetailsSegue(_ gesture: UIGestureRecognizer) {
        
        if(gesture.state == UIGestureRecognizerState.began) {
            let p = gesture.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: p)
            if let index = indexPath {
                if let cell = self.tableView.cellForRow(at: index) as? MultiCellTableViewCell {
                    if cell.teamLabel!.text!.contains("Crossed") == false {
                        performSegue(withIdentifier: "sortedRankSegue", sender: cell.teamLabel!.text)
                    }
                }
            }
            
            
        }
    }
}


