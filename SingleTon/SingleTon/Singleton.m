//
//  Singleton.m
//  SingleTon
//
//  Created by caiyc on 15/1/5.
//  Copyright (c) 2015年 mingthink. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
+(Singleton *)shareinstance
{
    static Singleton *single = nil;
    if(!single)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            single = [[Singleton alloc]init];
        });
    NSLog(@"single address:%@",single);
    }
    return single;
}
@end
