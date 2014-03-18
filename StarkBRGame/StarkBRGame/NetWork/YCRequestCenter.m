//
//  YCRequestCenter.m
//  YCManger
//
//  Created by gaoyangchun on 14-3-5.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "YCRequestCenter.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "YCRequestParas.h"

@interface YCRequestCenter ()

@property ASINetworkQueue* reqQueue;

@end

YCRequestCenter *__RequestCenter;

@implementation YCRequestCenter
+ (YCRequestCenter*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __RequestCenter = [[YCRequestCenter alloc] init];
    });
    return __RequestCenter;
}

- (void)addASIRequest:(NSOperation *)operation{
    STRLOG(@"addASIRequest");
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _reqQueue = [[ASINetworkQueue alloc]init];
        _reqQueue.maxConcurrentOperationCount = 4;
    }
    
    return self;
}

-(void)dealloc
{
    [_reqQueue cancelAllOperations];
    [_reqQueue release];
    
    [super dealloc];
}

- (ASIHTTPRequest*)makeASIRequest:(YCRequestParas*)paras
{
    if(paras == nil)
        return nil;
    if([paras.httpMothod isEqualToString:HTTP_MOTHOD_GET])
    {
        STRLOG(@"HTTP_MOTHOD_GET");
        ASIHTTPRequest* req1  =[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[paras.downUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        req1.delegate = paras.reqDelegate;
        req1.userInfo = paras.userInfo;
        [self.reqQueue addOperation:req1];
        return req1;
        
    }
    else if([paras.httpMothod isEqualToString:HTTP_MOTHOD_POST])
    {
        ASIFormDataRequest* req2  =[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[paras.downUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        req2.delegate = paras.reqDelegate;
        req2.userInfo = paras.userInfo;
        [req2 appendPostData:[paras getRequestData]];
        [self.reqQueue addOperation:req2];
        
        return req2;
        
    }else if([paras.httpMothod isEqualToString:HTTP_MOTHOD_UPLOADFILE])
    {
        ASIFormDataRequest* req3  = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[paras.downUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        req3.delegate = paras.reqDelegate;
        req3.userInfo = paras.userInfo;
        [req3 setFile:paras.uploadFilename forKey:paras.uploadFileKey];
        
        [self.reqQueue addOperation:req3];
        return  req3;
    }
    
    return nil;
}
- (ASIHTTPRequest*)makeASIRequestAndStart:(YCRequestParas*)paras
{
    ASIHTTPRequest* retVal = [self makeASIRequest:paras];
    
    [self.reqQueue go];
    return retVal;
}

- (void)cancelAllRequest
{
    [self.reqQueue reset];
}

- (void)go
{
    [self.reqQueue go];
}

- (BOOL)isRequestSuccesed:(ASIHTTPRequest*)request
{
    STRLOG(@"responseStatusCode: %d",request.responseStatusCode);
    
    if (request.responseStatusCode == HTTP_DEFAULT_RESP_CODE_200) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
