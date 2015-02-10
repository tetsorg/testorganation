//
//  DistubVc.m
//  装之助
//
//  Created by caiyc on 14/12/1.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "DistubVc.h"
#import "PIc.h"
#import "ZYQAssetPickerController.h"
@interface DistubVc ()<UIActionSheetDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate>
{
    
    NSMutableArray *selectedPhotos;
    UIScrollView *src;
    UIPageControl *pageControl;

}
@end

@implementation DistubVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor,
                       (id)[UIColor grayColor].CGColor,
                       (id)[UIColor whiteColor].CGColor,nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    selectedPhotos = [NSMutableArray array];
    
    [FuncPublic InstanceNavgationBar:@"发帖" action:@selector(back) superclass:self isroot:NO];
    
    [self initContentViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endedtings:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)endedtings:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
-(void)initContentViews
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor grayColor].CGColor,
                       (id)[UIColor blackColor].CGColor,
                       (id)[UIColor whiteColor].CGColor,nil];
    UIScrollView *backScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_H, DEVW, DEVH-NAVBAR_H)];
    
    backScro.contentSize = CGSizeMake(DEVW, 400+100*2);
    backScro.delegate = self;
   // backScro.backgroundColor = [UIColor whiteColor];
    [backScro.layer insertSublayer:gradient atIndex:0];
    [self.view addSubview:backScro];
    
    [FuncPublic InstanceLabel:@"标题:" RECT:CGRectMake(10, 0, 50, 40) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backScro Lines:1 TAG:1 Ailgnment:1];
    
    UITextField *titleTf = [[UITextField alloc]initWithFrame:CGRectMake(60, 2, DEVW-70, 40)];
    
    titleTf.font = [UIFont systemFontOfSize:18];
    
    titleTf.placeholder = @"标题...";
    
    titleTf.borderStyle = UITextBorderStyleRoundedRect;
    titleTf.tag = 100;
    [backScro addSubview:titleTf];
    
    [FuncPublic InstanceLabel:@"内容" RECT:CGRectMake(10, 60, 50, 40) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backScro Lines:1 TAG:2 Ailgnment:1];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 105, DEVW-20, 100)];
    
    textView.layer.borderColor = [UIColor blackColor].CGColor;
    
    textView.layer.borderWidth = 1;
    
    textView.layer.cornerRadius = 5;
    
    textView.font = [UIFont systemFontOfSize:15];
    
    textView.tag = 101;
    
    [backScro addSubview:textView];
    
    UIButton *upImageBtn =   [FuncPublic instaceSimpleButton:CGRectMake((DEVW-100)/2, 210, 80, 40) andtitle:@"发帖" addtoview:backScro parentVc:self action:@selector(disTub:) tag:3];
    upImageBtn.backgroundColor = [UIColor darkGrayColor];
    
//    src = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 260, DEVW-20, 200)];
//    
//    [backScro addSubview:src];
//    
//    src.delegate = self;
//    
//    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(src.frame.origin.x, src.frame.origin.y+src.frame.size.height-20, src.frame.size.width, 20)];
//    
//    [backScro addSubview:pageControl];
//    
//    
//    UIButton *distubBtn = [FuncPublic instaceSimpleButton:CGRectMake((DEVW-100)/2, 480, 100, 40) andtitle:@"发帖" addtoview:backScro parentVc:self action:@selector(disTub:) tag:4];
//   // distubBtn.layer.cornerRadius = 10;
//    distubBtn.backgroundColor = [UIColor darkGrayColor];
  //  distubBtn.backgroundColor = [UIColor colorWithRed:255./255. green:48./255. blue:48./255. alpha:1];


}
//选择图片
-(void)upImage:(UIButton *)click
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [actionSheet showInView:self.view];
    
}
//发帖
-(void)disTub:(UIButton *)click{
    [self.view endEditing:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    UITextField *TF = (UITextField *)[self.view viewWithTag:100];
    UITextView *TV = (UITextView *)[self.view viewWithTag:101];
    if([TF.text isEqualToString:@""]||[TV.text isEqualToString:@""])
    {
        [WToast showWithText:@"请填入完整信息"];
        return;
    }
    [dic setObject:TF.text forKey:@"title"];
    [dic setObject:TV.text forKey:@"content"];
    [dic setObject:@"bbs" forKey:@"mod"];
   // [dic setObject:@"click" forKey:@"mods"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"uid"] forKey:@"uid"];
   // [dic setObject:[NSString stringWithFormat:@"%i",pa] forKey:<#(id<NSCopying>)#>]
   // [PIc postRequestWithURL:@"/set_api.php" postParems:dic picFilePath:selectedPhotos picFileName:nil];
    [SVHTTPRequest GET:@"/set_api.php" parameters:dic completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
     //   NSLog(@"发帖的返回信息%@",urlResponse);
        NSString *str = (NSString *)response;
        if([str isEqualToString:@"1"])
            [WToast showWithText:@"发帖成功"];
        else [WToast showWithText:@"发帖失败"];
        
    }];
    
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
    
}
//相册回调
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [src.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        src.contentSize=CGSizeMake(assets.count*src.frame.size.width, src.frame.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            pageControl.numberOfPages=assets.count;
        });
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            
            UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*src.frame.size.width, 0, src.frame.size.width, src.frame.size.height)];
            
            imgview.contentMode=UIViewContentModeScaleAspectFill;
            
            imgview.clipsToBounds=YES;
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            [selectedPhotos addObject:tempImg];
            //防止图片偏移，所以改图片尺寸
            UIImage *newImage = [self OriginImage:tempImg scaleToSize:CGSizeMake(src.frame.size.width, src.frame.size.height)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:newImage];
                
                [src addSubview:imgview];
            });
        }
    });

}
//改变原图尺寸
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    pageControl.currentPage=floor(scrollView.contentOffset.x/scrollView.frame.size.width);;
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
