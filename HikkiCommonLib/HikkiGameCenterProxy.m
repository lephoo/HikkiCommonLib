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
                
#ifdef HIKKI_DEBUG
                [self postVerifyIdentity];
#endif
                
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

-(void)postVerifyIdentity{
    
    [[GKLocalPlayer localPlayer]generateIdentityVerificationSignatureWithCompletionHandler:^(NSURL * _Nullable publicKeyUrl, NSData * _Nullable signature, NSData * _Nullable salt, uint64_t timestamp, NSError * _Nullable error) {
        if(error){
            NSLog(@"generateIdentityVerification:%@", [error localizedDescription]);
        }else{
            NSDictionary* params = @{
                                     @"public_key_url":[publicKeyUrl absoluteString],
                                     @"timestamp":[NSString stringWithFormat:@"%llu", timestamp],
                                     @"signature":[signature base64EncodedDataWithOptions:0],
                                     @"salt":[salt base64EncodedDataWithOptions:0],
                                     @"player_id":[GKLocalPlayer localPlayer].playerID,
                                     @"app_bundle_id":[[NSBundle mainBundle]bundleIdentifier]
                                     };
            
            NSError* jsonErr = nil;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&jsonErr];
            NSString* loginUrl = @"";
            NSMutableURLRequest* postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loginUrl]];
            [postRequest setHTTPBody:jsonData];
            [postRequest setHTTPMethod:@"POST"];
            NSOperationQueue* queue = [[NSOperationQueue alloc]init];
            [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                
                if(connectionError){
                    NSLog(@"GameCenter verify post err:%@", [connectionError localizedDescription]);
                    
                }else{
                    
                    NSInteger resCode = [(NSHTTPURLResponse*)response statusCode];
                    NSString* resStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"responseCode:%zd", resCode);
                    NSLog(@"responseStr:%@", resStr);
                }
            }];
        }
    }];
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

-(void)showGameCenter{
    GKGameCenterViewController* gvc = [[GKGameCenterViewController alloc]init];
    if(gvc != nil){
       // gvc.gameCenterDelegate = self;
        //gvc.viewState = GKGameCenterViewControllerStateDefault;
        //[[self getTopVC] presentViewController:gvc animated:YES completion:nil];
    }
}

-(void)showAuthenticationDialogWhenReasonable{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"gamecenter:1116904144"]];
    /*[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:id350536422"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:us/app/cheese-moon/id350536422"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:games/"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:350536422"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:/me/account"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:/me/signout"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:/friends/recommendations"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:/games/recommendations"]];*/
}

void KLog(NSString* log, ...){
    va_list args;
    va_start(args, log);
    NSLogv(log, args);
    va_end(args);
}
@end
