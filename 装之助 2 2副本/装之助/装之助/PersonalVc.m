//
//  PersonalVc.m
//  装之助
//
//  Created by caiyc on 14/11/4.
//  Copyright (c) 2014年 none. All rights reserved.
// 222

#import "PersonalVc.h"
#import "ModelCell.h"
#import "EffectModel.h"
@class EffectModel;

@interface PersonalVc ()

@end

@implementation PersonalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1];
    
    UIView *personInfoView = [FuncPublic instanceview:CGRectMake(0, 0, DEVW, (DEVH-BOTTOM_H)*1/5) andcolor:nil addtoview:self.view andparentvc:self isadption:NO];
    
    [FuncPublic instanceview:CGRectMake(0, personInfoView.frame.size.height-1, DEVW, 1) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    
    UIView *tabbarView = [FuncPublic instanceview:CGRectMake(0, personInfoView.frame.size.height+personInfoView.frame.origin.y, DEVW, (DEVH-BOTTOM_H)*0.5/5) andcolor:nil addtoview:self.view andparentvc:self isadption:NO];
    
    [FuncPublic instanceview:CGRectMake(0, tabbarView.frame.size.height+tabbarView.frame.origin.y, DEVW, 2) andcolor:[UIColor colorWithRed:117./255. green:117./255. blue:117./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
    
    float barwidth = DEVW/4;
    NSArray *titlearr = @[@"我的积分",@"积分处理",@"报试压",@"下订单"];
    for(int i =1;i<5;i++)
    {
        [FuncPublic instanceview:CGRectMake(barwidth *i, 2, 1, tabbarView.frame.size.height-4) andcolor:[UIColor grayColor] addtoview:tabbarView andparentvc:self isadption:NO];
     UIButton *btn =   [FuncPublic instaceImageAndTitleButton:CGRectMake(barwidth *(i-1), 0, barwidth, tabbarView.frame.size.height) nomalImage:nil selectImage:nil imageEdgeinset:UIEdgeInsetsMake(0, 0, 0, 0) titleStr:titlearr[i-1] titlefont:[UIFont systemFontOfSize:14] strAlignment:1 nomalColor:[UIColor blackColor] selectColor:[UIColor redColor] titleEdgeinset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [tabbarView addSubview:btn];
    }
    
 UIView *jifView =   [FuncPublic instanceview:CGRectMake(0, tabbarView.frame.size.height+tabbarView.frame.origin.y, DEVW, tabbarView.frame.size.height) andcolor:nil addtoview:self.view andparentvc:self isadption:NO];
    [FuncPublic instanceview:CGRectMake(0, jifView.frame.size.height+jifView.frame.origin.y-2, DEVW, 1) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    
    UIView *ItemView = [FuncPublic instanceview:CGRectMake(0, jifView.frame.origin.y+jifView.frame.size.height, DEVW, (DEVH-BOTTOM_H)*3/5) andcolor:[UIColor redColor] addtoview:self.view andparentvc:self isadption:NO];
    ItemView.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
