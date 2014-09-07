//
//  LogViewController.m
//  WebTools
//
//  Created by Alex Seifert on 05.06.14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)awakeFromNib {
    [self changeTab:0];
    
    _standardDefaults = [NSUserDefaults standardUserDefaults];
           
    bool floatWindow = [_standardDefaults boolForKey:@"floatAboveWindows"];
    
    if (floatWindow) {
        [_window setLevel: NSPopUpMenuWindowLevel];
        [_floatAboveWindows setState:NSOnState];
    }
    else {
        [_floatAboveWindows setState:NSOffState];
    }
}

- (void)insertIntoLog:(NSString*)string {
    NSInteger length = [[[_logView textStorage] string] length];
    [_logView setSelectedRange:NSMakeRange(length, 0)];
    [_logView insertText:[string stringByAppendingString:@"\n"]];
    
    NSLog(string);
}

- (IBAction)setFloatOption:(id)sender {
    bool floatWindow = [_standardDefaults boolForKey:@"floatAboveWindows"];
    
	if (!floatWindow) {
		[_window setLevel: NSPopUpMenuWindowLevel];
        [_floatAboveWindows setState:NSOnState];
        [_standardDefaults setBool:YES forKey:@"floatAboveWindows"];
	}
	else {
		[_window setLevel: NSNormalWindowLevel];
        [_floatAboveWindows setState:NSOffState];
        [_standardDefaults setBool:NO forKey:@"floatAboveWindows"];
	}
    
    [_standardDefaults synchronize];
}

- (IBAction)openWindow:(id)sender {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [_window makeKeyAndOrderFront:self];
}

- (IBAction)switchTab:(id)sender {
    _clickedSegment = [sender selectedSegment];
    
    [self changeTab:_clickedSegment];
}

- (void)changeTab:(NSInteger)tabIndex {
    [_tabView selectTabViewItemAtIndex:tabIndex];
    [_tabControl setSelectedSegment:tabIndex];
    
//    if ([[[_tabView selectedTabViewItem] label]  isEqual: @"Lyrics"]) {
//        [_window makeFirstResponder:_lyricsView];
//    }
}

- (IBAction)clearLog:(id)sender {
    [_logView setString:@""];
}

@end
