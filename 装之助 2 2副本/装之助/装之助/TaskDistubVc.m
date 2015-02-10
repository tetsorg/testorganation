//
//  TaskDistubVc.m
//  装之助
//
//  Created by caiyc on 14/11/24.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "TaskDistubVc.h"
#import "CityListVc.h"
#import "DistubTaskVc.h"
#import "TaskDetailVc.h"
#import "TaskCell.h"
#import "TaskModel.h"
#import "DSBottomPullToMoreManager.h"
#import "CustomButon.h"
#import "MyDistubTasksVc.h"
#import "UIImageView+webimage.h"
#import "MyDbHandel.h"
#import "MTMudelDaTa.h"
#define PAGE_SUM 8
@interface TaskDistubVc ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,DSBottomPullToMoreManagerClient,UISearchBarDelegate>
{
    UITableView *contentTab;
    UITableView *conditionTab;
    NSMutableArray *MainDataSouce;
    NSMutableArray *conditionArr;
    long int selectId;
    UIButton *selectBtn;
    NSMutableArray *labelArr;
    NSMutableArray *downImageArr;
    UIView *coverView;
    DSBottomPullToMoreManager *pullToMore;
    NSMutableArray *btnArr;
    UIImageView *selectImages;
    int pagenum;
    UIView *coverviews;
    UIImageView *bigImage;
    
    int conditionindex;
    
     NSMutableArray *arrs ;
    
    BOOL refresh;
    
    NSMutableDictionary *reginalDic;
   // NSMutableDictionary *
   // NSString *rids;
    NSString *regionId;
    NSString *typeId;
    NSString *statusId;
    NSString *timeId;
    NSString *priceId;
    NSString *titles;
    
    
}
@end

@implementation TaskDistubVc

- (void)viewDidLoad {
    [super viewDidLoad];
    regionId = @"";
    typeId = @"";
    statusId = @"";
    timeId = @"";
    priceId = @"";
    titles = @"";
    
    reginalDic = [NSMutableDictionary dictionary];
    MainDataSouce = [NSMutableArray array];
    pagenum = 1;
    labelArr = [NSMutableArray array];
    downImageArr = [NSMutableArray array];
    btnArr = [NSMutableArray array];
    arrs = [NSMutableArray array];
    conditionArr = [NSMutableArray array];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViews:)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    [self initContentViews];
    [self getData];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCity) name:@"changecity" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockact:) name:@"HandelSuccess" object:@"1"];
  //  [FuncPublic instanceview:CGRectMake(0, 0, DEVW, NAVBAR_H) andcolor:<#(UIColor *)#> addtoview:<#(UIView *)#> andparentvc:<#(UIViewController *)#> isadption:<#(BOOL)#>]
    // Do any additional setup after loading the view.
}
-(void)blockact:(NSNotification *)no
{
    pagenum = 1;
    [self getData];
}
-(void)changeCity
{
   // DLog(@"任务界面城市选择消息----------------");
    UILabel *LB = (UILabel *)[self.view viewWithTag:1003];
    LB.text = [FuncPublic GetDefaultInfo:@"cityName"];
}
-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[NSString stringWithFormat:@"%i",PAGE_SUM] forKey:@"page_sum"];
    
    [dic setObject:[NSString stringWithFormat:@"%i",pagenum] forKey:@"page"];
    
    [dic setObject:@"task" forKey:@"mod"];
