//
//  BrandVc.m
//  装之助
//
//  Created by caiyc on 14/11/4.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "BrandVc.h"
#import "UIImageView+webimage.h"
#import "TaskCell.h"
#define FlashHeigh 150
@interface BrandVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *flashView;
    UIView *catogryView;
    NSMutableArray *labelArr;
    UIView *selectView;
    UITableView *proList;
    
}
@end

@implementation BrandVc

- (void)viewDidLoad {
    [super viewDidLoad];
    labelArr = [NSMutableArray array];
    
    [FuncPublic InstanceNavgationBar:@"品牌汇" action:nil superclass:self isroot:YES];
    
    [FuncPublic InstanceImageView:@"downl" Ect:@"png" RECT:CGRectMake(20, 28, 15, 15) Target:self.view TAG:2 isadption:NO];
    
    [FuncPublic InstanceLabel:@"类目" RECT:CGRectMake(40, 22, 80, 28) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:self.view Lines:0 TAG:3 Ailgnment:2];
    
    [FuncPublic instaceSimpleButton:CGRectMake(20, 20, 100, NAVBAR_H-20) andtitle:nil addtoview:self.view parentVc:self action:@selector(selectCatogy:) tag:4];
    
    
    [self initContentViews];
    // Do any additional setup after loading the view from its nib.
}
-(void)initContentViews
{
    flashView =[FuncPublic instanceview:CGRectMake(0, NAVBAR_H+2, DEVW, DEVH-NAVBAR_H-BOTTOM_H) andcolor:nil addtoview:self.view  andparentvc:self isadption:NO];
    
    UIScrollView *flashscro = [[UIScrollView alloc]init];
    
    flashscro.frame = CGRectMake(0, 0, DEVW, flashView.frame.size.height);
    
    flashscro.contentSize = CGSizeMake(DEVW, FlashHeigh *8);
    
    [flashView addSubview:flashscro];
    
    for(int i=0;i<8;i++)
    {
        UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5+FlashHeigh*i, DEVW, FlashHeigh-11)];
        
        NSString *str = @"http://172.16.1.92:83/userdailyimages/2014016/20141212/164443.jpg";
        
        [images setImageWithURL:[NSURL URLWithString:str]];
        
        [FuncPublic instanceview:CGRectMake(0, (FlashHeigh-1)*i, DEVW, 1) andcolor:[UIColor blackColor] addtoview:flashscro andparentvc:self isadption:NO];
        
        [flashscro addSubview:images];
        
    }
    NSArray *arrs = @[@"区域区域",@"类别",@"状态",@"时间",@"价格"];
    
    float width = DEVW/arrs.count;
    
    float RowHeighs = DEVW/5;
    
    catogryView = [FuncPublic instanceview:CGRectMake(0, NAVBAR_H+2, DEVW, DEVH-NAVBAR_H-BOTTOM_H-2) andcolor:nil addtoview:self.view andparentvc:self isadption:NO];
    
    catogryView.hidden = YES;
    
    UIView *secondTopView = [FuncPublic instanceview:CGRectMake(0, 2, DEVW, width) andcolor:[UIColor colorWithRed:224./255. green:224./255. blue:224./255. alpha:1] addtoview:catogryView andparentvc:self isadption:NO];
    
    secondTopView.tag = 2;
    
    selectView = [FuncPublic instanceview:CGRectZero andcolor:[UIColor whiteColor] addtoview:secondTopView andparentvc:self isadption:NO];
   // selectImages = [[UIImageView alloc]initWithFrame:CGRectZero];
   // selectImages.backgroundColor = [UIColor whiteColor];
   // [secondTopView addSubview:selectImages];
    
   
    for(int i =0;i<arrs.count;i++)
    {
        UILabel *labels =   [FuncPublic InstanceLabel:arrs[i] RECT:CGRectMake(10+width*i, 10, width-30, 20) FontName:nil Red:0 green:0 blue:0 FontSize:17 Target:secondTopView Lines:0 TAG:10000+i Ailgnment:1];
        
        CGSize iszed = CGSizeMake(labels.frame.size.width, MAXFLOAT);
        
        NSDictionary *attribute = @{NSFontAttributeName: labels.font};
        
        CGSize labelsize = [arrs[i] boundingRectWithSize:iszed options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
        //  NSLog(@"文本的高度:%f",labelsize.height);
        labels.frame = CGRectMake(labels.frame.origin.x, labels.frame.origin.y, labels.frame.size.width, RowHeighs-20);
        

        [labelArr addObject:labels];
       // UIImageView *imagess =   [FuncPublic InstanceImageView:@"downl" Ect:@"png" RECT:CGRectMake(width-20+width*i, 12, 15, 15) Target:secondTopView TAG:50+i isadption:NO];
     //   [downImageArr addObject:imagess];
        [FuncPublic instaceSimpleButton:CGRectMake(width*i, 0, width, RowHeighs) andtitle:nil addtoview:secondTopView parentVc:self action:@selector(selectCondition:) tag:i+256];
        //  [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // btn.titleLabel.textAlignment = 0;
        if(i<arrs.count-1)
            [FuncPublic instanceview:CGRectMake(width-1+width*i, 0, 1, RowHeighs) andcolor:[UIColor whiteColor] addtoview:secondTopView andparentvc:self isadption:NO];
    }
    float HEIGHS = 0;
    
    if(ISIPHONE6||ISIPHONE6_PLUS)HEIGHS=100;
    
    else if (ISIPHONE5)HEIGHS = 80;
    
    else HEIGHS = 60;
    
    UIView *catogryConteneViwe1 =  [FuncPublic instanceview:CGRectMake(0, secondTopView.frame.origin.y+secondTopView.frame.size.height, DEVW, HEIGHS) andcolor:[UIColor colorWithRed:210./255. green:210./255. blue:210./255. alpha:1] addtoview:catogryView andparentvc:self isadption:NO];
    
     UIView *catogryConteneViwe2 =  [FuncPublic instanceview:CGRectMake(0, catogryConteneViwe1.frame.origin.y+catogryConteneViwe1.frame.size.height, DEVW, HEIGHS) andcolor:[UIColor colorWithRed:200./255. green:200./255. blue:200./255. alpha:1] addtoview:catogryView andparentvc:self isadption:NO];
    
    proList = [[UITableView alloc]initWithFrame:CGRectMake(0, catogryConteneViwe2.frame.origin.y+catogryConteneViwe2.frame.size.height, DEVW, catogryView.frame.size.height-(catogryConteneViwe2.frame.origin.y+catogryConteneViwe2.frame.size.height)) style:UITableViewStylePlain];
    
    proList.dataSource = self;
    
    proList.delegate = self;
    
    [catogryView addSubview:proList];

    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    NSString *str = @"http://172.16.1.92:83/userdailyimages/2014016/20141212/164412.jpg";

    [cell.images setImageWithURL:[NSURL URLWithString:str]];
    
    cell.titleLabel.text = @"美女";
    
    cell.addressLabel.text = @"地址:火炬广场189号";
    
    cell.typeLable.text = @"的撒加福克斯";
    
    cell.subLabel.text = @"的就撒了看到了撒考虑到";
    
    cell.priceLabel.text = @"400";
    //cell.textLabel.text = @"测试数据";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)selectCondition:(UIButton *)clicks
{
    selectView.frame = clicks.frame;
    
    [labelArr enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL *stop) {
        if(clicks.tag-256==idx)
        {
            obj.textColor = [UIColor redColor];
        }
        else
        {
            obj.textColor = [UIColor blackColor];
        }
        
    }];
}
-(void)selectCatogy:(UIButton *)click
{
    flashView.hidden = YES;
    
    catogryView.hidden = NO;
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
