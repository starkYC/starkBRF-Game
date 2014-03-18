//
//  YCFileMgr.m
//  YCManger
//
//  Created by gaoyangchun on 14-3-5.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "YCFileMgr.h"
@implementation YCFileMgr
//获取沙盒Document目录
+(NSString*)getDocumentFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
//获取libraray目录
+(NSString*)getLibraryFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(NSString*)getUserFile:(NSString*)userID
{
    NSString *userFile = [YCFileMgr getDocumentFile];
    userFile = [userFile stringByAppendingPathComponent:userID];
    //创建目录
    [[NSFileManager defaultManager]createDirectoryAtPath:userFile withIntermediateDirectories:YES attributes:nil error:NULL];
    return userFile;
}

//获得存储游戏数据的目录
+(NSString*)getGameDataFile
{
    NSString *gameStr = [YCFileMgr getDocumentFile];
    gameStr = [gameStr stringByAppendingPathComponent:@"gameData"];
    [[NSFileManager defaultManager]createDirectoryAtPath:gameStr withIntermediateDirectories:YES attributes:nil error:nil];
    return gameStr;
}

////写入string,
//+(BOOL)saveStringToFullPath:(NSString *)fullPath string:(NSString *)string append:(BOOL)flag
//{
//    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
//   
//    return [YCFileMgr saveDataToFullPath:fullPath data:data append:flag];
//    
//}

//写入data
+(BOOL)saveDataToFullPath:(NSInteger)gamePage data:(NSData *)data append:(BOOL)flag
{
    NSString *gamePath =  [self getGameDataFile];
    
    BOOL isSuccess = NO;
    
    if(!flag)
    {
        NSString *pagePath = [gamePath stringByAppendingPathComponent:[NSString stringWithFormat:@"page%ld.txt",(long)gamePage]];
        STRLOG(@"path:%@",pagePath);
       isSuccess = [[NSFileManager defaultManager] createFileAtPath:pagePath contents:data attributes:nil];
        
    }
    else
    {

    }
    return isSuccess;
}
//删除文件
+(BOOL)removeFile:(NSString *)fullPath
{
    BOOL isExist = FALSE;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        isExist = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }
    return  isExist;
}


/**
 *  @brief  获得指定目录下，指定后缀名的文件列表
 *  @param  type    文件后缀名
 *  @param  dirPath     指定目录
 *  @return 文件名列表
 */
+(NSArray *)getFileArrayOfType:(NSString*)type fromFilePath:(NSString*)path
{
    NSMutableArray *fileArray = [NSMutableArray  array];
    
    NSArray *allFileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *fileName in allFileArray) {
        NSString *fullpath = [path stringByAppendingPathComponent:fileName];
        if ([YCFileMgr isFileExistAtPath:fullpath]) {
            if ([[fileName pathExtension] isEqualToString:type]) {
                [fileArray  addObject:fileName];
            }
        }
    }
    return fileArray;
    
}
/**
 *  @brief  检查文件是否存在
 *  @param  type    文件全路径
 *  @return 是否存在
 */
+(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}
@end
