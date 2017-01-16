//
//  UIColor+HexString.h
//  scout-viewer-2014-ios
//
//  Created by Donald Pinckney on 3/31/14.
//  Copyright (c) 2014 Citrus Circuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *) colorFromHexString:(NSString *)hexString;

@end
