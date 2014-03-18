//
//  YCRequestParas.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-6.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@interface YCRequestParas : NSObject

@property (nonatomic,retain) NSString *downUrl;
//请求数据字典
@property(nonatomic, retain) NSDictionary* reqParamsDict;
@property(nonatomic, retain) NSDictionary* reqUrlParamsDict;
//数据请求方式
@property(nonatomic, retain) NSString* httpMothod;
@property(nonatomic, assign) id <ASIHTTPRequestDelegate> reqDelegate;
// Custom user information associated with the request (not sent to the server)
//标示不同请求
@property(nonatomic, retain) NSDictionary *userInfo;
@property(nonatomic, assign) NSInteger page;
//for upload file
@property(nonatomic, retain) NSString* uploadFilename;
@property(nonatomic, retain) NSString* uploadFileKey;
//请求数据格式
@property(nonatomic, retain) NSString* dataFormart;
@property(nonatomic, retain) NSData *reqData;

//根据请求参数拼接数据体
-(NSData*)getRequestData;

//获取请求地址
-(NSString*)getRequestUrl;

@end
