//
//  PDFRenderer.m
//  scout-viewer-2014-ios
//
//  Created by Donald Pinckney on 3/24/14.
//  Copyright (c) 2014 Citrus Circuits. All rights reserved.
//

#import "PDFRenderer.h"
#import "NSAttributedString+OrdinalFormat.h"
#import <objc/runtime.h>
#import "scout_viewer_2015_iOS-Swift.h"

@interface PDFRenderer ()

@end

@implementation PDFRenderer

FirebaseDataFetcher *firebaseFetcher;


#define GRAPH_KEYS @[@"secondPickAbility", @"stackingAbility", @"thirdPickAbility", @"thirdPickAbilityLandfill"]
#define COLORS @[[UIColor purpleColor], [UIColor greenColor], [UIColor blueColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor redColor]]

static NSMutableDictionary *teamsDict;
static NSMutableArray *teamNums;

-(void)viewDidLoad {
    firebaseFetcher = [AppDelegate getAppDelegate].firebaseFetcher;
}

+ (void) renderPDFToPath:(NSString *)filePath withProgressCallback:(void(^)(float progress, BOOL done))progressCallback
{
    teamsDict = [[NSMutableDictionary alloc] init];
    teamNums = [[NSMutableArray alloc] init];
    NSArray *teams = [firebaseFetcher.teams sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES]]];
    for (Team *team in teams) {
        [teamNums addObject: team.number];
        NSMutableDictionary *teamDict = [[NSMutableDictionary alloc] init];
        [teamsDict setObject:teamDict forKey:team.number];
        [teamDict setObject:team.number forKey:@"number"];
        [teamDict setObject:team.calculatedData.actualSeed forKey:@"seed"];
        [teamDict setObject:team.name forKey:@"name"];
        for (NSString *prop in [self allPropertyNamesForClass:[CalculatedTeamData class]]) {
            [teamDict setObject:[team.calculatedData valueForKeyPath:prop] forKey:prop];
        }
        for (NSString *prop in [self allPropertyNamesForClass:[CalculatedTeamData class]]) {
            [teamDict setObject:[team.calculatedData valueForKeyPath:prop] forKey:prop];
        }
    }
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float width = 612;
        float height = 792;
    
        
#pragma mark - PDF Render Loop
        // Begin PDF context
        UIGraphicsBeginPDFContextToFile(filePath, CGRectMake(0, 0, width, height), nil);
        
        for (int i = 0; i < teamNums.count; i++) {
            [PDFRenderer renderPDFPageForTeamData:[teamsDict objectForKey:[teamNums objectAtIndex:i]]];
            
            NSLog(@"Completed page %d of %ld", i+1, (unsigned long)teams.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressCallback) {
                    progressCallback((float)(i+1) / teams.count, NO);
                }
            });
        }
        
        UIGraphicsEndPDFContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressCallback) {
                progressCallback(1, YES);
            }
        });
    });
}

+(NSArray *)dataLabelsForTeam:(NSDictionary *)team {
    NSArray *datas = [self graphValuesForTeamDict:team];
    NSMutableArray *a = [[NSMutableArray alloc] init];
    for (NSNumber *num in datas) {
        [a addObject:[Utils roundValue:[num floatValue] toDecimalPlaces:2]];
    }
    return a;
}


#define CATEGORY_HEIGHT 100
#define LEFT_MARGIN 20
#define RIGHT_MARGIN 20
#define TOP_MARGIN 20
#define BOTTOM_MARGIN 20
#define AFTER_LABEL_MARGIN 40
#define GRAPH_WIDTH 150
#define GRAPH_IMAGE_MARGIN 5
#define CATEGORY_TOP_MARGIN 15

