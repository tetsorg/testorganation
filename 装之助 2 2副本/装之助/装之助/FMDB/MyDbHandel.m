//
//  MyDbHandel.m
//  MyFmDbtest
//
//  Created by caiyc on 14-6-24.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MyDbHandel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "MTMudelDaTa.h"
//#define NAME @""
@implementation MyDbHandel
{
    FMDatabase *db;
    NSString *namepath;
}
static MyDbHandel * _sharedDBManager;
+ (MyDbHandel *) defaultDBManager {
    
   
    
//    static dispatch_once_t oncetoken;
//    dispatch_once(&oncetoken,^{
//        _sharedDBManager = [[MyDbHandel alloc]init];
//    });

	if (!_sharedDBManager) {
        
        
		_sharedDBManager = [[MyDbHandel alloc] init];
	}
	return _sharedDBManager;
}

-(BOOL)openDb:(NSString *)str
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:str];
    NSLog(@"数据库路径:%@",path);
    db = [FMDatabase databaseWithPath:path];
  
    if(![db open])
    {
        NSLog(@"打开数据库失败.....");
        return NO;
    }
    else
        NSLog(@"打开数据库成功....");
        return YES;
}
-(BOOL)creatTab:(NSString *)sql
{
    [db open];
    
    if(![db open])
    {
        
        return NO;
    }
    else if ([db executeUpdate:sql])
    {
      
        [db close];
        return YES;
    }
    else
    {
         NSLog(@"创建表失败.....");
        [db close];
        return NO;
    }
}
-(BOOL)insertdata:(NSMutableDictionary *)dic
{
    NSLog(@"插入数据----------------------");
    
    
    [db open];
    
    
        NSArray *allkeys = [dic allKeys];
       // NSArray *allvalues = [dic allValues];

    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@",NAME];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
        NSMutableArray *arrs = [NSMutableArray array];
        for(NSString *keyss in allkeys)
        {
            [keys appendFormat:@"%@,",keyss];
            [values appendString:@"?,"];
            [arrs addObject:[dic objectForKey:keyss]];
            
        }
   // NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
        /*
       if ([sql objectAtIndex:0]) {
        [keys appendString:@"icon,"];
        [values appendString:@"?,"];
        //[arguments addObject:user.name];
       }
       if ([sql objectAtIndex:1]) {
           
        [keys appendString:@"id,"];
           
        [values appendString:@"?,"];
       // [arguments addObject:user.description];
       }
        
        if ([sql objectAtIndex:2]) {
            
            [keys appendString:@"mode,"];
            
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:3]) {
            
            [keys appendString:@"name,"];
            
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:4]) {
            
            [keys appendString:@"num,"];
            
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:5]) {
            
            [keys appendString:@"param,"];
            
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:6]) {
            
            [keys appendString:@"status,"];
            
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:7]) {
            
            [keys appendString:@"ver,"];
            
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if([sql objectAtIndex:8])
        {
            [keys appendString:@"mouname,"];
            
            [values appendString:@"?,"];
        }
         */
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
    [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
    [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
   // NSLog(@"%@",query);
   // [AppDelegate showStatusWithText:@"插入一条数据" duration:2.0];
    [db executeUpdate:query withArgumentsInArray:arrs];
   //  NSLog(@"插入数据.....");
    [db close];
  //  NSString *sqls = @"INSERT INTO CityLists  (id,py,name,pid,pyjx) VALUES ( 10,'bj','北京',1002,‘b’)"
   
    

//   if(![db open])
//   {
//       return NO;
//   }
//    FMResultSet *rs = [db executeQuery:sql];
//    if([rs next])
//    {
//        [db executeUpdate:sql];
//        return YES;
//    }
//    else
//    {
//        [db executeQuery:sql];
//        return YES;
//    }
     return YES;
}
-(BOOL)deletedata:(NSString *)ids
{
    if(![db open])
    {
        return NO;
    }
    else
    {
    
        [db executeUpdate:ids];
        [db close];
        return YES;
    }
}
-(NSArray *)select:(NSString *)sql
{
   
    if(![db open])
    {
        [db open];
        //return ;
    }
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    FMResultSet *rs = [db executeQuery:sql];
  //  NSLog(@"rs is %@",[rs columnNameForIndex:0]);
    while ([rs next]) {
       
    MTMudelDaTa *MDdata = [[MTMudelDaTa alloc]init];
    
    MDdata.ids = [rs stringForColumnIndex:0];
      //  NSLog(@"data id is ；%@",MDdata.id);
    MDdata.pid = [rs stringForColumnIndex:1];
    MDdata.name = [rs stringForColumnIndex:2];
        
    MDdata.pyjx = [rs stringForColumnIndex:3];
    MDdata.py = [rs stringForColumnIndex:4];
    MDdata.sindex = [rs stringForColumnIndex:5];

    [arr addObject:MDdata];
     
    }
    [db close];
    return arr;
}
-(NSString *)jsonwrite:(NSString *)sql
{
    
    
    if(![db open])
    {
        return @"";
    }
    NSMutableArray *arr1 = [NSMutableArray array];
    //[arr removeAllObjects];
    FMResultSet *rs = [db executeQuery:sql];
    NSString *str = @"[";
    while ([rs next]) {
        str = @"{";
        int k = [rs columnCount];
        for(int n= 0;n<k;n++)
        {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"\"%@",[rs columnNameForIndex:n]]];
    
        str = [str stringByAppendingString:@"\""];
        str = [str stringByAppendingString:@":"];
        str = [str stringByAppendingString:@"\""];
        NSString *str1 = [rs stringForColumnIndex:n];
        str = [str stringByAppendingString:str1];
        str = [str stringByAppendingString:@"\""];
        if(n<k-1)
        {
        str = [str stringByAppendingString:@","];
        }
 
        }
        str = [str stringByAppendingString:@"}"];
        [arr1 addObject:str];
        }
   
    str = [arr1 componentsJoinedByString:@","];
    str = [str stringByAppendingString:@"]"];
    NSString *tempstr = @"[";
    str = [tempstr stringByAppendingString:str];
    [db close];
    return str;
}
-(BOOL)updata:(NSString *)sql
{
    if(![db open])
    {
       
        return NO;
    }
    else
    {
        
        [db executeUpdate:sql];
        [db close];
        return YES;
    }

}
@end
