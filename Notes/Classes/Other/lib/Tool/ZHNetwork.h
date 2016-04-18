//
//  ZHNetwork.h
//  Notes
//
//  Created by apple on 4/18/16.
//  Copyright (c) 2016 swjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHNetwork : NSObject

/**
 *  POST方法
 *
 *  @param URLString  目的URL
 *  @param message    显示等待信息
 *  @param parameters post的数据
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
- (void)post:(NSString *)URLString
     message:(NSString *)message
compoundResponseSerialize:(BOOL)compoundResponseSerialize
  parameters:(id)parameters
     success:(void (^)(NSString *responseString, id responseObject))success
     failure:(void (^)(NSString *responseString, NSError *error))failure;


/**
 *  GET方法
 *
 *  @param URLString  目的URL
 *  @param message    显示等待信息
 *  @param parameters post的数据
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
- (void)get:(NSString *)URLString
     message:(NSString *)message
compoundResponseSerialize:(BOOL)compoundResponseSerialize
  parameters:(id)parameters
     success:(void (^)(NSString *responseString, id responseObject))success
     failure:(void (^)(NSString *responseString, NSError *error))failure;


@end
