//
//  SDKInterface.h
//  Unity-iPhone
//
//  Created by liupingpin on 2017/1/16.
//
//

#import <Foundation/Foundation.h>

@protocol SDKInterface <NSObject>
@required
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
