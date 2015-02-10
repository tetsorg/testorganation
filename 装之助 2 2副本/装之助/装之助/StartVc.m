//
//  StartVc.m
//  装之助
//
//  Created by caiyc on 15/1/12.
//  Copyright (c) 2015年 none. All rights reserved.
//

#import "StartVc.h"
#import "AppDelegate.h"
#import "MyDbHandel.h"
#import "MTMudelDaTa.h"
#import "NSString+SBJSON.h"

@interface StartVc ()

@end

@implementation StartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *corver = [FuncPublic instanceview:CGRectMake(0, 0, DEVW, DEVH) andcolor:[UIColor] addtoview:self.view andparentvc:<#(UIViewController *)#> isadption:<#(BOOL)#>]
    // Do any additional setup after loading the view.
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
    
    //    if(exsits)
    //    {
    //        dispatch_async(dispatch_queue_create("dsd", nil), ^{
    //
    //           // [self performSelector:@selector(getCityData) withObject:nil];
    //
    //        });
    //
    //        //   [self getCityData];
    //      //  return;
    //    }else
    //    {
    
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
