//
//  YCRequestCenter.h
//  YCManger
//
//  Created by gaoyangchun on 14-3-5.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSOperation.h>


@class YCRequestParas;
@class ASIHTTPRequest;

@interface YCRequestCenter : NSObject

+ (YCRequestCenter*)sharedInstance;

- (void)addASIRequest:(NSOperation*)operation;

- (ASIHTTPRequest*)makeASIRequest:(YCRequestParas*)paras;
- (ASIHTTPRequest*)makeASIRequestAndStart:(YCRequestParas*)paras;
- (void)go;
- (void)cancelAllRequest;
- (BOOL)isRequestSuccesed:(ASIHTTPRequest*)request;

@end
