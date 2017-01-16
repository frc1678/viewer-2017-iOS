//
//  NSString+OrdinalFormat.h
//  scout-viewer-2014-ios
//
//  Created by Citrus Circuits on 4/16/14.
//  Copyright (c) 2014 Citrus Circuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (OrdinalFormat)

+ (NSAttributedString *) attributedStringWithOrdinalInteger:(NSInteger)num andBaseAttributes:(NSDictionary *)attributes;

@end