+ (void) renderPDFPageForTeamData:(NSDictionary *)team
{
    float pageWidth = 612;
    float pageHeight = 792;
    
    // Setup highlight color
    UIColor *highlightColor = [UIColor colorWithRed:0.903 green:0.158 blue:0.193 alpha:1.000];
    
    // Setup styles
    NSMutableParagraphStyle *centerParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    centerParagraphStyle.alignment = NSTextAlignmentCenter;
    
    // Style used for team number title
    NSDictionary *titleStyle = @{NSParagraphStyleAttributeName: centerParagraphStyle,
                                 NSForegroundColorAttributeName:highlightColor,
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:26]};
    
    // Style used for team name subtitle
    NSDictionary *seedingStyle = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                   NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:14]};
    
    // Style used as header at top of Offense, Defense, and Passing categories
    NSDictionary *categoryHeaderStyle = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16]};
    
    // Style used for bolded number in data
    NSDictionary *dataNumberStyle = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Italic" size:11]};
    
    // Style used for bolded number in data
    NSDictionary *rankNumberStyle = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:11]};
    
    // Style used for generic body text
    NSDictionary *bodyStyle = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:11]};

    
    #pragma mark - PDF Rendering
    UIGraphicsBeginPDFPage();

    UIImage *robotImage = [firebaseFetcher getTeamPDFImage:[[team objectForKey:@"number"] integerValue]];
    
    NSAttributedString *numberTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)[[team objectForKey:@"number"] integerValue]] attributes:titleStyle];
    CGFloat topLabelHeight = numberTitle.size.height;
    [numberTitle drawInRect:CGRectMake(0, TOP_MARGIN, pageWidth, topLabelHeight)];
    
    float aspect = 0;
    float imageHeight = 0;
    float imageWidth = 0;
    if (robotImage) {
        aspect = robotImage.size.width / robotImage.size.height;
        imageHeight = pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT - CATEGORY_TOP_MARGIN - TOP_MARGIN - AFTER_LABEL_MARGIN - topLabelHeight;
        imageWidth = pageWidth - LEFT_MARGIN - RIGHT_MARGIN - GRAPH_WIDTH - GRAPH_IMAGE_MARGIN;
        if (imageHeight * aspect < imageWidth) {
            imageWidth = imageHeight * aspect;
        } else {
            imageHeight = imageWidth / aspect;
        }
    }
    
    
    [[NSString stringWithFormat:@"Avg. Score: %@ (%@)", [Utils roundValue:[team[@"averageScore"] floatValue] toDecimalPlaces:2], team[@"seed"]] drawInRect:CGRectMake(pageWidth - 150, TOP_MARGIN, 150, topLabelHeight) withAttributes:seedingStyle];
    
    // Render robot image
    [robotImage drawInRect:CGRectMake(LEFT_MARGIN, ((pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT - CATEGORY_TOP_MARGIN - TOP_MARGIN - AFTER_LABEL_MARGIN - topLabelHeight) / 2 + TOP_MARGIN + AFTER_LABEL_MARGIN + topLabelHeight) - imageHeight / 2, imageWidth, imageHeight)];
    CGPoint graphPoint = CGPointMake(pageWidth - GRAPH_WIDTH - RIGHT_MARGIN + GRAPH_IMAGE_MARGIN, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT - CATEGORY_TOP_MARGIN);
   
    [self createGraphAtLocation:graphPoint withWidth:(pageWidth - RIGHT_MARGIN - graphPoint.x) withHeight:pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT - CATEGORY_TOP_MARGIN - AFTER_LABEL_MARGIN - TOP_MARGIN - topLabelHeight withDataValues:[self graphValuesForTeamDict:team] withMaxValues:[self maxValues] withMinValues:[self minValues] withLabels:[self dataLabelsForTeam:team] withColors:COLORS];
    
    
    // Create and render first pick category
    NSAttributedString *firstPickCategoryText = [self firstPickAttributedStringWithCategoryHeaderStyle:categoryHeaderStyle dataNumberStyle:dataNumberStyle rankNumberStyle:rankNumberStyle bodyStyle:bodyStyle team:team];
    CGPoint offensePoint = CGPointMake(LEFT_MARGIN, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT);
    [firstPickCategoryText drawAtPoint:offensePoint];
    
    // Create and render second pick category
    NSAttributedString *secondPickCategoryText = [self secondPickAttributedStringWithCategoryHeaderStyle:categoryHeaderStyle dataNumberStyle:dataNumberStyle rankNumberStyle:rankNumberStyle bodyStyle:bodyStyle team:team];
    CGPoint defensePoint = CGPointMake(171, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT);
    [secondPickCategoryText drawAtPoint:defensePoint];
    
    // Create and render third pick category
    NSAttributedString *thirdPickCategoryText = [self thirdPickAttributedStringWithCategoryHeaderStyle:categoryHeaderStyle dataNumberStyle:dataNumberStyle rankNumberStyle:rankNumberStyle bodyStyle:bodyStyle team:team];
    CGPoint passingPoint = CGPointMake(332, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT);
    [thirdPickCategoryText drawAtPoint:passingPoint];
    
    // Create and render cheesecake category
    NSAttributedString *cheesecakeCategoryText = [self cheesecakeAttributedStringWithCategoryHeaderStyle:categoryHeaderStyle dataNumberStyle:dataNumberStyle rankNumberStyle:rankNumberStyle bodyStyle:bodyStyle team:team];
    CGPoint notesPoint = CGPointMake(483, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT);
    [cheesecakeCategoryText drawAtPoint:notesPoint];
    
    // Render separator lines
    float separatorX = 298;
    
    UIBezierPath *offenseDefenseSeparator = [[UIBezierPath alloc] init];
    [offenseDefenseSeparator moveToPoint:CGPointMake(defensePoint.x - 10, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT)];
    [offenseDefenseSeparator addLineToPoint:CGPointMake(defensePoint.x - 10, pageHeight - BOTTOM_MARGIN)];
    
    separatorX = 398;
    UIBezierPath *defensePassingSeparator = [[UIBezierPath alloc] init];
    [defensePassingSeparator moveToPoint:CGPointMake(passingPoint.x - 10, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT)];
    [defensePassingSeparator addLineToPoint:CGPointMake(passingPoint.x - 10, pageHeight - BOTTOM_MARGIN)];
    
    UIBezierPath *passingNotesSeparator = [[UIBezierPath alloc] init];
    [defensePassingSeparator moveToPoint:CGPointMake(notesPoint.x - 10, pageHeight - BOTTOM_MARGIN - CATEGORY_HEIGHT)];
    [defensePassingSeparator addLineToPoint:CGPointMake(notesPoint.x - 10, pageHeight - BOTTOM_MARGIN)];
    
    [[UIColor blackColor] setStroke];
    [offenseDefenseSeparator stroke];
    [defensePassingSeparator stroke];
    [passingNotesSeparator stroke];
}

