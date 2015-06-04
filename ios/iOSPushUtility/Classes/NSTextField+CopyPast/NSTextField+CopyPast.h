//
//  NSTextField+CopyPast.h
//  iOSPushUtility
//
//  Created by Steven on 15/6/3.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  当程序的MainMenu中的Edit栏不存在的话，NStextField的快捷键功能会失效，因为需要使用协议重新定义它的快捷键功能。
 *  在你要使用的窗口（或view）添加如下，覆盖原有的TextField的函数。
 */
@interface NSTextField (NSTextField_CopyPast)

@end
