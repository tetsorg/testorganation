//
//  MyDistubTasksVc.m
//  装之助
//
//  Created by caiyc on 14/12/16.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "MyDistubTasksVc.h"
#import "TaskCell.h"
#import "UIImageView+webimage.h"
#import "DSBottomPullToMoreManager.h"
#import "TaskModel.h"
#import "TaskDetailVc.h"
#define PAGE_SUM 8
@interface MyDistubTasksVc ()<UITableViewDataSource,UITableViewDelegate,DSBottomPullToMoreManagerClient,UIGestureRecognizerDelegate>
{
    UITableView *taskTab;
     DSBottomPullToMoreManager *pullToMore;
    int pagenum;
    NSMutableArray *dataSource;
    UIView *coverviews;
    BOOL isrecived;
}

@end

@implementation MyDistubTasksVc

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray array];
    pagenum = 1;
    [FuncPublic InstanceNavgationBar:@"我的任务" action:@selector(back) superclass:self
                              isroot:NO];
    taskTab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+1, DEVW, DEVH-NAVBAR_H-1) style:UITableViewStylePlain];
    taskTab.delegate = self;
    taskTab.dataSource = self;
    taskTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //taskTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:taskTab];
    pullToMore = [[DSBottomPullToMoreManager alloc]initWithPullToMoreViewHeight:60.0f tableView:taskTab withClient:self];
    [pullToMore setPullToMoreViewVisible:YES];
    
    [FuncPublic instaceSimpleButton:CGRectMake(DEVW-120, 20, 100, 30) andtitle:@"我发布的任务" addtoview:self.view parentVc:self action:@selector(clickTask:) tag:102];
    [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(DEVW-20, 27, 15, 15) Target:self.view TAG:5435 isadption:NO];
    
    //查看大图图层
    
    
    coverviews = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H-BOTTOM_H) andcolor:[UIColor whiteColor] addtoview:self.view andparentvc:self isadption:NO];
    coverviews.hidden = 1;
    
    UIScrollView *imageScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVW, coverviews.frame.size.height)];
    [coverviews addSubview:imageScro];
    imageScro.contentSize = CGSizeMake(DEVW, imageScro.frame.size.height);
    imageScro.tag = 12324;
    imageScro.backgroundColor = [UIColor blackColor];
    
    // bigImage = [FuncPublic InstanceImageView:nil Ect:nil RECT:CGRectMake(0, 50, DEVW, coverviews.frame.size.height-100) Target:coverviews TAG:122 isadption:NO];
    
    //  [FuncPublic InstanceButton:@"delete" ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake(DEVW-50, 10, 30, 30) AddView:coverviews ViewController:self SEL_:@selector(tapViews:) Kind:1 TAG:1381294 isadption:NO];
    
    [self.view addSubview:coverviews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViews:)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;

    
    [self getdata];
    // Do any additional setup after loading the view.
}
-(void)clickTask:(UIButton *)click
{
    UIView *views = [FuncPublic instanceview:CGRectMake(DEVW-100, NAVBAR_H, 100, 80) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    views.tag = 1133;
    NSArray *titles = @[@"我发布的任务",@"我接受的任务"];
    for(int i =0;i<2;i++)
    {
        [ FuncPublic instaceSimpleButton:CGRectMake(0, 40*i, 100, 40) andtitle:titles[i] addtoview:views parentVc:self action:@selector(selecttype:) tag:i+100];
    }

}
-(void)selecttype:(UIButton *)click
{
    UIView *v = (UIView *)[self.view viewWithTag:1133];
    [v removeFromSuperview];
    if(click.tag==100)
    {
        isrecived = 0;
        pagenum = 1;
    }
    else
    {
        pagenum = 1;
        isrecived = 1;
        
    }
    [self getdata];
  //  NSString *keys = [sortDic allKeys][click.tag-100];
  //  NSString *values = [sortDic objectForKey:keys];
   // NSLog(@"选中合格的分类是%@",values);
}
-(void)getdata
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   // [dic setObject:@"阿" forKey:@"title"];
   // [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];
   // [dic setObject:[FuncPublic GetDefaultInfo:@"cid"] forKey:@"city"];
    [dic setObject:[NSString stringWithFormat:@"%i",PAGE_SUM] forKey:@"page_sum"];
    
    [dic setObject:[NSString stringWithFormat:@"%i",pagenum] forKey:@"page"];
    
    [dic setObject:@"task" forKey:@"mod"];
    
    if(isrecived)
    {
        [dic setObject:@"ctask" forKey:@"mods"];
        [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"worker"];
    }
    else [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];
    [SVHTTPRequest GET:@"/banner_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        DLog(@"我的任务数据%@",response);
        DLog(@"任务的url----%@",urlResponse);
        [pullToMore tableViewReloadFinished];
        NSArray *arr = [response objectForKey:@"tasklist"];
        if(pagenum==1)
          [ dataSource removeAllObjects];
        for(int i=0;i<arr.count;i++)
        {
            NSDictionary *dictions = arr[i];
            
            TaskModel *model = [[TaskModel alloc]init];
            
            model.name = [dictions objectForKey:@"name"];
            model.titles = [dictions objectForKey:@"title"];
            model.status = [dictions objectForKey:@"state"];
            model.price = [dictions objectForKey:@"price"];
            model.uids = [dictions objectForKey:@"uid"];
            model.type = [dictions objectForKey:@""];
            model.contactPeople = [dictions objectForKey:@"cname"];
            model.contactNum = [dictions objectForKey:@"phone"];
            model.areas = [dictions objectForKey:@"area"];
            model.huXing = [dictions objectForKey:@"units"];
            model.address = [dictions objectForKey:@"adds"];
            model.xiangXiSM = [dictions objectForKey:@"content"];
            model.evalution = [dictions objectForKey:@"evaluation"];
            model.time = [dictions objectForKey:@"time"];
            model.type = [dictions objectForKey:@"fitmentclass"];
            
            
            NSString *recieve = [dictions objectForKey:@"worker"];
            if([recieve isEqualToString:@""])
            {
                model.isrecieve = NO;
            }
            else
            {
                model.isrecieve = YES;
            }
            
            if([[dictions objectForKey:@"pic"] rangeOfString:@","].location !=NSNotFound)//_roaldSearchText
            {
                NSLog(@"yes");
                model.imageArr = [[dictions objectForKey:@"pic"]componentsSeparatedByString:@","];
                model.imageurl = model.imageArr[0];
            }
            else
            {
                NSLog(@"no");
                model.imageurl = [dictions objectForKey:@"pic"];
            }
            
            model.ids = [dictions objectForKey:@"id"];
            [dataSource addObject:model];
            
        }
        
        pagenum++;
        
        [taskTab reloadData];

        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    
        TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell = [[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            
        }
        TaskModel *model = [dataSource objectAtIndex:indexPath.row];
        if(![model.imageurl isEqualToString:@""])
        {
            NSString *picurl =[NSString stringWithFormat:@"%@", model.imageurl];
            
            [cell.images setImageWithURL:[NSURL URLWithString:picurl]];
        }
        else
        {
            cell.images.image = [UIImage imageNamed:@"笑脸-2"];
        }
        cell.images.contentMode = UIViewContentModeScaleAspectFit;
        cell.titleLabel.text = model.titles;
        cell.addressLabel.text = model.address;
        cell.priceLabel.text = model.price;
        
        
        //  cell.typeLable.text = @"一室一厅";
        NSString *states = model.status;
        states = [states integerValue]==0?@"未结束":@"已结束";
        cell.subLabel.text = states;
        //  cell.priceLabel.text = @"200元";
        cell.priceLabel.textColor = [UIColor colorWithRed:255./255. green:86./255. blue:86./255. alpha:1];
        cell.clcikBtn.tag = indexPath.row;
        [cell.clcikBtn addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
      //  cell.selectedBackgroundView.backgroundColor = color;
        return cell;
//    static NSString *cellid = @"cell";
//    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    if(!cell)
//    {
//        cell = [[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//    }
//    NSString *str = @"http://172.16.1.92:83/userdailyimages/2014016/20141212/164428.jpg";
//    
//    [cell.images setImageWithURL:[NSURL URLWithString:str]];
//    cell.titleLabel.text = @"美女";
//    cell.addressLabel.text = @"地址:火炬广场189号";
//    cell.typeLable.text = @"的撒加福克斯";
//    cell.subLabel.text = @"的就撒了看到了撒考虑到";
//    cell.priceLabel.text = @"400";
//    cell.priceLabel.textColor = [UIColor colorWithRed:255./255. green:86./255. blue:86./255. alpha:1];
//
//    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskDetailVc *vc = [[TaskDetailVc alloc]init];
    TaskModel *model = [dataSource objectAtIndex:indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:NO];
}
//点击图片预览
-(void)clickImage:(UIButton *)click
{
    
    coverviews.hidden = NO;
    
    TaskModel *model = dataSource[click.tag];
    UIScrollView *scro = (UIScrollView *)[self.view viewWithTag:12324];
    if([model.imageArr count]>0)
    {
        scro.contentSize = CGSizeMake(DEVW*model.imageArr.count, scro.frame.size.height);
        for(int i =0;i<model.imageArr.count;i++)
        {
            UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(DEVW*i, 0, DEVW, scro.frame.size.height)];
            [images setImageWithURL:[NSURL URLWithString:model.imageArr[i]] placeholderImage:nil];
            images.contentMode = UIViewContentModeScaleAspectFit;
            [scro addSubview:images];
        }
    }
    else
    {
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVW, scro.frame.size.height)];
        [images setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:nil];
        images.contentMode = UIViewContentModeScaleAspectFit;
        [scro addSubview:images];
        
    }
    //  NSString *imageurl = [NSString stringWithFormat:@"%@",model.imageurl];
    // [bigImage setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:nil];
    
}
-(void)tapViews:(UITapGestureRecognizer *)gesture
{
    coverviews.hidden = YES;
    UIView *v = (UIView *)[self.view viewWithTag:1002333];
    if(v)
        [UIView animateWithDuration:.5 animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
    [v removeFromSuperview];
    
}
//tableview 点击和手势冲突解决办法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [pullToMore tableViewScrolled];
    [pullToMore relocatePullToMoreView];
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [pullToMore tableViewReleased];
}
//加载更多的处理方法
-(void)bottomPullToMoreTriggered:(DSBottomPullToMoreManager *)manager
{
    DLog(@"加载更多中...........");
    [self getdata];
   // [self getData];
    //    page = 1;
    //    [self getDataList];
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
