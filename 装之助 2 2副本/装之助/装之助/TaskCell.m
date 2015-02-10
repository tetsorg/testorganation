//
//  TaskCell.m
//  装之助
//
//  Created by guest on 14/11/26.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "TaskCell.h"
#define CELLWIDTH DEVW/4
@implementation TaskCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _images = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, CELLWIDTH-10, 100)];
    _clcikBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_clcikBtn setFrame:_images.frame];
    float startX=_images.frame.origin.x+_images.frame.size.width+20;
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(startX, 0, 2*CELLWIDTH, 20)];
    _addressLabel =[[UILabel alloc]initWithFrame:CGRectMake(startX, 20, 2*CELLWIDTH, 20)];
    _typeLable = [[UILabel alloc]initWithFrame:CGRectMake(startX, 40, 2*CELLWIDTH, 20)];
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(startX, 60, 2*CELLWIDTH, 20)];
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(startX+2*CELLWIDTH, 40, CELLWIDTH, 20)];
    [self addSubview:_images];
    [self addSubview:_titleLabel];
    [self addSubview:_addressLabel];
    [self addSubview:_typeLable];
    [self addSubview:_subLabel];
    [self addSubview:_priceLabel];
    [self addSubview:_clcikBtn];
    return self;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
