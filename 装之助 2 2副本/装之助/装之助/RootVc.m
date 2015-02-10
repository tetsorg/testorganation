//
//  RootVc.m
//  装之助
//
//  Created by caiyc on 14/11/4.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "RootVc.h"
#import "MainVc.h"
#import "LiuChengVc.h"
#import "BrandVc.h"
#import "PersonalVc.h"
#import "MyDbHandel.h"
#import "NSString+SBJSON.h"
#import "SBJSON.h"
@interface RootVc ()
{
    UIImageView *selectimages;//选中框
}
@end

@implementation RootVc
-(void)viewWillAppear:(BOOL)animated
{
    //将系统的tabar隐藏
    self.tabBar.hidden = YES;
    //[self handeldata];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self handeldata];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(missCorver:) name:@"insertFinishs" object:nil];
   // self.selectedIndex = 2;
    [self initview];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
              // [self handeldata];
           });
   // self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)initview
{
    //tabbar自定义构建
  UIView *botomview =  [FuncPublic instanceview:CGRectMake(0, DEVH-BOTTOM_H, DEVW, BOTTOM_H) andcolor:[UIColor darkGrayColor] addtoview:self.view andparentvc:self isadption:NO];
    botomview.alpha = 0.8;
    int itemwidth = DEVW/4;
    selectimages = [FuncPublic InstanceImageView:@"选中框" Ect:@"png" RECT:CGRectMake(8, 0,itemwidth-16 , BOTTOM_H) Target:botomview TAG:1123 isadption:NO];
   // selectimages.contentMode = UIViewContentModeScaleToFill;
   // selectimages.contentMode = UIViewContentModeScaleAspectFill;
    selectimages.backgroundColor = [UIColor blackColor];
    selectimages.layer.cornerRadius=5;
    NSArray *arrs = [NSArray arrayWithObjects:@"首页",@"流程",@"品牌",@"我的家", nil];
    for(int i=0;i<4;i++)
    {
      UIView *itemviews = [FuncPublic instanceview:CGRectMake(itemwidth*i, 0, itemwidth, BOTTOM_H) andcolor:[UIColor clearColor] addtoview:botomview andparentvc:self isadption:NO];
        
        [FuncPublic InstanceImageView:[NSString stringWithFormat:@"item%d",i+1 ] Ect:@"png" RECT:CGRectMake((itemviews.frame.size.width-48)/2, 0, 48, 38) Target:itemviews TAG:i+10023 isadption:NO];
        
        [FuncPublic InstanceLabel:arrs[i] RECT:CGRectMake((itemviews.frame.size.width-48)/2, 38, 48, 12) FontName:nil Red:255 green:255 blue:255 FontSize:14 Target:itemviews Lines:0 TAG:i+1323 Ailgnment:1];
        
       // [FuncPublic InstanceButton:@"" Ect:@"" RECT:CGRectMake(itemwidth*i, 0, itemwidth, BOTTOM_H) AddView:botomview ViewController:self SEL_:@selector(itemclick:) Kind:1 TAG:i+1024 isadption:NO];
        
        [FuncPublic instaceSimpleButton:CGRectMake(itemwidth*i, 0, itemwidth, BOTTOM_H) andtitle:nil addtoview:botomview parentVc:self action:@selector(itemclick:) tag:i+1024];
      
    }
    //tabbar容器
    MainVc *mainVc = [[MainVc alloc]init];
   
    LiuChengVc *liucVc = [[LiuChengVc alloc]init];
    
    BrandVc *brandVc = [[BrandVc alloc]init];
    
    PersonalVc *personVc = [[PersonalVc alloc]init];
    
    UINavigationController *navForMainVc = [[UINavigationController alloc]initWithRootViewController:mainVc];
    navForMainVc.navigationBarHidden = YES;
    
    UINavigationController *navForLiuVc = [[UINavigationController alloc]initWithRootViewController:liucVc];
    navForLiuVc.navigationBarHidden = YES;
    
    UINavigationController *navForBrandVc = [[UINavigationController alloc]initWithRootViewController:brandVc];
    navForBrandVc.navigationBarHidden = YES;
    
    UINavigationController *navForPersonVc = [[UINavigationController alloc]initWithRootViewController:personVc];
    navForPersonVc.navigationBarHidden = YES;
    
    self.viewControllers = [NSArray arrayWithObjects:mainVc,liucVc,brandVc,personVc, nil];
}
-(void)itemclick:(UIButton *)sender
{
    DLog(@"fdsfdsfds");
    self.selectedIndex = sender.tag-1024;
    selectimages.frame = CGRectMake(sender.frame.origin.x+8, selectimages.frame.origin.y, selectimages.frame.size.width, selectimages.frame.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) handeldata
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"jsondata" ofType:@"txt"];
    
    NSString *cityString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *cityDic = [cityString JSONValue];
    
    NSArray *cityarr = [cityDic objectForKey:@"data"];
    
    NSFileManager *fiels = [NSFileManager defaultManager];
    NSString *paths = [NSHomeDirectory()stringByAppendingString:@"/Documents/Citylists.sqlite"];
    
    BOOL exsits = [fiels fileExistsAtPath:paths isDirectory:nil];
    if(exsits)
    {
        return;
    }
    //第一次加载时数据插入
