//
//  ComunicateCenterVc.m
//  装之助
//
//  Created by caiyc on 14/12/1.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "ComunicateCenterVc.h"
#import "CModelCell.h"
#import "DistubVc.h"
#import "TdetailVc.h"
#import "TModel.h"
#import "DSBottomPullToMoreManager.h"
#define PAGE_SUM 4
@interface ComunicateCenterVc ()<UITableViewDataSource,UITableViewDelegate,DSBottomPullToMoreManagerClient>
{
    UITableView *contentTab;
    UIView *depview;
    UITextView *depText;
     float kbHeight;
    int pagenum;
    NSMutableArray *dataSource;
    DSBottomPullToMoreManager *pullToMore;
    long int depIndex;
}
@end

@implementation ComunicateCenterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray array];
    pagenum = 1;
    [FuncPublic InstanceNavgationBar:@"交流中心" action: @selector(back) superclass:self isroot:NO];
    //发帖按钮
    [FuncPublic InstanceButton:@"发帖" ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake(DEVW-50, 20, 40, 35) AddView:self.view ViewController:self SEL_:@selector(disTub:) Kind:1 TAG:1 isadption:NO];
    
    [self initContentViews];
    
    [self  getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)getData
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"bbs" forKey:@"mod"];
    [dic setObject:[NSString stringWithFormat:@"%i",pagenum] forKey:@"page"];
    [SVHTTPRequest GET:@"/banner_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
      //  NSLog(@"交流中心信息:%@",response);
        if(error!=nil)
        {
            return ;
        }
        else
        {
            for(NSDictionary *dic in [response objectForKey:@"bbslist"])
            {
                TModel *model = [[TModel alloc]init];
                model.title = [dic objectForKey:@"title"];
                model.content = [dic objectForKey:@"content"];
                model.depraiseCount = [dic objectForKey:@"depraisecount"];
                model.priseCount = [dic objectForKey:@"praisecount"];
                model.discussCount = [dic objectForKey:@"discusscount"];
                model.ids = [dic objectForKey:@"id"];
                model.time = [dic objectForKey:@"time"];
                model.uid = [dic objectForKey:@"uid"];
                [dataSource addObject:model];
            }
           // dataSource = [response objectForKey:@"bbslist"];
            [contentTab reloadData];
            pagenum ++;
            [pullToMore tableViewReloadFinished];
        }
    }];
    
    
}
//动态获取键盘高度
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    kbHeight = keyboardSize.height;
    
    [UIView animateWithDuration:.5 animations:^{
        depview.frame = CGRectMake(0, DEVH-kbHeight-120-60, DEVW, 120);
        
    } completion:^(BOOL finished) {
        
    }];
    NSLog(@"keyBoard:%f,depview height :%f", keyboardSize.height,depview.frame.origin.y);  //216
    ///keyboardWasShown = YES;
}

