//
//  HikkiUncaughtExceptionHandler.h
//  HikkiCommonLib
//
//  Created by jiangtao on 2016/6/3.
//  Copyright © 2016年 Hikki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <csignal>

@interface HikkiUncaughtExceptionHandler : NSObject

+(void)InstallUncaughtExceptionHandler;
@end
