//
//  ZHNetwork.m
//  Notes
//
//  Created by apple on 4/18/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import "ZHNetwork.h"

#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@implementation ZHNetwork

+ (void)post:(NSString *)URLString
     message:(NSString *)message
compoundResponseSerialize:(BOOL)compoundResponseSerialize
  parameters:(id)parameters
     success:(void (^)(NSString *, id))success
     failure:(void (^)(NSString *, NSError *))failure
{
    //显示提示信息
    if (message) [MBProgressHUD showMessage:message];
    
    //打开网络指示器
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    if (compoundResponseSerialize)
        mgr.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    // 设置超时时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr POST:URLString
   parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //关掉提示消息
          if (message) [MBProgressHUD hideHUD];
          
          //关闭网络指示器
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          
          if (success) success(operation.responseString, responseObject);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          //关掉提示消息
          if (message) [MBProgressHUD hideHUD];
          
          //关闭网络指示器
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"%@", error);
          if (failure) failure(operation.responseString, error);
      }];

}


+ (void)get:(NSString *)URLString
    message:(NSString *)message
compoundResponseSerialize:(BOOL)compoundResponseSerialize
 parameters:(id)parameters
    success:(void (^)(NSString *, id))success
    failure:(void (^)(NSString *, NSError *))failure
{
    //显示提示信息
    if (message) [MBProgressHUD showMessage:message];
    
    //打开网络指示器
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    if (compoundResponseSerialize)
        mgr.responseSerializer = [[AFCompoundResponseSerializer alloc] init];
    
    // 设置超时时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 10.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [mgr GET:URLString
  parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         //关掉提示消息
         if (message) [MBProgressHUD hideHUD];
         
         //关闭网络指示器
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         if (success) success(operation.responseString, responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
         
         //关掉提示消息
         if (message) [MBProgressHUD hideHUD];
         
         //关闭网络指示器
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         if (failure) failure(operation.responseString, error);
     }];
}

@end
