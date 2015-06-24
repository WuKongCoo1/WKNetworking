//
//  NSMutableString+WKNetworkingMethods.h
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+WKNetworkingMethods.h"

@interface NSMutableString (WKNetworkingMethods)
- (void)appendURLRequest:(NSURLRequest *)request;
@end
