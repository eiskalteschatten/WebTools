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
    [self executeScript:pathToScript];
}

- (IBAction)stopWebDev:(id)sender {
    NSString *pathToScript = [[NSBundle mainBundle] pathForResource:@"stop-webdev" ofType:@"sh"];
    [self executeScript:pathToScript];
}

- (void)executeScript:(NSString*)pathToScript {
    [_logWindow makeKeyAndOrderFront:self];
    
    NSPipe *pipe = [NSPipe pipe];
    NSTask *script = [[NSTask alloc] init];
    
    [script setLaunchPath:@"/bin/sh"];
    [script setArguments: [NSArray arrayWithObjects: pathToScript, nil]];
    [script setStandardOutput: pipe];
    [script setStandardError: pipe];
    [script launch];
    
    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [_logView insertIntoLog:output];
}

@end