//    if([titles isEqualToString:@""])
//    {
    if(![regionId isEqualToString:@""]&&[regionId integerValue]>0)
    {
    [dic setObject:regionId forKey:@"regional"];
    }
    if(![priceId isEqualToString:@""]&&[priceId integerValue]>0)
    {
        [dic setObject:priceId forKey:@"prices"];
    }
    if(![statusId isEqualToString:@""]&&[statusId integerValue]>0)
    {
    [dic setObject:statusId forKey:@"state"];
    }
    if(![timeId isEqualToString:@""]&&[timeId integerValue]>0)
    {
    [dic setObject:timeId forKey:@"time"];
    }
    if(![typeId isEqualToString:@""]&&[typeId integerValue]>0)
    {
        [dic setObject:typeId forKey:@"fitmentclass"];
    }
        
   // }
    if(![titles isEqualToString:@""])
    {
        [dic setObject:titles forKey:@"title"];
    }
    [dic setObject:[FuncPublic GetDefaultInfo:@"cid"] forKey:@"city"];
    
    [SVHTTPRequest GET:@"/banner_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [pullToMore tableViewReloadFinished];
        DLog(@"url response is %@",urlResponse);
      //  DLog(@"resule is ---------------------------------%@",response);
        
        if(error!=nil)
            return ;
        else if ([[response objectForKey:@"tasklist"]count]==0)
        {
            [WToast showWithText:@"暂无数据"];
           // [pullToMore setPullToMoreViewVisible:NO];

            return;
        }
        else{
            if(pagenum==1)
            {
                [MainDataSouce removeAllObjects];
            }
      // NSLog(@"返回数据>:%@",urlResponse);
        NSArray *arr = [response objectForKey:@"tasklist"];
        
        for(int i=0;i<arr.count;i++)
        {
            NSDictionary *dictions = arr[i];
            TaskModel *model = [[TaskModel alloc]init];
            model.name = [dictions objectForKey:@"name"];
            model.titles = [dictions objectForKey:@"title"];
            model.status = [dictions objectForKey:@"state"];
            model.price = [dictions objectForKey:@"price"];
            model.uids = [dictions objectForKey:@"uid"];
            model.type = [dictions objectForKey:@"fitmentclass"];
            model.contactPeople = [dictions objectForKey:@"cname"];
            model.contactNum = [dictions objectForKey:@"phone"];
            model.areas = [dictions objectForKey:@"area"];
            model.huXing = [dictions objectForKey:@"units"];
            model.address = [dictions objectForKey:@"adds"];
            model.xiangXiSM = [dictions objectForKey:@"content"];
            model.time = [dictions objectForKey:@"time"];
            
            model.cityName = [dictions objectForKey:@"cityname"];
            model.regionName = [dictions objectForKey:@"regionalname"];
            model.evalution = [dictions objectForKey:@"evaluation"];
            
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
                  //  NSLog(@"yes");
                    model.imageArr = [[dictions objectForKey:@"pic"]componentsSeparatedByString:@","];
                    model.imageurl = model.imageArr[0];
                }
                else
                {
                  //  NSLog(@"no");
                    model.imageurl = [dictions objectForKey:@"pic"];
                }
            
            model.ids = [dictions objectForKey:@"id"];
            [MainDataSouce addObject:model];
            
        }
        pagenum++;
        
        [contentTab reloadData];
        }
    }];
    
    
}
-(void)initContentViews
{
    //上面的bar
    UIView *topView = [FuncPublic instanceview:CGRectMake(0, 0, DEVW, NAVBAR_H) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
  UIButton *backBtn =  [FuncPublic InstanceButton:@"back" ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake(10, 20, 30, 25) AddView:topView ViewController:self SEL_:@selector(back) Kind:1 TAG:1002 isadption:NO];
    
    
    NSString *cityname= nil;
    if([FuncPublic GetDefaultInfo:@"cityName"])
        cityname = [FuncPublic GetDefaultInfo:@"cityName"];
    else
    {cityname = @"南昌";}

  UILabel *cityLabel =   [FuncPublic InstanceLabel:cityname RECT:CGRectMake(DEVW-100, 23, 70, 20) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:topView Lines:0 TAG:1003 Ailgnment:3];
    [FuncPublic InstanceImageView:@"downl" Ect:@"png" RECT:CGRectMake(DEVW-27, 26, 17, 17) Target:topView TAG:1004 isadption:NO];
    [FuncPublic instaceSimpleButton:CGRectMake(DEVW-100, 0, 100, 50) andtitle:nil addtoview:topView parentVc:self action:@selector(selectCity:) tag:1005];
    UISearchBar *search = [[UISearchBar alloc]initWithFrame:CGRectMake(backBtn.frame.origin.x+backBtn.frame.size.width, 20, cityLabel.frame.origin.x-(backBtn.frame.origin.x+backBtn.frame.size.width), 30)];
    search.placeholder = @"请输入关键字";
    search.delegate = self;
    [topView addSubview:search];
    //筛选条件视图
    UIView *secondTopView = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H+1, DEVW, 40) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
    secondTopView.tag = 2;
    selectImages = [[UIImageView alloc]initWithFrame:CGRectZero];
    selectImages.backgroundColor = [UIColor whiteColor];
    [secondTopView addSubview:selectImages];

    NSArray *arrss = @[@"区域",@"类别",@"状态",@"时间",@"价格"];
    float width = DEVW/arrss.count;
    for(int i =0;i<arrss.count;i++)
    {
     UILabel *labels =   [FuncPublic InstanceLabel:arrss[i] RECT:CGRectMake(width*i, 10, width-20, 20) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:secondTopView Lines:0 TAG:10000+i Ailgnment:1];
        [labelArr addObject:labels];
     UIImageView *imagess =   [FuncPublic InstanceImageView:@"downl" Ect:@"png" RECT:CGRectMake(width-20+width*i, 12, 15, 15) Target:secondTopView TAG:50+i isadption:NO];
        [downImageArr addObject:imagess];
       [FuncPublic instaceSimpleButton:CGRectMake(width*i, 0, width, 40) andtitle:nil addtoview:secondTopView parentVc:self action:@selector(selectCondition:) tag:i+256];
      //  [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       // btn.titleLabel.textAlignment = 0;
        if(i<arrss.count-1)
        [FuncPublic instanceview:CGRectMake(width-1+width*i, 0, 1, 40) andcolor:[UIColor whiteColor] addtoview:secondTopView andparentvc:self isadption:NO];
    }
    
    //底面的bar
  UIView *bottomView =  [FuncPublic instanceview:CGRectMake(0, DEVH-50, DEVW, 50) andcolor:[UIColor darkGrayColor] addtoview:self.view andparentvc:self isadption:NO];
    NSArray *arrsss = @[@"我的任务",@"我要发布任务"];
    float botomWid = DEVW/arrsss.count;
    for(int i =0;i<arrsss.count;i++)
    {
       // [FuncPublic InstanceLabel:arrss[i] RECT:CGRectMake(botomWid*i, 0, botomWid, 50) FontName:nil Red:0 green:0 blue:0 FontSize:17 Target:bottomView Lines:0 TAG:1340+i Ailgnment:1];
        [FuncPublic instanceview:CGRectMake(botomWid, 0, 1, 50) andcolor:[UIColor whiteColor] addtoview:bottomView andparentvc:self isadption:NO];
        [FuncPublic instaceSimpleButton:CGRectMake(botomWid*i, 0, botomWid, 50) andtitle:arrsss[i] addtoview:bottomView parentVc:self action:@selector(selectTask:) tag:512+i];
    }
    contentTab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+41, DEVW, DEVH-NAVBAR_H-BOTTOM_H-41) style:UITableViewStylePlain];
    contentTab.delegate = self;
    contentTab.dataSource = self;
    contentTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:contentTab];
    
    pullToMore = [[DSBottomPullToMoreManager alloc]initWithPullToMoreViewHeight:60.0f tableView:contentTab withClient:self];
    [pullToMore setPullToMoreViewVisible:YES];
    
    //条件列表视图
    conditionTab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+40, DEVW, DEVH-NAVBAR_H-BOTTOM_H-40) style:UITableViewStylePlain];
    conditionTab.delegate =self;
    conditionTab.dataSource =self;
    conditionTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:conditionTab];
    conditionTab.hidden = 1;
