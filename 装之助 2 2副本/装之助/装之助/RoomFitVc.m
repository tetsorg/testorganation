//
//  RoomFitVc.m
//  装之助
//
//  Created by caiyc on 14/11/19.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "RoomFitVc.h"
#import "DSBottomPullToMoreManager.h"
#import "EffectModel.h"
#import "ModelCell.h"
#import "UIImageView+webimage.h"
#define  HEIGHT  DEVH-NAVBAR_H
#define WIDTH self.view.bounds.size.width

@interface RoomFitVc ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,DSBottomPullToMoreManagerClient>
{
    MyTableView *secondView;
    MyTableView *thirdView;
    MyTableView *firstView;
    //判断是否展开
    BOOL  expanding;
    
    UIView *topView;
    
    UITableView *contentTab;
    
    DSBottomPullToMoreManager *pullToMore;
    
    UIView *selectView;
    NSMutableArray *btnarr;
    int page;
    NSMutableArray *dataSouce;
    
    UIView *coverView;
    
    UIImageView *chechImage;
}
@end

@implementation RoomFitVc

- (void)viewDidLoad {
    [super viewDidLoad];
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(select) name:@"hdh" object:nil];
    btnarr = [NSMutableArray array];
    page = 1;
    dataSouce = [NSMutableArray array];
  UIButton *btn =  [FuncPublic instaceSimpleButton:CGRectMake(0, NAVBAR_H, DEVW/2, 40) andtitle:@"固装" addtoview:self.view parentVc:self action:@selector(selectCatogry:) tag:101];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  UIButton *btn1 =  [FuncPublic instaceSimpleButton:CGRectMake(DEVW/2, NAVBAR_H, DEVW/2, 40) andtitle:@"散装" addtoview:self.view parentVc:self action:@selector(selectCatogry:) tag:102];
    [btnarr addObject:btn];
    [btnarr addObject:btn1];
    [FuncPublic instanceview:CGRectMake(0, NAVBAR_H+39, DEVW, 1) andcolor:[UIColor colorWithRed:225./255. green:222./255. blue:210./255. alpha:1] addtoview:self.view andparentvc:self isadption:NO];
    selectView = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H+39, DEVW/2, 1) andcolor:[UIColor redColor] addtoview:self.view andparentvc:self isadption:NO];
    [FuncPublic instanceview:CGRectMake(DEVW/2, NAVBAR_H, 1, 40) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    
    contentTab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+40, DEVW, DEVH-NAVBAR_H-40) style:UITableViewStylePlain];
    contentTab.delegate =self;
    contentTab.dataSource = self;
    [self.view addSubview:contentTab];
    pullToMore = [[DSBottomPullToMoreManager alloc]initWithPullToMoreViewHeight:60 tableView:contentTab withClient:self];
    [pullToMore setPullToMoreViewVisible:YES];
    
    topView = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H+40, DEVW, DEVH-NAVBAR_H-40) andcolor:nil addtoview:self.view  andparentvc:self isadption:NO];
    topView.alpha = 0;
    expanding = NO;
    self.title = @"func you";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [FuncPublic InstanceNavgationBar:@"家居" action:@selector(back) superclass:self isroot:NO];
    firstView = [[MyTableView alloc]initWithFrame:CGRectMake(0,0, WIDTH/2, DEVH-NAVBAR_H) tag:1];
    firstView.backgroundColor = [UIColor whiteColor];
    firstView.dataSource = @[@"卧房",@"书房",@"青少年房",@"客餐厅",@"厨房"];
    firstView.delegate = self;
    firstView.rowHeight = 80;
    
    firstView.selectImage = [UIImage imageNamed:@"one_pg.png"];
   
    [topView insertSubview:firstView atIndex:0];
    
    secondView = [[MyTableView alloc]initWithFrame:CGRectMake(WIDTH/2, 0, WIDTH/2, DEVH-NAVBAR_H) tag:2];
    secondView.delegate = self;
    //妈比颜色自己配，我不会
    secondView.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    secondView.dataSource = @[@"整体衣柜",@"衣帽间",@"飘窗利用",@"定制床",@"装饰柜组合",@"电视柜组合",@"米兰范儿卧房"];
    secondView.rowHeight = 60;
    secondView.selectImage = [UIImage imageNamed:@"t_bg.png"];
    [topView insertSubview:secondView atIndex:1];
    
    
