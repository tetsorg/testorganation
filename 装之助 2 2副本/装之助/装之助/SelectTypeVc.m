//
//  SelectTypeVc.m
//  装之助
//
//  Created by guest on 14/11/24.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "SelectTypeVc.h"
#import "CustomButon.h"
@interface SelectTypeVc ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSIndexPath *_index;
    NSMutableArray *arrs;
    NSArray *titlearr;
    
}

@end

@implementation SelectTypeVc

- (void)viewDidLoad {
    [super viewDidLoad];
  
    arrs = [NSMutableArray array];
    titlearr = @[@"电工",@"水工",@"木工",@"油漆工",@"打墙工",@"搬运工",@"贴墙纸",@"泥工",@"吊顶",@"乱瓷",@"结墙",@"清理工"];
   
    _index = [NSIndexPath indexPathForRow:0 inSection:0];
    [FuncPublic InstanceNavgationBar:@"选择类别" action:@selector(back) superclass:self isroot:NO];
    [self initContentViews];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
  //  [self.view addSubview:table];
    // Do any additional setup after loading the view.
}
-(void)changeType:(NSNotification *)no
{
    
}
-(void)initContentViews
{
    UIScrollView *backscro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H)];
    backscro.contentSize = CGSizeMake(DEVW, 50*titlearr.count);
    backscro.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backscro];
    for(int i =0;i<titlearr.count;i++)
    {
        CustomButon *btn = [[CustomButon alloc]initWithFrame:CGRectMake(40, 50*i+10, DEVW-50, 30)];
        
        btn.tag = i+50;
        
        btn.btnTitle = titlearr[i];
        
        [backscro addSubview:btn];
        
        [FuncPublic instaceSimpleButton:CGRectMake(40, 50*i, DEVW, 50) andtitle:nil addtoview:backscro parentVc:self action:@selector(CLICKS:) tag:i+50*2];
        
        [arrs addObject:btn];
        
        [FuncPublic instanceview:CGRectMake(0, 49+50*i, DEVW, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:backscro andparentvc:self isadption:NO];
        

    }
}
-(void)CLICKS:(UIButton *)click
{
    long int TAG = click.tag-50;
    NSString*objs = [NSString stringWithFormat:@"%li",TAG-50+1];
    NSLog(@"typeid %li",TAG-50+1);
    NSString *type = [titlearr objectAtIndex:TAG-50];
    [arrs enumerateObjectsUsingBlock:^(CustomButon * obj, NSUInteger idx, BOOL *stop) {
        
        if(obj.tag==TAG)obj.isSelect = YES;
        
        else obj.isSelect = NO;
        
        if(stop)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",objs,@"typeid", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changetype" object:nil userInfo:dic];
            
        }
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
       if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    
   // [cell.contentView addSubview:views];
    
   
    cell.textLabel.text = @"测试数据";
   
    
    if ([_index compare:indexPath] == NSOrderedSame && _index != nil) {
        
        
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        cell.textLabel.textColor = [UIColor redColor];
        
        UIView *viewss = (UIView *)[cell.contentView viewWithTag:13];
        
        viewss.hidden = NO;
        
    }else{
        
        cell.textLabel.textColor = [UIColor blackColor];
       
        
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [arrs enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
//        if(obj.tag==indexPath.row)obj.hidden = NO;
//        else obj.hidden = YES;
//    }];
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(DEVW-40, 10, 20, 20)];
    
    views.backgroundColor = [UIColor redColor];
    //views.hidden = YES;
    views.tag = 10;
    
    [cell.contentView addSubview:views];
    
    //label.textColor = [UIColor blackColor];
    

    if (_index != indexPath) {
        
        if ([_index compare:indexPath] != NSOrderedSame){
            
            UITableViewCell *deselectCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:_index];
            
            deselectCell.textLabel.textColor = [UIColor blackColor];
            
            UIView *vv = [cell.contentView viewWithTag:10];
            
            vv.hidden = YES;

        }
        
        
    }
    _index = indexPath;
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
