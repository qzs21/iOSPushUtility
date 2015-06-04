//
//  WindowController.m
//  iOSPushUtility
//
//  Created by Steven on 15/6/2.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "WindowController.h"

@interface WindowController() <NSWindowDelegate>

@end

@implementation WindowController

- (BOOL)windowShouldClose:(id)sender;
{
    exit(0);
    return YES;
}

@end
