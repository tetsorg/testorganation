//
//  MyTableView.h
//  SliderView
//
//  Created by Jeffrey on 14-11-14.
//  Copyright (c) 2014年 Jeffrey_wjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol updateDataDelegate <NSObject>

@optional
-(void)tableViewdisSelectRow:(NSIndexPath *)indexpath mark:(NSInteger)tag;

@end
@interface MyTableView : UIView<UITableViewDataSource,UITableViewDelegate>

-(id)initWithFrame:(CGRect)frame tag:(int)tag;
@property(nonatomic,strong) NSArray *dataSource;
@property(nonatomic) float rowHeight;
//选中图片,默认nil
@property(nonatomic,strong) UIImage *selectImage;
@property(nonatomic,strong) id<updateDataDelegate> delegate;
@property(nonatomic,retain)UIImage *titleImage;
@property(nonatomic)BOOL isFirsts;

@end
