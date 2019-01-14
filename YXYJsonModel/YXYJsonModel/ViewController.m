//
//  ViewController.m
//  YXYJsonModel
//
//  Created by LiuGen on 2019/1/12.
//  Copyright © 2019年 Test. All rights reserved.
//

#import "ViewController.h"
#import "YXYJsonModelFactory.h"
#import "YXYMessageCenter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[YXYMessageCenter defaultCenter] postForKey:@"message"];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.backgroundColor = [UIColor redColor];
    bt.frame = CGRectMake(100, 100, 100, 50);
    [bt setTitle:@"button" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(actionForButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

-(void)actionForButton
{
    NSDictionary *dic = @{@"name":@"json",@"age":@"10",@"height":@"100"};
    NSObject<YXYJsonModelProtocol,YXYJsonSetGetProtocol> *model = [YXYJsonModelFactory creatModelWithJson:dic];
    for (NSString *str in [dic allKeys]) {
        NSLog(@"=%@",[model performSelector:@selector(valueForProperty:) withObject:str]);
    }
    [model setName:@"aaaa"];
//    NSLog(@"set=%@",[model aname]);
    NSLog(@"=%@",[model performSelector:@selector(valueForProperty:) withObject:@"name"]);
}

@end
