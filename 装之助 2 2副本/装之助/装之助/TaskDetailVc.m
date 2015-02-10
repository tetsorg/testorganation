//
//  TaskDetailVc.m
//  装之助
//
//  Created by caiyc on 14/11/25.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "TaskDetailVc.h"
#import "UIImageView+webimage.h"
@interface TaskDetailVc ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UITableView *myTab;
    NSArray *labelArr;
    NSMutableArray *dataSource;
    UIView *corverView;
    UIView *departView;
    NSDictionary *typeDic;
}
@end

@implementation TaskDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   // typeDic = [NSDictionary dictionary];
    NSArray *temparr = @[@"不限",@"电工",@"水工",@"木工",@"油漆工",@"打墙工",@"搬运工",@"贴墙纸",@"泥工",@"吊顶",@"乱瓷",@"结墙",@"清理工"];
    NSArray *keyarr = @[@"-1",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    typeDic = [NSDictionary dictionaryWithObjects:temparr forKeys:keyarr];
   
    dataSource = [NSMutableArray array];
    [dataSource addObject:[NSString stringWithFormat:@"标题:%@",_model.titles]];
    NSString *typeName = [typeDic objectForKey:_model.type];
    [dataSource addObject:[NSString stringWithFormat:@"类别:%@",typeName]];
    [dataSource addObject:[NSString stringWithFormat:@"工价:%@",_model.price]];
    [dataSource addObject:[NSString stringWithFormat:@"联系人:%@",_model.contactPeople]];
    [dataSource addObject:[NSString stringWithFormat:@"手机号:%@",_model.contactNum]];
    [dataSource addObject:[NSString stringWithFormat:@"小区:%@",_model.xiaoQu]];
    [dataSource addObject:[NSString stringWithFormat:@"户型:%@",_model.huXing]];
    [dataSource addObject:[NSString stringWithFormat:@"面积:%@",_model.areas]];
    [dataSource addObject:[NSString stringWithFormat:@"周边建筑:%@",_model.zhouBianJZ]];
    [dataSource addObject:[NSString stringWithFormat:@"城市:%@",_model.cityName]];
    [dataSource addObject:[NSString stringWithFormat:@"区域:%@",_model.regionName]];
    [dataSource addObject:[NSString stringWithFormat:@"地址:%@",_model.address]];
    [dataSource addObject:[NSString stringWithFormat:@"详细说明:%@",_model.xiangXiSM]];
    [dataSource addObject:[NSString stringWithFormat:@"发布时间:%@",_model.time]];
    NSString *status = [_model.status isEqualToString:@"0"]?@"未完结":@"已完结";
    NSString *isrecieved = _model.isrecieve?@"已接受":@"未接收";
    [dataSource addObject:[NSString stringWithFormat:@"任务状态:%@",isrecieved]];
    [dataSource addObject:[NSString stringWithFormat:@"任务完结:%@",status]];
    [dataSource addObject:[NSString stringWithFormat:@"评语:%@",_model.evalution]];
    //labelArr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",];
    [FuncPublic InstanceNavgationBar:@"任务详情" action:@selector(back) superclass:self isroot:NO];
    UIScrollView *imagescro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, 100)];
    imagescro.delegate =self;
    imagescro.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imagescro];
    if(![_model.imageurl isEqualToString:@""])
    {
        if(_model.imageArr.count>0)
        {
            imagescro.contentSize = CGSizeMake(DEVW *_model.imageArr.count, 100);
            for(int i =0;i<_model.imageArr.count;i++)
            {
                UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(DEVW*i, 0, DEVW, 100)];
                NSString *imgurl = _model.imageArr[i];
                [images setImageWithURL:[NSURL URLWithString:imgurl]];
                [imagescro addSubview:images];
                images.contentMode = UIViewContentModeScaleAspectFit;
                
            }
        }
        else
        {
            UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 100)];
            NSString *imgurl = _model.imageurl;
            [images setImageWithURL:[NSURL URLWithString:imgurl]];
            [imagescro addSubview:images];
            images.contentMode = UIViewContentModeScaleAspectFit;
        }
    }
    else imagescro.frame = CGRectMake(0, NAVBAR_H, 0, 0);
    
    
    
    UIView *bottomView =  [FuncPublic instanceview:CGRectMake(0, DEVH-50, DEVW, 50) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
  
    NSString *titles = @"";
    NSString *uid = [FuncPublic GetDefaultInfo:@"uid"];
    bool hidd = 0;
    if([_model.uids isEqualToString:uid])
    {
        
    if(_model.isrecieve&&[_model.status isEqualToString:@"0"])
    
        titles = @"评价员工";
        
        else hidd = 1;
    
    }
    else if (!_model.isrecieve)
    {
        titles = @"接受任务";
    }
    else hidd = 1;
    
        [FuncPublic instaceSimpleButton:CGRectMake(0, 0, DEVW, 50) andtitle:titles addtoview:bottomView parentVc:self action:@selector(selectTask:) tag:512];
    bottomView.hidden = hidd;
    
    float heii = hidd?0:50;
    myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+imagescro.frame.size.height, DEVW, DEVH-NAVBAR_H-heii-imagescro.frame.size.height) style:UITableViewStylePlain];
    
    myTab.delegate = self;
    myTab.dataSource = self;
    [self.view addSubview:myTab];
    
    
    
    corverView = [FuncPublic instanceview:CGRectMake(0, 0, DEVW, DEVH) andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
    corverView.alpha = .5;
    corverView.hidden = 1;
    
   
    departView = [FuncPublic instanceview:CGRectMake(10, DEVH/2-200, (DEVW-20),200 ) andcolor:[UIColor whiteColor] addtoview:self.view andparentvc:self isadption:NO];
    departView.hidden = 1;
    [FuncPublic InstanceLabel:@"评价员工" RECT:CGRectMake(0,0,(DEVW-20),30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:departView Lines:0 TAG:132 Ailgnment:1];
    UITextView *departtext = [[UITextView alloc]initWithFrame:CGRectMake(0, 40,DEVW-20, 120)];
    departtext.layer.borderWidth = 1;
    departtext.layer.borderColor = [UIColor grayColor].CGColor;
    departtext.font = [UIFont systemFontOfSize:16];
    departtext.tag = 1024;
    [departView addSubview:departtext];
    [FuncPublic instaceSimpleButton:CGRectMake(0, 160, (DEVW-20)/2-20, 40) andtitle:@"提交评价" addtoview:departView parentVc:self action:@selector(evalution:) tag:7548];
    [FuncPublic instaceSimpleButton:CGRectMake((DEVW-20)/2+10, 160, (DEVW-20)/2-20, 40) andtitle:@"取消" addtoview:departView parentVc:self action:@selector(hiddViews:) tag:75834];
    
    
    UITapGestureRecognizer *gets = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddViews:)];
    [self.view addGestureRecognizer:gets];
    gets.delegate = self;
    
   // HandelSuccess
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockact:) name:@"HandelSuccess" object:@"1"];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockact:) name:@"HandelFailed" object:@"0"];
//    FuncPublic instanceview:<#(CGRect)#> andcolor:<#(UIColor *)#> addtoview:<#(UIView *)#> andparentvc:<#(UIViewController *)#> isadption:<#(BOOL)#>
    
   // dataSource addObject:_model.
   // }

    // Do any additional setup after loading the view.
}
//-(void)blockact:(NSNotification *)no
//{
//    NSString *str = (NSString *)no.object;
//    NSString *tempstr = @"";
//    if([str isEqualToString:@"1"])
//    {
//        tempstr = @"操作成功";
//        [WToast showWithText:tempstr];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {tempstr = @"操作失败";
//        [WToast showWithText:tempstr];
//    }
//    
//    
//}

