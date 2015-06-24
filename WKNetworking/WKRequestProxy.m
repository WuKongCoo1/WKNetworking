//
//  WKRequestProxy.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKRequestProxy.h"
#import "WKRequestGenerator.h"
#import "WKLogger.h"
#import <AFNetworking.h>

@interface WKRequestProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

//AFNetworking
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation WKRequestProxy

- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [NSMutableDictionary new];
    }
    return _dispatchTable;
}

- (AFHTTPRequestOperationManager *)operationManager
{
    if (_operationManager == nil) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static WKRequestProxy *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WKRequestProxy alloc] init];
    });
    
    return sharedInstance;
}

- (NSInteger)callGETWithURLString:(NSString *)urlString Params:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(requestCallBack)success fail:(requestCallBack)fail
{
    NSURLRequest *request = [[WKRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier urlString:urlString requestParams:params methodName:methodName];
    NSNumber *requestID  = [self callRequestWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}


- (NSInteger)callPOSTWithURLString:(NSString *)urlString Params:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(requestCallBack)success fail:(requestCallBack)fail
{
    NSURLRequest *request = [[WKRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier urlString:urlString requestParams:params methodName:methodName];
    NSNumber *requestID = [self callRequestWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}


#pragma mark - 实际网络请求
/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callRequestWithRequest:(NSURLRequest *)request success:(requestCallBack)success fail:(requestCallBack)fail
{
    NSNumber *requestId = [self generateRequestId];
    
   //进行请求
   AFHTTPRequestOperation *httpRequestOperation  = [self.operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
       AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
       
       if (storedOperation == nil) {
           //请求已经被取消
           return;
       }else{
           //打印返回信息
           
           
           WKURLResponse *response = [[WKURLResponse alloc] initWithResponseString:operation.responseString requestId:requestId request:operation.request responseData:operation.responseData status:WKURLResponseStatusSuccess];
           
           [WKLogger logDebugInfoWithResponse:operation.response resposeString:response.content request:operation.request error:NULL];
           
           success ? success(response) : nil;
      }
       
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil) {
            return ;
        }else{
            [WKLogger logDebugInfoWithResponse:operation.response resposeString:operation.responseString request:operation.request error:error];
            
            WKURLResponse *response = [[WKURLResponse alloc] initWithResponseString:operation.responseString requestId:requestId request:operation.request responseData:operation.responseData error:error];
            
            fail ? fail(response) : nil;
        }
    }];
    
    self.dispatchTable[requestId] = httpRequestOperation;
    
    [[self.operationManager operationQueue] addOperation:httpRequestOperation];
    
    return requestId;
}

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @1;
    }else if([_recordedRequestId integerValue] == NSIntegerMax){
        _recordedRequestId = @1;
    }else{
        _recordedRequestId = @([_recordedRequestId integerValue] + 1);
    }
    return _recordedRequestId;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    AFHTTPRequestOperation *requestOperation = self.dispatchTable[requestID];

    [requestOperation cancel];
    
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestID in requestIDList) {
        [self cancelRequestWithRequestID:requestID];
    }
}

@end
