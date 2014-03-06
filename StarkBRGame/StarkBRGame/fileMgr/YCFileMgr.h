//
//  YCFileMgr.h
//  YCManger
//
//  Created by gaoyangchun on 14-3-5.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

/*
    文件管理
 */

#import <Foundation/Foundation.h>

@interface YCFileMgr : NSObject


//以下方法中得"fullPath"指的是完整的单个文件路径，path指的是完整的单个目录的路径
/*
 保存string到文件
 filename：要保存的文件名（包括路径）
 writeData：要保存的内容
 append：是否追加到文件
 */
//+(BOOL)saveStringToFullPath:(NSString*)fullPath string:(NSString*)string append:(BOOL)flag;

/*
 保存NSData到文件
 filename：要保存的文件名（包括路径）
 writeData：要保存的内容
 append：是否追加到文件
 */
+(BOOL)saveDataToFullPath:(NSInteger)gamePage data:(NSData *)data append:(BOOL)flag;

/*
 删除文件
 filename：要保存的文件名（包括路径）
 返回值：是否删除成功
 */
+(BOOL)removeFile:(NSString*)fullPath;
/*
 日志到文件。每行为一条日志，每行开头有时间戳
 filename：要保存的文件名（包括路径）
 writeData：要保存的内容
 append：是否追加到文件
 */

//+(void)writeLogToFullPath:(NSString *)fullPath string:(NSString *)string append:(BOOL)flag;

//获取程序沙盒里document目录
+(NSString*)getDocumentFile;

//获取程序沙盒里Library目录
+(NSString*)getLibraryFile;

//获取document目录下，玩家的目录
+(NSString*)getUserFile:(NSString*)userID;

//获取gameData目录（没有就创建）
+(NSString*)getGameDataFile;

+(BOOL)isFileExistAtPath:(NSString*)fileFullPath;

//获取指定目录下，指定同类型后缀名的文件
+(NSArray *)getFileArrayOfType:(NSString*)type fromFilePath:(NSString*)path;

@end
