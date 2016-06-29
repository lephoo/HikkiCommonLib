//
//  HikkiCommonLib.m
//  HikkiCommonLib
//
//  Created by jiangtao on 15/10/27.
//  Copyright © 2015年 Hikki. All rights reserved.
//

#import "HikkiCommonLib.h"
#import <UIKit/UIDevice.h>
#import <UIKit/UILocalNotification.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIUserNotificationSettings.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIViewController.h>

@implementation HikkiCommonLib

-(void)loadInfoPlist{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"Info.plist" ofType:nil];
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    //[self performSelectorOnMainThread:nil withObject:nil waitUntilDone:NO];
    //
    //NSNumber* style = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Unity_LoadingActivityIndicatorStyle"];
}

-(void)loadJsonFile:(NSString*)filePath{
    NSString* path = [[NSBundle mainBundle]pathForResource:filePath ofType:nil];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSArray* jsonArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //
}

-(NSString*)getJsonFromDict:(NSDictionary*)dict{
   // NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[MPVarible getInstance].Token, @"token", [MPVarible getInstance].gID, @"gid", nil];
    NSString* json = nil;
    if([NSJSONSerialization isValidJSONObject:dict]){
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@" jsonData:%@", json);
    }
    return json;
}

-(void)predicateHandler{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id = %d", 1];
    NSArray* arr;
    NSArray* newArr = [arr filteredArrayUsingPredicate:predicate];
}

-(void)checkIOSVersion:(UIDevice*) currentDevice{
    if([[currentDevice systemVersion]floatValue] >= 7.0){
        
    }
}

//iOS 6+
-(NSString*)getUUID{
    return [[NSUUID UUID]UUIDString];
}

-(NSString*)getIDFAIdentifier{
    //[[[ASIdentifierManager sharedManager]advertisingIdentifer]UUIDString];
    return nil;
}

-(NSString*)getVenderIdentifier{
    return [[[UIDevice currentDevice]identifierForVendor]UUIDString];
}

-(void)redirectNSLogToDocumentFolder:(NSString*) docName{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSAllDomainsMask, YES);
    NSString* documentDir = [paths objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@", docName];
    NSString* logFilePath = [documentDir stringByAppendingPathComponent:fileName];
    //
    NSFileManager* defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    //
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stderr);
}

-(void)registerAPNS:(UIApplication*)application{
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notiSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:notiSettings];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
}


-(void)scheduleLocalNotification:(NSString*)msg weekDay:(NSInteger)weekDay hours:(NSInteger)hour mins:(NSInteger)min{
    
    //世界BOSS戰5分鐘後開始，想要獲得豐富獎勵，快來活動挑戰我！
    //世界BOSS再過5分鐘出現，騎士們準備好為榮譽而戰嗎？
    //騎士團領地戰即將開始，請騎士團的成員們快進入戰場準備吧~
    NSCalendar* cal = [NSCalendar autoupdatingCurrentCalendar];
    //NSDate* weekDate = [NSDate date];
    //NSDateComponents* weekComps = [[[NSDateComponents alloc]init] autorelease];
    //NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    //weekComps = [cal components:unitFlags fromDate:weekDate];
    
    //NSInteger dwd = [weekComps weekday];
    //if(dwd != weekDay && weekDay > 0)
    //return;
    NSDateComponents* dateComps = [cal components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:[NSDate date]];
    if(weekDay > 0){
        [dateComps setWeekday:weekDay];
    }
    [dateComps setHour:hour];
    [dateComps setMinute:min];
    NSDate* fDate = [cal dateFromComponents:dateComps];
    //[NSDate dateWithTimeInterval:(NSTimeInterval) sinceDate:fDate];
    
    //NSDate *date = [NSDate dateWithTimeIntervalSinceNow:20]; //chuagjian一个本地推送]
    UILocalNotification *noti = [[[UILocalNotification alloc] init]autorelease];
    if (noti) { //设置推送时间
        noti.fireDate = fDate; //设置时区
        noti.timeZone = [NSTimeZone defaultTimeZone]; //设置重复间隔
        if(weekDay > 0)
            noti.repeatInterval = NSWeekCalendarUnit;
        else
            noti.repeatInterval = NSDayCalendarUnit; //推送声音
        noti.soundName =UILocalNotificationDefaultSoundName; //内容
        noti.alertBody = msg; //显示在icon上的红色圈中的数子
        noti.applicationIconBadgeNumber =1; //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        noti.userInfo = infoDic; //添加推送到uiapplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:noti];
    }
}

-(void)cleanLocalNotification{
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
    app.applicationIconBadgeNumber = 0;
}

-(void)describeDictionary:(NSDictionary*) dict{
    NSArray* keys;
    NSInteger i, count;
    id key, value;
    
    keys = [dict allKeys];
    count = [keys count];
    for (i=0; i<count; i++) {
        key = [keys objectAtIndex:i];
        value = [dict objectForKey:key];
        NSLog(@"key:%@ for value: %@", key, value);
    }
}


void hlog(NSString* log, ...){
    va_list args;
    va_start(args, log);
    NSLogv(log, args);
    va_end(args);
}

-(UIViewController*)getTopVC{
    UIViewController* topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topVc.presentedViewController) {
        topVc = topVc.presentedViewController;
    }
    return topVc;
}


static HikkiCommonLib* m_shared;
+(HikkiCommonLib*) SharedIns{
    @synchronized(m_shared) {
        if(m_shared == nil){
            m_shared = [[HikkiCommonLib alloc]init];
        }
        return m_shared;
    }
}
@end
