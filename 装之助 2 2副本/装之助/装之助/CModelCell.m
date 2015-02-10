//
//  CModelCell.m
//  装之助
//
//  Created by caiyc on 14/12/1.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "CModelCell.h"

@implementation CModelCell
@synthesize authImage,authNameLable,distubTimeLable,contentLable;
- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIView *authView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, DEVW-10, 60)];
    authView.backgroundColor = [UIColor colorWithRed:231./255. green:231./255. blue:231./255. alpha:1];
    authImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 60, 60)];
    authNameLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, authView.frame.size.width-60, 30)];
    authNameLable.font = [UIFont systemFontOfSize:12];
    distubTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, authView.frame.size.width-60, 30)];
    distubTimeLable.font = [UIFont systemFontOfSize:12];
    [authView addSubview:authImage];
    [authImage addSubview:authNameLable];
    [authView addSubview:distubTimeLable];

    contentLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 65, DEVW-10, 70)];
    
        float labelWidth = authView.frame.size.width/3;
    
    contentLable.numberOfLines = 0;
    
    UIFont *fonts = [UIFont systemFontOfSize:13];
    
    [FuncPublic InstanceImageView:@"点赞1" Ect:@"png" RECT:CGRectMake(20+labelWidth*0, 138, 30, 30) Target:self TAG:11 isadption:NO];
    
    [FuncPublic InstanceImageView:@"踩下" Ect:@"png" RECT:CGRectMake(20+labelWidth*1, 138, 30, 30) Target:self TAG:12 isadption:NO];
    
   [FuncPublic InstanceImageView:@"评论1" Ect:@"png" RECT:CGRectMake(20+labelWidth*2, 138, 30, 30) Target:self TAG:13 isadption:NO];
    
    _supportLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*0+50, 144, 60, 20)];
    
    _supportLabel.font = fonts;
   // _supportLabel.textAlignment = NSTextAlignmentCenter;
    
    _badLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*1+50, 144, 60, 20)];
    
    _badLabel.font = fonts;
    //_badLabel.textAlignment = NSTextAlignmentCenter;
    _collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth*2+50, 144, 60, 20)];
    
    _collectLabel.font = fonts;
   // _collectLabel.textAlignment = NSTextAlignmentCenter;
    
    _supportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _supportBtn.frame = CGRectMake(20, 138, 100, 28);
    //  [_supportBtn setImage:[UIImage imageNamed:@"点赞1.png"] forState:UIControlStateSelected];
   // [_supportBtn setBackgroundImage:[UIImage imageNamed:@"点赞.png"] forState:UIControlStateSelected];
    _badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _badBtn.frame = CGRectMake(20+labelWidth, 138, 100, 28);
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _collectBtn.frame = CGRectMake(20+labelWidth*2, 138, 100, 28);
    if(self)
    {
        [self addSubview:authView];
        [self addSubview:contentLable];
        [self addSubview:_supportLabel];
        [self addSubview:_badLabel];
        [self addSubview:_collectLabel];
        [self addSubview:_supportBtn];
        [self addSubview:_badBtn];
        [self addSubview:_collectBtn];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
