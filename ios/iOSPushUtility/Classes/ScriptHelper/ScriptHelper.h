//
//  ScriptHelper.h
//  iOSPushUtility
//
//  Created by Steven on 15/6/4.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ScriptHelperHandler)(NSString * output, BOOL success);

@interface ScriptHelper : NSObject

+ (NSString *)getInstallShellPath;
+ (NSString *)getUninstallShellPath;
+ (NSString *)getAPNPath;
+ (BOOL)hasHouston;

+ (void)runCommand:(NSString *)cmd arguments:(NSArray *)argument handler:(ScriptHelperHandler)handler;

+ (void)runProcessAsAdministrator:(NSString*)scriptPath
                    withArguments:(NSArray *)arguments
                          handler:(ScriptHelperHandler)handler;

@end
