//
//  FileHandle.m
//  DouBan
//
//  Created by 怒煮西兰花 on 15/6/16.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import "FileHandle.h"
#import "DataBaseManager.h"
static FileHandle *handle = nil;
@implementation FileHandle

+ (FileHandle *)shareHandle
{
    if (handle ) {
        return handle;
    }
    handle = [[FileHandle alloc]init];
    return handle;
}

//图片的存储
//获取imageDownLoad文件路径
- (NSString *)getImageDownLoadFilePath
{
    //获取caches
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    //拼接文件路径
    NSString *imageDownLoadFilePath = [cachesPath stringByAppendingFormat:@"/imageDownLoad"];
    //文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //判断是否存在
    if ([manager fileExistsAtPath:imageDownLoadFilePath] == NO) {
        //不存在创建文件
        [manager createDirectoryAtPath:imageDownLoadFilePath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    return imageDownLoadFilePath;
    
}
//获取图片文件路径
- (NSString *)getImageFilePathWithImageURL:(NSString *)imageURL
{
    //获取存储图片的文件夹路径
    NSString *imageDownLoadPath = [self getImageDownLoadFilePath];
    //拼接图片文件路径
    NSString *imageFilePath = [imageDownLoadPath stringByAppendingFormat:@"/%@",[imageURL stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];
    
    return imageFilePath;
}
//存储图片
- (void)saveDownImageWithImage:(UIImage *)image filePath:(NSString *)filePath
{
    //获取存储的数据
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //写入本地图片
    [imageData writeToFile:filePath atomically:YES];
}


//数据库的存储
//通过电影名字获取电影
- (Movie *)selectMovieFromDataBaseWithMovieName:(NSString *)movieName
{
    Movie *movie = nil;
    //1.打开数据库
    sqlite3 *db = [DataBaseManager openDataBase];
    //2.创建指令集
    sqlite3_stmt *stmt = nil;
    //3.设置sqlite语句
    NSString *sqlStr = @"SELECT movie FROM Movie WHERE movieName = ?";
    //4.语法检查
    int flag = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, nil);
    //5.判断语法检查是否正确
    if (flag == SQLITE_OK) {
        //6.绑定属性
        sqlite3_bind_text(stmt, 1, [movieName UTF8String], -1, nil);
        //7.执行
        sqlite3_step(stmt);
        NSData *data = [NSData dataWithBytes:sqlite3_column_blob(stmt, 0) length:sqlite3_column_bytes(stmt, 0)];
        
//反归档操作
        //1).创建反归档对象
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        //2).反归档操作
        movie = [unarchiver decodeObjectForKey:movieName];
        //3).结束反归档
        [unarchiver finishDecoding];
        
    }
    //8.释放所有权
    sqlite3_finalize(stmt);
    //9.关闭数据库
    [DataBaseManager closeDataBase];
    
    return movie;
}
//保存电影
- (void)insertMovie:(Movie *)movie
{
    //判断电影是否已经收藏
    Movie *testMovie = [self selectMovieFromDataBaseWithMovieName:movie.movieName];
    if (testMovie != nil) {
        //已经收藏
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏过了" delegate:nil
    cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        return;
    }
    //1.打开数据库
    sqlite3 *db = [DataBaseManager openDataBase];
    //2.创建指令集
    sqlite3_stmt *stmt = nil;
    //3.设置sqlite语句
    NSString *sqlStr = @"INSERT INTO Movie(movieName,movie)VALUES(?,?)";
    //4.语法检查
    int flag = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, nil);
    //5.判断语法检查是否正确
    if (flag == SQLITE_OK) {
        //6.绑定属性
        sqlite3_bind_text(stmt, 1, [movie.movieName UTF8String], -1, nil);
        //归档
        NSMutableData *data = [NSMutableData data];
        //1).创建归档对象
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        //2).归档操作
        [archiver encodeObject:movie forKey:movie.movieName];
        //3).结束归档
        [archiver finishEncoding];
        
        sqlite3_bind_blob(stmt, 2, data.bytes, (int)data.length, nil);
        
        //7.执行
        sqlite3_step(stmt);
    }
    //8.释放所有权
    sqlite3_finalize(stmt);
    //9.关闭数据库
    [DataBaseManager closeDataBase];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    [alertView release];
}
//获取表单所有电影名字
- (NSArray *)selectMovieNames
{
    //创建名字数组
    NSMutableArray *movieNames = [NSMutableArray array];
    //1.打开数据库
    sqlite3 *db = [DataBaseManager openDataBase];
    //2.创建指令集
    sqlite3_stmt *stmt = nil;
    //3.设置sqlite语句
    NSString *sqlStr = @"SELECT movieName FROM Movie";
    //4.语法检查
    int flag = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, nil);
    //5.判断语法检查是否正确
    if (flag == SQLITE_OK) {
        //6.绑定参数
        //7.执行
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获取数据
            char *name_C = (char *)sqlite3_column_text(stmt, 0);
            //转化为OC字符串
            NSString *nameOC = [NSString stringWithUTF8String:name_C];
            //放入数组
            [movieNames addObject:nameOC];
        }
    }
    //8.释放所有权
    sqlite3_finalize(stmt);
    //9.关闭数据库
    [DataBaseManager closeDataBase];
    
    return movieNames;
}

@end
