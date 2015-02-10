//
//  DistubTaskVc.m
//  装之助
//
//  Created by guest on 14/11/24.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "DistubTaskVc.h"
#import "SelectTypeVc.h"
#import "ZYQAssetPickerController.h"
#import "PicUpload.h"
#import "MyDbHandel.h"
#import "MTMudelDaTa.h"
#import "CityListVc.h"
#import "PIc.h"
#define RowHeigh 50
#define PicHeigh DEVW/5
@interface DistubTaskVc ()<UITextFieldDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *picScro;
    NSMutableArray *picArr;
    UIView *coverView;
    int TAG;
    NSMutableArray *picname;
    UITableView *regionTab;
    NSMutableArray *regionArr;
    NSString *regionID;
    NSString *regionName;
    
    UITextField*titleTf;
    UITextField *priceTf;
    UITextField *contactPerTf;
    UITextField *contactNum;
    UITextField *yanZMTf;
    UITextField *xiaoQuTf;
    UITextField *huXTf;
    UITextField *zhouBianJZTf;
    UITextField *addressTf;
    UITextField *xiangXiSMTf;
    
    NSString *typeID;
    
}
@end

@implementation DistubTaskVc

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                       (id)[UIColor grayColor].CGColor,
                       (id)[UIColor blackColor].CGColor,nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    picname = [NSMutableArray array];
    regionArr = [NSMutableArray array];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeType:) name:@"changetype" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockact:) name:@"HandelSuccess" object:@"1"];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockact:) name:@"HandelFailed" object:@"0"];
    
   
    picArr = [NSMutableArray array];
    [FuncPublic InstanceNavgationBar:@"我要发布任务" action:@selector(back) superclass:self isroot:NO];
    [self initContentViews];
    // Do any additional setup after loading the view.
}
//-(void)blockact:(NSNotification *)no
//{
//    NSString *str = (NSString *)no.object;
//    NSString *tempstr = @"";
//    if([str isEqualToString:@"1"])
//    {
//        tempstr = @"操作成功";
//    [WToast showWithText:tempstr];
//    [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {tempstr = @"操作失败";
//    [WToast showWithText:tempstr];
//    }
//    
//    
//}
-(void)changeType:(NSNotification *)no
{
    NSDictionary *dic = no.userInfo;
    UILabel *label =(UILabel *)[self.view viewWithTag:443];
    label.text = [dic objectForKey:@"type"];
    typeID = [dic objectForKey:@"typeid"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(void)initContentViews
{
    NSArray *arr = @[@"选择类别",@"所在区域",@"标题",@"给出的工价",@"联系人",@"手机号",@"验证码",@"小区名称",@"户型",@"周边大型建筑",@"地址",@"详细说明"];
   
    UIScrollView *backScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H)];
    backScro.contentSize = CGSizeMake(DEVW, RowHeigh*arr.count+130+PicHeigh*2);
    [self.view addSubview:backScro];
    backScro.delegate = self;
    backScro.backgroundColor = [UIColor whiteColor];
    backScro.tag = 435;
    NSString *appStr = @":";
    for(int i=0;i<arr.count;i++)
    {
        NSString *appstr=nil;
        if(i>1)
            appstr = [arr[i] stringByAppendingString:appStr];
        else appstr = arr[i];

        [FuncPublic InstanceLabel:appstr RECT:CGRectMake(10, RowHeigh*i, 90, RowHeigh) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:backScro Lines:0 TAG:256+i Ailgnment:2];
        [FuncPublic instanceview:CGRectMake(0, RowHeigh*(i+1), DEVW, 1) andcolor:[UIColor grayColor] addtoview:backScro andparentvc:self isadption:NO];
//        if(i>1){
//        UITextField *textFied = [[UITextField alloc]initWithFrame:CGRectMake(100, RowHeigh*i, DEVW-100, RowHeigh)];
//            [backScro addSubview:textFied];
//            textFied.delegate = self;
//            textFied.tag = i+12313;
//            if(i==2)
//            {
//                textFied.placeholder = @"输入任务标题(必填)";
//            }
//            if(i>3&&i<8)
//                textFied.placeholder = placeStrArr[i-4];
//        }
        
        
    }
    [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(DEVW-40, 20, 20, 20) Target:backScro TAG:777 isadption:NO];
    
    [FuncPublic InstanceLabel:@"选择类别" RECT:CGRectMake(100, 20, DEVW-40, 20) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:backScro Lines:0 TAG:443 Ailgnment:1];
    
    [FuncPublic InstanceImageView:@"downl" Ect:@"png" RECT:CGRectMake(DEVW-40, 20+RowHeigh, 20, 20) Target:backScro TAG:779 isadption:NO];
    
    [FuncPublic InstanceLabel:@"选择区域" RECT:CGRectMake(100, 20+RowHeigh, DEVW-40, 20) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:backScro Lines:0 TAG:444 Ailgnment:1];
     NSArray *placeStrArr = @[@"请输入您的姓名(必填)",@"请输入您的手机号码(必填)",@"请输入验证码",@"请输入您所在小区名称"];
    int tfHeight = 30;
    titleTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh *2+10, DEVW-100, tfHeight) andplaceholder:@"请输入标题(必填)" andTag:123 addtoView:backScro andPvc:self];
    priceTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*3+10, DEVW-100, tfHeight) andplaceholder:@"请输入工价(必填)" andTag:124 addtoView:backScro andPvc:self];
    contactPerTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*4+10, DEVW-100, tfHeight) andplaceholder:@"请输入联系人姓名(必填)" andTag:125 addtoView:backScro andPvc:self];
    contactNum = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*5+10, DEVW-100, tfHeight) andplaceholder:placeStrArr[1] andTag:126 addtoView:backScro andPvc:self];
    
    yanZMTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*6+10, DEVW-100, tfHeight) andplaceholder:placeStrArr[2] andTag:127 addtoView:backScro andPvc:self];
    
    xiaoQuTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*7+10, DEVW-100, tfHeight) andplaceholder:placeStrArr[3] andTag:128 addtoView:backScro andPvc:self];
    
    huXTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*8+10, DEVW-100, tfHeight) andplaceholder:@"请输入户型" andTag:129 addtoView:backScro andPvc:self];
    
    zhouBianJZTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*9+10, DEVW-100, tfHeight) andplaceholder:@"请输入周边标识建筑" andTag:129 addtoView:backScro andPvc:self];
    
    addressTf = [FuncPublic instanceTextField:CGRectMake(100, RowHeigh*10+10, DEVW-100, tfHeight) andplaceholder:@"请输入地址(必填)" andTag:130 addtoView:backScro andPvc:self];
    
    xiangXiSMTf = [FuncPublic  instanceTextField:CGRectMake(100, RowHeigh*11+10, DEVW-100, tfHeight) andplaceholder:@"附加说明" andTag:131 addtoView:backScro andPvc:self];
    

    //选择类别按钮
    [FuncPublic instaceSimpleButton:CGRectMake(100, 0, DEVW-100, 50) andtitle:nil addtoview:backScro parentVc:self action:@selector(selectType:) tag:233];
    //选择区域按钮
    [FuncPublic instaceSimpleButton:CGRectMake(100, RowHeigh, DEVW-100, 50) andtitle:nil addtoview:backScro parentVc:self action:@selector(selectRegions:) tag:234];

    
   UIButton *selectpic = [FuncPublic instaceSimpleButton:CGRectMake(10, RowHeigh*arr.count+10, 60, 30) andtitle:@"选择图片" addtoview:backScro parentVc:self action:@selector(selectPic:) tag:2324];
    
    [FuncPublic InstanceLabel:@"最多上传10张图片" RECT:CGRectMake(80,RowHeigh*arr.count+10,100,30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:backScro Lines:0 TAG:2325 Ailgnment:1];
    
    selectpic.titleLabel.font = [UIFont systemFontOfSize:14];
    
    selectpic.backgroundColor = [UIColor greenColor];
   // picScro = [UIScrollView alloc]initWithFrame:CGRectMake(0, selectpic.frame.origin.y+selectpic.frame.size.height, DEVW, <#CGFloat height#>)
    UIView *picView = [FuncPublic instanceview:CGRectMake(0, RowHeigh*arr.count+50, DEVW, PicHeigh*2) andcolor:[UIColor colorWithRed:229./255. green:229./255. blue:229./255. alpha:1] addtoview:backScro andparentvc:self isadption:NO];
    
    picView.tag = 1213;
    
  UILabel *labes =  [FuncPublic InstanceLabel:@"点击图片可预览大图" RECT:CGRectMake(90,backScro.contentSize.height-70 , DEVW-180, 20) FontName:nil Red:255. green:0 blue:0 FontSize:15 Target:backScro Lines:1 TAG:23266 Ailgnment:1];
    labes.hidden = YES;
    UIButton *distubBtn =   [FuncPublic instaceSimpleButton:CGRectMake(100,backScro.contentSize.height-40 , DEVW-200, 40) andtitle:@"发布" addtoview:backScro parentVc:self action:@selector(distubTask:) tag:100];
    
    distubBtn.backgroundColor = [UIColor colorWithRed:255./255. green:48./255. blue:48./255. alpha:1];

    
    
    //预览大图层
    coverView = [FuncPublic instanceview:self.view.bounds andcolor:[UIColor grayColor] addtoview:self.view andparentvc:self isadption:NO];
   // coverView.alpha = .95;
    coverView.hidden = YES;
    [FuncPublic  InstanceImageView:nil Ect:nil RECT:CGRectMake(0, 70, DEVW, DEVH-140) Target:coverView TAG:133 isadption:NO];
  //  [FuncPublic InstanceButton:@"delete" ect:@"png" FileName2:nil ect2:nil RECT:CGRectMake(DEVW-50, 20, 25, 25) AddView:coverView ViewController:self SEL_:@selector(removePic:) Kind:2 TAG:134 isadption:NO];
    [FuncPublic instaceSimpleButton:CGRectMake(DEVW-100, 30, 100, 40) andtitle:@"删除此张" addtoview:coverView parentVc:self action:@selector(deletePic:) tag:135];
    [FuncPublic instaceSimpleButton:CGRectMake(20, 30, 60, 40) andtitle:@"返回" addtoview:coverView parentVc:self action:@selector(removePic:) tag:134];
    
    //区域选择列表
    regionTab = [[UITableView alloc]initWithFrame:CGRectMake(DEVW-150, RowHeigh+NAVBAR_H, 150, 300) style:UITableViewStylePlain];
    regionTab.delegate = self;
    regionTab.dataSource = self;
    regionTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
   // regionTab.backgroundColor = [UIColor grayColor];
    [backScro addSubview:regionTab];
    regionTab.hidden = YES;
}
-(void)deletePic:(UIButton *)click
{
    [self removePic:nil];
    [picArr removeObjectAtIndex:TAG];
//    UIImageView *images = (UIImageView *)[self.view viewWithTag:TAG+10];
//    [images removeFromSuperview];
    [self initPic];
}
//选择类别
-(void)selectType:(UIButton *)click
{
    SelectTypeVc *typeVc = [[SelectTypeVc alloc]init];
    [self.navigationController pushViewController:typeVc animated:NO];
}
//选择所在区
-(void)selectRegions:(UIButton *)click
{
    [[MyDbHandel defaultDBManager]openDb:@"Citylists.sqlite"];
    if(![FuncPublic GetDefaultInfo:@"cid"])
    {
        [WToast showWithText:@"请先选择城市"];
        CityListVc *vc = [[CityListVc alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
        return;
        
    }
    NSString *pids = [FuncPublic GetDefaultInfo:@"cid"];
//    NSString *sql1 = [NSString stringWithFormat:@"select * from %@ where pid = %i  and name ='市辖区'",NAME,[pids integerValue]];
//    NSArray *temparr1 = [[MyDbHandel defaultDBManager]select:sql1];
//    NSString *pidhdj =@"" ;
//    for(MTMudelDaTa *datas in temparr1)
//    {
//      //  NSLog(@"城市pid -------%@",datas.ids);
//      //  pidhdj = datas.ids;
//        // [conditionArr addObject:datas.name];
//        //[reginalDic setObject:datas.ids forKey:datas.name];
//    }
    
    NSLog(@"城市pid %@",pids);
  //  NSLog(<#NSString *format, ...#>)
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where pid = %li and name like '%%区' and name not like '市辖区'",NAME,[pids integerValue ]];
    NSLog(@"sql 语句%@",sql);
    
    NSArray *temparr = [[MyDbHandel defaultDBManager]select:sql];
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where pid = %i and name like '%%区' and name not like '市辖区'",NAME,[pids integerValue]+100];
//    NSArray *temparr = [[MyDbHandel defaultDBManager]select:sql];
   // NSLog(@"区域数组%i",[temparr count]);
    if([temparr count]==0)
    {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where pid = %li and name like '%%区' and name not like '市辖区'",NAME,[pids integerValue ]+100];
        NSLog(@"sql 语句%@",sql);
        
        temparr = [[MyDbHandel defaultDBManager]select:sql];

    }
    regionTab.hidden = !regionTab.hidden;
    regionArr = [NSMutableArray arrayWithArray:temparr];
    [regionTab reloadData];
   
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return regionArr.count;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    MTMudelDaTa *data = [regionArr objectAtIndex:indexPath.row];
    cell.textLabel.text = data.name;
    NSLog(@"city name is %@",data.name);
    cell.contentView.backgroundColor = [UIColor grayColor];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTMudelDaTa *data = [regionArr objectAtIndex:indexPath.row];
    
    UILabel *LB = (UILabel *)[self.view viewWithTag:444];
    LB.text = data.name;
    regionTab.hidden = 1;
    regionID = data.ids;
    regionName = data.name;
}

-(void)initRegions:(NSArray *)arr
{
    UIScrollView *scro = [[UIScrollView alloc]initWithFrame:CGRectMake(DEVW-150, 2*RowHeigh+NAVBAR_H, 100, 300)];
    scro.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scro];
    for(int i=0;i<arr.count;i++)
    {
        MTMudelDaTa *data = [arr objectAtIndex:i];
        [FuncPublic InstanceLabel:data.name RECT:CGRectMake(0, 30*i+1, 100, 30) FontName:nil Red:255./255. green:255./255. blue:255./255. FontSize:14 Target:scro Lines:0 TAG:1 Ailgnment:1];
    }
}
//发布任务
-(void)distubTask:(UIButton *)click
{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    UILabel *lb1 =(UILabel *)[self.view viewWithTag:443];
    UILabel *lb2 = (UILabel *)[self.view viewWithTag:444];
    BOOL types = [lb1.text isEqualToString:@"选择类别"]?NO:YES;
    BOOL regionss = [lb2.text isEqualToString:@"选择区域"]?NO:YES;
    if(!types||!regionss||[titleTf.text isEqualToString:@""]||[titleTf.text isEqualToString:@""]||[priceTf.text isEqualToString:@""]||[contactPerTf.text isEqualToString:@""]||[contactNum.text isEqualToString:@""]||[addressTf.text isEqualToString:@""])
    {
        [WToast showWithText:@"请输入必填信息(包括类别和区域选择)"];
        return;
    }
//    UITextField *titleTf =(UITextField *) [self.view viewWithTag:2+12313];
//    
//     UITextField *priceTf =(UITextField *) [self.view viewWithTag:3+12313];
//    
//     UITextField *contpeopleTf =(UITextField *) [self.view viewWithTag:4+12313];
//    
//     UITextField *phoneTf =(UITextField *) [self.view viewWithTag:5+12313];
//    
//    UITextField *xqmc = (UITextField *)[self.view viewWithTag:7+12313];
//    
//    UITextField *hx = (UITextField *)[self.view viewWithTag:8+12313];
//    
//    UITextField *zbjz = (UITextField *)[self.view viewWithTag:9+12313];
//    
//    UITextField *address = (UITextField *)[self.view viewWithTag:10+12313];
//    
//    UITextField *detail = (UITextField *)[self.view viewWithTag:11+12313];
    
//    for(UITextField *fiels in self.view.subviews)
//    {
//        if([fiels.text isEqualToString:@""])
//        {
//            [WToast showWithText:@"请输入完整信息"];
//            return;
//        }
//    }
    
    [dic setObject:titleTf.text forKey:@"title"];
    NSString *pricestr = priceTf.text;
    long int pricevalue = [pricestr integerValue];
    NSString *priceID = @"";
   // NSArray *temparr = @[@"0-500",@"500-1000",@"1000-1500",@"1500-2000",@"2000-2500",@"2500-3000",@"3000-5000",@"5000-10000",@"10000-20000",@"20000-30000",@"30000-50000",@"50000-70000",@"70000-100000",@"100000以上"];
    if(pricevalue<500)
    {
        priceID = @"1";
    }
    if(500<=pricevalue<1000)
    {
        priceID = @"2";
    }
    if(1000<=pricevalue<1500)
    {
        priceID = @"3";
    }if(1500<=pricevalue<2000)
    {
         priceID = @"4";
    }
    if(2000<=pricevalue<2500)
    {
         priceID = @"5";
    }
    if(2500<=pricevalue<3000)
    {
         priceID = @"6";
    }
    if(3000<=pricevalue<5000)
    {
         priceID = @"7";
    }
    if(5000<=pricevalue<10000)
    {
         priceID = @"8";
    }
    if(10000<=pricevalue<20000)
    {
         priceID = @"9";
    }
    if(2000<=pricevalue<30000)
    {
         priceID = @"10";
    }if(30000<=pricevalue<50000)
    {
         priceID = @"11";
    }if(50000<=pricevalue<70000)
    {
         priceID = @"12";
    }if(70000<=pricevalue<100000)
    {
         priceID = @"13";
    }
    if(pricevalue>=100000)
    {
         priceID = @"14";
    }
    [dic setObject:priceTf.text forKey:@"price"];
    [dic setObject:priceID forKey:@"prices"];
    [dic setObject:contactPerTf.text forKey:@"cname"];
    [dic setObject:contactNum.text forKey:@"phone"];
    [dic setObject:xiaoQuTf.text forKey:@"communit"];
    [dic setObject:huXTf.text forKey:@"units"];
    [dic setObject:zhouBianJZTf.text forKey:@"periphery"];
    [dic setObject:addressTf.text forKey:@"adds"];
    [dic setObject:xiangXiSMTf.text forKey:@"content"];
    [dic setObject:@"task" forKey:@"mod"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"cid"] forKey:@"city"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"cityName"] forKey:@"cityname"];
    [dic setObject:regionID forKey:@"regional"];
    [dic setObject:regionName forKey:@"regionalname"];
    //[dic setObject:<#(id)#> forKey:<#(id<NSCopying>)#>]
    [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];
    [dic setObject:typeID forKey:@"fitmentclass"];
    //[dic setObject:picArr forKey:@"image"];
    if(picArr.count>0)
    {
        for(int i=0;i<picArr.count;i++)
        {
  //  UIImage *images = picArr[i];
   //
   // NSData *imagedata = UIImageJPEGRepresentation(images, 1.0f);
            
   // NSString *encodestring = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
   // [dic setValue:encodestring forKey:[NSString stringWithFormat:@"image%d",i]];
    NSString *keys = i==0?@"image":[NSString stringWithFormat:@"image%i",i];
    [picname addObject:keys];
   
        }
        
    }
    
    NSLog(@"dic is :-------------------%@",dic);

    [PIc postRequestWithURL:@"http://app.wait-u.com/set_api.php" postParems:dic picFilePath:picArr picFileName:picname];
   // [PicUpload postRequestWithURL:@"http://172.16.1.110:8888/httpUpload/Index.aspx" postParems:nil picFilePath:picArr picFileName:picname];
   // [self posts:dic urlstr:@"http://app.wait-u.com/set_api.php"];
   // PIc postRequestWithURL:<#(NSString *)#> postParems:<#(NSMutableDictionary *)#> picFilePath:<#(NSMutableArray *)#> picFileName:<#(NSMutableArray *)#>
}
//选择图片
-(void)selectPic:(UIButton *)click
{
    if(picArr.count>=10)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多上传10张图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新选择", nil];
        [alert show];
        return;
        
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [actionSheet showInView:self.view];
 
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [picArr removeAllObjects];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        [actionSheet showInView:self.view];

    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //相册0，拍照1
    NSLog(@"click index %ld",(long)buttonIndex);
    if(buttonIndex==0)
    {
        
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        
        picker.maximumNumberOfSelection = 10;
        
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        
        picker.showEmptyGroups=NO;
        
        picker.delegate=self;
        
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
        
    }
    else if(buttonIndex==1)
    {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [WToast showWithText:@"摄像头不可用"];
        }
        else{
            UIImagePickerController *pick = [[UIImagePickerController alloc]init];
            
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            pick.delegate = self;
            
            [self presentViewController:pick animated:YES completion:nil];
        }
    }
}
//相机回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
        
        
    UIImage *images =[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(images, .00001);
    UIImage *newimage = [UIImage imageWithData:data];
    [picArr addObject:newimage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if(picArr.count<=10)
        [self initPic];
    }];
    
    
    
}
//相册回调
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    UIView *views =[self.view viewWithTag:1213];
   
    [views.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
  
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
        dispatch_async(dispatch_get_main_queue(), ^{
          
        });
        
        
        for (int i=0; i<assets.count; i++)
        {
            ALAsset *asset=assets[i];
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
          //  UIImage *images =[info objectForKey:UIImagePickerControllerOriginalImage];
            NSData *data = UIImageJPEGRepresentation(tempImg, .00001);
            UIImage *newimage = [UIImage imageWithData:data];
            //[picArr addObject:newimage];

           // NSData *data = UIImageJPEGRepresentation(tempImg, 0.000001);
           // UIImage *images = [UIImage imageWithData:data];
            if(picArr.count<10)
            {
                
            [picArr addObject:newimage];
            }
//            int rownum = i/5;
//            int colunmnum = i%5;
//         
//            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(colunmnum *PicHeigh, rownum*PicHeigh, PicHeigh, PicHeigh)];
//        
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [imgview setImage:tempImg];
//                [views addSubview:imgview];
//                [FuncPublic instaceSimpleButton:imgview.frame andtitle:nil addtoview:views parentVc:self action:@selector(checkBigPic:) tag:256+i];
//            });
        }
        [self initPic];
    });
    
}
-(void)initPic
{
    UIView *views =[self.view viewWithTag:1213];
    UILabel *labes =(UILabel* ) [self.view viewWithTag:23266];
    // views.backgroundColor = [UIColor redColor];
    [views.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i=0;i<picArr.count;i++)
    {
       
           
        
        
        int rownum = i/5;
        int colunmnum = i%5;
        
        UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(colunmnum *PicHeigh, rownum*PicHeigh, PicHeigh, PicHeigh)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [imgview setImage:picArr[i]];
            [views addSubview:imgview];
            imgview.tag = i+10;
            labes.hidden = NO;
            [FuncPublic instaceSimpleButton:imgview.frame andtitle:nil addtoview:views parentVc:self action:@selector(checkBigPic:) tag:256+i];
        });
        
