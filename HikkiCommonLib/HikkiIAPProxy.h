//
//  HikkiIAPInterface.h
//  HikkiCommonLib
//
//  Created by jiangtao on 15/10/27.
//  Copyright © 2015年 Hikki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HikkiIAPProxy : NSObject

@end

@protocol HikkiIAPProtocol <NSObject>

@required
-(void)completeTransaction:(NSString*)receipt;

@optional
-(void)failedTransaction:(NSString*)reason;

-(void)serverCompleteTransaction:(NSString*)transactionId;
-(void)checkReceipt;
@end