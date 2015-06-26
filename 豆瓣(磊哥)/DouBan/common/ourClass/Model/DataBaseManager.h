//
//  DataBaseManager.h
//  LessonUI-20-DataBase
//
//  Created by 怒煮西兰花 on 15/6/15.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
//如果想要使用 sqlite 需要进行两步配置
//1.导入动态链接库 libsqlite3.0.dylib
//2.导入库文件 sqlite3.h
@interface DataBaseManager : NSObject
//DataBaseManager 是一个数据库管理类,他只需要提供两个功能 打开数据 和 关闭数据库
//打开数据库
+ (sqlite3 *)openDataBase;

//关闭数据库
+ (void)closeDataBase;

@end
