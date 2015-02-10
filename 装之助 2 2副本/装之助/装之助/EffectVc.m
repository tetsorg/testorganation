//
//  EffectVc.m
//  装之助
//
//  Created by guest on 14/11/10.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "EffectVc.h"
#import "ModelCell.h"
#import "DSBottomPullToMoreManager.h"
#import "SortOfEffect.h"
#import "EffectModel.h"
#import "UIImageView+webimage.h"
@interface EffectVc ()<UITableViewDataSource,UITableViewDelegate,DSBottomPullToMoreManagerClient>
{
    UITableView *myTab;
    DSBottomPullToMoreManager *pullToMore;
    int page;
    NSMutableArray *dataSouce;
    BOOL LoadMore;
    UIView *coverView;
    UIImageView *chechImage;
    NSMutableDictionary *sortDic;
}
@end

@implementation EffectVc

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *temparr1 = @[@"不限",@"水电图",@"电路图",@"水电泥图"];
    NSArray *temparr2 = @[@"-1",@"1",@"2",@"3"];
    sortDic = [NSMutableDictionary dictionaryWithObjects:temparr2 forKeys:temparr1];
    dataSouce = [NSMutableArray array];
    page = 1;
    [FuncPublic InstanceNavgationBar:_titleStr action:@selector(back) superclass:self isroot:NO];
    //右边分类选项的配置
    [FuncPublic InstanceLabel:@"分类" RECT:CGRectMake(DEVW-70, 20, 40, 30) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:self.view Lines:0 TAG:324 Ailgnment:2];
    
    [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(DEVW-40, 27, 15, 15) Target:self.view TAG:5435 isadption:NO];
    
    [FuncPublic instaceSimpleButton:CGRectMake(DEVW-70, 20, 70, 30) andtitle:nil addtoview:self.view parentVc:self action:@selector(selectSort:) tag:434];
    
    
    myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H) style:UITableViewStylePlain];
    myTab.delegate = self;
    myTab.dataSource = self;
    
    [self.view addSubview:myTab];
    
    //去除多余的分割线
    [self setExtraCellLineHidden:myTab];
    
    //加载更多
    pullToMore = [[DSBottomPullToMoreManager alloc]initWithPullToMoreViewHeight:60.0f tableView:myTab withClient:self];
    [pullToMore setPullToMoreViewVisible:YES];
    //异步加载数据
    dispatch_async(dispatch_queue_create("dsd", nil), ^{
        [self getDataList];
    });

    //查看大图的视图
    coverView = [FuncPublic instanceview:CGRectMake(0, 0, DEVW, DEVH) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    chechImage = [FuncPublic InstanceImageView:nil Ect:nil RECT:CGRectMake(0, 50, DEVW, DEVH-100) Target:coverView TAG:777 isadption:NO];
    coverView.hidden = YES;
    [FuncPublic InstanceButton:@"back" ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake(20, DEVH-40, 30, 30) AddView:coverView ViewController:self SEL_:@selector(hidePic:) Kind:1 TAG:22 isadption:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePic:)];
    [coverView addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}
-(void)getDataList
{
    //[pullToMore tableViewReloadFinished];
    NSString *type = [_titleStr isEqualToString:@"效果图"]?@"1":@"2";
    NSString *pages =[ NSString stringWithFormat:@"%d",page ];
    NSString *pagenum = @"5";
    NSString *mod = @"pic";
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:type forKey:@"fitmentclass"];
    [dic setObject:pages forKey:@"page"];
    [dic setObject:pagenum forKey:@"page_sum"];
    [dic setObject:mod forKey:@"mod"];
    [SVHTTPRequest GET:@"/banner_api.php" parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        DLog(@"urlresponse %@",urlResponse);
        DLog(@"data %@",response);
        
        if(error!=nil&&!LoadMore)
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
                
                [myTab reloadData];
                
                [pullToMore tableViewReloadFinished];
                
                page++;
               // [pullToMore setPullToMoreViewVisible:NO];
                
            }
        }
    }];
    
}

