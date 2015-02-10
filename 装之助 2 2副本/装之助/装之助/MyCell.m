//
//  MyCell.m
//  SliderView
//
//  Created by Jeffrey on 14-11-14.
//  Copyright (c) 2014年 Jeffrey_wjx. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)drawRect:(CGRect)rect{
//   //解决分割线不能到头的问题（不知道怎么搞）
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor redColor] set];
//    CGPoint points[2] ={
//    
//        CGPointMake(0, 50),
//        CGPointMake(rect.size.width,50)
//    };
//    CGContextAddLines(context, points, 2);
//    CGContextStrokePath(context);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
