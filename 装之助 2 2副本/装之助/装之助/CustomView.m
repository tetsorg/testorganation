//
//  CustomView.m
//  装之助
//
//  Created by caiyc on 14/11/13.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "CustomView.h"
#import "UIImageView+webimage.h"
@implementation CustomView
{
    UILabel *label;
    UIImageView *iconImage;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (frame.size.height-60)/2, 60,60)];
        
        iconImage.contentMode = UIViewContentModeScaleAspectFit;
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, frame.size.width-70, frame.size.height)];
        
        label.textColor = [UIColor blackColor];
        
        label.textAlignment = 1;
        
        [self addSubview:iconImage];
        
        [self addSubview:label];
        
    }
    return self;
}
-(void)setUrlForImage:(NSString *)urlForImage
{
    [iconImage setImageWithURL:[NSURL URLWithString:urlForImage]];
}
-(void)setLabelTitle:(NSString *)labelTitle
{
    label.text = labelTitle;
    
}
-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if(_isSelect){
        label.textColor = [UIColor redColor];
       }
    else {label.textColor = [UIColor blackColor];}

}
-(void)setIsHaveIcon:(BOOL)isHaveIcon
{
    _isHaveIcon = isHaveIcon;
    
    if(!_isHaveIcon){iconImage.hidden = YES;label.frame = CGRectMake(10, label.frame.origin.y, label.frame.size.width, label.frame.size.height);}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
