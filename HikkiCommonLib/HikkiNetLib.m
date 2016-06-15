//
//  HikkiNetLib.m
//  HikkiCommonLib
//
//  Created by jiangtao on 2016/6/14.
//  Copyright © 2016年 Hikki. All rights reserved.
//

#import "HikkiNetLib.h"

@implementation HikkiNetLib

-(void)NSURLtest{
    
    NSURL* url = [NSURL URLWithString:@"http://g.cn/s?n=google&t=NSURL"];
    NSLog(@"Scheme:%@", [url scheme]);
    NSLog(@"name:%@", [url host]);
    
}

@end