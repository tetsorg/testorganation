//
//  CustomView.h
//  装之助
//
//  Created by caiyc on 14/11/13.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property(nonatomic,retain)NSString *urlForImage;
@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,retain)NSString *labelTitle;
@property(nonatomic,assign)BOOL isHaveIcon;
@property(nonatomic,retain)UIImageView *iconsImage;
@end
