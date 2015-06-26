//
//  Movie.h
//  DouBan
//
//  Created by 怒煮西兰花 on 15/6/16.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

/*
 //列表界面
    movieName：电影名
	pic_url：图片
	movieid：电影编号
 
 //详情
    plot_simple：简介
	title：电影名字
	genres：分类
	country：国家
	runtime：时间
	poster：图片
	rating_count: 评论人数
	rating：评分
	release_date：上映时间
	actors：制作人信息
 
 */
#import <UIKit/UIKit.h>
#import "ImageDownLoader.h"
@interface Movie : NSObject<ImageDownLoaderDelegate,NSCoding>
//列表界面请求的数据
@property (nonatomic,copy)NSString *movieName;
@property (nonatomic,copy)NSString *pic_url;
@property (nonatomic,copy)NSString *movieId;

@property(nonatomic,retain)UIImage *movie_pic;//电影图片
@property(nonatomic)BOOL isLoading;//是否正在下载

//详情界面请求的数据
@property (nonatomic,copy)NSString *plot_simple;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *genres;
@property (nonatomic,copy)NSString *country;
@property (nonatomic,copy)NSString *runtime;
@property (nonatomic,copy)NSString *poster;
@property (nonatomic,copy)NSString *rating_count;
@property (nonatomic,copy)NSString *rating;
@property (nonatomic,copy)NSString *release_date;
@property (nonatomic,copy)NSString *actors;

//请求图片
- (void)loadImage;

@end