//        else
//        {
//            NSLog(@"delete pic........");
//            [picArr removeObjectAtIndex:i];
//        }

    }
   
    
}
//查看大图
-(void)checkBigPic:(UIButton *)click
{
    coverView.hidden = NO;
    UIImageView *imagew = (UIImageView *)[coverView viewWithTag:133];
    UIImage *images = [picArr objectAtIndex:click.tag-256];
    [imagew setImage:images];
    TAG =(int) click.tag-256;
   
   
}
//移除大图
-(void)removePic:(UIButton *)click

{
    coverView.hidden = YES;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)posts:(NSDictionary *)params urlstr:(NSString *)url picArr:(NSMutableArray *)arr
{
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    //要上传的图片
    for(int i=0;i<arr.count;i++){
   // UIImage *image=arr[i];
    //得到图片的data
   // NSData* data = UIImagePNGRepresentation(image);
    }
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"image"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
   // [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%i", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    //  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //设置接受response的data
    //    if (conn) {
    //        mResponseData = [[NSMutableData data] retain];
    //    }
    
}

//表单提交成功
-(void)posts:(NSDictionary *)params urlstr:(NSString *)url
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    NSArray *imagearr = [params objectForKey:@"image"];
    NSMutableData *myRequestData1=[NSMutableData data];
    
    for(int i=0;i<imagearr.count;i++)
    {
   
    //得到图片的data
    UIImage *image = imagearr[i];
    NSData* data = UIImagePNGRepresentation(image);

    
    NSMutableString *fileTitle=[[NSMutableString alloc]init];
        [fileTitle appendString:MPboundary];
    if(i==0)
    {
        //更改上传的接口参数就行
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"image\";filename=\"%@\"",[NSString stringWithFormat:@"image%d.png",i+1]];
    }
    
    else
    {
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"image%d",i],[NSString stringWithFormat:@"image%d.png",i+1]];
    }
