//
//  AppDelegate.m
//  iOSPushUtility
//
//  Created by Steven on 15/6/2.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "AppDelegate.h"
#import "ScriptHelper.h"

@interface AppDelegate ()

- (IBAction)onInstallHoustonTouch:(id)sender;
@property (weak) IBOutlet NSMenuItem *installHoustonMenuItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdateButtons)
                                                 name:@"handleUpdateButtons"
                                               object:nil];
    [self handleUpdateButtons];
}

- (void)handleUpdateButtons
{
    BOOL hasHouston = [ScriptHelper hasHouston];
    self.installHoustonMenuItem.title = hasHouston ? @"Uninstall Houston" : @"Install Houston";
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    // Insert code here to tear down your application
}

- (IBAction)onInstallHoustonTouch:(id)sender
{
    BOOL hasHouston = [ScriptHelper hasHouston];
    [ScriptHelper runProcessAsAdministrator:hasHouston?
     [ScriptHelper getUninstallShellPath]:
     [ScriptHelper getInstallShellPath]
                              withArguments:nil
                                    handler:^(NSString *output, BOOL success)
     {
         [self handleUpdateButtons];
         NSLog(@"%@", output);
     }];
}

@end
