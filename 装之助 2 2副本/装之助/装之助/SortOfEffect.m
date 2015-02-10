//
//  SortOfEffect.m
//  装之助
//
//  Created by caiyc on 14/11/12.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "SortOfEffect.h"
#import "CustomButon.h"
#define LISTHEIGH 50
#define LEFTMAXTAG 500
#define RIGHTMAXTAG 5000
@interface SortOfEffect ()
{
    NSMutableArray *btnarr;
    NSArray *titlearr;
    UIScrollView *lefeScro;
    NSArray *rightArr;
    UIScrollView *rightScro;
    NSMutableArray *rightBtnArr;
    NSString *funcStr;
    NSString *styleStr;
    NSMutableDictionary *styleDic;
    NSMutableDictionary *GnDic;
}
@end

@implementation SortOfEffect

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *temparr1 = @[@"不限",@"现代",@"简欧",@"简约",@"中式",@"欧式",@"田园",@"地中海",@"混搭",@"美式",@"日韩",@"东南亚",@"古典"];
    NSArray *temparr2=@[@"-1",@"2",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    styleDic = [NSMutableDictionary dictionaryWithObjects:temparr2 forKeys:temparr1];
    temparr1 = @[@"不限",@"客厅",@"卧室",@"厨房",@"阳台",@"卫生间",@"书房",@"玄关",@"儿童间",@"衣帽间"];
    temparr2 = @[@"-1",@"1",@"3",@"4",@"6",@"7",@"8",@"9",@"10",@"11"];
    GnDic = [NSMutableDictionary dictionaryWithObjects:temparr2 forKeys:temparr1];
    titlearr = [GnDic allKeys];
    
    rightArr = [styleDic allKeys];
    
    [FuncPublic InstanceNavgationBar:@"分类" action:@selector(back) superclass:self isroot:NO];
    
    [FuncPublic InstanceLabel:@"完成" RECT:CGRectMake(DEVW-70, 20, 40, 30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:self.view Lines:0 TAG:324 Ailgnment:2];
    
    
    [FuncPublic instaceSimpleButton:CGRectMake(DEVW-70, 20, 70, 30) andtitle:nil addtoview:self.view parentVc:self action:@selector(selectDone:) tag:434];
    self.view.backgroundColor = [UIColor whiteColor];
    
    lefeScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+50, DEVW/2, DEVH-NAVBAR_H-50)];
    
    [self.view addSubview:lefeScro];
    
    rightScro = [[UIScrollView alloc]initWithFrame:CGRectMake(DEVW/2, NAVBAR_H+50, DEVW/2, DEVH-NAVBAR_H-50)];
    
    [self.view addSubview:rightScro];
   // rightScro.backgroundColor = [UIColor redColor];
    [self initContentView];
    // Do any additional setup after loading the view.
}
-(void)initContentView
{
    [FuncPublic instanceview:CGRectMake(DEVW/2, NAVBAR_H+2, 1, DEVH-NAVBAR_H) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:self.view  andparentvc:self isadption:NO];
    
  UIView *tempView =  [FuncPublic instanceview:CGRectMake(0, NAVBAR_H, DEVW, 50) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
    
    NSArray *tempArr = @[@"功能间",@"风格"];
    
    for(int i =0;i<2;i++)
    {
        [FuncPublic InstanceLabel:tempArr[i] RECT:CGRectMake(DEVW/2*i, 10, DEVW/2, 30) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:tempView Lines:0 TAG:4+i Ailgnment:1];
    }
    //功能间列表布局
    btnarr = [NSMutableArray array];
    
    lefeScro.contentSize = CGSizeMake(lefeScro.frame.size.width, LISTHEIGH*titlearr.count);
    
    for(int i =0;i<titlearr.count;i++)
    {
    CustomButon *btn = [[CustomButon alloc]initWithFrame:CGRectMake(40, 50*i+10, DEVW/2-50, 30)];
        
    btn.tag = i+LEFTMAXTAG;
        
    btn.btnTitle = titlearr[i];
        
    [lefeScro addSubview:btn];
        
    [FuncPublic instaceSimpleButton:CGRectMake(40, 50*i, DEVW/2, 50) andtitle:nil addtoview:lefeScro parentVc:self action:@selector(CLICK:) tag:i+LEFTMAXTAG*2];
        
        [btnarr addObject:btn];
        
        [FuncPublic instanceview:CGRectMake(40, 49+50*i, DEVW/2-50, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:lefeScro andparentvc:self isadption:NO];
    }
    //风格的列表布局
    rightBtnArr = [NSMutableArray array];
    
    rightScro.contentSize = CGSizeMake(rightScro.frame.size.width, LISTHEIGH*rightArr.count);
    
  //  DLog(@"right arrcount is%ld",rightArr.count);
    
    for(int i =0;i<rightArr.count;i++)
    {
        
        CustomButon *btn = [[CustomButon alloc]initWithFrame:CGRectMake(40, 50*i+10, DEVW/2-50, 30)];
        
        btn.tag = i+RIGHTMAXTAG;
        
        btn.btnTitle = rightArr[i];
       
        [rightScro addSubview:btn];
        
        [FuncPublic instaceSimpleButton:CGRectMake(40, 50*i, DEVW/2, 50) andtitle:nil addtoview:rightScro parentVc:self action:@selector(CLICKS:) tag:i+RIGHTMAXTAG*2];
        
        [rightBtnArr addObject:btn];
        
        [FuncPublic instanceview:CGRectMake(40, 49+50*i, DEVW/2-50, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:rightScro andparentvc:self isadption:NO];
        
        [rightBtnArr addObject:btn];
    }
    
}
-(void)CLICKS:(UIButton *)click
{
    long int Tag = click.tag-RIGHTMAXTAG*2;
    
    styleStr = rightArr[Tag];
    
    [rightBtnArr enumerateObjectsUsingBlock:^(CustomButon * btn,
                                         NSUInteger idx, BOOL *stop) {
        if(btn.tag==RIGHTMAXTAG+Tag)btn.isSelect = YES;
        
        else btn.isSelect = NO;
        
    }];
}
-(void)CLICK:(UIButton *)clcik
{
    
    long int Tag = clcik.tag-LEFTMAXTAG*2;
    
    funcStr = titlearr[Tag];
    
    [btnarr enumerateObjectsUsingBlock:^(CustomButon * btn,
                                         NSUInteger idx, BOOL *stop) {
        if(btn.tag==LEFTMAXTAG+Tag)btn.isSelect = YES;
        
        else btn.isSelect = NO;

    }];

}
-(void)selectDone:(UIButton *)click
{
    [WToast showWithText:[NSString stringWithFormat:@"功能间选择：%@，风格间选择：%@",funcStr,styleStr]];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
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
