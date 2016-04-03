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

@property (weak, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentMatch;
@end

@implementation ScheduleTableViewController


- (IBAction)ourScheduleTapped:(id)sender {
    [self performSegueWithIdentifier:@"citrusSchedule" sender:sender];
}

-(void)firebaseFinished {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    self.cacheButton.enabled = NO;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToCurrentMatch:) name:@"currentMatchUpdated" object:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //[self cachePhotos:self.cacheButton];
   // [self.tableView setUserInteractionEnabled:NO];
}

- (void)scrollToCurrentMatch:(NSNotification*)note {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"currentMatchUpdated" object:nil];
    self.currentMatch = (NSInteger)[self.firebaseFetcher currentMatchNum];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target: self selector:@selector(scroll:) userInfo:nil repeats:NO];
}

-(void)scroll:(NSTimer*)timer {
    //NSIndexPath *i = ;
   // UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:i];
    if([self.tableView numberOfRowsInSection:0] > self.currentMatch - 1) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentMatch - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
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
       // NSLog([NSString stringWithFormat:@"%ld", match.redScore.integerValue]);
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.redScore.integerValue];
        
        matchCell.redScoreLabel.alpha = 1;
    } else {
        if(match.calculatedData.predictedRedScore != nil) {
            matchCell.redScoreLabel.text = [Utils roundValue: match.calculatedData.predictedRedScore.floatValue toDecimalPlaces:1];
        } else {
            matchCell.redScoreLabel.text = @"?";
        }
        
        matchCell.redScoreLabel.alpha = .3;
        matchCell.slash.alpha = .3;
    }
    if (match.blueScore != nil) {
        //NSLog([NSString stringWithFormat:@"%ld",match.blueScore.integerValue]);
        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.blueScore.integerValue];
        matchCell.slash.alpha = 1;
        matchCell.blueScoreLabel.alpha = 1;
    }
    else {
        if (match.calculatedData.predictedBlueScore != nil) {
            matchCell.blueScoreLabel.text = [Utils roundValue: match.calculatedData.predictedBlueScore.floatValue toDecimalPlaces:1];
        } else {
        matchCell.blueScoreLabel.text = @"?";
        }
        matchCell.blueScoreLabel.alpha = .3;
    }
    if(![matchCell.blueScoreLabel.text  isEqual: @"?"] && ![matchCell.redScoreLabel.text  isEqual: @"?"] && ![matchCell.blueScoreLabel.text isEqual:@"-1"] && ![matchCell.redScoreLabel.text isEqual:@"-1"]) {
        if ([matchCell.matchLabel.text integerValue] > self.currentNumber) {
            self.currentNumber = [matchCell.matchLabel.text integerValue];
        }
        //NSLog([NSString stringWithFormat:@"%ld",(long)self.currentNumber]);
    }
}

- (NSString *)cellIdentifier {
    return MATCH_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = self.firebaseFetcher.matches;
    
    //NSLog(@"%lu", (unsigned long)returnData.count);
    //[self.tableView setUserInteractionEnabled:YES];
    return returnData;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    if([self.firebaseFetcher.starredMatchesArray containsObject:matchCell.matchLabel.text]) {
        matchCell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64 blue:1.0 alpha:0.6];
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
    //NSLog([NSString stringWithFormat:@"%lu",(unsigned long)self.firebaseFetcher.matches.count]);
    detailController.match = [self.firebaseFetcher.matches objectAtIndex:cell.matchLabel.text.integerValue-1];
    detailController.matchNumber = cell.matchLabel.text.integerValue;
    }
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    if(scope == 0) {
        return [self.firebaseFetcher filteredMatchesForMatchSearchString:searchString];
    } else if(scope == 1) {
        return [self.firebaseFetcher filteredMatchesforTeamSearchString:searchString];
    }
    return @[@"ERROR"];
    
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
    //[self.firebaseFetcher downloadAllImages];
}

+ (NSArray *)mappings {
    return @[@"One", @"Two", @"Three"];
}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        CGPoint p = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        MatchTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if([self.firebaseFetcher.starredMatchesArray containsObject:cell.matchLabel.text]) {
            NSMutableArray *a = [NSMutableArray arrayWithArray:self.firebaseFetcher.starredMatchesArray];
            [a removeObject:cell.matchLabel.text];
            self.firebaseFetcher.starredMatchesArray = a;
            cell.backgroundColor = [UIColor whiteColor];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64 blue:1.0 alpha:0.6];
            self.firebaseFetcher.starredMatchesArray = [self.firebaseFetcher.starredMatchesArray arrayByAddingObjectsFromArray:@[cell.matchLabel.text]];
        }
        [self.firebaseFetcher checkForNotification];
        //NSNotification *note = [[NSNotification alloc] initWithName:@"lpgrTriggered" object:nil userInfo:nil];
        //[[NSNotificationCenter defaultCenter] postNotification:note];
    }
}


@end
