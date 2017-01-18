//
//  HikkiGenericTest.h
//  HikkiCommonLib
//
//  Created by liupingpin on 2017/1/18.
//  Copyright © 2017年 Hikki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HikkiGenericTest<__covariant T> : NSObject{
    T obj;
}

@property(nonatomic, retain) T obj;
@end
