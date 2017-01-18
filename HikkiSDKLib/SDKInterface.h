//
//  SDKInterface.h
//  Unity-iPhone
//
//  Created by jiangtao on 2017/1/16.
//
//

#import <Foundation/Foundation.h>

@interface SDKInterfaceImpl :NSObject<SDKInterface>

@end

@protocol SDKInterface <NSObject>
@optional
-(void)didFinishLaunching:(NSDictionary*)launchOptions;
@optional
-(void)setDeviceToken:(NSData*)deviceToken;
@optional
-(BOOL)handleOpenURL:(NSURL*)url app:(UIApplication*)app;
@optional
-(BOOL)openURL:(NSURL*)url srcApp:(NSString*)srcApp annotation:(id)annotation app:(UIApplication*)app;
@optional
-(BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options app:(UIApplication*)app;
@optional
- (void)applicationWillEnterForeground:(UIApplication *)application;
@end
