//
//  YXYJsonModel.m
//  SafeTest
//
//  Created by LiuGen on 2019/1/12.
//  Copyright © 2019年 Test. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YXYJsonModelFactory.h"
#import <objc/runtime.h>

@implementation YXYJsonModelFactory

+(NSObject<YXYJsonModelProtocol>*)creatModelWithJson:(NSDictionary*)jDic
{
    
    NSArray *keys = [jDic allKeys];
    Class JsonClass = [self creatModelClassWithIvars:keys];
    id jsonObjc = [[JsonClass alloc] init];
    for (NSString *ivar in keys) {
        [jsonObjc setValue:jDic[ivar] forKey:ivar];
    }
    
    return jsonObjc;
}

+(Class)creatModelClassWithIvars:(NSArray*)ivars
{
    Class JsonClass = objc_allocateClassPair([NSObject class], "JsonClass", 0);
    class_addProtocol(JsonClass, @protocol(YXYJsonModelProtocol));
    for (NSString * ivar in ivars) {
        const char * chIvar = [ivar cStringUsingEncoding:NSUTF8StringEncoding];
        BOOL isSuccess = class_addIvar(JsonClass, chIvar, sizeof(NSString *), 0, "@");
        NSLog(@"添加属性:%@ %@",ivar,(isSuccess ? @"成功" : @"失败"));
    }
    Method imp_a = class_getInstanceMethod([self class], @selector(valueForProperty:));
    class_addMethod(JsonClass, @selector(valueForProperty:), method_getImplementation(imp_a), "#@:");
    
    Method imp_b = class_getInstanceMethod([self class], @selector(setValue:forProperty:));
    class_addMethod(JsonClass, @selector(setValue:forProperty:), method_getImplementation(imp_b), "v@:");
    
    objc_registerClassPair(JsonClass);
    return JsonClass;
}

-(id)valueForProperty:(NSString*)property
{
    return  [self valueForKey:property];
}

-(void)setValue:(id)value forProperty:(NSString*)property
{
    [self setValue:value forKey:property];
}

@end
