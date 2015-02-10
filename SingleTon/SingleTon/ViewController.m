//
//  ViewController.m
//  SingleTon
//
//  Created by caiyc on 15/1/5.
//  Copyright (c) 2015年 mingthink. All rights reserved.
// fgdsgdfdsadsa

#import "ViewController.h"

@interface ViewController ()
{
    NSDictionary *comDic;
    NSMutableDictionary *muDic;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    muDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"cyc",@"蔡跃春",@"cycc",@"蔡跃春是", nil];
    comDic = [NSDictionary dictionaryWithObjectsAndKeys:@"cycc",@"ccyc",@"ccyyc",@"cycc", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self test1];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self test2];
    });
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)test1
{
   // NSString *str = [muDic objectForKey:@"蔡跃春"];
    [muDic setObject:@"蔡跃春" forKey:@"cyc"];
    NSLog(@"diction is :%@",muDic);
}
-(void)test2
{
  //  NSString *str = [muDic objectForKey:@"蔡跃春"];
    [muDic setObject:@"张三" forKey:@"zs"];
    NSLog(@"diction is :%@",muDic);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