+ (NSArray *)graphValuesForTeamDict:(NSDictionary *)teamDict {
    NSMutableArray *vals = [[NSMutableArray alloc] init];
    for (NSString *key in GRAPH_KEYS) {
        [vals addObject:teamDict[key]];
    }
    
    return vals;
}

+ (NSArray *)maxValues {
    NSMutableArray *maxVals = [[NSMutableArray alloc] init];
    for (NSString *key in GRAPH_KEYS) {
        [maxVals addObject:[NSNumber numberWithFloat:[self maxValueForKey:key]]];
    }
    
    return maxVals;
}

+ (float)maxValueForKey:(NSString *)key {
    float max = 0.00000000001;
    for (NSDictionary *teamKey in teamsDict) {
        NSDictionary *teamDict = teamsDict[teamKey];
        max = MAX(max, [teamDict[key] floatValue]);
    }
    
    return max;
}

+ (NSArray *)minValues {
    NSMutableArray *minValues = [[NSMutableArray alloc] init];
    for (NSString *key in GRAPH_KEYS) {
        [minValues addObject:[NSNumber numberWithFloat:[self minValueForKey:key]]];
    }
    
    return minValues;
}

+ (float)minValueForKey:(NSString *)key {
    float min = -0.00000000001;
    for (NSDictionary *teamKey in teamsDict) {
        NSDictionary *teamDict = teamsDict[teamKey];
        min = MIN(min, [teamDict[key] floatValue]);
    }
    
    return min;
}

