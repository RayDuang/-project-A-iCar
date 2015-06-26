
//
//  ImageDownLoader.m
//  LessonUI-18-ImageDownLoaderAndKVO
//
//  Created by 怒煮西兰花 on 15/6/11.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import "ImageDownLoader.h"


@interface ImageDownLoader () <NSURLConnectionDataDelegate>

@property (nonatomic,retain)NSMutableData *data; //拼接数据
@property (nonatomic,retain)NSURLConnection *connection;//连接对象
@end

@implementation ImageDownLoader
- (id)initWithImageURL:(NSString *)imageURL delegate:(id<ImageDownLoaderDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        
        //请求
        [self requestImageWithImageURL:imageURL];
    }
    return self;
}

//请求
- (void)requestImageWithImageURL:(NSString *)imageURL
{
    //1.URL
    NSString *newStr = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newStr];
    //2.请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.连接 并 请求
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}
//取消请求
- (void)cancel
{
    [self.connection cancel];
}
//连接成功
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}
//获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //数据拼接
    [self.data appendData:data];
}
//数据接收完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //获取image
    UIImage *image = [UIImage imageWithData:_data];
    
    //通知代理去执行协议中的方法 并把image拿走
    if ([_delegate respondsToSelector:@selector(imageDownLoader:didSucceedWithImage:)]) {
        
        [_delegate imageDownLoader:self didSucceedWithImage:image];
    }
}
//请求失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}
@end
