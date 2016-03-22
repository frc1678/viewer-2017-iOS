//
//  GraphViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 3/29/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import UIKit
import JBChartView

class GraphViewController: UIViewController, JBBarChartViewDataSource, JBBarChartViewDelegate {
    
    @IBOutlet weak var graph: JBBarChartView!
    @IBOutlet weak var mainDisplay: UILabel!
    @IBOutlet weak var subDisplayLeft: UILabel!
    @IBOutlet weak var subDisplayRight: UILabel!
    
    
    var values: [CGFloat] = []
    var subValuesLeft: [AnyObject] = []
    var subValuesRight: [AnyObject] = []
    var color = UIColor.greenColor()
    var negativeColor = UIColor.blueColor()
    var highlightColor = UIColor.grayColor()
    var fadeColor = UIColor.blackColor()
    var highlightIndex = -1;
    var defaultHeight: CGFloat!
    var graphTitle = ""
    var displayTitle = ""
    var subDisplayLeftTitle = ""
    var subDisplayRightTitle = ""
    var negativeMultiplier = 0.5
    var zeroAndOneReplacementValues = [CGFloat : String]()
    var newValuesArray = [String]()
    var isPercentageGraph = false
    
    var lens: UIView!
    
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
        "rankBallControl" : "calculatedData.avgBallControl", //
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
    
    override func viewDidAppear(animated: Bool) {
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
        graph.setState(JBChartViewState.Collapsed, animated: false)
        graph.reloadData()
        graph.setState(JBChartViewState.Expanded, animated: true)
    }
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(values.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return values[Int(index)] - min(values.minElement()!, 0.0);
    }
    
    func barSelectionColorForBarChartView(barChartView: JBBarChartView!) -> UIColor! {
        return highlightColor
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let mainDisplayText : String
        if newValuesArray.count == 0 {
            if !isPercentageGraph {
                mainDisplayText = "\(displayTitle)\(roundValue(values[Int(index)], toDecimalPlaces: 2))"
            } else {
                mainDisplayText = "\(displayTitle)\(percentageValueOf(values[Int(index)]))"
            }
        } else {
            mainDisplayText = "\(displayTitle)\(newValuesArray[Int(index)])"
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
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        toggleDisplay(true)
        barChartView.becomeFirstResponder()
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        if Int(index) == highlightIndex {
            if values[Int(index)] < 0 {
                return UIColor.purpleColor()
            } else {
                return UIColor.greenColor()
            }
        } else if values[Int(index)] < 0 {
            let fraction = ((values.maxElement()! - min(values.minElement()!, 0.0)) / (values[Int(index)] - min(values.minElement()!, 0.0)))
            return negativeColor.colorWithAlphaComponent((fraction * 0.3 + 0.2) * CGFloat(negativeMultiplier))
        } else {
            return color.colorWithAlphaComponent(((values[Int(index)] - min(values.minElement()!, 0.0)) / (values.maxElement()! - min(values.minElement()!, 0.0))) * 0.5 + 0.5)
        }
    }
    
    
    
    
    
    
    func toggleDisplay(hide: Bool) {
        if hide {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.mainDisplay.alpha = 0.0
                self.subDisplayLeft.alpha = 0.0
                self.subDisplayRight.alpha = 0.0
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                self.mainDisplay.alpha = 1.0
                self.subDisplayLeft.alpha = 1.0
                self.subDisplayRight.alpha = 1.0
                }, completion: nil)
        }
    }
    
    @IBAction func displayAlphaChanged(sender: UISlider) {
        negativeMultiplier = Double(sender.value)
        graph.reloadData()
    }
}