+ (NSAttributedString *) attributedRankRowForKey:(NSString *)key inTeam:(NSDictionary *)team withTitle:(NSString *)title dataNumberStyle:(NSDictionary *)dataNumberStyle rankNumberStyle:(NSDictionary *)rankNumberStyle bodyStyle:(NSDictionary *)bodyStyle asPercent:(BOOL)asPercent forColor:(UIColor *)color
{
    float number = [[team objectForKey:key] floatValue];
    if(isnan(number)) {
        number = 0;
    }
    
    NSInteger rank = [self rankOfTeam:team byKey:key];
    
    NSString *numberString;
    if(asPercent) {
        numberString = [NSString stringWithFormat:@"%d%%", (int)round(100*number)];
    } else {
        numberString = [NSString stringWithFormat:@"%.2f", number];
    }
    
    NSMutableAttributedString *rankRowText = [[NSAttributedString attributedStringWithOrdinalInteger:rank andBaseAttributes:rankNumberStyle] mutableCopy];
    [rankRowText appendAttributedString:[[NSAttributedString alloc] initWithString:@" (" attributes:bodyStyle]];
    [rankRowText appendAttributedString:[[NSAttributedString alloc] initWithString:numberString attributes:dataNumberStyle]];
    [rankRowText appendAttributedString:[[NSAttributedString alloc] initWithString:@") " attributes:bodyStyle]];
    [rankRowText appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:bodyStyle]];

    if (color) {
        [rankRowText appendAttributedString:[[NSAttributedString alloc] initWithString:@" ⦁" attributes:@{NSForegroundColorAttributeName : color}]];
    }
    
    [rankRowText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];

    return rankRowText;
}

+ (UIColor *)colorFromKey:(NSString *)key {
    if ([GRAPH_KEYS containsObject:key]) {
        return COLORS[[GRAPH_KEYS indexOfObject:key]];
    } else {
        return nil;
    }
}

+ (NSAttributedString *)firstPickAttributedStringWithCategoryHeaderStyle:(NSDictionary *)categoryHeaderStyle dataNumberStyle:(NSDictionary *)dataNumberStyle rankNumberStyle:(NSDictionary *)rankNumberStyle bodyStyle:(NSDictionary *)bodyStyle team:(NSDictionary *)team
{
    // Create and render offense category
    NSMutableAttributedString *firstPickCategoryText = [[NSMutableAttributedString alloc] initWithString:@"First Pick:\n" attributes:categoryHeaderStyle];
    
    // Auto text
    [firstPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"firstPickAbility"
                                                                              inTeam:team
                                                                           withTitle:@"1st Ability"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"firstPickAbility"]]];
    
    [firstPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"isStackedToteSetPercentage"
                                                                              inTeam:team
                                                                           withTitle:@"Auto Stack"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:YES
                                                                            forColor:[self colorFromKey:@"isStackedToteSetPercentage"]]];
//
//    // Tele text
    [firstPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"avgNumTotesFromHP"
                                                                              inTeam:team
                                                                           withTitle:@"HP Totes"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"avgNumTotesFromHP"]]];

    [firstPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"avgNumTotesPickedUpFromGround"
                                                                              inTeam:team
                                                                           withTitle:@"Ground Totes"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"avgNumTotesPickedUpFromGround"]]];
    
    return firstPickCategoryText;
}

+ (NSAttributedString *)secondPickAttributedStringWithCategoryHeaderStyle:(NSDictionary *)categoryHeaderStyle dataNumberStyle:(NSDictionary *)dataNumberStyle rankNumberStyle:(NSDictionary *)rankNumberStyle bodyStyle:(NSDictionary *)bodyStyle team:(NSDictionary *)team
{
    // Create and render defense category
    NSMutableAttributedString *secondPickCategoryText = [[NSMutableAttributedString alloc] initWithString:@"Second Pick:\n" attributes:categoryHeaderStyle];
    
    [secondPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"secondPickAbility"
                                                                              inTeam:team
                                                                           withTitle:@"2nd Ability"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"secondPickAbility"]]];
    
    // Auto text
    [secondPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"stackingAbility"
                                                                              inTeam:team
                                                                           withTitle:@"Avg. Stk. Pts."
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"stackingAbility"]]];
    //
//    // Tele text
    [secondPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"avgMaxFieldToteHeight"
                                                                              inTeam:team
                                                                           withTitle:@"Avg. Max T"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"avgMaxFieldToteHeight"]]];
