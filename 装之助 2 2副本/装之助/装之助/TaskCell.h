//
//  TaskCell.h
//  装之助
//
//  Created by guest on 14/11/26.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
@property(nonatomic,retain)UIImageView *images;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *addressLabel;
@property(nonatomic,retain)UILabel *typeLable;
@property(nonatomic,retain)UILabel *subLabel;
@property(nonatomic,retain)UILabel *priceLabel;
@property(nonatomic,retain)UIButton *clcikBtn;

@end
