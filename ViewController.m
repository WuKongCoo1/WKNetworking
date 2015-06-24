//
//  ViewController.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "ViewController.h"
#import "WeiBoStatusManager.h"

@interface ViewController ()<WKHttpRequestBaseManagerParamDelegate, WKHttpRequestBaseManagerCallBackDelegate>

@property (nonatomic, strong) WeiBoStatusManager *manager;

@property (nonatomic, assign) NSInteger requestID;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [[WeiBoStatusManager alloc] init];
    
    _manager.delegate = self;
    _manager.paramDelegate = self;
    
    _requestID = [_manager loadData];
}

#pragma mark - WKAPIBaseManagerParamSourceDelegate
- (NSDictionary *)paramForRequest:(WKHttpRequestBaseManager *)manager
{
    return @{@"access_token" : @"2.00PxLDhC02jcEB5d0a91350404liAz",
             @"uid" : @(2468409053)};
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_manager.isLoading) {
        [_manager cancelRequestWithRequestId:_requestID];
        NSLog(@"重新请求");
    }
    _requestID =  [_manager loadData];
    
}

- (void)testDefine
{
    NSLog(@"%@", @"hehe");
}

- (void)httpRequestBaseManagerDidSuccess:(WKHttpRequestBaseManager *)manager
{
    
}
- (void)httpRequestBaseManagerDidFailure:(WKHttpRequestBaseManager *)manager
{
    
}

@end