//
    
    [secondPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"avgMaxReconHeight"
                                                                              inTeam:team
                                                                           withTitle:@"Avg. Max RC"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"avgMaxReconHeight"]]];
    
    [secondPickCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"avgNumCappedSixStacks"
                                                                              inTeam:team
                                                                           withTitle:@"Avg. Cap 5/6"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"avgNumCappedSixStacks"]]];
    
    return secondPickCategoryText;
}

+ (NSAttributedString *)thirdPickAttributedStringWithCategoryHeaderStyle:(NSDictionary *)categoryHeaderStyle dataNumberStyle:(NSDictionary *)dataNumberStyle rankNumberStyle:(NSDictionary *)rankNumberStyle bodyStyle:(NSDictionary *)bodyStyle team:(NSDictionary *)team
{
    // Create and render offense category
    NSMutableAttributedString *passingCategoryText = [[NSMutableAttributedString alloc] initWithString:@"Third Pick:\n" attributes:categoryHeaderStyle];
    
    // Auto text
    
    [passingCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"thirdPickAbility"
                                                                              inTeam:team
                                                                           withTitle:@"3rd Ability"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"thirdPickAbility"]]];
    
    [passingCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"thirdPickAbilityLandfill"
                                                                              inTeam:team
                                                                           withTitle:@"3rd LF Abil"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"thirdPickAbilityLandfill"]]];
    
    [passingCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"avgNumTotesFromHP"
                                                                              inTeam:team
                                                                           withTitle:@"Avg. HP Totes"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"avgNumTotesFromHP"]]];
    
    
    [passingCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"avgNumTotesPickedUpFromGround"
                                                                              inTeam:team
                                                                           withTitle:@"Avg. LF Totes"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                            forColor:[self colorFromKey:@"avgNumTotesPickedUpFromGround"]]];
    
    return passingCategoryText;
}



#define AXIS_WIDTH 1
#define AXIS_LEFT_MARGIN 1
#define AXIS_RIGHT_MARGIN 1
#define GRAPH_TOP_MARGIN 1
#define BAR_SEPARATOR 1
#define BAR_LIFT 1
#define BAR_LABEL_MARGIN 10
+ (void)createGraphAtLocation:(CGPoint)point withWidth:(float)width withHeight:(float)height withDataValues:(NSArray *)datas withMaxValues:(NSArray *)maxes withMinValues:(NSArray *)mins withLabels:(NSArray *)labels withColors:(NSArray *)colors {
    
    UIBezierPath *graphX = [[UIBezierPath alloc] init];
    graphX.lineWidth = AXIS_WIDTH;
    [graphX moveToPoint:point];
    [graphX addLineToPoint:CGPointMake(point.x + width, point.y)];
    [[UIColor grayColor] setStroke];
    [graphX stroke];
    
    UIBezierPath *maxLine = [[UIBezierPath alloc] init];
    maxLine.lineWidth = AXIS_WIDTH;
    [maxLine moveToPoint:CGPointMake(point.x + width / 2 - 10, point.y - height)];
    [maxLine addLineToPoint:CGPointMake(point.x + width / 2 + 10, point.y - height)];
    [[UIColor lightGrayColor] setStroke];
    [maxLine stroke];
    
    float barWidth = (width - AXIS_LEFT_MARGIN - AXIS_RIGHT_MARGIN - BAR_SEPARATOR * datas.count) / datas.count;
    
    
    for (int i = 0; i < datas.count; i++) {
        float dataPoint = [datas[i] floatValue];
        
        UIBezierPath *bar = [[UIBezierPath alloc] init];
        bar.lineWidth = barWidth;
        [bar moveToPoint:CGPointMake(point.x + AXIS_LEFT_MARGIN + (BAR_SEPARATOR + barWidth) * i + barWidth / 2, point.y - BAR_LIFT)];
        [bar addLineToPoint:CGPointMake(point.x + AXIS_LEFT_MARGIN + (BAR_SEPARATOR + barWidth) * i + barWidth / 2, point.y - AXIS_WIDTH - BAR_LIFT - (MAX(dataPoint, 0) / [maxes[i] floatValue]) * (height - AXIS_WIDTH - BAR_LIFT - GRAPH_TOP_MARGIN))];
        [colors[i] setStroke];
        [bar stroke];
        
        UIColor *negativeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:dataPoint / [mins[i] floatValue]];

        NSAttributedString *label = [[NSAttributedString alloc] initWithString:labels[i] attributes:@{NSBackgroundColorAttributeName : negativeColor}];

        CGRect rect = CGRectMake(point.x + AXIS_LEFT_MARGIN + (BAR_SEPARATOR + barWidth) * i + barWidth / 2 - label.size.width / 2, point.y - AXIS_WIDTH - BAR_LIFT - (MAX(dataPoint, 0) / [maxes[i] floatValue]) * (height - AXIS_WIDTH - BAR_LIFT - GRAPH_TOP_MARGIN) - label.size.width / 2 - 15, label.size.width, label.size.height);
        CGContextAddRect(UIGraphicsGetCurrentContext(), rect);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, CGRectGetMidX(rect), CGRectGetMidY(rect));
        transform = CGAffineTransformRotate(transform, - M_PI / 2);
        transform = CGAffineTransformTranslate(transform, -CGRectGetMidX(rect), -CGRectGetMidY(rect));
        CGContextConcatCTM(context, transform);
        CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, rect);
        [label drawInRect:rect];
        CGContextRestoreGState(context);
    }
}

