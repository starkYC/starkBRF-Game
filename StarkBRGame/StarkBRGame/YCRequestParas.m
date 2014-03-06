//
//  YCRequestParas.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-6.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "YCRequestParas.h"

@implementation YCRequestParas


-(id)init
{
    self = [super init];
    if(self)
    {
        self.httpMothod = HTTP_MOTHOD_GET;
        self.dataFormart = HTTP_DATA_FORMART_XML;
        
        self.reqData = nil;
    }
    
    return  self;
}

-(NSData*)getRequestData
{
    if([self.dataFormart isEqualToString:HTTP_DATA_FORMART_XML])
    {
        return [self getRequestDataXml];
    }
    else if([self.dataFormart isEqualToString:HTTP_DATA_FORMART_JSON])
    {
        return [self getRequestDataJson];
    }
    else
    {
        return nil;
    }
}
-(NSString*)getRequestUrl{
    
    return [self getRequestUrlBy:self.page ];
}

- (NSString*)getRequestUrlBy:(NSInteger)page{
    
    //拼接请求字符串
    self.downUrl = @"https://itunes.apple.com/br/rss/topfreeapplications/limit=10/genre=6014/xml";
    return self.downUrl;
}

- (NSData*)getRequestDataXml{
    
    return nil;
}

- (NSData*)getRequestDataJson{
    
    return nil;
}


@end
