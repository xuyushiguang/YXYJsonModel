//
//  YXYJsonModel.h
//  SafeTest
//
//  Created by LiuGen on 2019/1/12.
//  Copyright © 2019年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YXYJsonModelProtocol <NSObject>

-(id)valueForProperty:(NSString*)property;

-(void)setValue:(id)value forProperty:(NSString*)property;

@end


NS_ASSUME_NONNULL_BEGIN

@interface YXYJsonModelFactory : NSObject


+(NSObject<YXYJsonModelProtocol>*)creatModelWithJson:(NSDictionary*)jDic;



@end

NS_ASSUME_NONNULL_END