//[myRequestData1 appendData:data];
    
    [fileTitle appendString:endMPboundary];
    
    [fileTitle appendFormat:@"Content-Type:image/png\r\n\r\n"];
        
        [fileTitle appendString:endMPboundary];
        
    [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:data];
        
    
//        // [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",endMPboundary]];
//        [fileTitle appendString:endMPboundary];
        
    [myRequestData1 appendData:[endMPboundary dataUsingEncoding:NSUTF8StringEncoding]];
        
        

}
    
//    [myRequestData1 appendData:[MPboundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[TWITTERFON_FORM_BOUNDARY dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[MPboundary dataUsingEncoding:NSUTF8StringEncoding]];
//    [myRequestData1 appendData:[endMPboundary dataUsingEncoding:NSUTF8StringEncoding]];
    //要上传的图片数组
    // UIImage *image=[params objectForKey:@"image"];
   // NSData *data = UIImageJPEGRepresentation(image, 0.001);
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"image"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:myRequestData1];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%i", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
  //  NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //设置接受response的data
//    if (conn) {
//        mResponseData = [[NSMutableData data] retain];
//    }
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finish---------------------");
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"---------------------%@",response);
}

-(NSString *)postRequestWithURL: (NSString *)url  // IN
postParems: (NSMutableDictionary *)postParems // IN
picFilePath: (NSString *)picFilePath  // IN
picFileName: (NSString *)picFileName;  // IN
{
    
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
       // [key stringByAppendingString:@"cycc"];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n",picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
       // [body appendString:@"cycc........"];
       // [body appendFormat:@"select * from %@ where name = '%@'"]
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
   
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%i", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        return result;
    }
    return nil;
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