+ (NSAttributedString *)cheesecakeAttributedStringWithCategoryHeaderStyle:(NSDictionary *)categoryHeaderStyle dataNumberStyle:(NSDictionary *)dataNumberStyle rankNumberStyle:(NSDictionary *)rankNumberStyle bodyStyle:(NSDictionary *)bodyStyle team:(NSDictionary *)team
{
    NSMutableAttributedString *cheesecakeCategoryText = [[NSMutableAttributedString alloc] initWithString:@"CC:\n" attributes:categoryHeaderStyle];
        
    NSString *mechanismMount = [[PDFRenderer mountConvert:[team[@"canMountMechanism"] boolValue]] stringByAppendingString:@"\n"];
    [cheesecakeCategoryText appendAttributedString:[[NSAttributedString alloc] initWithString:mechanismMount attributes:rankNumberStyle]];
    
    NSString *willingToMount = [[PDFRenderer willingConvert:[team[@"willingToMount"] boolValue]] stringByAppendingString:@"\n"];
    [cheesecakeCategoryText appendAttributedString:[[NSAttributedString alloc] initWithString:willingToMount attributes:rankNumberStyle]];

    [cheesecakeCategoryText appendAttributedString:[PDFRenderer attributedRankRowForKey:@"easeOfMounting"
                                                                              inTeam:team
                                                                           withTitle:@"Mount Ease"
                                                                     dataNumberStyle:dataNumberStyle
                                                                     rankNumberStyle:rankNumberStyle
                                                                           bodyStyle:bodyStyle
                                                                           asPercent:NO
                                                                               forColor:[self colorFromKey:@"easeOfMounting"]]];
    
    NSString *programmingLanguage = team[@"programmingLanguage"];
    [cheesecakeCategoryText appendAttributedString:[[NSAttributedString alloc] initWithString:@"Prog. Lang.: " attributes:bodyStyle]];

    [cheesecakeCategoryText appendAttributedString:[[NSAttributedString alloc] initWithString:programmingLanguage attributes:rankNumberStyle]];
    
    return cheesecakeCategoryText;
}

+ (NSArray *)allPropertyNamesForClass:(Class)cls
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

+ (NSInteger)rankOfTeam:(NSDictionary *)team byKey:(NSString *)key {
    NSInteger rank = 1;
    for (NSMutableDictionary *teamDict in [teamsDict allValues]) {
        if ([teamDict[key] floatValue] > [team[key] floatValue]) {
            rank++;
        }
    }
    
    return rank;
}

+ (NSString *)mountConvert:(BOOL)mountStatus {
    return mountStatus ? @"Can Mount" : @"Cannot Mount";
}

+ (NSString *)willingConvert:(BOOL)willingStatus {
    return willingStatus ? @"Willing" : @"Not Willing";
}

@end