//    UIView *corver = [FuncPublic instanceview:CGRectMake(0, 0, DEVW, DEVH) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
//    corver.alpha = .9;
//    
//    UIActivityIndicatorView *act =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(DEVW/2-20, DEVH/2-20, 40, 40)];
//    [corver addSubview:act];
//    [act startAnimating];
//    [FuncPublic InstanceLabel:@"正在配置应用数据，请不要退出" RECT:CGRectMake(DEVW/2-100,DEVH/2-100,200,30) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:corver Lines:0 TAG:12 Ailgnment:1];
  //  [self performSelector:@selector(missCorver:) withObject:corver afterDelay:7];
    

    [fiels createFileAtPath:path contents:nil attributes:nil];
    
       
    [[MyDbHandel defaultDBManager]openDb:@"Citylists.sqlite"];
    
    NSString *sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id INTEGER,pid INTEGER,name TEXT, pyjx TEXT,py TEXT,sindex TEXT)",NAME];
    
    [[MyDbHandel defaultDBManager]creatTab:sql];
    
    // [[MyDbHandel defaultDBManager]openDb:@"Citys.sqlite"];
    
    for(NSDictionary *dic in cityarr)
    {
        //  NSLog(@"数组数据;;%@",dic);
        
        NSMutableDictionary *dictions = [NSMutableDictionary dictionary];
        
        [dictions setObject:[dic objectForKey:@"id"] forKey:@"id"];
        [dictions setObject:[dic objectForKey:@"pid"] forKey:@"pid"];
        [dictions setObject:[dic objectForKey:@"name"] forKey:@"name"];
        [dictions setObject:[dic objectForKey:@"piny"] forKey:@"py"];
        [dictions setObject:[dic objectForKey:@"pinyjx"] forKey:@"pyjx"];
        NSString *F =[[dic objectForKey:@"pinyjx"]substringWithRange:NSMakeRange(0, 1)];
        [dictions setObject:F forKey:@"sindex"];
        [[MyDbHandel defaultDBManager]insertdata:dictions];
        // [[MyDbHandel defaultDBManager]insertdata:dic];
    }
    //        for(NSString *str in [dic allKeys])
    //        {
    //
    //            NSArray *arr = [dic objectForKey:str];
    //
    //            NSMutableDictionary *dicto = [NSMutableDictionary dictionary];
    //
    //            for(NSDictionary *dicc in arr)
    //            {
    //                [dicto setObject:[dicc objectForKey:@"key"] forKey:@"first"];
    //
    //                [dicto setObject:[dicc objectForKey:@"name"] forKey:@"name"];
    //
    //                NSString *piny = [self phonetic:[dicc objectForKey:@"name"]];
    //
    //                [dicto setObject:piny forKey:@"piny"];
    //
    //                [[MyDbHandel defaultDBManager]insertdata:dicto];
    //
    //            }
    //        }
  //  [self performSelectorOnMainThread:@selector(missCorver:) withObject:corver waitUntilDone:YES modes:nil];
    
}
-(void)missCorver:(NSObject *)obj
{
    DLog(@"插入数据完成-----------------------------");
    UIView *v = (UIView *)obj;
    [v removeFromSuperview];
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
