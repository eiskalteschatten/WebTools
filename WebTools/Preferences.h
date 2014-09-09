//
//  Preferences.h
//  WebTools
//
//  Created by Alex Seifert on 9/9/14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

@property (assign) IBOutlet NSTextField *pathLabel;

@property (assign) NSUserDefaults *standardDefaults;

- (IBAction)setImageCompressionPath:(id)sender;

@end
