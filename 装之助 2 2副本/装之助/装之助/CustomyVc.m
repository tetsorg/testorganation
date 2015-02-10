//
//  CustomyVc.m
//  装之助
//
//  Created by caiyc on 14/11/10.
//  Copyright (c) 2014年 none. All rights reserved.
//
//我要装修和我要定制
#import "CustomyVc.h"
#import "CityListVc.h"
#import "SVHTTPClient.h"
#import "SVHTTPRequest.h"
@interface CustomyVc ()<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *backScro;
    UIView *selectView;
    NSString *valiCode;//验证码
    NSString *cityName;//城市名
    NSString *roomType;//居室类型
    NSString *colourType;//装修风格
}
@end

@implementation CustomyVc
-(void)viewWillAppear:(BOOL)animated
{
   
//    UILabel *label =(UILabel *)[self.view viewWithTag:4355];
//    
//    label.text = @"北京";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    cityName = @"南昌";
    roomType = @"一居室";
    colourType = @"复古风尚";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetUi) name:@"changecity" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(missKb)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor whiteColor];
    [FuncPublic InstanceNavgationBar:_titlestring action:@selector(back) superclass:self isroot:NO];
    [self initContentViews];
    // Do any additional setup after loading the view.
}
-(void)missKb
{
    [self.view endEditing:YES];
}
-(void)resetUi
{
    UILabel *label =(UILabel *)[self.view viewWithTag:4355];
    label.text = [FuncPublic GetDefaultInfo:@"cityName"];
}
-(void)initContentViews
{
    backScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H)];
    backScro.contentSize = CGSizeMake(DEVW, 50*10+50);
    backScro.delegate = self;
    [self.view addSubview:backScro];
    backScro.tag = 2;
    NSArray *labelArray = @[@"我的称呼:",@"联系电话:",@"验  证  码:",@"选择所在城市",@"房子面积:",@"我的地址:"];
    NSArray *textArray = @[@"请输入您的姓名",@"请输入您的手机号码",@"请输入验证码",@"",@"平方米",@"请输入您的地址"];
    //填入个人信息项
    for(int i=0;i<labelArray.count;i++)
    {
        [FuncPublic InstanceLabel:labelArray[i] RECT:CGRectMake(20, 51*i+10, 100, 30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:backScro Lines:0 TAG:i+133 Ailgnment:2];
        [FuncPublic instanceview:CGRectMake(0, 50*(i+1), DEVW, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:backScro andparentvc:self isadption:NO];
        if(i!=3)
        {
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(130, 51*i+10, DEVW-130, 30)];
            
            textField.placeholder = textArray[i];
            
            [backScro addSubview:textField];
            
            textField.tag = i+1000;
            
            textField.delegate = self;
           // if(i!=5)
            textField.returnKeyType = UIReturnKeyNext;
           // else textField.returnKeyType = UIReturnKeyDone;
        }
        else
        {
            //选择城市项
            [FuncPublic InstanceLabel:@"南昌" RECT:CGRectMake(130, 51*i+10, 50, 30) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:backScro Lines:0 TAG:4355 Ailgnment:1];
            
             [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(DEVW-45, 51*i+17, 15, 15) Target:backScro TAG:563567 isadption:NO];
            
            [FuncPublic instaceSimpleButton:CGRectMake(130, 51*i+10, DEVW-130, 30) andtitle:nil addtoview:backScro parentVc:self action:@selector(selectCities:) tag:64372647];
        }
        if(i==2)
        {
            UIButton *btn = [FuncPublic instaceSimpleButton:CGRectMake(DEVW-80, 51*i+10, 80, 30) andtitle:@"获取验证码" addtoview:backScro parentVc:self action:@selector(getValidate) tag:5456];
            
            
            
            [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            
           

        }
    }
    //选择房子类型项
    for(int i =7;i<9;i++)
    {
    [FuncPublic instanceview:CGRectMake(0, 50*i, DEVW, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:backScro andparentvc:self isadption:NO];
    }
    
    NSArray *typeArray = @[@"一居室",@"二居室",@"三居室",@"三居室以上"];
    
    int btnwid = DEVW/typeArray.count;
    selectView = [FuncPublic instanceview:CGRectMake(0, 51*6+10, btnwid, 30) andcolor:[UIColor grayColor] addtoview:backScro andparentvc:self isadption:NO];
    for(int i =0;i<typeArray.count;i++)
    {
        UIButton *btn = [FuncPublic instaceSimpleButton:CGRectMake(btnwid*i, 51*6+10, btnwid, 30) andtitle:typeArray[i] addtoview:backScro parentVc:self action:@selector(selectType:) tag:i+10234];
        
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    if([_titlestring isEqualToString:@"我要定制"])
    {
    //
    [FuncPublic InstanceLabel:@"我要定制类型" RECT:CGRectMake(20,51*7+10,100,30) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:backScro Lines:0 TAG:5748756 Ailgnment:2];
    
    [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(DEVW-45, 51*7+17, 15, 15) Target:backScro TAG:563567 isadption:NO];
        
    [FuncPublic instaceSimpleButton:CGRectMake(20, 51*7, DEVW-20, 50) andtitle:nil addtoview:backScro parentVc:self action:@selector(selectCustomyType:) tag:146];
    }
    else
    {
        [FuncPublic InstanceLabel:@"点击           ,填写更多信息,可以为您提供更加匹配的案列!" RECT:CGRectMake(20,51*7+10,290,30) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:backScro Lines:0 TAG:43765 Ailgnment:2];
      UIButton *btn = [FuncPublic instaceSimpleButton:CGRectMake(40, 51*7+5, 50, 20) andtitle:@"更多" addtoview:backScro parentVc:self action:@selector(selectMore) tag:46376];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btn .titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    [FuncPublic instaceSimpleButton:CGRectMake(DEVW/2-25, 51*8+10, 50, 30) andtitle:@"发布" addtoview:backScro parentVc:self action:@selector(distub:) tag:57];
    
    
    
}
-(void)selectMore
{
    UILabel *label = (UILabel *)[self.view viewWithTag:43765];
    UIButton *btn = (UIButton *)[self.view viewWithTag:46376];
    UIButton *btns = (UIButton *)[self.view viewWithTag:57];
    [btns setFrame:CGRectMake(btns.frame.origin.x
                             , btns.frame.origin.y+50*5, btns.frame.size.width, btns.frame.size.height)];
    backScro.contentSize = CGSizeMake(DEVW, 50*15);
    [label removeFromSuperview];
    [btn removeFromSuperview];
    [FuncPublic InstanceLabel:@"选择装修风格" RECT:CGRectMake(20,51*7+10,100,30) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:backScro Lines:0 TAG:5748756 Ailgnment:2];
    
    [FuncPublic InstanceImageView:@"right" Ect:@"png" RECT:CGRectMake(DEVW-45, 51*7+17, 15, 15) Target:backScro TAG:563567 isadption:NO];
    
    [FuncPublic instaceSimpleButton:CGRectMake(20, 51*7, DEVW-20, 50) andtitle:nil addtoview:backScro parentVc:self action:@selector(selectCustomyType:) tag:145];
    NSArray *moreArr = @[@"装修预算:",@"我的邮箱:"];
    //分隔线
    for(int i =8;i<10;i++)
    {
        [FuncPublic instanceview:CGRectMake(0, 50*(i+1), DEVW, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:backScro andparentvc:self isadption:NO];
        [FuncPublic InstanceLabel:moreArr[i-8] RECT:CGRectMake(20, 51*(i-0)+10, 100, 30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:backScro Lines:0 TAG:i+133 Ailgnment:2];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(130, 51*(i-0)+10, DEVW-130, 30)];
        if(i==8)
        {
        textField.placeholder = @"万元";
            textField.returnKeyType = UIReturnKeyNext;
        }
        
        [backScro addSubview:textField];
        
        textField.tag = i+1000;
        
        textField.delegate = self;

    }
    [FuncPublic InstanceLabel:@"具体要求:" RECT:CGRectMake(20,51*10+10,80,30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:backScro Lines:0 TAG:43656 Ailgnment:2];
    
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(100,51*10+10, DEVW-100, 100)];
    
  //  textview.layer.borderColor = [UIColor blackColor].CGColor;
   // textview.layer.borderWidth = 1.0;
    
    textview.font = [UIFont systemFontOfSize:15];
    
    
    [backScro addSubview:textview];
    textview.delegate = self;
    textview.tag = 10010;
    textview.returnKeyType = UIReturnKeyDone;
    [FuncPublic instanceview:CGRectMake(0, textview.frame.origin.y+textview.frame.size.height+10, DEVW, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:backScro andparentvc:self isadption:NO];

}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(ISIPHONE4||ISIPHONE5)
    [backScro setContentOffset:CGPointMake(0, 450) animated:YES];
    else
        [backScro setContentOffset:CGPointMake(0, 250) animated:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
//获取验证码
-(void)getValidate
{
    
}
-(void)selectCities:(UIButton *)sender
{
    
    CityListVc *cityList = [[CityListVc alloc]init];
    [self.navigationController pushViewController:cityList animated:NO];
   // [self presentViewController:cityList animated:YES completion:nil];
}
//选择房子类型
-(void)selectType:(UIButton *)sender
{
    selectView.frame = sender.frame;
    roomType = sender.titleLabel.text;
    DLog(@"选择的房子类型:%@",sender.titleLabel.text);
}
//选择定制或装修类型
-(void)selectCustomyType:(UIButton *)sender
{
    
}
//发布
-(void)distub:(UIButton *)sender
{
    NSArray *paramArr = @[@"name",@"phone",@"title",@"city",@"area",@"adds",@"flah",@"type",@"price",@"mail",@"content"];
    NSMutableArray *paramArrs = [NSMutableArray array];
    for(UITextField *vv in backScro.subviews)
    {

        if([vv isKindOfClass:[UITextField class]]&&[vv.text isEqualToString:@""])
        {
            
            
            [vv becomeFirstResponder];
            //[WToast showWithText:@"请填入必填信息"];
            return;
        }
        else if([vv isKindOfClass:[UITextField class]])
        {
            [paramArrs addObject:vv.text];
           // NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
        }
       
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(paramArrs.count>5){
    [dic setObject:paramArrs[0] forKey:paramArr[0]];
    [dic setObject:paramArrs[1] forKey:paramArr[1]];
    [dic setObject:paramArrs[2] forKey:paramArr[2]];
    [dic setObject:paramArrs[3] forKey:paramArr[4]];
    [dic setObject:paramArrs[4] forKey:paramArr[5]];
    [dic setObject:paramArrs[5] forKey:paramArr[8]];
    [dic setObject:paramArrs[6] forKey:paramArr[9]];
    UITextView *textviews = (UITextView *)[backScro viewWithTag:10010];
    [dic setObject:textviews.text forKey:paramArr[10]];
        
    }
    else
    {
        [dic setObject:paramArrs[0] forKey:paramArr[0]];
        [dic setObject:paramArrs[1] forKey:paramArr[1]];
        [dic setObject:paramArrs[2] forKey:paramArr[2]];
        [dic setObject:paramArrs[3] forKey:paramArr[4]];
        [dic setObject:paramArrs[4] forKey:paramArr[5]];
    }
    [dic setObject:cityName forKey:paramArr[3]];
    [dic setObject:roomType forKey:paramArr[6]];
    [dic setObject:colourType forKey:paramArr[7]];
    [dic setObject:@"1000" forKey:@"id"];
    NSString *fitmentclass;
    if([_titlestring isEqualToString:@"我要定制"])fitmentclass = @"1";
    else fitmentclass = @"2";
    [dic setObject:fitmentclass forKey:@"fitmentclass"];
   
    [dic setObject:@"renovation" forKey:@"mod"];
    [SVHTTPRequest GET:@"/set_api.php" parameters:dic completion:^(id  response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(error!=nil){
            [WToast showWithText:@"发布失败"];
            return;
        }
        else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
            [WToast showWithText:@"发布成功"];
        DLog(@"返回的地址信息：%@",urlResponse);
        DLog(@"返回信息:%@",response);
    }];
    
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(ISIPHONE4&&textField.tag>=1004)
    {
        UIScrollView *backscro =(UIScrollView *)[self.view viewWithTag:2];
        
        [backscro setContentOffset:CGPointMake(0, 150+(textField.tag-1004)*40) animated:YES];
    }
    else if (ISIPHONE5&&textField.tag>=1005)
    {
        UIScrollView *backscro =(UIScrollView *)[self.view viewWithTag:2];
        
        [backscro setContentOffset:CGPointMake(0, 100+(textField.tag-1005)*40) animated:YES];
    }
    else if(ISIPHONE6||ISIPHONE6_PLUS)
    {
        if(textField.tag>=1008)
        [backScro setContentOffset:CGPointMake(0, 200) animated:YES];
        
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    long int  tags = textField.tag;
    if(tags!=1002)
    {
        
    UITextField *textfield = (UITextField*)[self.view viewWithTag:tags+1];
        
    [textfield becomeFirstResponder];
    }
    else
    {
        UITextField *textfield = (UITextField*)[self.view viewWithTag:tags+2];
        [textfield becomeFirstResponder];
        
    }
            
     return YES;
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
