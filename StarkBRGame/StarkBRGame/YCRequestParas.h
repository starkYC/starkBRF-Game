//
//  YCRequestParas.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-6.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

#define HTTP_MOTHOD_POST        @"post"
#define HTTP_MOTHOD_GET         @"get"
#define HTTP_MOTHOD_UPLOADFILE  @"uploadfile"

//响应通用字段
#define HTTP_RESPONSE_XML_STATUSCODE        @"statuscode"
#define HTTP_RESPONSE_XML_ERRORMESSAGE      @"errormessage"
//标准http响应码
#define HTTP_DEFAULT_RESP_CODE_200      200  //http请求返回成功
//http数据格式
#define HTTP_DATA_FORMART_XML   @"XML"
#define HTTP_DATA_FORMART_JSON  @"JSON"

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
