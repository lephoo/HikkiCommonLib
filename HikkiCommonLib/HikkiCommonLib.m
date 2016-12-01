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
#import "IPAddress.h"
#import "sys/utsname.h"

#include <sys/sysctl.h>
#include <mach/mach.h>

//
#define ObjectKeyMake(Name) (@"com.hikki."#Name)

@implementation HikkiCommonLib

-(void)loadInfoPlist{
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"Info.plist" ofType:nil];
    NSArray* array = [NSArray arrayWithContentsOfFile:path];
    //[self performSelectorOnMainThread:nil withObject:nil waitUntilDone:NO];
    //
    //NSNumber* style = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Unity_LoadingActivityIndicatorStyle"];
}

-(id)getInfoPlistProperty:(NSString*)propertyName{
    NSObject* obj = [[[NSBundle mainBundle]infoDictionary] valueForKey:propertyName];
    
    return obj;
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
/*NSDictionary* uploadData = @{
                             @"productId":cardId,
                             @"productName":[extData objectForKey:@"product"],
                             @"productPrice":[data objectForKey:@"needMoney"],
                             @"productCount":@"1",
                             @"productDesc":[extData objectForKey:@"desc"],
                             @"coinName":@"钻石",
                             @"coinRate":@"10",
                             @"roleId":[data objectForKey:@"roleId"],
                             @"roleName":[data objectForKey:@"roleName"],
                             @"roleGrade":[data objectForKey:@"level"],
                             @"roleBalance":[data objectForKey:@"coin"],
                             @"vipLevel":[data objectForKey:@"vipLevel"],
                             @"partyname":[data objectForKey:@"partyName"],
                             @"zoneId":[data objectForKey:@"groupId"],
                             @"zoneName":zoneName,
                             @"gameReceipts":receipt
                             };*/

-(NSDictionary*)getDictByJson:(NSString*)json{
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err != nil){
        //NSLog(@"%@", [err localizedDescription]);
    }
    return data;
}

-(NSString*)getJsonByDict:(NSDictionary*)dict{
    NSError* jsonErr = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&jsonErr];
    if(jsonErr != nil && jsonErr.localizedDescription != nil){
        NSLog(@"getJsonByDict err:%@", jsonErr.localizedDescription);
    }
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
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

-(bool)isAdTrackingEnable{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    if(NSClassFromString(@"ASIdentifierManager")){
        return [ASIdentifierManager sharedManager].advertisingTrackingEnabled;
    }
#endif
    return false;
}

-(NSString*)getIDFAIdentifier{
    [[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
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

+(NSString*)getSysInfoByName:(char*)typeSpecifier{
    
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char* answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString* res = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    free(answer);
    return res;
}

+(NSString*)getPlatform{
    
    return [self getSysInfoByName:"hw.machine"];
}

+(NSUInteger)getSysInfo:(uint)typeSpecifier{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger)results;
}



+(NSUInteger)getIndicatedInfo{
    //frequency
    [self getSysInfo:HW_CPU_FREQ];
    //bus freq
    [self getSysInfo:HW_BUS_FREQ];
    //total mem
    [self getSysInfo:HW_PHYSMEM];
    //user mem
    [self getSysInfo:HW_USERMEM];
    //sock buf size
    [self getSysInfo:KIPC_MAXSOCKBUF];
    
    return 0;
}

+(NSUInteger)getAvailableMem{
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCnt = HOST_VM_INFO_COUNT;
    kern_return_t kernRet = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCnt);
    if(kernRet != KERN_SUCCESS){
        return NSNotFound;
    }
    NSLog(@"free: %lu\nactive: %lu\ninactive: %lu\nwire: %lu\nzero fill: %lu\nreactivations: %lu\npageins: %lu\npageouts: %lu\nfaults: %u\ncow_faults: %u\nlookups: %u\nhits: %u", vmStats.free_count * vm_page_size, vmStats.active_count * vm_page_size, vmStats.inactive_count * vm_page_size, vmStats.wire_count * vm_page_size, vmStats.zero_fill_count * vm_page_size, vmStats.reactivations * vm_page_size, vmStats.pageins * vm_page_size, vmStats.pageouts * vm_page_size, vmStats.faults, vmStats.cow_faults, vmStats.lookups, vmStats.hits ); 
    return (vm_page_size * vmStats.free_count);//
}

+(NSString*)getSystemLanguage{
    NSArray* arr = [NSLocale preferredLanguages];
    NSString* curLang = [arr objectAtIndex:0];
    return curLang;
}

#pragma mark - Device Info
-(NSString*)getIPAddress{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

- (NSString*)deviceVersion
{
    // 需要加入#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

/*
 */
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
