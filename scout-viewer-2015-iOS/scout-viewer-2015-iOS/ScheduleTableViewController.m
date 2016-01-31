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

FirebaseDataFetcher *firebaseFetcher;


-(void)firebaseFinished {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkRes:) name:@"updateLeftTable" object:nil];
    firebaseFetcher = [[FirebaseDataFetcher alloc] init];
    [self cachePhotos:self.cacheButton];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return firebaseFetcher.matches.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    
    Match *match = [firebaseFetcher getIntMatch:[indexPath row]];
    NSArray *redTeams = [firebaseFetcher getTeamsFromNumbers:match.redAllianceTeamNumbers];
    NSArray *blueTeams = [firebaseFetcher getTeamsFromNumbers:match.blueAllianceTeamNumbers];
    cell.redOneLabel.text = [NSString stringWithFormat:@"%@",match.redAllianceTeamNumbers[0]];
    cell.redTwoLabel.text = [NSString stringWithFormat:@"%@",match.redAllianceTeamNumbers[1]];
    cell.redThreeLabel.text = [NSString stringWithFormat:@"%@",match.redAllianceTeamNumbers[2]];
    cell.blueOneLabel.text = [NSString stringWithFormat:@"%@",match.blueAllianceTeamNumbers[0]];
    cell.blueTwoLabel.text = [NSString stringWithFormat:@"%@",match.blueAllianceTeamNumbers[1]];
    cell.blueThreeLabel.text = [NSString stringWithFormat:@"%@",match.blueAllianceTeamNumbers[2]];
    cell.matchLabel.text = [NSString stringWithFormat:@"%d",match.number];
    cell.redScoreLabel.text = [NSString stringWithFormat:@"%d",match.redScore];
    cell.blueScoreLabel.text = [NSString stringWithFormat:@"%d",match.blueScore];
    return cell;
}
-(void)checkRes:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"updateLeftTable"])
    {
        [self.tableView reloadData];
    }
}

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path forData:(id)data inTableView:(UITableView *)tableView {
//    NSLog(@"-----------------------------------");
//    NSLog(data);
//    Match *match = data;
//    NSArray *redTeams = [firebaseFetcher getTeamsFromNumbers:match.redAllianceTeamNumbers];
//    NSArray *blueTeams = [firebaseFetcher getTeamsFromNumbers:match.blueAllianceTeamNumbers];
//    
//    
//    
//    MatchTableViewCell *matchCell = (MatchTableViewCell *)cell;
//    matchCell.matchLabel.attributedText = [self textForScheduleLabelForType:0 forString:[NSString stringWithFormat:@"%ld", (long)match.number]];
//    
//    for (int i = 0; i < 3; i++) {
//        if(i < redTeams.count) {
//            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[redTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
//        } else {
//            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"red%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
//        }
//    }
//    
//    
//    for (int i = 0; i < 3; i++) {
//        if(i < blueTeams.count) {
//            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"%ld", (long)((Team *)[blueTeams objectAtIndex:i]).number]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
//        } else {
//            [cell setValue:[self textForScheduleLabelForType:1 forString:[NSString stringWithFormat:@"???"]] forKeyPath:[NSString stringWithFormat:@"blue%@Label.attributedText", [ScheduleTableViewController mappings][i]]];
//        }
//    }
//    
//
//    
//    
//    if (match.redScore != -1 || match.blueScore != -1) {
//        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.redScore];
//        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.blueScore];
//        matchCell.redScoreLabel.alpha = 1;
//        matchCell.slash.alpha = 1;
//        matchCell.blueScoreLabel.alpha = 1;
//    } else {
//        matchCell.redScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.calculatedData.predictedRedScore];
//        matchCell.blueScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)match.calculatedData.predictedBlueScore];
//        matchCell.redScoreLabel.alpha = .3;
//        matchCell.slash.alpha = .3;
//        matchCell.blueScoreLabel.alpha = .3;
//    }
//}

- (NSString *)cellIdentifier {
    return MATCH_CELL_IDENTIFIER;
}

- (NSArray *)loadDataArray:(BOOL)shouldForce {
    NSArray *returnData = [firebaseFetcher fetchMatches:shouldForce];
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
    detailController.match = [firebaseFetcher.matches objectAtIndex:cell.matchLabel.text.integerValue-1];
    detailController.matchNumber = cell.matchLabel.text.integerValue;
}

- (NSArray *)filteredArrayForSearchText:(NSString *)searchString inScope:(NSInteger)scope
{
    return [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Match *match, NSDictionary *bindings) {
        if (scope == 0) {
            return ([match.matchName rangeOfString:searchString].location == 0 || [match.matchName rangeOfString:searchString].location == 1);
        } else if (scope == 1) {
            for (Team *team in [firebaseFetcher allTeamsInMatch:match]) {
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

- (IBAction)cachePhotos:(UIBarButtonItem *)sender {
    sender.enabled = NO;


    // Prepare PDF file
    [firebaseFetcher downloadAllwithProgressCallback:^(float progress, BOOL done) {
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

@end
