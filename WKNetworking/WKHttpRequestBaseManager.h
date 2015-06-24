//
//  WKHttpRequestBaseManager.h
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//  请求基类

#import <Foundation/Foundation.h>
#import "WKURLResponse.h"

static NSString * const kWKHttpRequestBaseManagerRequestID = @"kWKHttpRequestBaseManagerRequestID";

typedef NS_ENUM (NSUInteger, WKAPIManagerRequestType){
    WKAPIManagerRequestTypeGet,
    WKAPIManagerRequestTypePost,
};

typedef NS_ENUM (NSUInteger, WKNetworkingErrorType){
    WKNetworkingErrorTypeDefault,       //没有产生过API请求
    WKNetworkingErrorTypeSuccess,       //API请求成功且返回数据正确
    WKNetworkingErrorTypeNoContent,     //API请求成功但返回数据不正确
    WKNetworkingErrorTypeParamsError,   //参数错误的。
    WKNetworkingErrorTypeTimeout,       //请求超时。
    WKNetworkingErrorTypeNoNetWork      //网络不通。
};

@class WKHttpRequestBaseManager;


@protocol WKHttpRequestManager <NSObject>

@required
/**调用的API名称*/
- (NSString *)methodName;
- (NSString *)serviceType;
- (WKAPIManagerRequestType)requestType;
- (NSString *)urlString;

@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end


/**
 *  请求回调
 */
@protocol WKHttpRequestBaseManagerCallBackDelegate <NSObject>

- (void)httpRequestBaseManagerDidSuccess:(WKHttpRequestBaseManager *)manager;
- (void)httpRequestBaseManagerDidFailure:(WKHttpRequestBaseManager *)manager;

@end

/**
 *  获取请求参数
 */
@protocol WKHttpRequestBaseManagerParamDelegate <NSObject>

- (NSDictionary *)paramForRequest:(WKHttpRequestBaseManager *)manager;

@end

@protocol WKHttpRequestBaseManagerValidator <NSObject>

/**
 *  请求参数检查
 *
 *  @param manager 请求manager
 *  @param data    返回数据
 *
 *  @return 是否通过
 */
- (BOOL)httpRequestBaseManager:(WKHttpRequestBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

/**
 *  请求参数检查
 *
 *  @param manager 请求manager
 *  @param data    请求参数
 *
 *  @return 是否通过
 */
- (BOOL)httpRequestBaseManager:(WKHttpRequestBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end

/**
 *  请求拦截器
 */
@protocol WKHttpRequestManagerInterceptor <NSObject>

@optional
- (void)manager:(WKHttpRequestBaseManager *)manager beforePerformSuccessWithResponse:(WKURLResponse *)response;
- (void)manager:(WKHttpRequestBaseManager *)manager afterPerformSuccessWithResponse:(WKURLResponse *)response;

- (void)manager:(WKHttpRequestBaseManager *)manager beforePerformFailWithResponse:(WKURLResponse *)response;
- (void)manager:(WKHttpRequestBaseManager *)manager afterPerformFailWithResponse:(WKURLResponse *)response;

- (BOOL)manager:(WKHttpRequestBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(WKHttpRequestBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end

/**
 *  数据转化
 */
@protocol WKHttpRequestBaseManagerResultReformer <NSObject>

- (id)manager:(WKHttpRequestBaseManager *)manager reformData:(NSDictionary *)data;

@end

/**
 *  请求基类
 */
@interface WKHttpRequestBaseManager : NSObject

@property (nonatomic, weak) id<WKHttpRequestBaseManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<WKHttpRequestBaseManagerParamDelegate> paramDelegate;
@property (nonatomic, weak) id<WKHttpRequestBaseManagerValidator> validator;

//要用到NSObject
@property (nonatomic, weak) NSObject<WKHttpRequestManager> *child;
@property (nonatomic, weak) id<WKHttpRequestManagerInterceptor> interceptor;
//网络情况
@property (nonatomic, assign, readonly) BOOL isReachable;
//请求状态
@property (nonatomic, assign, readonly) BOOL isLoading;

/**
 *  用reformer转换数据
 *
 *  @param reformer 转换器
 *
 *  @return 转换结果
 */
- (id)fetchDataWithReformer:(id<WKHttpRequestBaseManagerResultReformer>)reformer;

/**
 *  请求数据
 *
 *  @return 请求id
 */
- (NSInteger)loadData;

/**
 *  取消所有
 */
- (void)cancelAllRequests;

/**
 *  根据requestID取消请求
 */
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (NSDictionary *)reformParams:(NSDictionary *)params;
@end
