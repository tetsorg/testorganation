//
//  CityListVc.m
//  装之助
//
//  Created by caiyc on 14/11/6.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "CityListVc.h"
#import "CustomyVc.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "CityModel.h"
#import "MyDbHandel.h"
#import "MTMudelDaTa.h"

@interface CityListVc ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSArray *fontarray;
    NSArray *indexarray;
    UISearchBar *search;
    NSArray *datasouce;
    UITableView *cityList;
    NSMutableArray *indexarr;
    NSMutableDictionary *datadic;
    UITableView *serachTable;
    UIButton *searchBtn;
    NSMutableArray *searchData;
    BOOL issearch;
    UIScrollView *searchScro;
    NSArray *dataArr;
    NSMutableArray *datas;
    NSMutableArray *indxarr;
}
@end

@implementation CityListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    indexarray = [NSArray array];
    indxarr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    datas = [NSMutableArray array];
    dataArr = [NSArray array];
    datasouce = [NSArray array];
    
    indexarr = [NSMutableArray array];
    
    datadic = [NSMutableDictionary dictionary];
    
    searchData = [NSMutableArray array];
    
  //  [self handelCityData];
    dispatch_async(dispatch_queue_create("dsd", nil), ^{
    [self performSelector:@selector(getCityData) withObject:nil];
       
    });
   
    
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NAVBAR_H+20, DEVW-60, 30)];
    
    search.backgroundColor = [UIColor grayColor];
    
    search.placeholder = @"中文/拼音/首字母";
    
    search.delegate = self;
    
    search.barTintColor = [UIColor grayColor];
    
    search.barStyle = UIBarStyleBlack;
    
    [self.view addSubview:search];

    searchBtn = [FuncPublic instaceSimpleButton:CGRectMake(DEVW-60, NAVBAR_H+20, 60, 30) andtitle:@"搜索" addtoview:self.view parentVc:self action:@selector(serchClick:) tag:583495];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [FuncPublic InstanceNavgationBar:@"请选择城市" action:@selector(back:) superclass:self isroot:NO];
    
    cityList = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+60, DEVW, DEVH-NAVBAR_H-60) style:UITableViewStyleGrouped];
    
    cityList.dataSource = self;
    
    cityList.delegate = self;
    
    [self.view addSubview:cityList];
    
    searchScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H+60, DEVW, DEVH-NAVBAR_H-60)];
    
    [self.view addSubview:searchScro];
    
    searchScro.hidden = YES;
    
    searchScro.backgroundColor = [UIColor whiteColor];
    
    
   // self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}
/*
-(void)handelCityData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"rrrrrr" ofType:@"txt"];
    
    NSString *cityString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *cityDic = [cityString JSONValue];
    
   NSArray *cityarr = [cityDic objectForKey:@"Cities"];
    
   NSDictionary *dic = cityarr[0];

    NSFileManager *fiels = [NSFileManager defaultManager];
    NSString *paths = [NSHomeDirectory()stringByAppendingString:@"/Documents/Citys.sqlite"];

    BOOL exsits = [fiels fileExistsAtPath:paths isDirectory:nil];
    if(exsits)
    {
        dispatch_async(dispatch_queue_create("dsd", nil), ^{
            
            [self performSelector:@selector(getCityData) withObject:nil];
            
        });
        
     //   [self getCityData];
        return;
    }else
    {
    [[MyDbHandel defaultDBManager]openDb:@"City.sqlite"];
        
     NSString *sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id INTEGER,pid INTEGER,name TEXT, pyjx TEXT,py TEXT)",NAME];
        
    [[MyDbHandel defaultDBManager]creatTab:sql];
        
    for(NSString *str in [dic allKeys])
    {
        
        NSArray *arr = [dic objectForKey:str];
        
        NSMutableDictionary *dicto = [NSMutableDictionary dictionary];
        
        for(NSDictionary *dicc in arr)
        {
            [dicto setObject:[dicc objectForKey:@"key"] forKey:@"first"];
            
            [dicto setObject:[dicc objectForKey:@"name"] forKey:@"name"];
            
            NSString *piny = [self phonetic:[dicc objectForKey:@"name"]];
            
            [dicto setObject:piny forKey:@"piny"];
            
            [[MyDbHandel defaultDBManager]insertdata:dicto];
            
        }
    }
        
    [self getCityData];
    }
   
}
 */
