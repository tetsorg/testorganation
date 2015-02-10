//
//  SetVc.m
//  装之助
//
//  Created by caiyc on 14/12/9.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "SetVc.h"
#import "SDImageCache.h"
#define ROWHEIGH 40
@interface SetVc ()
{
    UILabel *cacheLb;
}
@end

@implementation SetVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1];
    [FuncPublic InstanceNavgationBar:@"设置" action:@selector(back) superclass:self isroot:NO];
    [self initContentViews];
    //[self initContentViews];
    
    // Do any additional setup after loading the view.
}
-(void)initContentViews
{
  
    UIView *view1 =  [FuncPublic instanceview:CGRectMake(10, NAVBAR_H+20, DEVW-20, ROWHEIGH) andcolor:[UIColor colorWithRed:250./255. green:250./255. blue:250./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
    
    [FuncPublic InstanceLabel:@"接收推送消息" RECT:CGRectMake(10,0,200,40) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:view1 Lines:1 TAG:2 Ailgnment:2];
    
    UISwitch *sw = [[UISwitch alloc]initWithFrame:CGRectMake(DEVW-80, 5, 80, 30)];
    
    sw.On = 1;
    
    [view1 addSubview:sw];
    
    [sw addTarget:self action:@selector(changenotifer:) forControlEvents:UIControlEventValueChanged];
    
    NSArray *titles = @[@"关于我们",@"使用帮助",@"技术支持"];
    
    for(int i=0;i<3;i++)
    {
     UIView *view2 =   [FuncPublic instanceview:CGRectMake(10, NAVBAR_H+40+ROWHEIGH+(ROWHEIGH+1)*i, DEVW-20, ROWHEIGH) andcolor:[UIColor colorWithRed:250./255. green:250./255. blue:250./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
        
        [FuncPublic InstanceLabel:titles[i] RECT:CGRectMake(10, 0, 200, 40) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:view2 Lines:1 TAG:100+i Ailgnment:2];
        
        [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(view2.frame.size.width-20, 10, 15, 15) Target:view2 TAG:i+20 isadption:NO];
        
        [FuncPublic instaceSimpleButton:CGRectMake(0, 0, view2.frame.size.width, view2.frame.size.height) andtitle:nil addtoview:view2 parentVc:self action:@selector(selectItem:) tag:i+30];
    }
    
  
    UIView *view3 =  [FuncPublic instanceview:CGRectMake(10, NAVBAR_H+60+ROWHEIGH*4, DEVW-20, ROWHEIGH) andcolor:[UIColor colorWithRed:250./255. green:250./255. blue:250./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
    
    [FuncPublic InstanceLabel:@"获取新版本" RECT:CGRectMake(10,0,150,40) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:view3 Lines:1 TAG:2 Ailgnment:2];
    
     [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(view3.frame.size.width-20, 10, 15, 15) Target:view3 TAG:20 isadption:NO];
    
    [FuncPublic instaceSimpleButton:CGRectMake(0, 0, view3.frame.size.width, view3.frame.size.height) andtitle:nil addtoview:view3 parentVc:self action:@selector(selectNewvis:) tag:10];
    
 
    
    
    
    UIView *view4 =   [FuncPublic instanceview:CGRectMake(10, NAVBAR_H+80+ROWHEIGH*5, DEVW-20, ROWHEIGH) andcolor:[UIColor colorWithRed:250./255. green:250./255. blue:250./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
    
    view4.tag  = 100;
    
    [FuncPublic InstanceLabel:@"清除缓存" RECT:CGRectMake(10,0,150,40) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:view4 Lines:1 TAG:2 Ailgnment:2];
    
    [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(view4.frame.size.width-20, 10, 15, 15) Target:view4 TAG:20 isadption:NO];
    
    float cacheSize = [self getCacheSizeandclear:NO];
    
  cacheLb =  [FuncPublic InstanceLabel:[NSString stringWithFormat:@"%.2fK",cacheSize] RECT:CGRectMake(DEVW-150, 0, 100, 40) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:view4 Lines:1 TAG:12 Ailgnment:3];
    
    [FuncPublic instaceSimpleButton:CGRectMake(0, 0, view4.frame.size.width, view4.frame.size.height) andtitle:nil addtoview:view4 parentVc:self action:@selector(clearCache:) tag:13];
    
    
}
//消息推送开关
-(void)changenotifer:(UISwitch *)sw
{
    
}
//中间三个选项
-(void)selectItem:(UIButton *)click
{
    NSLog(@"tag is %ld",click.tag);
}
//获取新版本
-(void)selectNewvis:(UIButton *)click
{
    DLog(@"获取新版本.....");
}
//清除缓存,应用的所有缓存内容在沙盒路径filedocument下面
-(void)clearCache:(UIButton *)click
{
    NSLog(@"clear caches");
    [self getCacheSizeandclear:YES];
    
    cacheLb.text = @"";
}
-(float)getCacheSizeandclear:(BOOL)clears
{
    float sizen = 0;
    
   NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
//    
//    NSString *fielpath = [fiel stringByAppendingPathComponent:DBName];
//    
   NSFileManager *FMM = [NSFileManager defaultManager];
//    
//    long long size1 = [[FMM attributesOfItemAtPath:fielpath error:nil]fileSize];
//    if(clears)
//    {
//        [FMM removeItemAtPath:fielpath error:nil];
//    }
    NSString *filepath1 = [fiel stringByAppendingPathComponent:@"/FileDocuments"];
    
    
    NSArray *arr = [FMM subpathsAtPath:filepath1];
    
    long long size2 = 0;
    
    for(NSString *str in arr)
    {
        NSString *filefullpath = [filepath1 stringByAppendingPathComponent:str];
        size2+= [[FMM attributesOfItemAtPath:filefullpath error:nil]fileSize];
        //  [FMM removeItemAtPath:filefullpath error:nil];
    }
    

    //图片缓存路径路径,library路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSString *fullpath = [cachesDir stringByAppendingString:@"/ImageCache"];
    
    NSArray *arr1 = [FMM subpathsAtPath:fullpath];
    
    long long size3 = 0;
    
    for(NSString *strs in arr1)
    {
       // NSLog(@"图片的缓存路径:%@",strs);
        
        NSString *imagepath = [fullpath stringByAppendingPathComponent:strs];
        
        size3+= [[FMM attributesOfItemAtPath:imagepath error:nil]fileSize];
        //  NSLog(@"图片的缓存大小:%2.f",size3);
    }
    if(clears)
    {
        [[SDImageCache sharedImageCache]clearDisk];
    }
    
    sizen = (0 + size2 + size3)/1024;
    
    
    
    
    
    
    
    return sizen;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
