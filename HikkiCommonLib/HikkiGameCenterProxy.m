//
//  HikkiGameCenterProxy.m
//  HikkiCommonLib
//
//  Created by jiangtao on 2016/6/3.
//  Copyright © 2016年 Hikki. All rights reserved.
//

#import "HikkiGameCenterProxy.h"

@implementation HikkiGameCenterProxy

#pragma mark - GameCenter

-(BOOL)isGameCenterAvailable{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString* reqSysVer = @"4.1";
    NSString* curSysVer = [[UIDevice currentDevice]systemVersion];
    BOOL osVersionSupported = ([curSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

//
-(void)authenticateLocalUser{
    GKLocalPlayer* player = [GKLocalPlayer localPlayer];
    player.authenticateHandler = ^(UIViewController* viewController, NSError* error){
    //[[GKLocalPlayer localPlayer]authenticateWithCompletionHandler:^(NSError* error){
        NSLog(@"[GameCenter] authenticateHandler called");
        if(viewController != nil){
         //[self presentViewController:viewController animated:YES completion:nil];
        }else{
            if([GKLocalPlayer localPlayer].authenticated){
            
                KLog(@"[GameCenter] authenticateHandler authenticated");
                NSString* pid = [[GKLocalPlayer localPlayer]playerID];
            
                KLog(@"[GameCenter] authenticateHandler pid:%@", pid);
            
                [[GKLocalPlayer localPlayer]loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString * _Nullable leaderboardIdentifier, NSError * _Nullable error) {
                    if(error != nil){
                        NSLog(@"leaderBoard %@", [error localizedDescription]);
                    }
                }];
            }else{
                KLog(@"[GameCenter] authenticateHandler not authenticated");
            }
        }
    };
}

-(void)registerForAuthenticationNotification{
    NSLog(@"[GameCenter] registerForAuthenticationNotification");
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

-(void)authenticationChanged{
    if([GKLocalPlayer localPlayer].isAuthenticated){
        NSLog(@"[GameCenter] authenticationChange isAuthenticated");
    }else{
        NSLog(@"[GameCenter] authenticationChange isNotAuthenticated");
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController NS_AVAILABLE(10_9, 6_0){
    KLog(@"[GameCenter] gameCenterViewControllerDidFinish");
}

void KLog(NSString* log, ...){
    va_list args;
    va_start(args, log);
    NSLogv(log, args);
    va_end(args);
}
@end
