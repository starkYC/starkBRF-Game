//
//  HttpRequest.h
//  LimitFreeDemo
//
//  Created by gaoyangchun on 14-1-7.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class +类名称 告诉编译器，存在HttpRequest类,不会编译多余的东西
//#import + 类名称 (告诉编译器，存在此类之外，还会将.h中定义的属性、成员变量、方法 全部编译)
@class HttpRequest;

@protocol HttpRequestDelegate <NSObject>

//数据请求完成的方法
- (void)httpRequestDidFinished:(HttpRequest *)hd;
//数据请求失败的方法
- (void)httpRequestFailed:(HttpRequest *)hd;
//post
- (void)httpRequestPostDidFinished:(HttpRequest *)hd;
- (void)httpRequestPostFailed:(HttpRequest *)hd;

@end

@interface HttpRequest : NSObject <NSURLConnectionDataDelegate>

//从服务器获取到的数据
@property (nonatomic,retain) NSMutableData *responseData;
@property (nonatomic,assign) id <HttpRequestDelegate> delegate;
@property (nonatomic,copy)  NSString *url;


//根据地址向服务器进行后续的请求
- (void)httpRequestWithUrlStr:(NSString *)urlStr;

//用第三方ASIHttpRequest进行post请求
-(void)downloadFromUrlWithASI:(NSString *)url  dict:(NSDictionary*)dict;
@end
