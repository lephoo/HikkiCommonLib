//
//  HikkiIAPInterface.m
//  HikkiCommonLib
//
//  Created by jiangtao on 15/10/27.
//  Copyright © 2015年 Hikki. All rights reserved.
//

#import "HikkiIAPProxy.h"
#import <StoreKit/StoreKit.h>

@interface HikkiIAPProxy()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation HikkiIAPProxy

-(BOOL)checkIfAllowPayment{
    if([SKPaymentQueue canMakePayments]){
        [self getProductInfo];
        return YES;
    }else{
        
        return NO;
    }
}

-(void)getProductInfo{
    NSSet* productSet = [NSSet setWithArray:@[@"ProductId"]];
    SKProductsRequest* req = [[SKProductsRequest alloc]initWithProductIdentifiers:productSet];
    req.delegate = self;
    [req start];
}

-(void)addTransactionObserver{
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}

-(void)removeTransactionObserver{
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

#pragma mark - SKProductsRequestDelegate impl

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response NS_AVAILABLE_IOS(3_0){
    NSArray* myProducts = response.products;
    if(myProducts.count == 0){
        NSLog(@"there is no product !!!");
        return;
    }
    NSLog(@"Products--------");
    for(SKProduct* product in myProducts){
        if(product != nil){
            NSLog(@"desc:%@, id:%@, price:%@", product.localizedDescription, product.productIdentifier, product.price.stringValue);
        }
    }
    SKPayment* payment = [SKPayment paymentWithProduct:myProducts[0]];
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}


#pragma mark - SKPaymentTransactionObserver impl

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions NS_AVAILABLE_IOS(3_0){
    for(SKPaymentTransaction* transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchased://purchase finished
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://already bought
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred://
                break;
            case SKPaymentTransactionStatePurchasing://add to list
                break;
        }
    }
}

-(void)completeTransaction:(SKPaymentTransaction*)transaction{
    //
    NSString* productIdentifier = transaction.payment.productIdentifier;
    NSString* receipt = [transaction.transactionReceipt base64Encoding];
    if([productIdentifier length] > 0){
        //send to game server for verification
        NSLog(@"transaction receipt:%@", receipt);
    }
    //remove transaction from queue
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction ];
}

-(void)failedTransaction:(SKPaymentTransaction* )transaction{
    if(transaction.error.code != SKErrorPaymentCancelled){
        NSLog(@"transaction failed");
    }else{
        NSLog(@"transaction cancelled");
    }
}

-(void)restoreTransaction:(SKPaymentTransaction*)transaction{
    //already bought
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}

@end
