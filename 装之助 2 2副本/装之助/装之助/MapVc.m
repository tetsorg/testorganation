//
//  MapVc.m
//  装之助
//
//  Created by caiyc on 14/12/10.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "MapVc.h"
#import "BMapKit.h"
#import "BMKMapView.h"
#import "BMKPointAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "BMKOverlay.h"
#import "BMKPolyline.h"
#import "BMKRouteSearch.h"
#import "MyWGS84TOGCJ02.h"
@interface MapVc ()<BMKGeneralDelegate,BMKMapViewDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>
{
    CLLocationManager *locationManager;
    BMKMapView *mapView;
    BMKPoiSearch *search;
    BMKRouteSearch *routSearch;
    
    CLLocationCoordinate2D commencoors;
    
}
@end

@implementation MapVc

- (void)viewDidLoad {
    [super viewDidLoad];
    //测试检索
    search = [[BMKPoiSearch alloc]init];
    search.delegate =self;
//公交线路检索
    routSearch = [[BMKRouteSearch alloc]init];
    routSearch.delegate = self;
    
    
    
    
    
    [FuncPublic InstanceNavgationBar:@"附近装修公司" action:@selector(back) superclass:self isroot:NO];
    
    [FuncPublic instaceSimpleButton:CGRectMake(DEVW-60, 20, 60, 40) andtitle:@"检索" addtoview:self.view parentVc:self action:@selector(checkPlace:) tag:133];
    [self initContentViews];
    // Do any additional setup after loading the view.
}
-(void)checkPlace:(UIButton *)click
{
    //普通位置检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 1;
    option.pageCapacity = 10;
    option.location = commencoors;
    option.keyword = @"学校";
    BOOL flag = [search poiSearchNearBy:option];
   // [option release];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
    //公交检索
   
//     BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
//     start.name = @"高新二路口";
//     BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
//     end.name = @"青山路口";
//     BMKTransitRoutePlanOption *transitRouteSearchOption =         [[BMKTransitRoutePlanOption alloc]init];
//     transitRouteSearchOption.city= @"南昌市";
//     transitRouteSearchOption.from = start;
//     transitRouteSearchOption.to = end;
//     BOOL flag = [routSearch transitSearch:transitRouteSearchOption];
//  //   [transitRouteSearchOption release];
//     
//     if(flag)
//     {
//     NSLog(@"bus检索发送成功");
//     }
//     else
//     {
//     NSLog(@"bus检索发送失败");
//     }
    
}
//实现PoiSearchDeleage处理回调结果,普通位置检索的回调
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"检索处理成功%@",poiResultList);
        
        //在此处理正常结果
       // BMKPoiResult* result = poiResultList[0];
        for (int i = 0; i < poiResultList.poiInfoList.count; ++i) {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [mapView addAnnotation:item];
        }
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
// 公交检索的回调
-(void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mapView.overlays];
    [mapView removeOverlays:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        //画出轨迹点
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        BMKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * plan.steps.count);
        int planPointCounts = 0;
        BMKMapPoint northEastPoint;
        BMKMapPoint southWestPoint;
        for (int i = 0; i < size; i++) {
             BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
          //  NSString* currentPointString = [plan.steps objectAtIndex:i];
         //   NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            
          //  CLLocationDegrees latitude = [[latLonArr objectAtIndex:0] doubleValue];
          //  CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
            
            // create our coordinate and add it to the correct spot in the array
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(plan.starting.location.latitude,plan.starting.location.longitude );
            
            BMKMapPoint point = BMKMapPointForCoordinate(coordinate);
            if(i==0)
            {
                northEastPoint = point;
                southWestPoint = point;
            }
            else
            {
                if (point.x > northEastPoint.x)
                    northEastPoint.x = point.x;
                if(point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;  
                if (point.y < southWestPoint.y)  
                    southWestPoint.y = point.y;  
            }  
            
            pointArr[i] = point;
            
        
        BMKPolyline *routline = [BMKPolyline polylineWithPoints:pointArr count:size];
        [mapView addOverlay:routline];
            /*
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
               
               BMKPointAnnotation * item = [[BMKPointAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
               // item.type = 0;
                //给地图加上标注
                [mapView addAnnotation:item]; // 添加起点标注
                [item release];
            }
            else if (i==size-1)
            {
                BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                [mapView addAnnotation:item];
            }
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            [mapView addAnnotation:item];
            planPointCounts += transitStep.pointsCount;
        }
      //  for(int j =0;j<size;j++)
            
        
      //        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
//        int i = 0;
//        for (int j = 0; j < size; j++) {
//            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
//            int k=0;
//            for(k=0;k
//                temppoints[i].x = transitStep.points[k].x;
//                temppoints[i].y = transitStep.points[k].y;
//                i++;
       // BMKMapPoint *temppoint = [BMKMapPoint alloc]init;
       // BMKPolyline *cc = [BMKPolyline polylineWithCoordinates:nil count:result.routes[0]];//执行画线方法
     //   BMKTransitRouteLine *lines = result.routes[0];
        [mapView addOverlays:result.routes];
             */
        }
        //在此处理正常结果
        for (BMKTransitRouteLine *line in result.routes) {
           // [mapView addOverlay:line];
            
            NSLog(@"-----------------------------------------------------");
            NSLog(@"  时间：%2d %2d:%2d:%2d 长度: %d米",
                  line.duration.dates,
                  line.duration.hours,
                  line.duration.minutes,
                  line.duration.seconds,
                  line.distance);
            for (BMKTransitStep *step in line.steps) {
                NSLog(@"%@     %@    %@    %@    %@",
                      step.entrace.title,
                      step.exit.title,
                      step.instruction,
                      (step.stepType == BMK_BUSLINE ? @"公交路段" : (step.stepType == BMK_SUBWAY ? @"地铁路段" : @"步行路段")),
                      [NSString stringWithFormat:@"名称：%@  所乘站数：%d   全程价格：%d  区间价格：%d",
                       step.vehicleInfo.title,
                       step.vehicleInfo.passStationNum,
                       step.vehicleInfo.totalPrice,
                       step.vehicleInfo.zonePrice]);
            }
        }
        // 打车信息
        NSLog(@"打车信息------------------------------------------");
        NSLog(@"路线打车描述信息:%@  总路程: %d米    总耗时：约%f分钟  每千米单价：%f元  全程总价：约%d元",
              result.taxiInfo.desc,
              result.taxiInfo.distance,
              result.taxiInfo.duration / 60.0,
              result.taxiInfo.perKMPrice,
              result.taxiInfo.totalPrice);
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        //当路线起终点有歧义时通，获取建议检索起终点
        //result.routeAddrResult
        NSLog(@"输入位置不明确");
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{

    NSLog(@"-----------------------------------画线方法");
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView *lineview=[[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        lineview.strokeColor=[[UIColor redColor] colorWithAlphaComponent:0.5];
        lineview.lineWidth=2.0;
        return lineview;
    }
    return nil;
}

//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    search.delegate = nil;
}
-(void)initContentViews
{
    // 定位
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;//最高精度，这种级别用于导航程序
    [locationManager requestAlwaysAuthorization];
   // [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];// 开始定位
    
    // 地图相关
    mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H)];
    mapView.delegate = self;
   
    mapView.showsUserLocation = YES; //设置显示我的位置
    [mapView setZoomLevel:18];// 设置地图比例级别
    [self.view addSubview:mapView];
  //  CLLocationCoordinate2D coor;// CLLocationCoordinate2D是一个结构体
