//
//  ColorConverter.h
//  WebTools
//
//  Created by Alex Seifert on 9/7/14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogViewController.h"

@interface ColorConverter : NSObject

@property (assign) IBOutlet NSTextField *rgbText;
@property (assign) IBOutlet NSTextField *hexText;
@property (assign) IBOutlet LogViewController *logView;

- (IBAction)convertColor:(id)sender;
- (NSString*)toHex:(NSInteger)number;
- (NSString*)fromHex:(NSString*)number;

@end
