//
//  ImageDownLoader.h
//  LessonUI-18-ImageDownLoaderAndKVO
//
//  Created by 怒煮西兰花 on 15/6/11.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ImageDownLoader;
@protocol ImageDownLoaderDelegate <NSObject>

//请求成功时
- (void)imageDownLoader:(ImageDownLoader *)imageDownLoader  didSucceedWithImage:(UIImage *)image;

@end

@interface ImageDownLoader : NSObject
@property (nonatomic,assign)id<ImageDownLoaderDelegate>delegate;

- (id)initWithImageURL:(NSString *)imageURL delegate:(id<ImageDownLoaderDelegate>)delegate;

- (void)cancel;

@end
