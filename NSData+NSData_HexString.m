//
//  NSData+NSData_HexString.m
//  ios-viewer
//
//  Created by Carter Luck on 2/19/17.
//  Copyright © 2017 brytonmoeller. All rights reserved.
//

#import "NSData+NSData_HexString.h"

@implementation NSData (NSData_HexString)
- (NSString *) hexString
{
    NSUInteger bytesCount = self.length;
    if (bytesCount) {
        const char *hexChars = "0123456789ABCDEF";
        const unsigned char *dataBuffer = self.bytes;
        char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
        char *s = chars;
        for (unsigned i = 0; i < bytesCount; ++i) {
            *s++ = hexChars[((*dataBuffer & 0xF0) >> 4)];
            *s++ = hexChars[(*dataBuffer & 0x0F)];
            dataBuffer++;
        }
        *s = '\0';
        NSString *hexString = [NSString stringWithUTF8String:chars];
        free(chars);
        return hexString;
    }
    return @"";
}
@end
