//
//  KoreaIAPProxy.h
//  Unity-iPhone
//
//  Created by jiangtao on 2016/6/1.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface HikkiIAPProxy : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>
-(void)getProductInfo:(NSString*)productId;
+(HikkiIAPProxy*) getShared;
-(void)serverCompleteTransaction:(NSString*)transactionId;
-(void)checkReceipt;
@end
