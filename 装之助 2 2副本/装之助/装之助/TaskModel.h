//
//  TaskModel.h
//  装之助
//
//  Created by guest on 14/11/26.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject
@property(nonatomic,retain)NSString *titles;
@property(nonatomic,retain)NSString *address;
@property(nonatomic,retain)NSString *type;
@property(nonatomic,retain)NSString *subtitle;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *imageurl;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *ids;
@property(nonatomic,retain)NSString *uids;
@property(nonatomic,retain)NSArray *imageArr;
@property(nonatomic,retain)NSString *contactPeople;
@property(nonatomic,retain)NSString *contactNum;
@property(nonatomic,retain)NSString *huXing;
@property(nonatomic,retain)NSString *areas;
@property(nonatomic,retain)NSString *zhouBianJZ;
@property(nonatomic,retain)NSString *city;
@property(nonatomic,retain)NSString *cityName;
@property(nonatomic,retain)NSString *regionName;
@property(nonatomic,retain)NSString *region;
@property(nonatomic,retain)NSString *time;
@property(nonatomic,retain)NSString *xiangXiSM;
@property(nonatomic,retain)NSString *xiaoQu;
@property(nonatomic,retain)NSString *evalution;
@property(assign)BOOL isrecieve;
@end
