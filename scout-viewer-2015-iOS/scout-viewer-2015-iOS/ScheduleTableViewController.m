//
//  ScheduleTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/8/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "config.h"
#import "MatchTableViewCell.h"
#import "scout_viewer_2015_iOS-Swift.h"
#import "UINavigationController+SGProgress.h"

@interface ScheduleTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cacheButton;

@end

@implementation ScheduleTableViewController


- (IBAction)ourScheduleTapped:(id)sender {
    [self performSegueWithIdentifier:@"citrusSchedule" sender:sender];
}

-(void)firebaseFinished {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self cachePhotos:self.cacheButton];
    }

//RIP (2016 - 2016)

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
   
    Match *match = data;
    NSArray *redTeams = [self.firebaseFetcher getTeamsFromNumbers:match.redAllianceTeamNumbers];
    NSArray *blueTeams = [self.firebaseFetcher getTeamsFromNumbers:match.blueAllianceTeamNumbers];
    
    
    
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    matchCell.matchLabel.attributedText = [self textForScheduleLabelForType:0 forString:[NSString stringWithFormat:@"%ld", (long)match.number.integerValue]];
    
    for (int i = 0; i < 3; i++) {
        if(i < redTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[redTeams objectAtIndex:i]).number.integerValue]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        }
    }
    
    
    for (int i = 0; i < 3; i++) {
        if(i < blueTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[blueTeams objectAtIndex:i]).number.integerValue]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
        }
    }
    

    
    
    if (match.redScore != nil) {
        NSLog([NSString stringWithFormat:@"%ld", match.redScore.integerValue]);
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.redScore.integerValue];
        
        matchCell.redScoreLabel.alpha = 1;
    } else {
        matchCell.redScoreLabel.text = @"?";
        
        matchCell.redScoreLabel.alpha = .3;
        matchCell.slash.alpha = .3;
    }
    if (match.blueScore != nil) {
        NSLog([NSString stringWithFormat:@"%ld",match.blueScore.integerValue]);
        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.blueScore.integerValue];
        matchCell.slash.alpha = 1;
        matchCell.blueScoreLabel.alpha = 1;
    }
    else {
        matchCell.blueScoreLabel.text = @"?";
        matchCell.blueScoreLabel.alpha = .3;
    }
    if(![matchCell.blueScoreLabel.text  isEqual: @"?"] && ![matchCell.redScoreLabel.text  isEqual: @"?"] && ![matchCell.blueScoreLabel.text isEqual:@"-1"] && ![matchCell.redScoreLabel.text isEqual:@"-1"]) {
        if ([matchCell.matchLabel.text integerValue] > self.currentNumber) {
            self.currentNumber = [matchCell.matchLabel.text integerValue];
        }
        NSLog(@"Here is the current number:");
        NSLog([NSString stringWithFormat:@"%d",self.currentNumber]);
    }
}

- (NSString *)cellIdentifier {
    return MATCH_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [self.firebaseFetcher fetchMatches:shouldForce];
    NSLog(@"%lu", (unsigned long)returnData.count);
    return returnData;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    if([self.starredMatchesArray containsObject:matchCell.matchLabel.text]) {
        matchCell.backgroundColor = [UIColor greenColor];
    }
    else {
        matchCell.backgroundColor = [UIColor whiteColor];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"Match Segue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier  isEqual: @"citrusSchedule"]) {
        TeamScheduleTableViewController *dest = segue.destinationViewController;
        dest.teamNumber = 1678;
    } else {
    MatchTableViewCell *cell = sender;
    MatchDetailsViewController *detailController = (MatchDetailsViewController *)segue.destinationViewController;
    NSLog([NSString stringWithFormat:@"%lu",(unsigned long)self.firebaseFetcher.matches.count]);
    detailController.match = [self.firebaseFetcher.matches objectAtIndex:cell.matchLabel.text.integerValue-1];
    detailController.matchNumber = cell.matchLabel.text.integerValue;
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.firebaseFetcher filteredMatchesForSearchString:searchString];
    
//    return [firebaseFetcher.matches filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Match *match, NSDictionary *bindings) {
//        if (scope == 0) {
//            return ([match.matchName rangeOfString:searchString].location == 0 || [match.matchName rangeOfString:searchString].location == 1);
//        } else if (scope == 1) {
//            for (Team *team in [firebaseFetcher allTeamsInMatch:match]) {
//                NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
//                if ([numberText rangeOfString:searchString].location == 0) {
//                    return YES;
//                }
//            }
//        }
//        return NO;
//    }]];

}

- (NSArray *)scopeButtonTitles {
    return @[@"Matches", @"Teams"];
}

- (NSAttributedString *)textForScheduleLabelForType:(NSInteger)type forString:(NSString *)string {
    if (type == [self currentScope] && type == 0) {
        return [self textForLabelForString:string highlightOccurencesOfString:[self highlightedStringForScope]];
    } else if (type == [self currentScope] && type == 1) {
        if ([string rangeOfString:[self highlightedStringForScope]].location == 0) {
            return [self textForLabelForString:string highlightOccurencesOfString:[self highlightedStringForScope]];
        }
    }
    
    return [[NSAttributedString alloc] initWithString:string];
}

- (NSAttributedString *)textForLabelForString:(NSString *)string highlightOccurencesOfString:(NSString *)highlightString {
    NSMutableAttributedString *mutAttribString = [[NSMutableAttributedString alloc] initWithString:string];
    if (highlightString) {
        [mutAttribString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:[string rangeOfString:highlightString]];
    }
    
    return mutAttribString;
}

- (IBAction)cachePhotos:(UIBarButtonItem *)sender {
    sender.enabled = NO;


    // Prepare PDF file
    [self.firebaseFetcher downloadAllwithProgressCallback:^(float progress, BOOL done) {
        [self.navigationController setSGProgressPercentage:progress * 100];
    
        if(done) {
            NSLog(@"Done caching images...");

            sender.enabled = YES;
        }
    }];
}

+ (NSArray *)mappings {
    return @[@"One", @"Two", @"Three"];
}
-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        CGPoint p = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        MatchTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if([self.starredMatchesArray containsObject:cell.matchLabel.text]) {
            [self.starredMatchesArray removeObject:cell.matchLabel.text];
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor greenColor];
            [self.starredMatchesArray addObject:cell.matchLabel.text];
        }
    }
}


@end
