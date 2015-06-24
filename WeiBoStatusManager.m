//
//  WeiBoStatusManager.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WeiBoStatusManager.h"

@interface WeiBoStatusManager ()<WKHttpRequestBaseManagerParamDelegate, WKHttpRequestBaseManagerCallBackDelegate, WKHttpRequestBaseManagerValidator>

@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, copy) NSString *serviceType;
@property (nonatomic, assign) WKAPIManagerRequestType requestType;
@property (nonatomic, copy) NSString *urlString;
@end

@implementation WeiBoStatusManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _methodName = @"_methodName";
        _requestType = WKAPIManagerRequestTypeGet;
        self.delegate = self;
        self.paramDelegate = self;
        self.validator = self;
    }
    return self;
}
- (NSString *)methodName
{
    return @"获取微博列表";
}
- (NSString *)serviceType
{
    return @"官方接口";
}

- (NSString *)urlString
{
    return @"https://api.weibo.com/2/users/show.json";
}

- (WKAPIManagerRequestType)requestType
{
    return WKAPIManagerRequestTypeGet;
}

/*
 对回调数据检查
 */
#pragma mark - WKAPIManagerValidator
/**
 *  请求参数检查
 *
 *  @param manager 请求manager
 *  @param data    返回数据
 *
 *  @return 是否通过
 */
- (BOOL)httpRequestBaseManager:(WKHttpRequestBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}

/**
 *  请求参数检查
 *
 *  @param manager 请求manager
 *  @param data    请求参数
 *
 *  @return 是否通过
 */
- (BOOL)httpRequestBaseManager:(WKHttpRequestBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}



#pragma mark - WKAPIManagerParamSourceDelegate
- (NSDictionary *)paramsForApi:(WKHttpRequestBaseManager *)manager
{
    //留给将来使用API的时候用
    return nil;
}

#pragma mark - RTAPIManagerApiCallBackDelegate
- (void)managerCallAPIDidSuccess:(WKHttpRequestBaseManager *)manager
{
    //留给将来使用API的时候用
}

- (void)managerCallAPIDidFailed:(WKHttpRequestBaseManager *)manager
{
    //留给将来使用API的时候用
}


@end
