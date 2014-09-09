//
//  Preferences.m
//  WebTools
//
//  Created by Alex Seifert on 9/9/14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

- (void)awakeFromNib {
    _standardDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *imagePath = [_standardDefaults stringForKey:@"imageCompressionPath"];
    
    if (!imagePath) {
        imagePath = [@"~/Downloads" stringByExpandingTildeInPath];
        [_standardDefaults setObject:imagePath forKey:@"imageCompressionPath"];
    }
    
    [_pathLabel setStringValue:imagePath];
}

- (IBAction)setImageCompressionPath:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
	
	[panel setCanChooseDirectories: YES];
	[panel setCanChooseFiles: NO];
	[panel setAllowsMultipleSelection: NO];
	
	if ([panel runModal] == NSOKButton) {
        NSString *imagePath = [[panel URL] path];
        
        [_standardDefaults setObject:imagePath forKey:@"imageCompressionPath"];
        [_pathLabel setStringValue:imagePath];
	}
}


@end
