//
//  ViewController.m
//  iOSPushUtility
//
//  Created by Steven on 15/6/2.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "ViewController.h"
#import "NSTextField+CopyPast.h"
#import "ScriptHelper.h"
#import "AMR_ANSIEscapeHelper.h"

#define SAVE_STRING(str)   (((str)&&![(str) isKindOfClass:NSNull.class])?[NSString stringWithFormat:@"%@",(str)]:@"")

@interface ViewController()

@property (weak) IBOutlet NSTextField *cerPathField;
@property (weak) IBOutlet NSTextField *tokenField;
@property (weak) IBOutlet NSTextField *soundField;
@property (weak) IBOutlet NSTextField *msgField;
@property (weak) IBOutlet NSButton *switchSoundButton;
@property (weak) IBOutlet NSButton *installButton;
@property (weak) IBOutlet NSButton *pushButton;
@property (weak) IBOutlet NSProgressIndicator *progressInstall;
@property (weak) IBOutlet NSProgressIndicator *progressPush;
@property (weak) IBOutlet NSTextField *outputLab;

@property (nonatomic, assign) BOOL isPushing;
@property (nonatomic, assign) BOOL isInstalling;

- (IBAction)onBrowseTouch:(id)sender;
- (IBAction)onPushTouch:(id)sender;
- (IBAction)onInstallTouch:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadInput];
    [self updateButtons];
    self.outputLab.stringValue = @"";
}

- (void)updateButtons
{
    BOOL hasHouston = [ScriptHelper hasHouston];
    
    self.outputLab.hidden = !hasHouston;
    
    // Install Button
    self.installButton.hidden = hasHouston;
    self.installButton.enabled = !self.isInstalling;
    dispatch_async(dispatch_get_main_queue(), ^{
       self.progressInstall.hidden = !self.isInstalling;
    });
    if (self.isInstalling)
    {
        [self.progressInstall startAnimation:self];
    }
    else
    {
        [self.progressInstall stopAnimation:self];
    }
    
    // Push Button
    self.pushButton.enabled = hasHouston && !self.isPushing;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressPush.hidden = !self.isPushing;
    });
    if (self.isPushing)
    {
        [self.progressPush startAnimation:self];
    }
    else
    {
        [self.progressPush stopAnimation:self];
    }

}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
    [self.msgField becomeFirstResponder];
}

- (IBAction)onBrowseTouch:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:TRUE];
    [openDlg setCanChooseDirectories:FALSE];
    [openDlg setAllowsMultipleSelection:FALSE];
    [openDlg setAllowsOtherFileTypes:FALSE];
    [openDlg setAllowedFileTypes:@[@"pem", @"PEM"]];
    
    if ([openDlg runModal] == NSModalResponseOK)
    {
        NSString* fileNameOpened = [[[openDlg URLs] objectAtIndex:0] path];
        [self.cerPathField setStringValue:fileNameOpened];
    }
}
- (IBAction)onPushTouch:(id)sender
{
    // cer
    if (self.cerPathField.stringValue.length == 0)
    {
        [self.cerPathField becomeFirstResponder];
        return;
    }
    // token
    if (self.tokenField.stringValue.length == 0)
    {
        [self.tokenField becomeFirstResponder];
        return;
    }
    // msg
    if (self.msgField.stringValue.length == 0)
    {
        [self.msgField becomeFirstResponder];
        return;
    }
    
    [self saveInput];
    
    NSArray * temp = @[@"push",
                       self.tokenField.stringValue,
                       @"-c",
                       self.cerPathField.stringValue,
                       @"-m",
                       self.msgField.stringValue];
    
    NSString * soundName = @"sosumi.aiff";
    NSMutableArray * args = [NSMutableArray arrayWithArray:temp];
    if (self.switchSoundButton.state)
    {
        if (self.soundField.stringValue.length)
        {
            soundName = self.soundField.stringValue;
        }
        [args addObject:@"-s"];
        [args addObject:soundName];
    }
    
    [self runAPNCmdWithArgs:args];
}

- (IBAction)onInstallTouch:(id)sender
{
    self.isInstalling = YES;
    [self updateButtons];
    
    // Install Houston
    [ScriptHelper runProcessAsAdministrator:[ScriptHelper getInstallShellPath]
                              withArguments:nil
                                    handler:^(NSString *output, BOOL success)
    {
        self.isInstalling = NO;
        [self updateButtons];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleUpdateButtons" object:nil];
        NSLog(@"%@", output);
    }];
}

// 执行push命令
- (void)runAPNCmdWithArgs:(NSArray *)args
{
    self.isPushing = YES;
    self.outputLab.stringValue = @"Pushing message...";
    [self updateButtons];
    
    [ScriptHelper runCommand:[ScriptHelper getAPNPath] arguments:args handler:^(NSString *output, BOOL success) {
        self.isPushing = NO;
        [self updateButtons];
        
        AMR_ANSIEscapeHelper *ansiEscapeHelper =
        [[AMR_ANSIEscapeHelper alloc] init];
        
        // display an ANSI-escaped string in a text view:
        NSString *ansiEscapedStr = output;
        NSAttributedString *attrStr = [ansiEscapeHelper attributedStringWithANSIEscapedString:ansiEscapedStr];
        self.outputLab.attributedStringValue = attrStr;
    }];
}


// 保存输入
- (void)saveInput
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:SAVE_STRING(self.cerPathField.stringValue) forKey:@"cerPathField"];
    [defaults setObject:SAVE_STRING(self.tokenField.stringValue) forKey:@"tokenField"];
    [defaults setObject:SAVE_STRING(self.soundField.stringValue) forKey:@"soundField"];
    [defaults setObject:@(self.switchSoundButton.state) forKey:@"switchSoundButton"];
    [defaults setObject:SAVE_STRING(self.msgField.stringValue) forKey:@"msgField"];
    [defaults synchronize];
}

// 加载输入
- (void)loadInput
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.cerPathField.stringValue = SAVE_STRING([defaults objectForKey:@"cerPathField"]);
    self.tokenField.stringValue = SAVE_STRING([defaults objectForKey:@"tokenField"]);
    self.soundField.stringValue = SAVE_STRING([defaults objectForKey:@"soundField"]);
    self.msgField.stringValue = SAVE_STRING([defaults objectForKey:@"msgField"]);
    
    NSNumber * state = [defaults objectForKey:@"switchSoundButton"];
    if (state)
    {
        self.switchSoundButton.state = [state integerValue];
    }
}

@end
