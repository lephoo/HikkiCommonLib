//
//  HikkiSDKLib.h
//  HikkiCommonLib
//
//  Created by jiangtao on 2017/1/17.
//  Copyright © 2017年 Hikki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDKInterface.h"

@interface HikkiSDKLib : NSObject{
    SDKInterfaceImpl* m_SDKInterface;
}

@end