//    coor.longitude = 115.89;// 经度X
//    coor.latitude =  28.68;// 纬度Y
//    BMKPointAnnotation* annotations = [[BMKPointAnnotation alloc] init];
//    annotations.coordinate = coor;
//    annotations.title = @"标注y";
//    // 设置地图标记
//    [mapView addAnnotation:annotations];

    
        CLLocationCoordinate2D coors;// CLLocationCoordinate2D是一个结构体
        coors.longitude = 116.89;// 经度X
        coors.latitude = 28.68;// 纬度Y
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coors;
        annotation.title = @"标注x";
        // 设置地图标记
        [mapView addAnnotation:annotation];
        
    
        //[mapView setCenterCoordinate:coor animated:false];// 设置地图上当前显示位置
    
      //  [annotation release];
//检索
    

    
}
-(void)ddPointAnnotation
{
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"arr count is ----------------------%i",locations.count);
    static int i =0;
    //移除之前所有标注
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
     NSLog(@"标注个数-------------%i",array.count);
    [mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:mapView.overlays];
   
//    [mapView removeOverlays:array];

   
    
     [locationManager stopUpdatingLocation];
    CLLocation *newLocation = [locations firstObject];
    if(![MyWGS84TOGCJ02 isLocationOutOfChina:[newLocation coordinate]])
            {
                CLLocationCoordinate2D oldCoordinate = [MyWGS84TOGCJ02 transformFromWGSToGCJ:[newLocation coordinate] ];
            
   // CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    
    CLLocationCoordinate2D coor;// CLLocationCoordinate2D是一个结构体
    commencoors.longitude = oldCoordinate.longitude;// 经度X
    commencoors.latitude =  oldCoordinate.latitude;// 纬度Y
       commencoors.longitude = oldCoordinate.longitude;
    commencoors.latitude = oldCoordinate.latitude;
  __block  NSString *locationName = nil;

    
    
    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       NSLog(@".........%@",error);
                       CLPlacemark *place = nil;
                       for (place in placemarks) {
                          // UILabel *label = (UILabel *)[self.window viewWithTag:101];
                          // label.text = place.name;
                           NSLog(@"name,%@",place.name);
                           locationName = place.name;
                           // 位置名
                           //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                           //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                           //                           NSLog(@"locality,%@",place.locality);               // 市
                           //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
                           //                           NSLog(@"country,%@",place.country);                 // 国家
                       }
                       
                      // NSLog(@"编码后的位置：%@",locationName);
                       //防止重复定位问题，定位结束后在显示标注
                       [self performSelectorOnMainThread:@selector(showAni:) withObject:locationName waitUntilDone:YES];
//                       annotations.title = locationName;
//                       
//                       [mapView addAnnotation:annotations];
//                       
//                       [mapView setCenterCoordinate:coor animated:false];
                       


                       
                   }];
            }
    NSLog(@"进入方法次数-------------------%d",i);
    i++;
    
}
-(void)showAni:(NSString *)str
{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = commencoors;
    annotation.title = str;
    [mapView addAnnotation:annotation];
    
    [mapView setCenterCoordinate:commencoors animated:false];
}
// 定位我的位置
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [locationManager stopUpdatingLocation];// 停止定位
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = newLocation.coordinate;// 取得newLocation经纬度，即我的位置
    annotation.title = @"我的位置";
    // 设置地图标记
    [mapView addAnnotation:annotation];
    
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
