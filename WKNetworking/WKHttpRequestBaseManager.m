//
//  WKHttpRequestBaseManager.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKHttpRequestBaseManager.h"
#import "WKRequestProxy.h"
#import "WKReachability.h"
#import <AFNetworking.h>

#define WKCallAPI(RequestName, RequestID)  \
{\
    RequestID = [[WKRequestProxy sharedInstance] call##RequestName##WithURLString:self.child.urlString Params:(NSDictionary *)params serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(WKURLResponse *response) {\
        [self successedOnCallingAPI:response]; \
    } fail:^(WKURLResponse *response) {\
[self failedOnCallingAPI:response withErrorType:WKNetworkingErrorTypeDefault];  \
                }]; \
[self.requestIdList addObject:@(RequestID)];  \
}



@interface WKHttpRequestBaseManager ()
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) WKNetworkingErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@end
@implementation WKHttpRequestBaseManager

+ (void)initialize
{
    [[WKReachability sharedInstance] startMonitoring];
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}


- (BOOL)isReachable
{
   return [[WKReachability sharedInstance] isReachable];
}

- (BOOL)isLoading
{
    return self.requestIdList.count > 0;
}

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _interceptor = nil;
        _fetchedRawData = nil;
        _errorMessage = nil;
        _errorType = WKNetworkingErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(WKHttpRequestManager)]) {
            self.child = (id<WKHttpRequestManager>) self;
        }else{
            NSAssert(NO, @"WKHttpRequestBaseManager 的子类必须实现WKHttpRequestManager协议");
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    _requestIdList = nil;
}

- (NSInteger)loadData
{
    NSDictionary *params = [self.paramDelegate paramForRequest:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}


- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requesID = 0;
    NSDictionary *requestParams = [self reformParams:params];
    
    if ([self shouldCallAPIWithParams:params]) {//拦截器检查参数
        if ([self.validator httpRequestBaseManager:self isCorrectWithParamsData:requestParams]) {//验证器验证参数
            //1.检查网络状态
            if ([self isReachable]) {//进行请求
                switch ([self.child requestType]) {
                    case WKAPIManagerRequestTypeGet: {

                        WKCallAPI(GET, requesID);
                        break;
                    }
                    case WKAPIManagerRequestTypePost: {

                        break;
                        WKCallAPI(POST, requesID);
                    }
                    default: {
                        break;
                    }
                }
                
                NSMutableDictionary *params = [requestParams mutableCopy];
                params[kWKHttpRequestBaseManagerRequestID] = @(requesID);
                [self afterCallingAPIWithParams:params];
                
            }else{//网络问题
                [self failedOnCallingAPI:nil withErrorType:WKNetworkingErrorTypeNoNetWork];
            }
        }else{//参数一样
            [self failedOnCallingAPI:nil withErrorType:WKNetworkingErrorTypeParamsError];
        }
    }
    
    return requesID;
}


- (NSDictionary *)reformParams:(NSDictionary *)params
{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    }else{
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        }else{
            return params;
        }
    }
}

#pragma mark - public methods
- (void)cancelAllRequests
{
    [[WKRequestProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[WKRequestProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<WKHttpRequestBaseManagerResultReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}
#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

#pragma mark - api callbacks
- (void)apiCallBack:(WKURLResponse *)response
{
    if (response.status == WKURLResponseStatusSuccess) {
        [self successedOnCallingAPI:response];
    }else{
        [self failedOnCallingAPI:response withErrorType:WKNetworkingErrorTypeTimeout];
    }
}

- (void)successedOnCallingAPI:(WKURLResponse *)response
{
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    
    if ([self.validator httpRequestBaseManager:self isCorrectWithCallBackData:response.content]) {
        
        
        [self beforePerformSuccessWithResponse:response];
        [self.delegate httpRequestBaseManagerDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:WKNetworkingErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(WKURLResponse *)response withErrorType:(WKNetworkingErrorType)errorType
{
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self beforePerformFailWithResponse:response];
    [self.delegate httpRequestBaseManagerDidFailure:self];
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor
- (void)beforePerformSuccessWithResponse:(WKURLResponse *)response
{
    self.errorType = WKNetworkingErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(WKURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(WKURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(WKURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

@end
