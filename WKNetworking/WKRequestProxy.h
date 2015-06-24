//
//  WKRequestProxy.h
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//  进行网络请求

#import <Foundation/Foundation.h>
#import "WKURLResponse.h"
typedef void(^requestCallBack)(WKURLResponse *response);
@interface WKRequestProxy : NSObject


+ (instancetype)sharedInstance;

/**
 *  get请求
 *
 *  @param urlString        请求路径
 *  @param params           参数
 *  @param servieIdentifier 服务id
 *  @param methodName       请求api名称
 *  @param success          成功回调
 *  @param fail             失败回调
 *
 *  @return 请求id
 */
- (NSInteger)callGETWithURLString:(NSString *)urlString Params:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(requestCallBack)success fail:(requestCallBack)fail;

/**
 *  post请求
 *
 *  @param urlString        请求路径
 *  @param params           参数
 *  @param servieIdentifier 服务id
 *  @param methodName       请求api名称
 *  @param success          成功回调
 *  @param fail             失败回调
 *
 *  @return 请求id
 */
- (NSInteger)callPOSTWithURLString:(NSString *)urlString Params:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(requestCallBack)success fail:(requestCallBack)fail;


- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
