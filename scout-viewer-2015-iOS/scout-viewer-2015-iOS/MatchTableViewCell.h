//
//  TableViewCell.h
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *redOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *redTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *redThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *redScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *slash;

- (NSArray *)teamFields;

@end