-(void)selectSort:(UIButton *)sender
{
    if(![_titleStr isEqualToString:@"效果图"])
    {
        int countt = [[sortDic allKeys]count];
        UIView *views = [FuncPublic instanceview:CGRectMake(DEVW-100, NAVBAR_H, 100, 40*countt) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
        views.tag = 1133;
        for(int i =0;i<countt;i++)
        {
           [ FuncPublic instaceSimpleButton:CGRectMake(0, 40*i, 100, 40) andtitle:[sortDic allKeys][i] addtoview:views parentVc:self action:@selector(selecttype:) tag:i+100];
        }
    }
    else{
    SortOfEffect *sortVc = [[SortOfEffect alloc]init];
    [self.navigationController pushViewController:sortVc animated:NO];
    }
}
-(void)selecttype:(UIButton *)click
{
    UIView *v = (UIView *)[self.view viewWithTag:1133];
    [v removeFromSuperview];
    NSString *keys = [sortDic allKeys][click.tag-100];
    NSString *values = [sortDic objectForKey:keys];
    NSLog(@"选中合格的分类是%@",values);
}
#pragma mark Tableview Handel
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSouce.count;
}


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
    
    [cell.supportBtn addTarget:self action:@selector(supportClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.badBtn.tag = indexPath.row+2000;
    
    [cell.badBtn addTarget:self action:@selector(badClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.collectBtn.tag = indexPath.row+3000;
    
    [cell.collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titelLable.text = model.title;
    
    [cell.mainImage setImageWithURL:[NSURL URLWithString:model.picUrl] ];
   // cell.mainImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.mainImage.tag = indexPath.row +102444;
    
    cell.checkpic.tag = indexPath.row+10244;
    
    [cell.checkpic addTarget:self action:@selector(chechPic:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
#pragma mark button click handel
//赞
-(void)supportClick:(UIButton *)click
{
   
    EffectModel *model = dataSouce[click.tag-1000];
    if([model.isparise isEqualToString:@"1"])
    {
        [WToast showWithText:@"已经赞过此贴"];
        return;
    }
    dispatch_async(dispatch_queue_create("dsd", nil), ^{
        
        [self userHandel:model.ids handel:@"praise"];
    });
    
    UIImageView *images = (UIImageView *)[click.superview viewWithTag:11];
    [click.superview addSubview:images];
    [self animation:images];
}
//鄙视
-(void)badClick:(UIButton *)click
{
    
    EffectModel *model = dataSouce[click.tag-2000];
    if([model.isdeparise isEqualToString:@"1"])
    {
        [WToast showWithText:@"已踩过此贴"];
        return;
    }
    dispatch_async(dispatch_queue_create("dsd", nil), ^{
        
        [self userHandel:model.ids handel:@"depraise"];
    });
   
    UIImageView *images = (UIImageView *)[click.superview viewWithTag:12];
    
    [click.superview addSubview:images];
    
    [self animation:images];

}
//收藏
-(void)collectClick:(UIButton *)click
{
    
    EffectModel *model = dataSouce[click.tag-3000];
    
    if([model.iscollect isEqualToString:@"1"])
    {
        [WToast showWithText:@"已收藏过此贴"];
        
        return;
    }
    dispatch_async(dispatch_queue_create("dsd", nil), ^{
        [self userHandel:model.ids handel:@"collect"];
    });

    //[WToast showWithText:@"收藏成功了"];
    UIImageView *images = (UIImageView *)[click.superview viewWithTag:13];
    
    [click.superview addSubview:images];
    
    [self animation:images];

}

-(void)animation:(UIImageView *)obj
{
    CGAffineTransform oldtransform = obj.transform;
    
   // UIImage *oldimage = obj.image;
    
   [UIView animateWithDuration:.7 animations:^{
       
       UIImage *newimage = nil;
       
       if(obj.tag==11)newimage = [UIImage imageNamed:@"点赞2"];
       
       else if (obj.tag==12)newimage = [UIImage imageNamed:@"鄙视2"];
       
       else newimage = [UIImage imageNamed:@"收藏2"];
       
       [obj setImage:newimage];
       
       CGAffineTransform newtransform = CGAffineTransformMakeScale(1.2, 1.2);
       
       [obj setTransform:newtransform];
       
   } completion:^(BOOL finished) {
       
       [UIView animateWithDuration:.3 animations:^{
          // obj.alpha = 0;
       } completion:^(BOOL finished) {
           //[obj removeFromSuperview];
           [obj setTransform:oldtransform];
           
           [obj setImage:obj.image];
       }];
   }];
}
//赞，踩，收藏操作
-(void)userHandel:(NSString *)tids handel:(NSString *)handels
{
    NSString *type = [_titleStr isEqualToString:@"效果图"]?@"1":@"2";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:type forKey:@"fitmentclass"];
    
    [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];//用户id先用1做测试
    
    [dic setObject:tids forKey:@"tid"];
    
    [dic setObject:@"1" forKey:handels];
    
    [dic setObject:@"pic" forKey:@"mod"];
    
    [SVHTTPRequest GET:@"/set_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        DLog(@"返回的操作信息：%@",response);
        if([handels isEqualToString:@"praise"])[WToast showWithText:@"点赞成功"];
        
        else if ([handels isEqualToString:@"depraise"])[WToast showWithText:@"踩成功"];
        
        else [WToast showWithText:@"收藏成功"];
        
        
    }];
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
    LoadMore = YES;
   // page = 1;
    [self getDataList];
}
-(void)back
{
    [UIView animateWithDuration:.5 animations:^{
        /*
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:0.15 animations:^{
                                    //顺时针旋转90度
                                    self.view.transform = CGAffineTransformMakeRotation(M_PI *
                                                                                        -1.5);
                                }];
        [UIView addKeyframeWithRelativeStartTime:0.15
                                relativeDuration:0.10 animations:^{
                                    //180度
                                    self.view.transform = CGAffineTransformMakeRotation(M_PI *
                                                                                        1.0);
                                }];
        [UIView addKeyframeWithRelativeStartTime:0.25
                                relativeDuration:0.20 animations:^{
                                    //摆过中点，225度
                                    self.view.transform = CGAffineTransformMakeRotation(M_PI *
                                                                                        1.3);
                                }];
        [UIView addKeyframeWithRelativeStartTime:0.45
                                relativeDuration:0.20 animations:^{
                                    //再摆回来，140度
                                    self.view.transform = CGAffineTransformMakeRotation(M_PI *
                                                                                        0.8);
                                }];
        [UIView addKeyframeWithRelativeStartTime:0.65
                                relativeDuration:0.35 animations:^{
                                    //旋转后掉落
                                    //最后一步，视图淡出并消失
                                    CGAffineTransform shift =
                                    CGAffineTransformMakeTranslation(180.0, 0.0);
                                    CGAffineTransform rotate =
                                    CGAffineTransformMakeRotation(M_PI * 0.3);
                                    self.view.transform = CGAffineTransformConcat(shift,
                                                                                  rotate);
                                    //  _coverView.alpha = 0.0;
                                }];
         */
       // self.view.transform = CGAffineTransformMakeRotation(M_PI*0.25);
        self.view.frame = CGRectMake(DEVW, 0, DEVW, DEVH);
        [self.navigationController popViewControllerAnimated:NO];
    } completion:^(BOOL finished) {
        
        
    }];
    
    
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
