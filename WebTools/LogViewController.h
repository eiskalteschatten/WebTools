//
//  LogViewController.h
//  WebTools
//
//  Created by Alex Seifert on 05.06.14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LogViewController : NSViewController

@property (assign) IBOutlet NSTextView *logView;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *floatAboveWindows;

@property (assign) NSUserDefaults *standardDefaults;

- (void)insertIntoLog:(NSString*)string;
- (IBAction)setFloatOption:(id)sender;

@end