-(void)initContentViews
{
    contentTab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H) style:UITableViewStylePlain];
    
    contentTab.delegate = self;
    
    contentTab.dataSource = self;
    
    [self.view addSubview:contentTab];
    
    
    //评论视图
    depview = [[UIView alloc]initWithFrame:CGRectMake(0, DEVH-120, DEVW, 120)];
    
    depview.backgroundColor = [UIColor grayColor];
    
    depview.alpha = .95;
    
    [self.view addSubview:depview];
    
    depText = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 80)];
    
    depText.layer.borderColor = [UIColor redColor].CGColor;
    
    depText.layer.borderWidth =1.0;
    
    depText.font = [UIFont systemFontOfSize:17];
    
    depText.layer.cornerRadius =5.0;
    
    [depview addSubview:depText];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(DEVW-70, 85, 60, 30);
    
    [btn setTitle:@"评论" forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 6;
    
    [btn setBackgroundColor:[UIColor colorWithRed:255./255. green:48./255. blue:48./255. alpha:1]];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [depview addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn1.frame = CGRectMake(0, 85, 60, 30);
    
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    
    btn1.layer.cornerRadius = 6;
    
    [btn1 setBackgroundColor:[UIColor colorWithRed:255./255. green:48./255. blue:48./255. alpha:1]];
    
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [depview addSubview:btn1];

    
    [btn addTarget:self action:@selector(submitdep) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(cancelDep) forControlEvents:UIControlEventTouchUpInside];
    
    depview.hidden = YES;
    
    
    pullToMore = [[DSBottomPullToMoreManager alloc]initWithPullToMoreViewHeight:60.0f tableView:contentTab withClient:self];
    [pullToMore setPullToMoreViewVisible:YES];


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

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    CModelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[CModelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    TModel *model = [dataSource objectAtIndex:indexPath.row];
    cell.contentLable.text =model.content ;
    cell.supportLabel.text = [model.priseCount isEqualToString:@""]?@"0":model.priseCount;
    cell.badLabel.text = [model.depraiseCount isEqualToString:@""]?@"0":model.depraiseCount;
    cell.collectLabel.text = [model.discussCount isEqualToString:@""]?@"0":model.discussCount;
    cell.supportBtn.tag = indexPath.row + 1000;
    
    [cell.supportBtn addTarget:self action:@selector(supportClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.badBtn.tag = indexPath.row+2000;
    
    [cell.badBtn addTarget:self action:@selector(badClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.collectBtn.tag = indexPath.row+3000;
    
    [cell.collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    
  //  cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TModel *model = [dataSource objectAtIndex:indexPath.row];
    TdetailVc *vc = [[TdetailVc alloc]init];
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:NO];
    
    depview.hidden = YES;
    
    [depText resignFirstResponder];
}

#pragma mark button click handel
//赞
-(void)supportClick:(UIButton *)click
{
    [WToast showWithText:@"赞了一下"];
    
    UIImageView *images = (UIImageView *)[click.superview viewWithTag:11];
    
    [click.superview addSubview:images];
    
    [self animation:images];
    [self clickAction:1 andClickIndex:(int)click.tag];
}
//踩
-(void)badClick:(UIButton *)click
{
    [WToast showWithText:@"踩了一下"];
    
    UIImageView *images = (UIImageView *)[click.superview viewWithTag:12];
    
    [click.superview addSubview:images];
    
    [self animation:images];
    [self clickAction:2 andClickIndex:(int)click.tag];
    
}
-(void)clickAction:(int)actId andClickIndex:(int)index
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"bbs" forKey:@"mod"];
    [dic setObject:@"click" forKey:@"mods"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];
   // [dic setObject:<#(id)#> forKey:<#(id<NSCopying>)#>]
    if(actId==1)
    {
        TModel *model = [dataSource objectAtIndex:index-1000];
        [dic setObject:model.ids forKey:@"id"];
        [dic setObject:@"1" forKey:@"praise"];
         [dic setObject:@"0" forKey:@"depraise"];
        [dic setObject:@"0" forKey:@"isdiscuss"];
    }
    else if (actId==2)
    {
        TModel *model = [dataSource objectAtIndex:index-2000];
        [dic setObject:model.ids forKey:@"id"];
        [dic setObject:@"0" forKey:@"praise"];
        [dic setObject:@"1" forKey:@"depraise"];
        [dic setObject:@"0" forKey:@"isdiscuss"];

    }
    [SVHTTPRequest GET:@"/set_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"带你咱的返回新消息%@",response);
    }];
}
//评论
-(void)collectClick:(UIButton *)click
{
    depIndex = click.tag-3000;
//    [WToast showWithText:@"收藏成功了"];
//    UIImageView *images = (UIImageView *)[click.superview viewWithTag:13];
//    [click.superview addSubview:images];
//    [self animation:images];
    depview.hidden = NO;
    
    [depText becomeFirstResponder];
    
   
    
}

-(void)animation:(UIImageView *)obj
{
    CGAffineTransform oldtransform = obj.transform;
    
    UIImage *oldimage = obj.image;
    
    [UIView animateWithDuration:.7 animations:^{
        
        UIImage *newimage = nil;
    
        if(obj.tag==11)newimage = [UIImage imageNamed:@"点赞2"];
        
        else if (obj.tag==12)newimage = [UIImage imageNamed:@"踩下2"];
        
        else newimage = [UIImage imageNamed:@"评论2"];
        
        [obj setImage:newimage];
        
        CGAffineTransform newtransform = CGAffineTransformMakeScale(1.2, 1.2);
        
        [obj setTransform:newtransform];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 animations:^{
            // obj.alpha = 0;
        } completion:^(BOOL finished) {
            //[obj removeFromSuperview];
            [obj setTransform:oldtransform];
            
            [obj setImage:oldimage];
           // [obj setImage:<#(UIImage *)#>]
        }];
    }];
}
//发表评论
-(void)submitdep
{
    //to do department handel....
    [depText resignFirstResponder];
    
    [UIView animateWithDuration:.5 animations:^{
        depview.frame = CGRectMake(0, DEVH-120, DEVW, 120);
        
    } completion:^(BOOL finished) {
        depview.hidden = YES;
        
    }];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"bbs" forKey:@"mod"];
    [dic setObject:@"click" forKey:@"mods"];
    TModel *model = [dataSource objectAtIndex:depIndex];
    [dic setObject:model.ids forKey:@"id"];
    [dic setObject:@"0" forKey:@"praise"];
    [dic setObject:@"0" forKey:@"depraise"];
    [dic setObject:@"1" forKey:@"isdiscuss"];
    [dic setObject:depText.text forKey:@"content"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];
    [SVHTTPRequest GET:@"/set_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"评论的返回信息%@",urlResponse);
        if(error!=nil)
            return ;
        else {
            NSString *str = (NSString *)response;
            if([str isEqualToString:@"1"])
                [WToast showWithText:@"评论成功"];
            else [WToast showWithText:@"评论失败"];
        }
    }];
    
    
}
-(void)cancelDep
{
    depview.hidden = YES;
    [self.view endEditing:YES];
}
//发帖
-(void)disTub:(UIButton *)click
{
    depview.hidden = YES;
    
    [depText resignFirstResponder];
    
    DistubVc *distubVc = [[DistubVc alloc]init];
    
    [self.navigationController pushViewController:distubVc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
    // Dispose of any resources that can be recreated.
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
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
