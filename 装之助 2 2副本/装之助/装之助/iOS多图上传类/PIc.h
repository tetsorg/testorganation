//
//  PIc.h
//  TestImages
//
//  Created by caiyc on 15/2/3.
//  Copyright (c) 2015年 mingthink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIc : NSObject
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     picFilePath: (NSMutableArray *)picFilePath  // IN
                     picFileName: (NSMutableArray *)picFileName;
@end
