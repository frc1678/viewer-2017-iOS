//
//  SecondPickTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "SecondPickTableViewController.h"
#import "MultiCellTableViewCell.h"
#import "config.h"
#import "scout_viewer_2015_iOS-Swift.h"


@interface SecondPickTableViewController ()

@end

@implementation SecondPickTableViewController


-(void)viewDidLoad {
    [super viewDidLoad];
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Team *team = data;
    MultiCellTableViewCell *multiCell = (MultiCellTableViewCell *)cell;
    
    
    multiCell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.firebaseFetcher rankOfTeam:team withCharacteristic:@"calculatedData.overallSecondPickAbility"]];
    multiCell.teamLabel.text = [NSString stringWithFormat:@"%ld", (long)team.number.integerValue];
    if(team.calculatedData.firstPickAbility != nil) {
    multiCell.scoreLabel.text = [NSString stringWithFormat:@"%@",
                                 [Utils roundValue:team.calculatedData.overallSecondPickAbility.floatValue toDecimalPlaces:2]];
    } else {
        multiCell.scoreLabel.text = @"";
    }
    
}

- (NSString *)cellIdentifier {
    return MULTI_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [self.firebaseFetcher getSecondPickList];
    NSLog(@"%lu", (unsigned long)returnData.count);
    return returnData;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"classSpecSecondPickSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.destinationViewController isKindOfClass:[TeamDetailsTableViewController class]]) {
//        MultiCellTableViewCell *multiCell = sender;
//        
//        TeamDetailsTableViewController *teamDetailsController = segue.destinationViewController;
//        
//        if ([firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]].calculatedData.actualSeed > 0) {
//            teamDetailsController.data = [firebaseFetcher fetchTeam:[multiCell.teamLabel.text integerValue]];
//        }
//    }
    if([segue.destinationViewController isKindOfClass:[ConditionalSecondPickTableViewController class]]) {
        NSLog(@"Prepping Segue");
        MultiCellTableViewCell *multiCell = sender;
        ConditionalSecondPickTableViewController *dest = segue.destinationViewController;
        dest.teamNumber = [multiCell.teamLabel.text integerValue];
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Team *team, NSDictionary *bindings) {
        NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
        return [numberText rangeOfString:searchString].location == 0;
    }]];
}


@end
