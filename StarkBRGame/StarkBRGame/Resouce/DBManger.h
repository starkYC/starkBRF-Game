//
//  BoutiqueViewController.h
//  LimitFreeDemo
//
//  Created by gaoyangchun on 14-1-7.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"
@interface DBManger : NSObject<HttpRequestDelegate>
{
    //保存下载任务对象(QFDownload)的字典
    NSMutableDictionary *taskDict;
    //保存下载解析结果的字典
    NSMutableDictionary *resultDict;
}
- (id)init;

+(DBManger*)shareManger;

- (void)addGetTask:(NSString*)url type:(NSInteger)apiType isASI:(BOOL)isASI;

- (void)postTask:(NSString*)url content:(NSDictionary*)dict;
//移除任务
- (void)removeTask:(NSString*)url;
//根据请求的网址获得解析结果
- (id)objectForKey:(NSString*)url;
//保存解析结果,用请求的网址做key(翻页的特殊处理)
- (void)setObject:(id)object forKey:(NSString*)url;


@end
