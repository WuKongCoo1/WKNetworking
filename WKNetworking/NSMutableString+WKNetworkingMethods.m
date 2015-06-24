//
//  NSMutableString+WKNetworkingMethods.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "NSMutableString+WKNetworkingMethods.h"

@implementation NSMutableString (WKNetworkingMethods)
- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] WK_defaultValue:@"\t\t\t\tN/A"]];

}
@end
