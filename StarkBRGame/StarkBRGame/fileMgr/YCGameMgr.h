//
//  YCGameMgr.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-5.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//
/*
    游戏数据管理
 */
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"

#define RequestError @"RequestError"

@interface YCGameMgr : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic,strong) NSString *DownUrl;
@property (nonatomic,assign) NSInteger Gamepage;
@property (nonatomic,strong) NSMutableDictionary *dict;
+ (YCGameMgr*)sharedInstance;

/*
 请求一页的游戏数据
 headUrl: 基础接口
 page:页数参数
 */
- (void)getGameDataFromServer:(NSString *)headUrl andPage:(NSInteger)page;

/*
 保存用户信息到本地

 
*/
- (BOOL)saveUserData:(BOOL)isUserInfoOnly;


@end
