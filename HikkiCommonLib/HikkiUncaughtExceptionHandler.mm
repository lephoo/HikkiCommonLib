//
//  HikkiUncaughtExceptionHandler.m
//  HikkiCommonLib
//
//  Created by jiangtao on 2016/6/3.
//  Copyright © 2016年 Hikki. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HikkiUncaughtExceptionHandler.h"

static NSString* POST_URL = @"http://120.132.75.251:8088/index.php/Report_Client_err";

NSString* getAppInfo(){
    NSString* appInfo = [NSString stringWithFormat:@"App:%@ %@ (%@)\n Device: %@\n OSVersion:%@ %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    
    NSLog(@"Crash AppInfo:%@", appInfo);
    return appInfo;
}

NSString* HTTPBodyWithParameters(NSDictionary* parameters){
    NSMutableArray* parametersArr = [[NSMutableArray alloc]init];
    
    for(NSString* key in [parameters allKeys]){
        id value = [parameters objectForKey:key];
        if([value isKindOfClass:[NSString class]]){
            [parametersArr addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
    }
    return [parametersArr componentsJoinedByString:@"&"];
}

void postErrorLog(NSString* log){
    NSURL* url = [[NSURL alloc]initWithString:POST_URL];
    NSTimeInterval interval = 60.0;
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1013620", @"ver",
                          @"accountName", @"account",
                          @"err", @"error",
                          log, @"stacktrack",nil];
    
    
    NSString* bodyStr = HTTPBodyWithParameters(dict);
    bodyStr = [bodyStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData* bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* urlReq = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:interval];
    NSLog(@"urlreq:%@", [[urlReq URL]absoluteString]);
    [urlReq setHTTPMethod:@"POST"];
    [urlReq setHTTPBody:bodyData];
    [urlReq setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-type"];
    //NSLog(@"urlreq:%@", [[urlReq URL]absoluteString]);
    //NSData* rtnData = [NSURLConnection sendSynchronousRequest:urlReq returningResponse:nil error:nil];
    //NSOperationQueue* queue = [[NSOperationQueue alloc]init];
    /*[NSURLConnection sendAsynchronousRequest:urlReq queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
     //
     NSLog(@"Post res:%@", response.URL);
     //NSLog("Post response:%@", [response v]);
     NSString* dataStr =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"Post data:%@", dataStr);
     NSLog(@"Post error:%@", [connectionError localizedDescription]);
     
     }];*/
    NSData* resData = nil;
    NSURLResponse* rep = nil;
    NSError* err = nil;
    try {
        
        resData = [NSURLConnection sendSynchronousRequest:urlReq returningResponse:&rep error:&err];
        
    } catch (NSException* ex) {
        
        NSLog(@"PostErrorLog ex:%@", [ex callStackSymbols]);
    }
    NSString* dataStr =[[NSString alloc]initWithData:resData encoding:NSUTF8StringEncoding];
    NSLog(@"Post result:%@", dataStr);
    NSLog(@"Post error:%@", [err localizedDescription]);
    NSLog(@"Post res:%@", rep.URL);
}

void exceptionHandler(NSException* exception){
    NSLog(@"Exception throw: %@", exception);
    NSLog(@"Stack Trace:\r\n%@", [exception callStackSymbols]);
    NSLog(@"Stack address:\r\n%@", [exception callStackReturnAddresses]);
    NSString* stackLog = [[NSString alloc]initWithFormat:@"info:%@ \n %@", getAppInfo(), [exception callStackSymbols]];
    
    try {
        postErrorLog(stackLog);
    } catch (NSException* ex) {
    }
    NSLog(@"exceptionHandler PostErrorLog:%@", stackLog);
}


void stacktrace(int sig, siginfo_t* info, void* context){
    NSLog(@"Stack Trace:\r\n%@", @"");
}

void SignalHandler(int signal){
    NSLog(@"SignalHandler%d", signal);
    NSString* log = [NSString stringWithFormat:@"SignalHandler %d", signal];
    try {
        postErrorLog(log);
    } catch (NSException* ex) {
        
    }
    NSLog(@"SignalHandler PostErrorLog:%@", log);
}

@implementation HikkiUncaughtExceptionHandler

+(void)InstallUncaughtExceptionHandler{
    
    NSSetUncaughtExceptionHandler(&exceptionHandler);
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}
@end
