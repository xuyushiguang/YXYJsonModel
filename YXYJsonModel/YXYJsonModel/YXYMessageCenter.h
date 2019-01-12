//
//  YXYMessageCenter.h
//  SafeTest
//
//  Created by LiuGen on 2019/1/11.
//  Copyright © 2019年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXYMessageCenter : NSObject


+(YXYMessageCenter*)defaultCenter;

-(void)addObserver:(NSObject *)observer forSelector:(SEL)selector forKey:(NSString *)keyPath;

-(void)postForKey:(NSString*)keyPath;

-(void)removeObsever:(NSObject*)observerObj;

@end

NS_ASSUME_NONNULL_END
