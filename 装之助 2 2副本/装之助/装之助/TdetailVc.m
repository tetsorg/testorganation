//
//  TdetailVc.m
//  装之助
//
//  Created by caiyc on 15/1/6.
//  Copyright (c) 2015年 none. All rights reserved.
//

#import "TdetailVc.h"

@interface TdetailVc ()

@end

@implementation TdetailVc
@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FuncPublic InstanceNavgationBar:@"详情" action:@selector(back) superclass:self isroot:NO];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initContentViews];
    // Do any additional setup after loading the view.
}
-(void)initContentViews
{
    UIScrollView *backscro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H)];
    backscro.contentSize = CGSizeMake(DEVW, backscro.frame.size.height*1.5);
    [self.view addSubview:backscro];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                       (id)[UIColor colorWithRed:127./225. green:255./255. blue:212./255. alpha:1].CGColor,
                       (id)[UIColor whiteColor].CGColor,nil];
    [backscro.layer insertSublayer:gradient atIndex:0];
    
  UIView *PerinfoView =  [FuncPublic instanceview:CGRectMake(10, 5, DEVW-20, 50) andcolor:[UIColor colorWithRed:231./255. green:231./255. blue:231./255. alpha:1] addtoview:backscro andparentvc:self isadption:NO];
   UIImageView *icon = [FuncPublic InstanceImageView:@"笑脸-2" Ect:@"png" RECT:CGRectMake(10, 0, 80, 50) Target:PerinfoView TAG:12 isadption:NO];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    
    [FuncPublic InstanceLabel:model.uid RECT:CGRectMake(120, 0, PerinfoView.frame.size.width-120, 25) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:PerinfoView Lines:1 TAG:13 Ailgnment:2];
    
    [FuncPublic InstanceLabel:model.time RECT:CGRectMake(120,25,PerinfoView.frame.size.width-120,25) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:PerinfoView Lines:1 TAG:14 Ailgnment:2];
    
    NSString *str = model.content;
    UIFont *sfont = [UIFont systemFontOfSize:15];
    float wid = PerinfoView.frame.size.width;
    CGSize Lbsize = [self stringSizeCacultor:str widths:wid fonts:sfont];
    [FuncPublic InstanceLabel:str RECT:CGRectMake(0, 50, PerinfoView.frame.size.width, Lbsize.height) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:PerinfoView Lines:0 TAG:15 Ailgnment:2];
    
    float btnwid = wid/3;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 50+Lbsize.height+10, 100, 40);
    [btn setImage:[UIImage imageNamed:@"点赞1.png"] forState:UIControlStateNormal];//给button添加image
    [btn setImage:[UIImage imageNamed:@"点赞2.png"] forState:UIControlStateHighlighted];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,60);
    [btn setTitle:[model.priseCount isEqualToString:@""]?@"0":model.priseCount forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    [backscro addSubview:btn];
    [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(btnwid, 50+Lbsize.height+10, 100, 40);
    [btn1 setImage:[UIImage imageNamed:@"鄙视1.png"] forState:UIControlStateNormal];//给button添加image
    [btn1 setImage:[UIImage imageNamed:@"鄙视2.png"] forState:UIControlStateHighlighted];
    btn1.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,60);
    [btn1 setTitle:[model.depraiseCount isEqualToString:@""]?@"0":model.depraiseCount forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
    [backscro addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btnwid*2, 50+Lbsize.height+10, 100, 40);
    [btn2 setImage:[UIImage imageNamed:@"评论1.png"] forState:UIControlStateNormal];//给button添加image
    [btn2 setImage:[UIImage imageNamed:@"评论2.png"] forState:UIControlStateHighlighted];
    btn2.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,60);
    [btn2 setTitle:[model.discussCount isEqualToString:@""]?@"0":model.discussCount  forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn2.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
    [backscro addSubview:btn2];
    [btn2 addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
    UIFont *sfonts = [UIFont systemFontOfSize:14];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 40);
//  UIButton *btns =  [FuncPublic instaceImageAndTitleButton:CGRectMake(100, 0, 100, 40) nomalImage:@"鄙视1" selectImage:@"鄙视2" imageEdgeinset:inset titleStr:@"hhdkdl" titlefont:sfonts strAlignment:1 nomalColor:[UIColor blackColor] selectColor:[UIColor redColor] titleEdgeinset:UIEdgeInsetsMake(0, -80, 0, 0)];
//    [self.view addSubview:btns];
   // btn2.frame.origin
    [FuncPublic InstanceLabel:@"最新评论" RECT:CGRectMake(10,btn2.frame.origin.y+btn2.frame.size.height+10,200,20) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:backscro Lines:1 TAG:145 Ailgnment:2];
    
    
}
-(void)btnAct:(UIButton *)click
{
    
}
-(CGSize)stringSizeCacultor:(NSString *)str widths:(CGFloat)widths fonts:(UIFont*)fonts
{
    CGSize iszed = CGSizeMake(widths, MAXFLOAT);
    NSDictionary *attribute = @{NSFontAttributeName:fonts};
    CGSize labelsize = [str boundingRectWithSize:iszed options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
    return labelsize;
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
