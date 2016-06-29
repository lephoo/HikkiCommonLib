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
bool m_observerMark;
bool m_transactionObAdded;

-(BOOL)checkIfAllowPayment{
    if([SKPaymentQueue canMakePayments]){
        return YES;
    }else{
        
        return NO;
    }
}

-(void)getProductInfo:(NSString*)productId{
    if(m_observerMark == NO)
        m_observerMark = YES;
    if(m_transactionObAdded == NO){
        [self addTransactionObserver];
        m_transactionObAdded = YES;
    }
    NSSet* productSet = [NSSet setWithArray:@[productId]];
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
    //[transaction.transactionIdentifier]
    [self verifyPurchaseLocal:transaction];
    //NSData* receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle]appStoreReceiptURL]];
    //NSString* receiptDesc = [[NSString alloc]initWithData:receiptData encoding:NSUTF8StringEncoding];
    NSString* receipt = [transaction.transactionReceipt base64Encoding];
    NSString* receiptOldStr = [[NSString alloc]initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSLog(@"[IAP]ReceiptOldStr:%@", receiptOldStr);
    NSLog(@"[IAP]Receipt:%@", receipt);
    //NSLog(@"[IAP]receiptDesc:%@", receiptDesc);
    //if(receiptData != nil)
    //[self parseTransaction:receiptData];
    //NSString* receipt = [transaction.transactionReceipt base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    if([productIdentifier length] > 0){
        //send to game server for verification
        NSLog(@"[IAP]transaction productId:%@", productIdentifier);
        
        [self notifyUnityCompletePayment:productIdentifier receipt:receipt];
    }
    //remove transaction from queue
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction ];
}


-(void)verifyPurchaseLocal:(SKPaymentTransaction*)transaction{
    
    NSData* receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle]appStoreReceiptURL]];
    if(receiptData == nil){
        NSLog(@"verify receiptData is Null");
        return;
    }
    NSString* oriStr = [[NSString alloc]initWithData:receiptData encoding:NSUTF8StringEncoding];
    NSLog(@"verify oriStr:%@", oriStr);
    NSString* encodedStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //
    if(encodedStr != nil){
        NSString* rcpStr = [NSString stringWithFormat:@"%@<order>%@",  transaction.payment.productIdentifier, encodedStr];
        NSLog(@"verify EcodedStr:%@", rcpStr);
        //UnitySendMessage("SDK", "paySuccess", [rcpStr UTF8String]);
    }
    
    NSLog(@"[IAP] verifyPurchaseLocal encodedStr:%@", encodedStr);
    
#ifdef HIKKI_DEBUG
    [self postCheckReceipt:encodedStr];
#endif
}

-(void)postCheckReceipt:(NSString*)encodedStr{
    
    NSURL* url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:10.0f];
    req.HTTPMethod = @"POST";
    NSString* payload = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}", encodedStr];
    NSData* payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    req.HTTPBody = payloadData;
    
    NSError* urlErr;
    NSData* res = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&urlErr];
    if(urlErr != nil){
        // NSLog(@"[IAP] urlErr:%@", [urlErr localizedDescription]);
    }
    if(res == nil){
        NSLog(@"[IAP] localVerify Failed");
    }
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:res options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"[IAP] res:%@", dict);
    if(dict != nil){
        NSLog(@"[IAP] res dict bundle_id:%@", [dict valueForKey:@"bundle_id"]);
        NSLog(@"[IAP] res dict application_version:%@", [dict valueForKey:@"application_verion"]);
        NSLog(@"[IAP] res dict product_id:%@", [dict valueForKey:@"product_id"]);
        NSLog(@"[IAP] res dict transaction_id:%@", [dict valueForKey:@"transaction_id"]);
        
    }
}

- (NSDictionary *)dictionaryFromPlistData:(NSData*)data err:(NSError **)outError {
    NSError *error;
    NSDictionary *dictionaryParsed = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&error];
    if (!dictionaryParsed) {
        if (error) {
            *outError = error;
        }
        return nil;
    }
    return dictionaryParsed;
}


-(void)parseTransaction:(NSData*)receipt{
    NSError *error = nil;
    NSDictionary *receiptDict = [self dictionaryFromPlistData:receipt err:&error];
    if(error != nil)
        return;
    NSString *transactionPurchaseInfo = [receiptDict objectForKey:@"purchase-info"];
    NSString *decodedPurchaseInfo = [NSString stringWithUTF8String:[[NSData dataWithBase64EncodedString:transactionPurchaseInfo] bytes]];
    NSData* decodedPurchaseInfoData = [decodedPurchaseInfo dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *purchaseInfoDict = [self dictionaryFromPlistData:decodedPurchaseInfoData err:&error];
    NSString *transactionID = [purchaseInfoDict objectForKey:@"transaction-id"];
    NSString *purchaseDateString = [purchaseInfoDict objectForKey:@"purchase-date"];
    NSString *signature = [receiptDict objectForKey:@"signature"];
    NSString *signatureDecoded = [NSString stringWithUTF8String:[[NSData dataWithBase64EncodedString:signature] bytes]];
    // Convert the string into a date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    NSDate *purchaseDate = [dateFormat dateFromString:[purchaseDateString stringByReplacingOccurrencesOfString:@"Etc/" withString:@""]];
    NSLog(@"Raw receipt content: \n%@", [NSString stringWithUTF8String:[receipt bytes]]);
    NSLog(@"Purchase Info: %@", purchaseInfoDict);
    NSLog(@"Transaction ID: %@", transactionID);
    NSLog(@"Purchase Date: %@", purchaseDate);
    NSLog(@"Signature: %@", signatureDecoded);
}


-(void)failedTransaction:(SKPaymentTransaction* )transaction{
    NSLog(@"[IAP]transaction failed");
    NSString* msg = nil;
    if(transaction.error.code == SKErrorUnknown){
        msg = @"can't connect to iTunes Store!";
    }else if(transaction.error.code == SKErrorClientInvalid){
        msg = @"client invalid";
    }else if(transaction.error.code == SKErrorPaymentInvalid){
        msg = @"payment invalid";
    }else if(transaction.error.code == SKErrorPaymentNotAllowed){
        msg = @"payment not allowed";
    }else if(transaction.error.code == SKErrorStoreProductNotAvailable){
        msg = @"store product not available";
    }else if(transaction.error.code == SKErrorPaymentCancelled){
        msg = @"payment cancelled";
    }
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    if(m_observerMark == NO)
        return;
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"error" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [alert addButtonWithTitle:@"Yes"];
    [alert show];
}

-(void)restoreTransaction:(SKPaymentTransaction*)transaction{
    //already bought
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}

@end
