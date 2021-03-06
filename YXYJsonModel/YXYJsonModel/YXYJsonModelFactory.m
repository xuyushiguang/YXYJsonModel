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
#import <objc/message.h>
@implementation YXYJsonModelFactory

+(Class)creatModelClassWithIvars:(NSArray*)ivars
{
    Class JsonClass = objc_allocateClassPair([NSObject class], "JsonClass", 0);
    class_addProtocol(JsonClass, @protocol(YXYJsonModelProtocol));
    class_addProtocol(JsonClass, @protocol(YXYJsonSetGetProtocol));
    for (NSString * ivar in ivars) {
        const char * chIvar = [[ivar lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
        BOOL isSuccess = class_addIvar(JsonClass, chIvar, sizeof(NSString *), 0, "@");
        NSLog(@"添加属性:%@ %@",ivar,(isSuccess ? @"成功" : @"失败"));
    }
    Method imp_a = class_getInstanceMethod([self class], @selector(valueForProperty:));
    class_addMethod(JsonClass, @selector(valueForProperty:), method_getImplementation(imp_a), "#@:");

    Method imp_b = class_getInstanceMethod([self class], @selector(setValue:forProperty:));
    class_addMethod(JsonClass, @selector(setValue:forProperty:), method_getImplementation(imp_b), "v@:");

    Method imp_c = class_getInstanceMethod([self class], @selector(addMethod:withSEL:));
    class_addMethod(JsonClass, @selector(addMethod:withSEL:), method_getImplementation(imp_c), "v@:");
   
    unsigned int count;
   struct objc_method_description *protocolMethods = protocol_copyMethodDescriptionList(@protocol(YXYJsonSetGetProtocol), YES, YES, &count);
    for (int i=0; i<count; i++) {
        struct objc_method_description pMethod = protocolMethods[i];
        if ([NSStringFromSelector(pMethod.name) hasPrefix:@"set"]) {
            Method imp_i = class_getInstanceMethod([self class], @selector(setJsonValue:));
            class_addMethod(JsonClass, pMethod.name, method_getImplementation(imp_i), "v@:");
        }else{
//            Method imp_ii = class_getInstanceMethod([self class], @selector(jsonModelValue));
//            class_addMethod(JsonClass, pMethod.name, method_getImplementation(imp_ii), "#@:");
            
        }
    }
    
    objc_registerClassPair(JsonClass);
    return JsonClass;
}

-(void)setJsonValue:(NSString*)value{
    
    NSString *str = NSStringFromSelector(_cmd);
    str = [str stringByReplacingOccurrencesOfString:@"set" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    str = [str lowercaseString];
    [self setValue:value forKey:str];
}

-(NSString*)jsonModelValue
{
    NSString *str = NSStringFromSelector(_cmd);
    NSLog(@"====%@",str);
    return [self valueForKey:str];
}

+(NSObject<YXYJsonModelProtocol,YXYJsonSetGetProtocol>*)creatModelWithJson:(NSDictionary*)jDic
{
    
    NSArray *keys = [jDic allKeys];
    Class JsonClass = [self creatModelClassWithIvars:keys];
    id jsonObjc = [[JsonClass alloc] init];
    for (NSString *ivar in keys) {
        [jsonObjc setValue:jDic[ivar] forKey:ivar];
    }
    return jsonObjc;
}

-(id)valueForProperty:(NSString*)property
{
    return  [self valueForKey:property];
}

-(void)setValue:(id)value forProperty:(NSString*)property
{
    [self setValue:value forKey:property];
}

-(void)addMethod:(Class)cls withSEL:(SEL)sel
{
    Method imp_c = class_getInstanceMethod(cls, sel);
    class_addMethod([self class], sel, method_getImplementation(imp_c), "v@:");
}


@end
