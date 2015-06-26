//
//  RequestHandle.h
//  RequestHandle_demo
//
//  Created by 怒煮西兰花 on 15/6/12.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class RequestHandle;

@protocol RequestHandleDelegate <NSObject>
//成功
- (void)requestHandle:(RequestHandle *)request didSucceedWithData:(NSData *)data;
//失败
- (void)requestHandle:(RequestHandle *)request
     didFailWithError:(NSError *)error;

@end

@interface RequestHandle : NSObject <NSURLConnectionDataDelegate>

//代理
@property (nonatomic,assign)id<RequestHandleDelegate>delegate;
//连接对象
@property (nonatomic,retain)NSURLConnection *connection;
//data
@property (nonatomic,retain)NSMutableData *data;
- (id)initWithURL:(NSString *)url method:(NSString *)method parameter:(NSString *)parameter delegate:(id<RequestHandleDelegate>)delegate;

- (void)cancel;
@end
