//
//  AppDelegate.m
//  WebTools
//
//  Created by Alex Seifert on 05.06.14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    _statusImage = [NSImage imageNamed:@"menu-icon"];
    _statusHighlightImage = [NSImage imageNamed:@"menu-icon-alt"];
    
    [_statusItem setImage:_statusImage];
    [_statusItem setAlternateImage:_statusHighlightImage];
    
    [_statusItem setMenu:_statusMenu];
    [_statusItem setToolTip:@"WebTools"];
    [_statusItem setHighlightMode:YES];
}

- (IBAction)jpegOptim:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"Jpegoptim" ofType:@"sh"];
    [self executeScript:pathToScript];
}

- (IBAction)optiPng:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"Optipng" ofType:@"sh"];
    [self executeScript:pathToScript];
}

- (IBAction)startWebDev:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"start-webdev" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (IBAction)stopWebDev:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"stop-webdev" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (void)executeScript:(NSString*)pathToScript {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [_logWindow makeKeyAndOrderFront:self];
    
    NSPipe *pipe = [NSPipe pipe];
    NSTask *script = [[NSTask alloc] init];
    
    [script setLaunchPath:@"/bin/sh"];
    [script setArguments: [NSArray arrayWithObjects: pathToScript, nil]];
    [script setStandardOutput: pipe];
    [script setStandardError: pipe];
    [script launch];
    [script waitUntilExit];
    
    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [_logView insertIntoLog:output];
}

- (void)executeSecureScript:(NSString*)pathToScript {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [_logWindow makeKeyAndOrderFront:self];
    
    NSString * output = nil;
    NSString * processErrorDescription = nil;
    BOOL success = [self runProcessAsAdministrator:@"/bin/sh"
                                     withArguments:[NSArray arrayWithObjects:pathToScript, nil]
                                            output:&output
                                  errorDescription:&processErrorDescription];
    
    [_logView insertIntoLog:output];
}

- (BOOL)runProcessAsAdministrator:(NSString*)scriptPath
                     withArguments:(NSArray *)arguments
                            output:(NSString **)output
                  errorDescription:(NSString **)errorDescription {
    
    NSString *allArgs = [arguments componentsJoinedByString:@" "];
    NSString *fullScript = [NSString stringWithFormat:@"%@ %@", scriptPath, allArgs];
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    if (!eventResult) {
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber]) {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        if (*errorDescription == nil) {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    }
    else {
        *output = [eventResult stringValue];
        
        return YES;
    }
}

@end