//
//  BoutiqueViewController.h
//  LimitFreeDemo
//
//  Created by gaoyangchun on 14-1-7.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "DBManger.h"


@implementation DBManger

static DBManger *manger = nil;


//通过类方法，返回一个DBManager的单例
+(DBManger *)shareManger{
    //保证调用类方法只返回唯一的一个实例，而不是多次创建的不同实例
    //@synchronized
    //保证同一时刻只有一个线程访问
    @synchronized(self){
        if (manger == nil) {
            manger = [[DBManger alloc] init];
        }
    }
    return manger;
}

//重写alloc方法，调用alloc方法时，会自动调用allocWithZone
+(id)allocWithZone:(NSZone *)zone{
    //加上线程访问限制
    @synchronized(self){
        if (manger == nil) {
            manger = [super allocWithZone:zone];
        }
        return manger;
    }
    return nil;
}
//重写copy(copyWithZone)方法,保证单例的唯一性
+(id)copyWithZone:(NSZone *)zone{
    return self;
}
//重写init方法
- (id)init{
    
    self = [super init];
    if (self) {
        taskDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        resultDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addGetTask:(NSString*)url type:(NSInteger)apiType isASI:(BOOL)isASI{
    //判断任务是否已经存在,根据网址
    HttpRequest *hd = [taskDict objectForKey:url];
    if (hd == nil) {
        hd = [[HttpRequest alloc] init];
        hd.delegate = self;
        hd.url = url;
        if (isASI) {
            
        }
        else {
            [hd httpRequestWithUrlStr:url];
        }
        //保存下载任务
        [taskDict setObject:hd forKey:url];
    }
    else{
        STRLOG(@"下载任务已经存在:%@",url);
    }
}

//post请求
- (void)postTask:(NSString*)url content:(NSDictionary*)dict{

    HttpRequest *hd = [[HttpRequest alloc] init];
    hd.delegate = self;
    hd.url = url;
    [hd downloadFromUrlWithASI:url dict:dict];
}

- (id)objectForKey:(NSString *)url{
    
    return [resultDict objectForKey:url];
}

- (void)setObject:(id)object forKey:(NSString *)url{
  
    [resultDict setObject:object forKey:url];
    
}

#pragma mark --HttpRequestDelegate

- (void)httpRequestDidFinished:(HttpRequest *)hd{
    
    STRLOG(@"下载完成");
    [self setObject:hd.responseData forKey:hd.url];
    //发出下载解析完成消息
    [[NSNotificationCenter defaultCenter] postNotificationName:hd.url object:nil];
    //当数据下载完清除任务
    //延迟0.5秒删除已完成任务
    [self performSelector:@selector(removeTask:) withObject:hd.url afterDelay:0.5];
    //[NSObject cancelPreviousPerformRequestsWithTarget:<#(id)#>];
}

- (void)httpRequestFailed:(HttpRequest *)hd{
    
    STRLOG(@"请求失败:%@",hd.url);
    
    [taskDict removeObjectForKey:hd.url];
    [self setObject:@"1" forKey:hd.url];//1代表下载失败
    [[NSNotificationCenter defaultCenter] postNotificationName:hd.url object:nil];
    
}

#pragma mark post delegate

- (void)httpRequestPostDidFinished:(HttpRequest *)hd{
    
    [self setObject:hd.responseData forKey:hd.url];
    //发出下载解析完成消息
    [[NSNotificationCenter defaultCenter] postNotificationName:hd.url object:nil];
    //当数据下载完清除任务
    //延迟0.5秒删除已完成任务
    [self performSelector:@selector(removeTask:) withObject:hd.url afterDelay:0.5];
    //[NSObject cancelPreviousPerformRequestsWithTarget:<#(id)#>];
}

- (void)httpRequestPostFailed:(HttpRequest *)hd{
   
    STRLOG(@"请求发生故障:%@",hd.url);
    [taskDict removeObjectForKey:hd.url];
    [self setObject:@"0" forKey:hd.url];//0代表请求故障
    [[NSNotificationCenter defaultCenter] postNotificationName:hd.url object:nil];
}

- (void)removeTask:(NSString*)url{
    
    HttpRequest *hd = [taskDict objectForKey:url];
    if (hd) {
        hd.delegate = self;
        STRLOG(@"任务已经删除");
        [taskDict removeObjectForKey:url];
    }
}

@end
