//
//  RequestHandle.m
//  RequestHandle_demo
//
//  Created by 怒煮西兰花 on 15/6/12.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import "RequestHandle.h"

@implementation RequestHandle
- (id)initWithURL:(NSString *)url method:(NSString *)method parameter:(NSString *)parameter delegate:(id<RequestHandleDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        //设置代理
        self.delegate = delegate;
        
        //通过传入的请求方式 区分 POST  GET
        if ([method isEqualToString:@"GET"]) {
            //GET请求
            [self requestDataByGETWithURL:url];
            
        }else if ([method isEqualToString:@"POST"])
        {
            //POST 请求
            [self requestDataByPOSTWithURL:url parameter:parameter];
        }
    }
    
    return self;
}
//GET请求
- (void)requestDataByGETWithURL:(NSString *)urlString
{
    //1.url
    //再编码
    NSString *newStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //创建url
    NSURL *url = [NSURL URLWithString:newStr];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.设置代理 请求数据
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

//POST请求
- (void)requestDataByPOSTWithURL:(NSString *)urlString  parameter:(NSString *)parameter
{
    //1.创建URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //3.封装请求体
    NSData *paraData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    //设置请求体 和 请求方式
    request.HTTPBody = paraData;
    request.HTTPMethod = @"POST";
    //设置代理 请求数据
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

//取消
- (void)cancel
{
    [self.connection cancel];
}
#pragma mark - delegate
//开始连接
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}
//获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
//数据获取完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //通知代理 执行方法 拿走data
    if ([_delegate respondsToSelector:@selector(requestHandle:didSucceedWithData:)] ) {
        
        [_delegate requestHandle:self didSucceedWithData:_data];
    }
}
//请求失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //通知代理 执行方法 拿走错误信息
    if ([_delegate respondsToSelector:@selector(requestHandle:didFailWithError:)]) {
        
        [_delegate requestHandle:self didFailWithError:error];
    }
}
@end
