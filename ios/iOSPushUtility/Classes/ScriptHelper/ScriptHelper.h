//
//  ScriptHelper.h
//  iOSPushUtility
//
//  Created by Steven on 15/6/4.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CMD_APN_PATH            @"/usr/bin/apn"

typedef void (^ScriptHelperHandler)(NSString * output, BOOL success);

@interface ScriptHelper : NSObject

+ (NSString *)getInstallShellPath;
+ (NSString *)getUninstallShellPath;
+ (BOOL)hasHouston;

+ (void)runProcessAsAdministrator:(NSString*)scriptPath
                    withArguments:(NSArray *)arguments
                          handler:(ScriptHelperHandler)handler;

@end
