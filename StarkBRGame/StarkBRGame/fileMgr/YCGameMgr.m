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
#import "YCNotifyMsg.h"
#import "GDataXMLNode.h"

YCGameMgr *__userMgr ;

@implementation YCGameMgr


- (id)init{
    
    self = [super init];
    if (self) {
        self.dict = [[NSMutableDictionary alloc ]init];
    }
    return self;
}

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
    [self.dict setObject:HTTP_RESPONSE_XML_ERRORMESSAGE forKey:self.DownUrl];
    [YCNotifyMsg shareYCNotifyMsg].code = NOTIFY_CODE_HTTP_ERR;
    [self postVCRequest];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if(![[YCRequestCenter sharedInstance] isRequestSuccesed:request])
    {
        [YCNotifyMsg shareYCNotifyMsg].code = NOTIFY_CODE_HTTP_ERR;
        //TODO.. http响应异常，响应码不是200
        [self postVCRequest];
        return;
    }
    if (request.responseData) {
        
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:request.responseData options:0 error:nil] ;
        if(doc == nil)
        {
            //返回的xml貌似有问题，不能解析！！！！！
            if ([[request.userInfo objectForKey:self.DownUrl] isEqualToString:self.DownUrl]) {
                [YCNotifyMsg shareYCNotifyMsg].code = NOTIFY_CODE_RESPONDATA_ERR;
            }
        }else{
             [YCNotifyMsg shareYCNotifyMsg].code = NOTIFY_CODE_OK;
            [self.dict setObject:request.responseData forKey:self.DownUrl];
            //本地保存
            [YCFileMgr saveDataToFullPath:_Gamepage data:request.responseData append:NO];
        }
        [self postVCRequest];
    }
    
    
}
//给请求数据的VC发送广播通知
- (void)postVCRequest{
    
    [YCNotifyMsg postNotification:self.DownUrl notifyObj:[YCNotifyMsg shareYCNotifyMsg]];
}

- (BOOL)saveUserData:(BOOL)isUserInfoOnly{
    // 保存数据到本地  ToDo。。。
    return YES;
}

@end
