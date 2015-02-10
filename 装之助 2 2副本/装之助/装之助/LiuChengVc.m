//
//  LiuChengVc.m
//  装之助
//
//  Created by caiyc on 14/11/4.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "LiuChengVc.h"
#import "DSBottomPullToMoreManager.h"

@interface LiuChengVc ()<UITableViewDataSource,UITableViewDelegate,DSBottomPullToMoreManagerClient,UIWebViewDelegate>
{
    UITableView *listTable;
    BOOL isSelect;
    UITableView *slidTable;
    UIWebView *webview;
     DSBottomPullToMoreManager *pullToMore;
    UIView *contentView;
   
    
    NSIndexPath *_indexpath;
    NSArray *dataSource;
    int selectIndex;
}
@end

@implementation LiuChengVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectIndex = 0;
    dataSource = [NSArray array];
    dataSource = @[@"量房",@"设计",@"打墙",@"选材",@"水电",@"试压",@"泥瓦",@"木工",@"油漆",@"收尾"];
    _indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
   
   // [FuncPublic InstanceNavgationBar:@"流程" action:nil superclass:self isroot:YES];
    [self initContenViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)initContenViews
{
   
    //主界面是一个webview
    contentView = [FuncPublic instanceview:self.view.bounds andcolor:nil addtoview:self.view andparentvc:self isadption:NO];
     UIView *topview =  [FuncPublic instanceview:CGRectMake(0, 0, DEVW, 60) andcolor:[UIColor grayColor] addtoview:contentView andparentvc:self isadption:NO];
    
    [FuncPublic InstanceLabel:@"量房" RECT:CGRectMake(0, 0, DEVW, 60) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:topview Lines:0 TAG:13 Ailgnment:1];
    
    [FuncPublic InstanceButton:@"菜单" ect:@"png" FileName2:nil
                          ect2:nil RECT:CGRectMake(20, 20, 30, 30) AddView:topview ViewController:self SEL_:@selector(selectType:) Kind:1 TAG:4334 isadption:NO];
    
    webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+40, DEVW, DEVH-NAVBAR_H-40-BOTTOM_H)];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
   // NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [webview loadRequest:request];
  
    webview.delegate = self;
   // webview.backgroundColor = [UIColor orangeColor];
    [contentView addSubview:webview];
    
   
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContent)];
    [contentView addGestureRecognizer:taps];
    //侧边选项栏
    UIView *slidView =  [FuncPublic instanceview:CGRectMake(-100, 0,100 , DEVH) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    [FuncPublic InstanceImageView:@"步骤" Ect:@"png" RECT:CGRectMake(10, 20, 30, 30) Target:slidView TAG:122 isadption:NO];
    [FuncPublic InstanceLabel:@"步骤" RECT:CGRectMake(45,20 , 55, 30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:slidView Lines:0 TAG:12334 Ailgnment:2];
    slidView.tag = 1004;
    slidView.alpha = .9;
    UIScrollView *backscro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50,slidView.frame.size.width, slidView.frame.size.height)];
    backscro.contentSize = CGSizeMake(backscro.frame.size.width, 50*15);
    
    slidTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, slidView.frame.size.width, slidView.frame.size.height) style:UITableViewStylePlain];
    slidTable.delegate = self;
    slidTable.dataSource = self;
    slidTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [slidView addSubview:slidTable];
    
    
  //  [FuncPublic InstanceLabel:@"测试" RECT:CGRectMake(0, 0, 100, 40) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:slidView Lines:0 TAG:11 Ailgnment:1];
    
    
}
-(void)tapContent
{
    isSelect=YES;
    [self selectType:nil];
}
-(void)selectType:(UIButton *)click
{
    isSelect = !isSelect;
    UIView *views = (UIView *)[self.view viewWithTag:1004];
    
    
    [UIView animateWithDuration:.7 animations:^{
        views.frame = isSelect? CGRectMake(0, 0, views.frame.size.width, views.frame.size.height):CGRectMake(-100, 0, views.frame.size.width, views.frame.size.height);
        contentView.frame = isSelect? CGRectMake(100, 0, DEVW-100, DEVH):CGRectMake(0, 0, DEVW, DEVH);
    } completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];;
        
    }
    if(tableView==slidTable)
    {
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.textAlignment = 1;
    }
    
   
    [FuncPublic instanceview:CGRectMake(0, (tableView==listTable?99:39), tableView.frame.size.width, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:cell.contentView andparentvc:self isadption:NO];
    //默认选中第一行
    
    
    if ([_indexpath compare:indexPath] == NSOrderedSame && _indexpath != nil) {
        
        //红色字体，背景选中图片,
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        
        cell.textLabel.textColor = [UIColor blackColor];
        
    }

  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectIndex = indexPath.row+1;
    [self selectType:nil];
    [self changeContent];
    NSLog(@"选择的流程----%@",dataSource[indexPath.row]);
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
       cell.textLabel.textColor = [UIColor redColor];
    
    if (_indexpath != nil) {
        
        if ([_indexpath compare:indexPath] != NSOrderedSame){
            
            UITableViewCell *deselectCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:_indexpath];
            deselectCell.textLabel.textColor = [UIColor blackColor];
            
        }
        
        
    }
    _indexpath = indexPath;


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView==listTable?100:40;
}
-(void)changeContent
{
    NSURL *url = [NSURL URLWithString:@"http://wwww.sina.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
}
//webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[FuncPublic SharedFuncPublic]StartActivityAnimation:self];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[FuncPublic SharedFuncPublic]StopActivityAnimation];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[FuncPublic SharedFuncPublic]StopActivityAnimation];
    [WToast showWithText:@"加载失败，稍后重试"];
}
#pragma mark LoadMore Handel
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToMore relocatePullToMoreView];
    [pullToMore tableViewScrolled];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [pullToMore tableViewReleased];
}
//加载更多的处理方法
-(void)bottomPullToMoreTriggered:(DSBottomPullToMoreManager *)manager
{
    DLog(@"加载更多中...........");
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
