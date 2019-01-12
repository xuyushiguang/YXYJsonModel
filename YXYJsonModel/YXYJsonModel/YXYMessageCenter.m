//
//  YXYMessageCenter.m
//  SafeTest
//
//  Created by LiuGen on 2019/1/11.
//  Copyright © 2019年 Test. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YXYMessageCenter.h"

@interface MessageModel : NSObject
@property (nonatomic,weak) NSObject *obj;
@property (nonatomic,assign)SEL      sel;
@property (nonatomic,copy)  NSString *key;
@property (nonatomic,copy)  NSString *classStr;
@end

@implementation MessageModel


@end


@interface YXYMessageCenter()

@property(nonatomic,strong)NSMutableArray *observers;

@end

static  YXYMessageCenter    *_center;
@implementation YXYMessageCenter

+(YXYMessageCenter*)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _center = [[YXYMessageCenter alloc] init];
    });
    return _center;
}

-(void)addObserver:(NSObject *)observer forSelector:(SEL)selector forKey:(NSString *)keyPath
{
    MessageModel *model = [MessageModel new];
    model.obj = observer;
    model.sel = selector;
    model.key = keyPath;
    model.classStr = NSStringFromClass([observer class]);
    __block BOOL hasObj = NO;
    [self.observers enumerateObjectsUsingBlock:^(MessageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.obj == observer) {
            hasObj = YES;
            *stop = YES;
        }
    }];
    if (!hasObj) {
        [self.observers addObject:model];
    }
}

-(void)postForKey:(NSString*)keyPath
{
    [self.observers enumerateObjectsUsingBlock:^(MessageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.key isEqualToString:keyPath]) {
            if ([obj.obj respondsToSelector:obj.sel]) {
               [obj.obj performSelector:obj.sel];
            }
        }
    }];
}

-(void)removeObserverForKey:(NSString*)keyPath
{
    [self.observers enumerateObjectsUsingBlock:^(MessageModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.key isEqualToString:keyPath]) {
            [self.observers removeObject:obj];
            *stop = YES;
        }
    }];
}

-(void)removeObsever:(NSObject*)observerObj
{
    NSString *cstr = NSStringFromClass([observerObj class]);
    [self.observers enumerateObjectsUsingBlock:^(MessageModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.classStr isEqualToString:cstr]) {
            [self.observers removeObject:obj];
            *stop = YES;
        }
    }];
}

#pragma mark --geter

-(NSMutableArray*)observers
{
    if (!_observers) {
        _observers = [NSMutableArray array];
    }
    return _observers;
}

@end
