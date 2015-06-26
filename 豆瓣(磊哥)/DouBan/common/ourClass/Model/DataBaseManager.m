//
//  DataBaseManager.m
//  LessonUI-20-DataBase
//
//  Created by 怒煮西兰花 on 15/6/15.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import "DataBaseManager.h"

//对一个程序来说 只需要一个数据库 足以
static sqlite3 *db = nil;
@implementation DataBaseManager
//打开数据库
+ (sqlite3 *)openDataBase
{
//    @synchronized
    if (db) {
        return db;
    }
    
    //获取文件路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",cachesPath);
    NSString *dbPath = [cachesPath stringByAppendingFormat:@"/db.sqlite"];
    //打开数据库
    //如果数据库文件存在就打开,如文件不存在 先创建数据库文件,再进行数据库的打开操作
    int flag = sqlite3_open([dbPath UTF8String], &db);
    if (flag == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //表单创建
        //1.创建sql语句
        NSString *sqlStr = @"CREATE TABLE Movie(movie_ID INTEGER PRIMARY KEY NOT NULL,movieName TEXT NOT NULL,movie BLOB NOT NULL)";
        //2.执行
        sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, NULL);
    }
    return db;
}

//关闭数据库
+ (void)closeDataBase
{
    //关闭
    int flag = sqlite3_close(db);
    if (flag == SQLITE_OK) {
        db = nil;
    }
}

@end
