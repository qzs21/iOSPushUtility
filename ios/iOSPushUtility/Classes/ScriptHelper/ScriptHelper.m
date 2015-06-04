//
//  ScriptHelper.m
//  iOSPushUtility
//
//  Created by Steven on 15/6/4.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "ScriptHelper.h"

@implementation ScriptHelper

+ (BOOL)runProcessAsAdministrator:(NSString*)scriptPath
                    withArguments:(NSArray *)arguments
                           output:(NSString **)output
                 errorDescription:(NSString **)errorDescription
{
    NSString * allArgs = [arguments componentsJoinedByString:@" "];
    NSString * fullScript = nil;
    if (arguments.count && allArgs.length)
    {
        fullScript = [NSString stringWithFormat:@"'%@' %@", scriptPath, allArgs];
    }
    else
    {
        fullScript = scriptPath;
    }
    
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
    // Check errorInfo
    if (! eventResult)
    {
        // Describe common errors
        *errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
        {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
        }
        
        // Set error message from provided message
        if (*errorDescription == nil)
        {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
        }
        
        return NO;
    }
    else
    {
        // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
    }
}

+ (void)runProcessAsAdministrator:(NSString*)scriptPath
                     withArguments:(NSArray *)arguments
                           handler:(ScriptHelperHandler)handler
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^
    {
        NSString * output = nil;
        NSString * processErrorDescription = nil;
        BOOL success = [self runProcessAsAdministrator:scriptPath
                                         withArguments:arguments
                                                output:&output
                                      errorDescription:&processErrorDescription];
        dispatch_sync(dispatch_get_main_queue(), ^
        {
            if (handler)
            {
                handler( success ? output : processErrorDescription, success);
            }
        });
    });
}

#pragma mark -
+ (NSString *)getInstallShellPath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"install.sh"];
}
+ (NSString *)getUninstallShellPath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"uninstall.sh"];
}
+ (BOOL)hasHouston
{
    NSFileManager * manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:CMD_APN_PATH isDirectory:NO];
}


@end
