//
//  CustomButon.m
//  装之助
//
//  Created by caiyc on 14/11/12.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "CustomButon.h"

@implementation CustomButon
{
    UIButton *btn;
    UILabel *label;
    UIView *views;
}
@synthesize isSelect=_isSelect;
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
       // self.backgroundColor = [UIColor blueColor];
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-10, frame.size.height)];
       
        label.textColor = [UIColor blackColor];
        
        [self addSubview:label];
        
        views = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-10, 10, 10, 10)];
        
        views.backgroundColor = [UIColor redColor];
        
        views.layer.cornerRadius = 6;
        
        [self addSubview:views];
        
        views.hidden = YES;
    }
    return self;
}
-(void)setBtnTitle:(NSString *)btnTitle
{
    label.text = btnTitle;
}
-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if(_isSelect){
        
        label.textColor = [UIColor redColor];
        
        views.hidden = NO;
        
    }
    else {
        label.textColor = [UIColor blackColor];views.hidden = YES;
    }
    
    
}
-(void)setHaveImage:(BOOL)haveImage
{
    _haveImage = haveImage;
    
    if(_haveImage)views.hidden = NO;
    
    else views.hidden = YES;
}
-(void)btnclick
{
    self.isSelect = !self.isSelect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
