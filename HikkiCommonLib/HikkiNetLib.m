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
    NSLog(@"Scheme:%@", [url scheme]);//http
    NSLog(@"name:%@", [url host]);//g.cn
    NSLog(@"path:%@", [url path]);//  /s
    NSLog(@"query:%@", [url query]);//n=google&t=NSURL
}

-(void)parseURLQuery:(NSString*)query{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    for(NSString* param in [query componentsSeparatedByString:@"&"]){
        NSArray* elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2)continue;
        
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
}

-(NSString*)getURLQueryValueByKey:(NSString*)query qkey:(NSString*)qkey{
    for(NSString* param in [query componentsSeparatedByString:@"&"]){
        NSArray* elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2)continue;
        
        if([qkey isEqualToString:[elts firstObject]]){
            return [elts lastObject];
        }
    }
    return nil;
}

@end
