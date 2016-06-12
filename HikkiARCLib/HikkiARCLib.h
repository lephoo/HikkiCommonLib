//
//  HikkiARCLib.h
//  HikkiARCLib
//
//  Created by hikkilephoo on 16/6/11.
//  Copyright © 2016年 Hikki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HikkiARCLib : NSObject

@property(atomic, weak)NSObject* weakVal;
@property(nonatomic, strong)NSObject* strongVal;

@end