-(void)getCityData
{
    [[MyDbHandel defaultDBManager]openDb:@"Citylists.sqlite"];

    NSString *indexsql = [NSString stringWithFormat:@"select * from %@ group by sindex",NAME];
    
    indexarray = [[MyDbHandel defaultDBManager]select:indexsql];
    for(int i =0;i<indexarray.count;i++)
    {
        MTMudelDaTa *data = [indexarray objectAtIndex:i];
        NSArray *temparr = [NSArray array];
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where name like '%%市' and sindex = '%@'",NAME,data.sindex];
        temparr = [[MyDbHandel defaultDBManager]select:sql];
        [indxarr addObject:data.sindex];
        [datadic setObject:temparr forKey:data.sindex];
        
    }
      dispatch_async(dispatch_get_main_queue(), ^{
        // [serachTable reloadData];
        [cityList reloadData];
    });
    
    
}
//汉字转拼音
//- (NSString *) phonetic:(NSString*)sourceString {
//    NSMutableString *source = [sourceString mutableCopy];
//    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
//    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
//    return source;
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return indexarray.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MTMudelDaTa *data = [indexarray objectAtIndex:section];
    NSString *keys = data.sindex;
    return [[datadic objectForKey:keys]count];
 

}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   
    return indxarr;

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MTMudelDaTa *data = [indexarray objectAtIndex:section];
    return data.sindex;
    
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    static NSString *cellids = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellids];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellids];


        
    }
    MTMudelDaTa *data = [indexarray objectAtIndex:indexPath.section];
    NSString *keys = data.sindex;
    NSArray *arr = [datadic objectForKey:keys];
    MTMudelDaTa *datasstr = [arr objectAtIndex:indexPath.row];
    cell.textLabel.text = datasstr.name;
    
   
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MTMudelDaTa *data = [indexarray objectAtIndex:indexPath.section];
    NSString *keys = data.sindex;
    NSArray *arr = [datadic objectForKey:keys];
    MTMudelDaTa *datasstr = [arr objectAtIndex:indexPath.row];

    
  //  MTMudelDaTa *data = [dataArr objectAtIndex:indexPath.row];
    
    [FuncPublic SaveDefaultInfo:datasstr.name Key:@"cityName"];
   // [FuncPublic SaveDefaultInfo:datasstr.pid Key:@"pid"];
    [FuncPublic SaveDefaultInfo:datasstr.ids Key:@"cid"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changecity" object:nil];
    [WToast showWithText:[NSString stringWithFormat:@"选中城市:%@",datasstr.name]];
    [self.navigationController popViewControllerAnimated:YES];

}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [indexarr objectAtIndex:section];
//
//}
-(void)serchClick:(UIButton *)btn
{
    [search resignFirstResponder];
    if([search.text isEqualToString:@""])
        return;
    NSString *titieStr = btn.titleLabel.text;
    if([titieStr isEqualToString:@"取消搜索"])
    {
        cityList.hidden = NO;
        searchScro.hidden = YES;
        [btn setTitle:@"搜索" forState:UIControlStateNormal];
        return;
    }
    
    searchScro.hidden = NO;
    
    cityList.hidden = YES;
  //  NSString *str = @"select * from citys where name not like'%县%' or name not like '市辖区'"
    [btn setTitle:@"取消搜索" forState:UIControlStateNormal];
    
//NSMutableString *sql = @"select distinct * from";
  NSString *sql = @"select distinct * from";
  sql =  [sql stringByAppendingString:@"(select * from citys where name like '%%市')"];
  sql =  [ sql stringByAppendingFormat:@"where (name like'%@%%') or (py like'%@%%') or (pyjx like'%@%%') order by pyjx",search.text,search.text,search.text];
   
// (select * from %@ where name not like '%%县%%' and name not like '市辖区',NAME) where (name like'%@%%') or (py like'%@%%') or (pyjx like'%@%%') order by pyjx",search.text,search.text,search.text];
    
    [[MyDbHandel defaultDBManager]openDb:@"Citylists.sqlite"];
    
    NSArray *arrs =  [[MyDbHandel defaultDBManager]select:sql];
    
    searchData = [NSMutableArray arrayWithArray:arrs];
    
    searchScro.contentSize = CGSizeMake(DEVW, 40*searchData.count+50);
    
    for(UIView *vis in searchScro.subviews)
    {
        [vis removeFromSuperview];
    }
    //搜索结果布局
    for(int i=0;i<searchData.count;i++)
    {
        MTMudelDaTa *dara = [searchData objectAtIndex:i];
        
        [FuncPublic InstanceLabel:dara.name RECT:CGRectMake(20, 40*i, DEVW, 40) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:searchScro Lines:0 TAG:42+i Ailgnment:2];
        
        [FuncPublic instanceview:CGRectMake(0, 40*(i+1), DEVW, 1) andcolor:[UIColor colorWithRed:214./255. green:214./255. blue:214./255. alpha:1] addtoview:searchScro andparentvc:self isadption:NO];
        
        [FuncPublic instaceSimpleButton:CGRectMake(20, 40*i, DEVW, 40) andtitle:nil addtoview:searchScro parentVc:self action:@selector(selectCity:) tag:i+10234];
    }
   
    // [self performSelectorOnMainThread:@selector(reloaddtas) withObject:nil waitUntilDone:YES];
    
    
}
-(void)selectCity:(UIButton *)click
{
    MTMudelDaTa *datass = [searchData objectAtIndex:click.tag-10234];
    [FuncPublic SaveDefaultInfo:datass.name Key:@"cityName"];
  //  [FuncPublic SaveDefaultInfo:datass.pid Key:@"pid"];
    [FuncPublic SaveDefaultInfo:datass.ids Key:@"cid"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changecity" object:nil];
    [WToast showWithText:[NSString stringWithFormat:@"选中城市:%@",datass.name]];
    [self.navigationController popViewControllerAnimated:NO];
    
    
}
//-(void)handelSearch
//{
//    NSString *sql = [NSString stringWithFormat:@"select distinct * from CityList where (first like'%@%%') or (name like'%@%%') or (piny like'%@%%') order by first",search.text,search.text,search.text];
//    
//    [[MyDbHandel defaultDBManager]openDb:@"City.sqlite"];
//    
//    NSArray *arrs =  [[MyDbHandel defaultDBManager]select:sql];
//    
//    searchData = [NSMutableArray arrayWithArray:arrs];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//          [cityList reloadData];
//    });
//
//    
//  
//   
//
//}
-(void)reloaddtas
{
    
   [cityList reloadData];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   searchBtn.titleLabel.text = @"搜索";
}
-(void)back:(UIButton *)sender
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