//    coverView =  [FuncPublic instanceview:CGRectMake(0, NAVBAR_H+41, DEVW, DEVH-NAVBAR_H-BOTTOM_H-41) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
//    coverView.hidden = YES;
//    coverView.alpha = .95;

    
    

    //查看大图图层
    
    
    coverviews = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H-BOTTOM_H) andcolor:[UIColor whiteColor] addtoview:self.view andparentvc:self isadption:NO];
    
    UIScrollView *imageScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVW, coverviews.frame.size.height)];
    
    [coverviews addSubview:imageScro];
    
    imageScro.contentSize = CGSizeMake(DEVW, imageScro.frame.size.height);
    
    imageScro.tag = 12324;
    
    imageScro.backgroundColor = [UIColor blackColor];

   // bigImage = [FuncPublic InstanceImageView:nil Ect:nil RECT:CGRectMake(0, 50, DEVW, coverviews.frame.size.height-100) Target:coverviews TAG:122 isadption:NO];
    
  //  [FuncPublic InstanceButton:@"delete" ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake(DEVW-50, 10, 30, 30) AddView:coverviews ViewController:self SEL_:@selector(tapViews:) Kind:1 TAG:1381294 isadption:NO];
    
    [self.view addSubview:coverviews];
    coverviews.hidden = YES;
   // [self.view bringSubviewToFront:coverView];
}
////条件列表视图
//-(void)initCorverView:(NSMutableArray *)dataarr
//{
//    
//
//    btnArr = [NSMutableArray array];
//    UIScrollView *backscro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVW, DEVH-NAVBAR_H-45)];
//    backscro.contentSize = CGSizeMake(DEVW, 50*10);
//    backscro.backgroundColor = [UIColor whiteColor];
//   // [self.view addSubview:backscro];
//    for(int i =0;i<dataarr.count;i++)
//    {
//        CustomButon *btn = [[CustomButon alloc]initWithFrame:CGRectMake(40, 50*i+10, DEVW-50, 30)];
//        
//        btn.tag = i+50;
//        if(conditionindex==256)
//        {
//            MTMudelDaTa *data = [dataarr objectAtIndex:i];
//            btn.btnTitle = data.name;
//        }
//        else
//        {
//        btn.btnTitle = dataarr[i];
//        }
//        
//        [backscro addSubview:btn];
//        
//        [FuncPublic instaceSimpleButton:CGRectMake(40, 50*i, DEVW, 50) andtitle:nil addtoview:backscro parentVc:self action:@selector(CLICKS:) tag:i+50*2];
//        
//        //[arrs addObject:btn];
//        [btnArr addObject:btn];
//        
//        [FuncPublic instanceview:CGRectMake(0, 49+50*i, DEVW, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:backscro andparentvc:self isadption:NO];
//        
//        
//    }
//    [coverView addSubview:backscro];
//
//}
////选择具体筛选条件
//-(void)CLICKS:(UIButton *)click
//{
//    long int TAG = click.tag-100;
//    if(conditionindex==256)
//    {
//        MTMudelDaTa *data = arrs[TAG];
//        DLog(@"区域选择%@",data.name);
//    }
//    DLog(@"选中的筛选条件%@",arrs[TAG]);
//    coverView.hidden = 1;
////    [btnArr enumerateObjectsUsingBlock:^(CustomButon * obj, NSUInteger idx, BOOL *stop) {
////        if(obj.tag==TAG)obj.isSelect = 1;
////        else obj.isSelect = 0;
////        if(stop)coverView.hidden = 1;
////        
////    }];
//    
//    
//    
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView==contentTab? MainDataSouce.count:conditionArr.count;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color = [UIColor colorWithRed:191./255. green:0 blue:0 alpha:1];//通过RGB来定义自己的颜色
    //cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
   // cell.selectedBackgroundView.backgroundColor = [UIColor xxxxxx];
    static NSString *cellid = @"cell";
    if(tableView==contentTab)
    {
        TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell = [[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            
        }
        TaskModel *model = [MainDataSouce objectAtIndex:indexPath.row];
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
        cell.selectedBackgroundView.backgroundColor = color;
        UIColor *Ccolor = [UIColor colorWithRed:200./255. green:227./255. blue:227./255. alpha:1];
       // UIColor *ccolor1 = [UIColor grayColor];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = cell.frame;
        gradient.colors = [NSArray arrayWithObjects:(id)Ccolor.CGColor,
                           (id)[UIColor grayColor].CGColor,
                           (id)Ccolor.CGColor,nil];
        if(indexPath.row%2==0)
          // [cell.layer insertSublayer:gradient atIndex:0];
            cell.backgroundColor = Ccolor;
        else cell.backgroundColor = [UIColor whiteColor];

        return cell;
    }
    else{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSString *tempstr = [conditionArr objectAtIndex:indexPath.row];
    cell.textLabel.text = tempstr;
    return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView==contentTab?120:50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  DLog(@"选择的类别是%i",selectId);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // UITableViewCell *cell =(UITableViewCell *) [tableView cellForRowAtIndexPath:indexPath.row];
    if(tableView==contentTab)
    {
        TaskModel *model = [MainDataSouce objectAtIndex:indexPath.row];
        
        TaskDetailVc *detailVc = [[TaskDetailVc alloc]init];
        detailVc.model = model;
        [self.navigationController pushViewController:detailVc animated:NO];
    }
    else
    {
        NSString *tempstr = [conditionArr objectAtIndex:indexPath.row];
        if(selectId==256)
        {
            NSString *ids = [reginalDic objectForKey:tempstr];
            regionId = ids;
            UILabel *label = (UILabel *)labelArr[0];
            label.text = conditionArr [indexPath.row];
            label.font = [UIFont systemFontOfSize:13];
           // DLog(@"区域的id%@",cell.);
        }
        if(selectId==257)
        {
            if(indexPath.row==0)
                typeId = [NSString stringWithFormat:@"%i",-1];
            typeId =[NSString stringWithFormat:@"%li",indexPath.row];
            UILabel *label = (UILabel *)labelArr[1];
            label.text = conditionArr [indexPath.row];
            label.font = [UIFont systemFontOfSize:13];
            NSLog(@"类别id——————%@",typeId);
        }
        if(selectId==258)
        {
            if(indexPath.row==0)
                statusId = [NSString stringWithFormat:@"%i",-1];
        else    if(indexPath.row==1)
                statusId = @"1";
            else
            statusId =@"0";
            UILabel *label = (UILabel *)labelArr[2];
            label.text = conditionArr [indexPath.row];
            label.font = [UIFont systemFontOfSize:13];
        }
        if(selectId ==259)
        {
            if(indexPath.row==0)
                timeId = [NSString stringWithFormat:@"%i",-1];
            timeId = [NSString stringWithFormat:@"%li",indexPath.row];
            UILabel *label = (UILabel *)labelArr[3];
            label.text = conditionArr [indexPath.row];
            label.font = [UIFont systemFontOfSize:13];
        }
    if(selectId==260)
    {
        if(indexPath.row==0)
            priceId = [NSString stringWithFormat:@"%i",-1];
        priceId = [NSString stringWithFormat:@"%li",indexPath.row];
        UILabel *label = (UILabel *)labelArr[4];
        label.text = conditionArr [indexPath.row];
        float widd = DEVW/5;
        label.frame = CGRectMake(DEVW-widd, label.frame.origin.y, widd, label.frame.size.height);
        label.font = [UIFont systemFontOfSize:13];
        UIImageView *imge = (UIImageView *)downImageArr[4];
        imge.hidden = 1;
    }
        conditionTab.hidden = YES;
       // NSString *tempstr11 = [conditionArr objectAtIndex:indexPath.row];
        pagenum = 1;
        [self getData];
       // DLog(@"选择的条件-----%@",tempstr);
    }
}

//点击图片预览
-(void)clickImage:(UIButton *)click
{
    
    coverviews.hidden = NO;
    
    TaskModel *model = MainDataSouce[click.tag];
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

//筛选条件类别
-(void)selectCondition:(UIButton *)click
{
    [self.view endEditing:YES];
    selectImages.frame = click.frame;
    
   
    
  
    [labelArr enumerateObjectsUsingBlock:^(UILabel * label, NSUInteger idx, BOOL *stop) {
        if(label.tag-10000 ==(click.tag-256) )label.textColor = [UIColor redColor];
        else label.textColor = [UIColor blackColor];
    }];
    [downImageArr enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL *stop) {
        if(obj.tag-50==(click.tag-256))obj.image = [UIImage imageNamed:@"up.png"];
        else obj.image = [UIImage imageNamed:@"downl.png"];
    }];
    DLog(@"选择的条件id-----%i",click.tag);
    
    if(selectId!=click.tag){
        
        conditionTab.hidden = NO;
        //return;
     //  [arrs removeAllObjects];
    //当选择不同的筛选类别时才更换数据
         [conditionArr removeAllObjects];
        switch (click.tag) {
               
            case 256:
            {
                
                conditionindex = 256;
                [[MyDbHandel defaultDBManager]openDb:@"Citylists.sqlite"];
                if(![FuncPublic GetDefaultInfo:@"cid"])
                {
                    [WToast showWithText:@"请先选择城市"];
                    CityListVc *vc = [[CityListVc alloc]init];
                    [self.navigationController pushViewController:vc animated:NO];
                    return;
                    
                }
                NSString *pids = [FuncPublic GetDefaultInfo:@"cid"];
//                NSString *sql1 = [NSString stringWithFormat:@"select * from %@ where pid = %i  and name  like '市辖区'",NAME,[pids integerValue]];
//                NSArray *temparr1 = [[MyDbHandel defaultDBManager]select:sql1];
//                NSString *pidhdj = @"";
//                for(MTMudelDaTa *datas in temparr1)
//                {
//                    pidhdj = datas.ids;
//                   // [conditionArr addObject:datas.name];
//                    //[reginalDic setObject:datas.ids forKey:datas.name];
//                }
//
                NSString *sql = [NSString stringWithFormat:@"select * from %@ where pid = %li and name like '%%区' and name not like '市辖区'",NAME,[pids integerValue ]];
                                
                NSArray *temparr = [[MyDbHandel defaultDBManager]select:sql];
                if([temparr count]==0)
                {
                    NSString *sql = [NSString stringWithFormat:@"select * from %@ where pid = %li and name like '%%区' and name not like '市辖区'",NAME,[pids integerValue ]+100];
                    NSLog(@"sql 语句%@",sql);
                    
                    temparr = [[MyDbHandel defaultDBManager]select:sql];
                    
                }
                [conditionArr addObject:@"不限"];

                [reginalDic setObject:@"-1" forKey:@"不限"];
                for(MTMudelDaTa *datas in temparr)
                {
                    [conditionArr addObject:datas.name];
                    [reginalDic setObject:datas.ids forKey:datas.name];
                }
//                NSString *sql = [NSString stringWithFormat:@"select * from %@ where pid = %i and name like '%%区' and name not like '市辖区'",NAME,[pids integerValue]+100];
               // arrs = [NSMutableArray arrayWithArray:temparr];
            }
                break;
                case 257:
            {
                NSArray *temparr = @[@"不限",@"电工",@"水工",@"木工",@"油漆工",@"打墙工",@"搬运工",@"贴墙纸",@"泥工",@"吊顶",@"乱瓷",@"结墙",@"清理工"];
               // arrs = [NSMutableArray arrayWithObjects:@"ceshi",@"ceshi",@"ceshi", nil];
                [conditionArr setArray:temparr];
            }
                break;
                case 258:
            {
                NSArray *temparr = @[@"不限",@"已结束",@"未结束"];
                [conditionArr setArray:temparr];
            }
                break;
            case 259:
            {
                NSArray *temparr = @[@"不限",@"降序",@"升序"];
                [conditionArr setArray:temparr];
            }
                break;
                case 260:
            {
                NSArray *temparr = @[@"不限",@"0-500",@"500-1000",@"1000-1500",@"1500-2000",@"2000-2500",@"2500-3000",@"3000-5000",@"5000-10000",@"10000-20000",@"20000-30000",@"30000-50000",@"50000-70000",@"70000-100000",@"100000以上"];
                [conditionArr setArray:temparr];
            }
                break;
            default:
                break;
        }
        [conditionTab reloadData];
        
        
    }
    
    
    else
    {
     conditionTab.hidden = !conditionTab.hidden;
        
    }
    selectId = click.tag;
    
    

   
}
//城市选择
-(void)selectCity:(UIButton *)button
{
    CityListVc *cityVc = [[CityListVc alloc]init];
    [self.navigationController pushViewController:cityVc animated:NO];
}
//选择任务
-(void)selectTask:(UIButton *)click
{
    if(click.tag==513)
    {
        DistubTaskVc *distubVc = [[DistubTaskVc alloc]init];
        [self.navigationController pushViewController:distubVc animated:NO];
    }
    else
    {
        MyDistubTasksVc *taskVc = [[MyDistubTasksVc alloc]init];
        [self.navigationController pushViewController:taskVc animated:NO];
    }

}
//search bar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    titles = searchBar.text;
    pagenum = 1;
    [self getData];
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0)
{
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark LoadMore Handel
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
   // NSLog(@"click.................");
    [self getData];
//    page = 1;
//    [self getDataList];
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
