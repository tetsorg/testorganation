//
//  PicUpload.m
//  haircut
//
//  Created by FengXingTianXia on 14-2-14.
//  Copyright (c) 2014年 Clover. All rights reserved.
//

#import "PicUpload.h"

#import "SBJson.h"
#import <UIKit/UIKit.h>
@implementation PicUpload
static NSString * const FORM_FLE_INPUT = @"file1";

+ (NSString *)postRequestWithURL: (NSString *)url
                      postParems: (NSMutableDictionary *)postParems
                     picFilePath: (NSMutableArray *)picFilePath
                     picFileName: (NSMutableArray *)picFileName
{
    
    
     NSString *hyphens = @"--";
     NSString *boundary = @"0xKhTmLbOuNdArY";
     NSString *end = @"--";
    
    NSMutableData *myRequestData1=[NSMutableData data];
    //遍历数组，添加多张图片
    for (int i = 0; i < picFilePath.count; i ++) {
        NSData* data;
        UIImage *image=[picFilePath objectAtIndex:i];
      //  data = UIImageJPEGRepresentation(image, 0.1);
       // 判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
         //   data = UIImageJPEGRepresentation(image, 1.0);
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
       // NSLog(@"图片数据%@",data);
        
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        if(i==0)
            //更改上传的接口参数就行
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"image\";filename=\"%@\"",[NSString stringWithFormat:@"image%d.png",i+1]];
        
        else
            [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"image%d",i],[NSString stringWithFormat:@"image%d.png",i+1]];

            
        [fileTitle appendString:end];
        
        [fileTitle appendFormat:@"Content-Type: image/png\r\n\r\n"];
      //  [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
         [fileTitle appendString:end];
        
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        
        [myRequestData1 appendData:data];
        
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

        }
    
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];

    
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys，添加其他参数
    for(int i=0;i<[keys count];i++)
    {
        
        NSMutableString *body=[[NSMutableString alloc]init];
         [body appendString:hyphens];
         [body appendString:boundary];
         [body appendString:end];
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
        
        [body appendString:end];
        
        [body appendString:end];
        //添加字段的值
        [body appendFormat:@"%@",[postParems objectForKey:key]];
        
        [body appendString:end];
        
         [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }

    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%ld", [myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        SBJsonParser *parser = [[SBJsonParser alloc ] init];
        NSDictionary *jsonobj = [parser objectWithString:result];
       // NSLog(@"返回字典数据%@",jsonobj);
        
//        if (jsonobj == nil || (id)jsonobj == [NSNull null] || [[jsonobj objectForKey:@"flag"] intValue] == 0)
        if([result integerValue]!=1)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"dissmissSVP" object:nil];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"basicInfo" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"dissmissSVP" object:nil];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             //   [Singleton sharedSingleton].shopId = [[jsonobj objectForKey:@"shopId"]stringValue];
                [alert show];
            });
        }
        
        return result;
    }
    else if (error) {
        NSLog(@"%@",error);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dissmissSVP" object:nil];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
        
    }
    else
        return nil;
    
}



@end
