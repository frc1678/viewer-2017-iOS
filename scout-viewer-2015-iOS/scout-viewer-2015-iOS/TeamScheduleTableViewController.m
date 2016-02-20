//
//  TeamScheduleTableViewController.m
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 3/28/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

#import "TeamScheduleTableViewController.h"
#import "config.h"
#import "MatchTableViewCell.h"
#import "scout_viewer_2015_iOS-Swift.h"

@interface TeamScheduleTableViewController ()

@end

@implementation TeamScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%ld - Matches", (long)self.teamNumber];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
    Match *match = data;
    NSArray *redTeams = [self.firebaseFetcher getTeamsFromNumbers:match.redAllianceTeamNumbers];
    NSArray *blueTeams = [self.firebaseFetcher getTeamsFromNumbers:match.blueAllianceTeamNumbers];
    
    
    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
    matchCell.matchLabel.attributedText = [self textForScheduleLabelForType:0 forString:[NSString stringWithFormat: @"%ld",match.number.integerValue]];
    
    for (int i = 0; i < 3; i++) {
        if(i < redTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[redTeams objectAtIndex:i]).number.integerValue]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [TeamScheduleTableViewController mappings][i]]];
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [TeamScheduleTableViewController mappings][i]]];
        }
    }
    
    
    for (int i = 0; i < 3; i++) {
        if(i < blueTeams.count) {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[blueTeams objectAtIndex:i]).number.integerValue]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [TeamScheduleTableViewController mappings][i]]];
        } else {
            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [TeamScheduleTableViewController mappings][i]]];
        }
    }
    
    for (UILabel *field in [matchCell teamFields]) {
        [field setBackgroundColor:[UIColor whiteColor]];
        if ([field.text isEqualToString:[@(self.teamNumber) stringValue]]) {
            [field setBackgroundColor:[UIColor greenColor]];
        }
    }
    
    if (match.redScore != nil || match.blueScore != nil) {
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.redScore];
        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.blueScore];
        matchCell.redScoreLabel.alpha = 1;
        matchCell.slash.alpha = 1;
        matchCell.blueScoreLabel.alpha = 1;
    } else if (match.calculatedData.predictedBlueScore != nil || match.calculatedData.predictedRedScore != nil) {
        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.calculatedData.predictedRedScore];
        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.calculatedData.predictedBlueScore];
        matchCell.redScoreLabel.alpha = .5;
        matchCell.slash.alpha = .5;
        matchCell.blueScoreLabel.alpha = .5;
    } else {
        matchCell.redScoreLabel.text = @"?";
        matchCell.blueScoreLabel.text = @"?";
        matchCell.slash.alpha = .5;
        matchCell.redScoreLabel.alpha = .5;
        matchCell.blueScoreLabel.alpha = .5;
    }
}

- (NSString *)cellIdentifier {
    return MATCH_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [self.firebaseFetcher fetchMatchesForTeamWithNumber:self.teamNumber];
    NSLog(@"Return Data");
    NSLog(@"%lu", (unsigned long)returnData.count);
    return returnData;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"Match Segue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MatchTableViewCell *cell = sender;
    MatchDetailsViewController *detailController = (MatchDetailsViewController *)segue.destinationViewController;
    detailController.match = [self.firebaseFetcher.matches objectAtIndex:cell.matchLabel.text.integerValue-1];
    detailController.matchNumber = cell.matchLabel.text.integerValue;}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Match *match, NSDictionary *bindings) {
        if (scope == 0) {
            return ([match.matchName rangeOfString:searchString].location == 0 || [match.matchName rangeOfString:searchString].location == 1);
        } else if (scope == 1) {
            for (Team *team in [self.firebaseFetcher allTeamsInMatch:match]) {
                NSString *numberText = [NSString stringWithFormat:@"%ld", (long)team.number];
                if ([numberText rangeOfString:searchString].location == 0) {
                    return YES;
                }
            }
        }
        
        return NO;
    }]];
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

+ (NSArray *)mappings {
    return @[@"One", @"Two", @"Three"];
}

@end
