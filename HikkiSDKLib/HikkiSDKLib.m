//
//  HikkiSDKLib.m
//  HikkiCommonLib
//
//  Created by liupingpin on 2017/1/17.
//  Copyright © 2017年 Hikki. All rights reserved.
//

#import "HikkiSDKLib.h"

@implementation HikkiSDKLib

#pragma mark - getTopVC

-(UIViewController*)getTopVC{
    UIViewController* topVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVc.presentedViewController) {
        topVc = topVc.presentedViewController;
    }
    return topVc;
}

#pragma mark - Singleton

static HikkiSDKLib* m_shared;
+(HikkiSDKLib*) getShared{
    @synchronized(m_shared) {
        if(m_shared == Nil){
            m_shared = [[HikkiSDKLib alloc]init];
        }
        return m_shared;
    }
}

-(void)dealloc{
    //[self removeTransactionObserver];
    [super dealloc];
}
@end

#pragma mark - Unity Called Funcs

#if defined(__cplusplus)
extern "C"{
#endif
    void ex_login();
    void ex_logout();
    void ex_getChannelId();
    void ex_enterGame(const char* serverId, const char* roleId);
    void ex_pay(const char* productId, const char* serverId, const char* roleId);
    void setGameParams(const char* version, const char* account, const char* levelId);
    void ex_unregister();
    void ex_finishTransaction(const char* transactionId);
    void ex_checkReceipt();
    void ex_localNotiRegister(const char* msg, int weekDay, int hours, int mins);
#if defined(__cplusplus)
}
#endif

void ex_login(){
   
}

void ex_logout(){
    
}

void ex_unregister(){
    
}

void ex_enterGame(const char* serverId, const char* roleId){
    //NSString* sid = [[NSString alloc]initWithCString:serverId encoding:NSUTF8StringEncoding];
    //NSString* rid = [[NSString alloc]initWithCString:roleId encoding:NSUTF8StringEncoding];
    //[[KoreaInterface getShared]enterGame:sid roleId:rid];
}

void ex_pay(const char* productId, const char* serverId, const char* roleId){
    NSString* pid = [[NSString alloc]initWithCString:productId encoding:NSUTF8StringEncoding];
    [[KoreaInterface getShared]unityPay:pid];
}
//

void setGameParams(const char* version, const char* account, const char* levelId){
    
    NSString* nsVer = [[NSString alloc]initWithCString:version encoding:NSUTF8StringEncoding];
    NSString* nsAcc = [[NSString alloc]initWithCString:account encoding:NSUTF8StringEncoding];
    NSString* nsLv = [[NSString alloc]initWithCString:levelId encoding:NSUTF8StringEncoding];
    //[[KoreaInterface getShared]unitySetGameParams:nsVer account:nsAcc levelId:nsLv];
}

void ex_finishTransaction(const char* transactionId){
    NSString* tid = [[NSString alloc]initWithCString:transactionId encoding:NSUTF8StringEncoding];
    //[[KoreaIAPProxy getShared]serverCompleteTransaction:tid];
}

void ex_checkReceipt(){
    //[[KoreaIAPProxy getShared]checkReceipt];
}

void ex_localNotiRegister(const char* msg, int weekDay, int hours, int mins){
    //
}

void ex_getChannelId(){
    [[KoreaInterface getShared]getChannelId];
}
