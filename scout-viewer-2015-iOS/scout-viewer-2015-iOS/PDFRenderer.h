//
//  PDFRenderer.h
//  scout-viewer-2014-ios
//
//  Created by Donald Pinckney on 3/24/14.
//  Copyright (c) 2014 Citrus Circuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFRenderer : NSObject

+ (void) renderPDFToPath:(NSString *)filePath withProgressCallback:(void(^)(float progress, BOOL done))progressCallback;

@end
