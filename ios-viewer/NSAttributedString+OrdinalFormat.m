//
//  NSString+OrdinalFormat.m
//  scout-viewer-2014-ios
//
//  Created by Citrus Circuits on 4/16/14.
//  Copyright (c) 2014 Citrus Circuits. All rights reserved.
//

#import "NSAttributedString+OrdinalFormat.h"
#import <CoreText/CTStringAttributes.h>



@implementation NSAttributedString (OrdinalFormat)

+ (NSAttributedString *) attributedStringWithOrdinalInteger:(NSInteger)num andBaseAttributes:(NSDictionary *)attributes
{
    NSString *ending;
    
    int ones = num % 10;
    int tens = floor(num / 10);
    tens = tens % 10;
    if(tens == 1) {
        ending = @"th";
    } else {
        switch (ones) {
            case 1:
                ending = @"st";
                break;
            case 2:
                ending = @"nd";
                break;
            case 3:
                ending = @"rd";
                break;
            default:
                ending = @"th";
                break;
        }
    }
    
    UIFont *baseFont = attributes[NSFontAttributeName];
    UIFont *superFont = [UIFont fontWithName:baseFont.fontName size:0.7*baseFont.pointSize];
    NSMutableDictionary *superscript = [attributes mutableCopy];
    superscript[(NSString *)kCTSuperscriptAttributeName] = @(YES);
    superscript[NSFontAttributeName] = superFont;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)num] attributes:attributes];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:ending attributes:superscript]];
    return text;
}

@end
