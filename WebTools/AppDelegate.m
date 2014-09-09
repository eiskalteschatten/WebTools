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
    NSString *pathToExec = [[NSBundle mainBundle] pathForResource:@"jpegoptim" ofType:nil];
    NSString *imagePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"imageCompressionPath"];
    
    [self executeScript:pathToScript withArguments:[NSArray arrayWithObjects:pathToScript, imagePath, pathToExec, nil]];
}

- (IBAction)optiPng:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"Optipng" ofType:@"sh"];
    NSString *pathToExec = [[NSBundle mainBundle] pathForResource:@"optipng" ofType:nil];
    NSString *imagePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"imageCompressionPath"];
    
    [self executeScript:pathToScript withArguments:[NSArray arrayWithObjects:pathToScript, imagePath, pathToExec, nil]];
}

- (IBAction)startWebDev:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"start-webdev" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (IBAction)stopWebDev:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"stop-webdev" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (IBAction)startApache:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"start-apache" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (IBAction)stopApache:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"stop-apache" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (IBAction)startMysql:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"start-mysql" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (IBAction)stopMysql:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"stop-mysql" ofType:@"sh"];
    [self executeSecureScript:pathToScript];
}

- (IBAction)openColorPicker:(id)sender {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [[NSApplication sharedApplication] orderFrontColorPanel:nil];
}

- (IBAction)compressJavascript:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
	
	[panel setCanChooseDirectories: NO];
	[panel setCanChooseFiles: YES];
	[panel setAllowsMultipleSelection: NO];
	
	if ([panel runModal] == NSOKButton) {
        NSString *jsPath = [[panel URL] path];
        
        NSMutableArray *pathParts = [jsPath componentsSeparatedByString:@"/"];
        NSUInteger lastPart = [pathParts count] - 1;
        NSString *oldName = [jsPath lastPathComponent];
        NSString *newName = [oldName stringByReplacingOccurrencesOfString:@".js" withString:@"-compiled.js"];
        [pathParts replaceObjectAtIndex:lastPart withObject:newName];
        NSString *compiledPath = [pathParts componentsJoinedByString:@"/"];

        NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"closure-compiler" ofType:@"sh"];
        NSString *pathToJar = [[NSBundle mainBundle] pathForResource:@"google-closure-compiler" ofType:@"jar"];
        [self executeScript:pathToScript withArguments:[NSArray arrayWithObjects:pathToScript, pathToJar, jsPath, compiledPath, nil]];
	}
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

- (void)executeScript:(NSString*)pathToScript withArguments:(NSArray*)arguments {
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [_logWindow makeKeyAndOrderFront:self];
    
    NSPipe *pipe = [NSPipe pipe];
    NSTask *script = [[NSTask alloc] init];
    
    [script setLaunchPath:@"/bin/sh"];
    [script setArguments: arguments];
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
    
    if (!success) {
        [_logView insertIntoLog:processErrorDescription];
    }
    else {
        [_logView insertIntoLog:output];
    }
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
                *errorDescription = @"An administrator password is required to do this.";
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