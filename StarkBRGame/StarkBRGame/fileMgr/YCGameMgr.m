//
//  YCGameMgr.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-5.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "YCGameMgr.h"

#import "YCRequestCenter.h"
#import "YCFileMgr.h"
#import "YCRequestParas.h"

YCGameMgr *__userMgr;

@implementation YCGameMgr

+ (YCGameMgr*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __userMgr = [[YCGameMgr alloc] init];
    });
    return __userMgr;
}

- (void)getGameDataFromServer:(NSString *)headUrl andPage:(NSInteger)page{
   

    YCRequestParas *parasUserInfo =[[YCRequestParas alloc]init];
    parasUserInfo.reqDelegate = self;
    parasUserInfo.downUrl = headUrl;
    self.DownUrl = headUrl;
    self.Gamepage = page;
    //请求UserInfo用于解析的标识
    NSMutableDictionary *reqInfoDict = [NSMutableDictionary dictionary];
    [reqInfoDict setObject:headUrl forKey:headUrl];
    parasUserInfo.userInfo = reqInfoDict;
    
    //执行请求
    [[YCRequestCenter sharedInstance] makeASIRequestAndStart:parasUserInfo];
}


- (void)requestFailed:(ASIHTTPRequest *)request{
    STRLOG(@"Error:%@",request.error);
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if(![[YCRequestCenter sharedInstance] isRequestSuccesed:request])
    {
        //TODO.. http响应异常，响应码不是200
        
        return;
    }
    if (request.responseData) {
        
        [self.dict setObject:request.responseData forKey:self.DownUrl];
        //本地保存
        [YCFileMgr saveDataToFullPath:_Gamepage data:request.responseData append:NO];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.DownUrl object:self];
}

- (BOOL)saveUserData:(BOOL)isUserInfoOnly{
    // 保存数据到本地  ToDo。。。
    return YES;
}

@end
