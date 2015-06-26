//
//  FileHandle.h
//  DouBan
//
//  Created by 怒煮西兰花 on 15/6/16.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
@interface FileHandle : NSObject
+ (FileHandle *)shareHandle;

//图片的存储
//获取imageDownLoad文件路径
- (NSString *)getImageDownLoadFilePath;
//获取图片文件路径
- (NSString *)getImageFilePathWithImageURL:(NSString *)imageURL;
//存储图片
- (void)saveDownImageWithImage:(UIImage *)image filePath:(NSString *)filePath;


//数据库的存储
//通过电影名字获取电影
- (Movie *)selectMovieFromDataBaseWithMovieName:(NSString *)movieName;
//保存电影
- (void)insertMovie:(Movie *)movie;
//获取表单所有电影名字
- (NSArray *)selectMovieNames;
@end
