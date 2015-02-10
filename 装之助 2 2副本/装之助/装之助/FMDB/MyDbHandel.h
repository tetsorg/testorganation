//
//  MyDbHandel.h
//  MyFmDbtest
//
//  Created by caiyc on 14-6-24.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface MyDbHandel : NSObject
+(MyDbHandel *) defaultDBManager;
-(BOOL)openDb:(NSString *)str;//传数据库名字进去
-(BOOL)creatTab:(NSString *)sql;
-(BOOL)insertdata:(NSMutableDictionary *)dict;//传一个跟表的字段匹配的字典进去
-(BOOL)deletedata:(NSString *)ids;
-(NSArray *)select:(NSString *)sql;//传进去sql语句，返回的是封装好的MTMUDELDaTa对象数组
-(BOOL)updata:(NSString *)sql;
-(NSString *)jsonwrite:(NSString *)sql;//直接将数据库的数据转成json字符串
@end
