//
//  GraphViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 3/29/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import JBChartView

class GraphViewController: UIViewController, JBBarChartViewDataSource, JBBarChartViewDelegate {
    
    @IBOutlet weak var graph: JBBarChartView!
    @IBOutlet weak var mainDisplay: UILabel!
    
    /// Text in the top left
    @IBOutlet weak var subDisplayLeft: UILabel!
    /// Text in the top right
    @IBOutlet weak var subDisplayRight: UILabel!
    
    /// How high the bars are
    var values: [CGFloat] = []
    /// When a bar is held down by the finger, what should you display on the left for that bar index? Maybe the team number? It depends on the particular graph.
    var subValuesLeft: [AnyObject] = []
    /// When a bar is held down by the finger, what should you display on the right for that bar index? Maybe the team number? It depends on the particular graph.
    var subValuesRight: [AnyObject] = []
    /// Normal color of the bars
    var color = UIColor.green
    
    var negativeColor = UIColor.blue
    /// Color when you press and hold a bar
    var highlightColor = UIColor.gray
    var fadeColor = UIColor.black
    var highlightIndex = -1;
    var defaultHeight: CGFloat!
    var graphTitle = ""
    var displayTitle = ""
    var subDisplayLeftTitle = ""
    var subDisplayRightTitle = ""
    var negativeMultiplier = 0.5
    /// Values to replace 0 and 1 with (maybe true and false, or yes and no).
    var zeroAndOneReplacementValues = [CGFloat : String]()
    var newValuesArray = [String]()
    var isPercentageGraph = false
    
    /// In Utils, we remap keys to nice titles. Use substitute keys in some cases to make the right titles come out.
    let titleSwitch = [
        "didScaleTele" : "scalePercentage",
        "didGetIncapacitated" : "incapacitatedPercentage",
        "didGetDisabled" : "disabledPercentage",
        "didChallengeTele" : "challengePercentage",
        "numShotsBlockedTele" : "avgShotsBlocked",
        "numLowShotsMadeTele" : "avgLowShotsTele",
        "numHighShotsMadeTele" : "avgHighShotsTele",
        "numBallsKnockedOffMidlineAuto" : "avgBallsKnockedOffMidlineAuto",
        "calculatedData.numBallsIntakedOffMidlineAuto" : "avgMidlineBallsIntakedAuto",
        "calculatedData.RScoreSpeed" : "calculatedData.avgSpeed",
        "calculatedData.RScoreEvasion" : "calculatedData.avgEvasion",
        "calculatedData.RScoreTorque" : "calculatedData.avgTorque",
        "rankBallControl" : "calculatedData.avgBallControl",
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = graphTitle
        if zeroAndOneReplacementValues.count > 0 {
            newValuesArray = [String]()
            for i in values.indices {
                let v = values[i]
                if let newValue = zeroAndOneReplacementValues[v] {
                    newValuesArray.append(newValue)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var reverseTitleSwitch = [String: String]()
        for (key, value) in titleSwitch {
            reverseTitleSwitch[value] = key
        }
        if let k = Utils.getKeyForHumanReadableName(self.graphTitle) {
            if reverseTitleSwitch.keys.contains(k) {
                if Utils.humanReadableNames.keys.contains(reverseTitleSwitch[k]!) {
                    self.graphTitle = Utils.humanReadableNames[reverseTitleSwitch[k]!]!
                }
            }
        }
        
        defaultHeight = graph.frame.height
        graph.dataSource = self
        graph.delegate = self
        graph.minimumValue = 0.0
        graph.setState(JBChartViewState.collapsed, animated: false)
        graph.reloadData()
        graph.setState(JBChartViewState.expanded, animated: true)
    }
    
    func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
        return UInt(values.count)
    }
    
    func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
        return values[Int(index)] - min(values.min()!, 0.0);
    }
    
    func barSelectionColor(for barChartView: JBBarChartView!) -> UIColor! {
        return highlightColor
    }
        
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
        let mainDisplayText : String
        let displayTitleWithoutAvg = displayTitle.replacingOccurrences(of: "Avg. ", with: "").replacingOccurrences(of: " Consistency", with: "").replacingOccurrences(of: " Percentage", with: "")
        if newValuesArray.count == 0 {
            if !isPercentageGraph {
                mainDisplayText = "\(displayTitleWithoutAvg)\(roundValue(values[Int(index)] as AnyObject?, toDecimalPlaces: 2))"
            } else {
                mainDisplayText = "\(displayTitleWithoutAvg)\(percentageValueOf(values[Int(index)] as AnyObject?))"
            }
        } else {
            mainDisplayText = "\(displayTitleWithoutAvg)\(newValuesArray[Int(index)])"
        }
        self.mainDisplay.text = mainDisplayText
        
        if Int(index) < subValuesLeft.count {
            self.subDisplayLeft.text = "\(subDisplayLeftTitle)\(subValuesLeft[Int(index)])"
        }
        
        if Int(index) < subValuesRight.count {
            self.subDisplayRight.text = "\(subDisplayRightTitle)\(subValuesRight[Int(index)])"
        }
        
        toggleDisplay(false)
        barChartView.becomeFirstResponder()
    }
    
    func didDeselect(_ barChartView: JBBarChartView!) {
        toggleDisplay(true)
        barChartView.becomeFirstResponder()
    }
    
    func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
        if Int(index) == highlightIndex {
            if values[Int(index)] < 0 {
                return UIColor.purple
            } else {
                return UIColor.green
            }
        } else if values[Int(index)] < 0 {
            let fraction = ((values.max()! - min(values.min()!, 0.0)) / (values[Int(index)] - min(values.min()!, 0.0)))
            return negativeColor.withAlphaComponent((fraction * 0.3 + 0.2) * CGFloat(negativeMultiplier))
        } else {
            return color.withAlphaComponent(((values[Int(index)] - min(values.min()!, 0.0)) / (values.max()! - min(values.min()!, 0.0))) * 0.5 + 0.5)
        }
    }
    
    func toggleDisplay(_ hide: Bool) {
        if hide {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.mainDisplay.alpha = 0.0
                self.subDisplayLeft.alpha = 0.0
                self.subDisplayRight.alpha = 0.0
                }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.mainDisplay.alpha = 1.0
                self.subDisplayLeft.alpha = 1.0
                self.subDisplayRight.alpha = 1.0
                }, completion: nil)
        }
    }
    
    @IBAction func displayAlphaChanged(_ sender: UISlider) {
        negativeMultiplier = Double(sender.value)
        graph.reloadData()
    }
}