//    thirdView = [[MyTableView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH/3, DEVH-NAVBAR_H) tag:3];
//    thirdView.backgroundColor = [UIColor colorWithWhite:0.78 alpha:1.0];
//    
//    thirdView.delegate = self;
//    thirdView.rowHeight = 50;
//    [topView insertSubview:thirdView atIndex:2];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiden)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    [UIView animateWithDuration:1 animations:^{
        topView.alpha = 1;
    } completion:^(BOOL finished) {
       // [WToast showWithText:@"点击空白处可取消选择"];
        
    }];
    
    
    //查看大图的视图
    coverView = [FuncPublic instanceview:CGRectMake(0, 0, DEVW, DEVH) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    chechImage = [FuncPublic InstanceImageView:nil Ect:nil RECT:CGRectMake(0, 50, DEVW, DEVH-100) Target:coverView TAG:777 isadption:NO];
    coverView.hidden = YES;
    [FuncPublic InstanceButton:@"back" ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake(20, DEVH-40, 30, 30) AddView:coverView ViewController:self SEL_:@selector(hidePic:) Kind:1 TAG:22 isadption:NO];
    
    
    [self getDataList];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePic:)];
//    [coverView addGestureRecognizer:tap];
    
    
}
-(void)selectCatogry:(UIButton *)click
{
    selectView.frame = CGRectMake(click.frame.origin.x, selectView.frame.origin.y, selectView.frame.size.width, selectView.frame.size.height);
    for(UIButton *btn in btnarr)
    {
        if(btn.tag==click.tag) [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        else [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self hiden];
}
-(void)getDataList
{
    //[pullToMore tableViewReloadFinished];
  //  NSString *type = [_titleStr isEqualToString:@"效果图"]?@"1":@"2";
    NSString *pages =[ NSString stringWithFormat:@"%d",page];
    NSString *pagenum = @"5";
    NSString *mod = @"pic";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"1" forKey:@"fitmentclass"];
    [dic setObject:pages forKey:@"page"];
    [dic setObject:pagenum forKey:@"page_sum"];
    [dic setObject:mod forKey:@"mod"];
    [SVHTTPRequest GET:@"/banner_api.php" parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        DLog(@"urlresponse %@",urlResponse);
        DLog(@"data %@",response);
        
        if(error!=nil)
        {
            [pullToMore setPullToMoreViewVisible:NO];
            //  [WToast showWithText:@"无数据"];
            [FuncPublic InstanceImageView:@"笑脸-2" Ect:@"png" RECT:CGRectMake((DEVW-100)/2, (DEVH-100)/2, 100, 100) Target:self.view TAG:232 isadption:NO];
            return ;
        }
        else
        {
            
            NSArray *arr = [FuncPublic tryObject:response Key:@"piclist" Kind:2];
            if(arr.count==0)
            {
                [WToast showWithText:@"已加载完"];
                [pullToMore setPullToMoreViewVisible:NO];
                [pullToMore tableViewReloadFinished];
                return;
            }
            
            for(int i =0;i<arr.count;i++)
            {
                EffectModel *model = [[EffectModel alloc]init];
                model.name = [FuncPublic tryObject:arr[i] Key:@"name" Kind:1];
                
                model.title = [FuncPublic tryObject:arr[i] Key:@"title" Kind:1];
                
                model.picUrl = [FuncPublic tryObject:arr[i] Key:@"pic" Kind:1];
                
                model.depraiseNum = [FuncPublic tryObject:arr[i] Key:@"depraisecount" Kind:1];
                
                model.praiseNum = [FuncPublic tryObject:arr[i] Key:@"praisecount" Kind:1];
                
                model.collectNum = [FuncPublic tryObject:arr[i] Key:@"collectcount" Kind:1];
                
                model.ids = [FuncPublic tryObject:arr[i] Key:@"id" Kind:1];
                
                model.isparise = [FuncPublic tryObject:arr[i] Key:@"praise" Kind:1];
                
                model.isdeparise = [FuncPublic tryObject:arr[i] Key:@"depraise" Kind:1];
                
                model.iscollect = [FuncPublic tryObject:arr[i] Key:@"collect" Kind:1];
                
                [dataSouce addObject:model];
                
                [contentTab reloadData];
                
                [pullToMore tableViewReloadFinished];
                
                page++;
                // [pullToMore setPullToMoreViewVisible:NO];
                
            }
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSouce.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid =@"cell";
    ModelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        
        cell = [[ModelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    EffectModel *model = [dataSouce objectAtIndex:indexPath.row];
    
    cell.supportLabel.text = model.praiseNum;
    
    cell.badLabel.text = model.depraiseNum;
    
    cell.collectLabel.text = model.collectNum;
    
    cell.supportBtn.tag = indexPath.row + 1000;
    
  //  [cell.supportBtn addTarget:self action:@selector(supportClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.badBtn.tag = indexPath.row+2000;
    
  //  [cell.badBtn addTarget:self action:@selector(badClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.collectBtn.tag = indexPath.row+3000;
    
   // [cell.collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titelLable.text = model.title;
    
    [cell.mainImage setImageWithURL:[NSURL URLWithString:model.picUrl] ];
    // cell.mainImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.mainImage.tag = indexPath.row +102444;
    
    cell.checkpic.tag = indexPath.row+10244;
    
    [cell.checkpic addTarget:self action:@selector(chechPic:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
//查看大的效果图
-(void)chechPic:(UIButton *)sender
{
    UIImageView *images = (UIImageView *)[self.view viewWithTag:sender.tag-10244+102444];
    coverView.hidden = NO;
    if(images.image)
    {
        chechImage.image = images.image;
        chechImage.frame = CGRectMake(0, 50, DEVW, DEVH-100);
    }
    else
    {
        chechImage.image = [UIImage imageNamed:@"笑脸-2.png"];
        chechImage.frame = CGRectMake((DEVW-100)/2, (DEVH-100)/2, 100, 100);
    }
    //    UIView *view = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H) andcolor:[UIColor whiteColor] addtoview:self.view andparentvc:self isadption:NO];
    //    UIImageView *imagess = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    //    imagess.image = images.image ;
    //    [view addSubview:imagess];
}
-(void)hidePic:(UIButton *)sender
{
    coverView.hidden = YES;
}
//去除多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    // [view release];
}

#pragma mark LoadMore Handel
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
   // LoadMore = YES;
    // page = 1;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
    }
    return YES;
}

-(void)hiden

{
    [UIView animateWithDuration:.7 animations:^{
        topView.alpha = topView.alpha==0?1:0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)tableViewdisSelectRow:(NSIndexPath *)indexpath mark:(NSInteger)tag{
    
    NSLog(@"-----indexpath：%i",indexpath.section);
    switch (tag){
            
        case 1:{
            switch (indexpath.section) {
                case 0:
                    secondView.dataSource = @[@"整体衣柜",@"衣帽间",@"飘窗利用",@"定制床",@"装饰柜组合",@"电视柜组合",@"米兰范儿卧房"];
                    break;
                    case 1:
                    secondView.dataSource = @[@"榻榻米",@"书柜组合",@"直角书桌组合",@"转角书桌组合",@"多功能室",@"简欧风格书房"];
                    break;
                    case 2:
                    secondView.dataSource = @[@"榻榻米",@"书柜组合",@"上下床",@"书柜组合",@"书桌组合",@"飘窗利用"];
                    break;
                    
                    
                default:
                    break;
            }
            
            
            //点击第一个tableview更新第二个的数据源
            //如果有3列则需要同时更新第2，第三个tableview的数据源（蛋疼吧）
//            secondView.dataSource = @[@"11111",@"2222",@"3333",@"4444",@"5555"];
//            expanding ? (thirdView.dataSource = @[@"无聊",@"放狗",@"杀猪",@"杀猪",@"杀猪"]):nil;
            
        }break;
        case 2:{
            //点击第二个tableview更新第三个的数据源
            
//            expanding = YES;
//            thirdView.dataSource = @[@"11杀猪",@"放狗",@"杀猪",@"杀猪",@"杀猪"];
            [self animate:NO];
            
            break;
            
        }
        default:{
            
            //点击第三个tableview，选择完成，做你该做的事了
            NSLog(@"选择完成了，视图消失");
            expanding = NO;
            [self animate:NO];
            
        }
            
            break;
            
    }
    //数据更新
    
    
}
-(void)animate:(BOOL)appear{
    
   
    [UIView animateWithDuration:0.5 animations:^{
      //  [self hiden];
        
        if (appear) {
            
            //相同宽度丑，按比率5：4：3分配(自己去调整)
            firstView.frame = CGRectMake(0,0, WIDTH/12*5, DEVH-NAVBAR_H);
            secondView.frame = CGRectMake(WIDTH/12*5, 0, WIDTH/12*4, DEVH-NAVBAR_H);
            thirdView.frame = CGRectMake(WIDTH/12*9,0, WIDTH/12*3, DEVH-NAVBAR_H);
            return ;
            
        }
        [self hiden];
//        firstView.frame = CGRectMake(0, NAVBAR_H, WIDTH/2, DEVH-NAVBAR_H);
//        secondView.frame =CGRectMake(WIDTH/2,NAVBAR_H, WIDTH/2, DEVH-NAVBAR_H);
//        thirdView.frame = CGRectMake(WIDTH, NAVBAR_H, HEIGHT/12*3, DEVH-NAVBAR_H);
    }];
    
    
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
