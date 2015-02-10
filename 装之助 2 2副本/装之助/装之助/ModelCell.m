//
//  ModelCell.m
//  装之助
//
//  Created by guest on 14/11/10.
//  Copyright (c) 2014年 none. All rights reserved.
// 效果图cell样式

#import "ModelCell.h"

@implementation ModelCell

- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _titelLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 200, 20)];
    
    _mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 22, DEVW-20, 100)];
    _checkpic = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkpic.frame = _mainImage.frame;

    
    float labelWidth = _mainImage.frame.size.width/3;
    
    UIFont *fonts = [UIFont systemFontOfSize:13];
    
    UIImageView *supportImage = [FuncPublic InstanceImageView:@"点赞1" Ect:@"png" RECT:CGRectMake(20+labelWidth*0, 122, 30, 30) Target:self TAG:11 isadption:NO];
    
    UIImageView *badImage = [FuncPublic InstanceImageView:@"鄙视1" Ect:@"png" RECT:CGRectMake(20+labelWidth*1, 122, 30, 30) Target:self TAG:12 isadption:NO];
    
    UIImageView *collectImage = [FuncPublic InstanceImageView:@"收藏黑" Ect:@"png" RECT:CGRectMake(20+labelWidth*2, 122, 30, 30) Target:self TAG:13 isadption:NO];
    
    _supportLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*0+50, 125, 60, 20)];
    
    _supportLabel.font = fonts;
    
    _badLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*1+50, 125, 60, 20)];
    
    _badLabel.font = fonts;
    
    _collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*2+50, 125, 60, 20)];
    
    _collectLabel.font = fonts;
    
    _supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _supportBtn.frame = CGRectMake(20, 122, 100, 28);
  //  [_supportBtn setImage:[UIImage imageNamed:@"点赞1.png"] forState:UIControlStateSelected];
    [_supportBtn setBackgroundImage:[UIImage imageNamed:@"点赞.png"] forState:UIControlStateSelected];
    _badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _badBtn.frame = CGRectMake(20+labelWidth, 122, 100, 28);
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _collectBtn.frame = CGRectMake(20+labelWidth*2, 122, 100, 28);
    
    if(self)
    {
        [self addSubview:_titelLable];
        [self addSubview:_mainImage];
        [self addSubview:_supportLabel];
        [self addSubview:_badLabel];
        [self addSubview:_collectLabel];
        [self addSubview:supportImage];
        [self addSubview:badImage];
        [self addSubview:collectImage];
        [self addSubview:_supportBtn];
        [self addSubview:_badBtn];
        [self addSubview:_collectBtn];
        [self addSubview:_checkpic];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