-(void)selectTask:(UIButton *)click
{
    if([click.titleLabel.text isEqualToString:@"接受任务"])
    {
        [self recieveTask];
    }
    if([click.titleLabel.text isEqualToString:@"评价员工"])
    {
        departView.hidden = 0;
        corverView.hidden = 0;
    }
}
-(void)recieveTask
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"task" forKey:@"mod"];
    [dic setObject:@"ctask" forKey:@"mods"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"worker"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];
    [dic setObject:_model.ids forKey:@"id"];
    [SVHTTPRequest GET:@"/set_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(error!=nil)
        
            return ;
        NSString *tempstr = (NSString *)response;
        if([tempstr isEqualToString:@"1"])
        {
            [ WToast showWithText:@"操作成功"];
            [self.navigationController popViewControllerAnimated:YES];
            }
        
      //  NSLog(@"接受任务返回信息----%@",urlResponse);
    }];
}
-(void)evalution:(UIButton *)click
{
    [self.view endEditing:YES];
    departView.hidden = 1;
    corverView.hidden = 1;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"task" forKey:@"mod"];
    [dic setObject:@"etask" forKey:@"mods"];
    UITextView *texts = (UITextView *)[self.view viewWithTag:1024];
    [dic setObject:texts.text forKey:@"evaluation"];
   // [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"worker"];
   // [dic setObject:_model.ids forKey:@"uid"];
    [dic setObject:_model.ids forKey:@"id"];
    [SVHTTPRequest GET:@"/set_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(error!=nil)
            return ;
        else
        {
            NSString *temp = (NSString *)response;
            if ([temp isEqualToString:@"1"]) {
                [WToast showWithText:@"操作成功"];
            }
            else [WToast showWithText:@"操作失败"];
        }
       // NSLog(@"接受任务返回信息----%@",urlResponse);
      //  NSLog(@"pingjia response %@",response);
    }];

}
-(void)hiddViews:(UITapGestureRecognizer *)taps
{
    [self.view endEditing:YES];
    departView.hidden = 1;
    corverView.hidden = 1;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if(!cell)
        {
        
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
    cell.textLabel.text = dataSource[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
