//
//  MainVc.m
//  装之助
//
//  Created by caiyc on 14/11/4.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "MainVc.h"
#import "UIImageView+webimage.h"
#import "CityListVc.h"
#import "CustomyVc.h"
#import "EffectVc.h"
#import "SVHTTPRequest.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "RoomFitVc.h"
#import "TaskDistubVc.h"
#import "ComunicateCenterVc.h"
#import "SetVc.h"
#import "MapVc.h"
#import <QuartzCore/QuartzCore.h>
@interface MainVc ()<UIScrollViewDelegate>

@end

@implementation MainVc
-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor,
                       (id)[UIColor grayColor].CGColor,
                       (id)[UIColor whiteColor].CGColor,nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetUi) name:@"changecity" object:nil];
    //导航栏配置
    [FuncPublic InstanceNavgationBar:@"装之助" action:nil superclass:self isroot:YES];
    NSString *cityname= nil;
    if([FuncPublic GetDefaultInfo:@"cityName"])
        cityname = [FuncPublic GetDefaultInfo:@"cityName"];
    else
    {cityname = @"南昌";}
    [FuncPublic InstanceLabel:cityname RECT:CGRectMake(20, 20, 30, 30) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:self.view Lines:0 TAG:-1 Ailgnment:2];
    
    [FuncPublic InstanceImageView:@"downl" Ect:@"png" RECT:CGRectMake(62, 27, 15, 15) Target:self.view TAG:1345 isadption:NO];
    
   // [FuncPublic InstanceButton:nil Ect:nil RECT:CGRectMake(10, 20, 80, 30) AddView:self.view ViewController:self SEL_:@selector(btncklicks:) Kind:1 TAG:10300 isadption:NO];
    [FuncPublic instaceSimpleButton:CGRectMake(10, 20, 80, 30) andtitle:nil addtoview:self.view parentVc:self action:@selector(btncklicks:) tag:10300];
    
    [self initContentView];
}
-(void)resetUi
{
    UILabel *label =(UILabel *)[self.view viewWithTag:-1];
    
    label.text = [FuncPublic GetDefaultInfo:@"cityName"];
}
-(void)initContentView
{
    
    float flashheight = (DEVH-NAVBAR_H-BOTTOM_H)/4;//广告的相对高度
    
    UIView *flashview =  [FuncPublic instanceview:CGRectMake(0, NAVBAR_H, DEVW, flashheight*0.8) andcolor:[UIColor orangeColor] addtoview:self.view andparentvc:self isadption:NO];//广告的视图
    
    flashview.tag = 23;
    
    UIScrollView *flashscro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVW, flashheight*0.8)];
    
    flashscro.delegate = self;
    
    flashscro.tag = 1233;
    
    [flashview addSubview:flashscro];
    
    //异步加载图片
    dispatch_async(dispatch_queue_create("dsd", nil), ^{
        [self getFlash];
    });
   
    
    NSArray *itemlablearr = @[@"裸妆图",@"效果图",@"家居",@"交流中心",@"任务发布",@"设置"];
    
  UIView * maincontent = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H+flashheight, DEVW, flashheight*1.5) andcolor:nil addtoview:self.view andparentvc:self isadption:NO];//功能区1的view
    
    UIView *maincontent2 = [FuncPublic instanceview:CGRectMake(0, maincontent.frame.origin.y+maincontent.frame.size.height+flashheight*.2, DEVW, flashheight*1.3-3) andcolor:nil addtoview:self.view andparentvc:self isadption:NO];//功能区2的view
    maincontent2.tag = 54;
    
    //功能区1的内容
    float widths = maincontent.frame.size.width/3;
    
    float heighs = maincontent.frame.size.height/2;
    
  //  NSLog(@"item width is%f,height is%f",widths,heighs);
    
    int itemwidth;//items的大小
    
    int fontsizes;//字体大小
    
    if(ISIPHONE4) {itemwidth = 45;
        fontsizes=11;}
    
    else if(ISIPHONE5){itemwidth = 55;
        fontsizes=13;}
    
    else {
        itemwidth=70;
    fontsizes=15;}
    
    for(int i=0;i<6;i++)
    {
     UIView *itemviews = [FuncPublic  instanceview:CGRectMake(i%3*widths, i/3*heighs+5, widths, heighs) andcolor:nil addtoview:maincontent andparentvc:self isadption:NO];

        UIButton *itembuttons = [FuncPublic InstanceButton:[NSString stringWithFormat:@"mainitem%d",i+1] ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake((itemviews.frame.size.width-itemwidth)/2, 0, itemwidth, itemwidth) AddView:itemviews ViewController:self SEL_:@selector(btncklicks:) Kind:1 TAG:i+1024 isadption:NO];
        [FuncPublic InstanceLabel:itemlablearr[i] RECT:CGRectMake(itembuttons.frame.origin.x, itemwidth, itemwidth, 24) FontName:nil Red:0 green:0 blue:0 FontSize:fontsizes Target:itemviews Lines:0 TAG:i+353 Ailgnment:1];

    }
    
    //功能区2的内容
    NSArray *labelarr = @[@"我要装修",@"我要定制家具",@"附近装修公司"];
    
    float singleviewheight=maincontent2.frame.size.height/3;
    
  //  NSLog(@"功能区2的宽度：%f",singleviewheight);
    for(int i =6;i<9;i++)
    {
        [FuncPublic instanceview:CGRectMake(10, singleviewheight*(i-6), DEVW-20, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:maincontent2 andparentvc:self isadption:NO];//分隔线
        
        [FuncPublic InstanceImageView:[NSString stringWithFormat:@"mainitem%d",i+1] Ect:@"png" RECT:CGRectMake(20, singleviewheight*(i-6)+2, singleviewheight-4, singleviewheight-4) Target:maincontent2 TAG:i+21 isadption:NO];//功能图标
        
        [FuncPublic InstanceLabel:labelarr[i-6] RECT:CGRectMake(singleviewheight+20+20, singleviewheight*(i-6)+5, 150, singleviewheight-10) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:maincontent2 Lines:1 TAG:i+10233 Ailgnment:2];//功能名字
        
        [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(DEVW-40, singleviewheight*(i-6)+(singleviewheight-15)/2, 15, 15) Target:maincontent2 TAG:5476547 isadption:NO];//向右选中图标
        
       // [FuncPublic InstanceButton:nil Ect:nil RECT:CGRectMake(0, singleviewheight*(i-6), DEVW, singleviewheight) AddView:maincontent2 ViewController:self SEL_:@selector(btncklicks:) Kind:1 TAG:i+1024 isadption:NO];
        [FuncPublic instaceSimpleButton:CGRectMake(0, singleviewheight*(i-6), DEVW, singleviewheight) andtitle:nil addtoview:maincontent2 parentVc:self action:@selector(btncklicks:) tag:i+1024];
    }
}
-(void)getFlash
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"banner" forKey:@"mod"];
    
    [SVHTTPRequest GET:@"/banner_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
      //  NSDictionary *dic = [response JSONValue];
        
        if(error!=nil)
            return ;
        else
        {
            NSArray *arrs = [response objectForKey:@"Film"];
            
            UIScrollView *flashScro =(UIScrollView *)[self.view viewWithTag:1233];
            
            flashScro.contentSize = CGSizeMake(DEVW*arrs.count, flashScro.frame.size.height);
            
            UIColor *colcos;
            
            for(int i =0;i<arrs.count;i++)
            {
                UIImageView *iamge = [[UIImageView alloc]initWithFrame:CGRectMake(DEVW*i, 0, DEVW, flashScro.frame.size.height)];
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[arrs objectAtIndex:i]objectForKey:@"pic"]]];
                
                [iamge setImageWithURL:url];
                
                [flashScro addSubview:iamge];
                
                if(i==0)colcos = [UIColor redColor];
              
                else colcos = [UIColor grayColor];
                
                UIView *flashview = (UIView *)[self.view viewWithTag:23];
                
                UIView *pageviews = [FuncPublic instanceview:CGRectMake(30+10*i, flashScro.frame.size.height-10, 8, 4) andcolor:colcos addtoview:flashview andparentvc:self isadption:NO];
                
                            pageviews.tag = i+1024;
            }
            
        }
    }];
}
-(void)btncklicks:(UIButton *)sender
{
    switch (sender.tag) {
            case 1024:
        {
            EffectVc *effectVc = [[EffectVc alloc]init];
            effectVc.titleStr = @"装修图";
            [self.navigationController pushViewController:effectVc animated:NO];
        }
            break;
            case 1025:
        {
            EffectVc *effectVc = [[EffectVc alloc]init];
            effectVc.titleStr = @"效果图";
            [self.navigationController pushViewController:effectVc animated:NO];
        }
            break;
            case 1026:
        {
           RoomFitVc *roomFitVc = [[RoomFitVc alloc]init];
            [self.navigationController pushViewController:roomFitVc animated:NO];
        }
            break;
        case 1031:
        {
            CustomyVc *customyVc = [[CustomyVc alloc]init];
            customyVc.titlestring=@"我要定制";
            [self.navigationController pushViewController:customyVc animated:NO];
        }
            break;
        case 1030:
        {
            CustomyVc *customyVc = [[CustomyVc alloc]init];
            customyVc.titlestring=@"我要装修";
            [self.navigationController pushViewController:customyVc animated:NO];
        }
            break;
            case 1027:
        {
            ComunicateCenterVc *conVc = [[ComunicateCenterVc alloc]init];
            [self.navigationController pushViewController:conVc animated:NO];
        }
            break;
            case 1028:
        {
            TaskDistubVc *taskVc = [[TaskDistubVc alloc]init];
            [self.navigationController pushViewController:taskVc animated:NO];
        }
            break;
            case 1029:
        {
            SetVc *vc = [[SetVc alloc]init];
            [self.navigationController pushViewController:vc animated:NO];
        }
            break;
            case 1032:
        {
            NSLog(@"附近装修公司");
            MapVc *vc = [[MapVc alloc]init];
            [self.navigationController pushViewController:vc
                                                 animated:NO];
        }
            break;
        default:
            break;
    }
   
    
   
    
   
  if(sender.tag>=1030)
  {
      UIView *viewss = [(UIView *)self.view viewWithTag:54];
      UIView *views = [FuncPublic instanceview:sender.frame andcolor:[UIColor blueColor] addtoview:viewss andparentvc:self isadption:NO];
      views.alpha = .4;
      [self performSelector:@selector(missview:) withObject:views afterDelay:.3];
  }
    if(sender.tag ==10300)
    {
        CityListVc *citylist = [[CityListVc alloc]init];
        [self.navigationController pushViewController:citylist animated:YES];
    }
   // NSLog(@"click....%d",sender.tag-1024);
    
}
-(void)missview:(UIView *)vv
{
    [vv removeFromSuperview];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int pagenum = scrollView.contentOffset.x/DEVW;
    
    UIView *views = [self.view viewWithTag:23];
    
    for(UIView *viewss in views.subviews)
    {
        if(viewss.tag==1024+pagenum)viewss.backgroundColor = [UIColor redColor];
        
        else viewss.backgroundColor = [UIColor grayColor];
    }
    
    
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
