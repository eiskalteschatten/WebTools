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

@end
