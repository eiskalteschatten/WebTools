//
//  AppDelegate.h
//  WebTools
//
//  Created by Alex Seifert on 05.06.14.
//  Copyright (c) 2014 Alex Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *logWindow;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet LogViewController *logView;

@property (retain, nonatomic) NSStatusItem *statusItem;
@property (retain, nonatomic) NSImage *statusImage;
@property (retain, nonatomic) NSImage *statusHighlightImage;

- (IBAction)jpegOptim:(id)sender;
- (IBAction)optiPng:(id)sender;
- (IBAction)startWebDev:(id)sender;
- (IBAction)stopWebDev:(id)sender;
- (IBAction)apacheConfg:(id)sender;
- (IBAction)startApache:(id)sender;
- (IBAction)stopApache:(id)sender;
- (IBAction)startMysql:(id)sender;
- (IBAction)stopMysql:(id)sender;
- (IBAction)openColorPicker:(id)sender;
- (IBAction)compressJavascript:(id)sender;

- (void)executeScript:(NSString*)pathToScript;
- (void)executeScript:(NSString*)pathToScript withArguments:(NSArray*)arguments;
- (void)executeSecureScript:(NSString*)pathToScript;

- (BOOL)runProcessAsAdministrator:(NSString*)scriptPath
                    withArguments:(NSArray *)arguments
                           output:(NSString **)output
                 errorDescription:(NSString **)errorDescription;

@end
