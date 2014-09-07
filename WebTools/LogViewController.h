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
@property (assign) IBOutlet NSMenuItem *floatAboveWindows;
@property (assign) IBOutlet NSSegmentedControl *tabControl;
@property (assign) IBOutlet NSTabView *tabView;

@property (assign) NSUserDefaults *standardDefaults;
@property (assign) NSInteger clickedSegment;

- (void)insertIntoLog:(NSString*)string;
- (IBAction)setFloatOption:(id)sender;
- (IBAction)openWindow:(id)sender;
- (IBAction)switchTab:(id)sender;
- (void)changeTab:(NSInteger)tabIndex;
- (IBAction)clearLog:(id)sender;

@end
