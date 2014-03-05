//
//  HttpRequest.h
//  LimitFreeDemo
//
//  Created by gaoyangchun on 14-1-7.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "HttpRequest.h"
#import "ASIFormDataRequest.h"

@implementation HttpRequest
{
    NSURLConnection *_urlConnection;
}
@synthesize responseData = _responseData;
@synthesize delegate =_delegate;
@synthesize url = _url;
- (id)init
{
    self = [super init];
    if (self) {
        STRLOG(@"ddd");
        _responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)httpRequestWithUrlStr:(NSString *)urlStr{
    
    if (urlStr == nil || [urlStr length] == 0) {
        return;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if(_urlConnection){
        _urlConnection  = nil;
    }
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)downloadFromUrlWithASI:(NSString *)url  dict:(NSDictionary*)dict{

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"验证网址"]];
    request.delegate = self;
    for (NSString *dicKey in [dict allKeys]) {
        //将字典中的参数添加到request中
        [request setPostValue:[dict objectForKey:dicKey] forKey:dicKey];
    }
    //设置请求方式
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
}

#pragma mark -- ConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
   
    //打印状态码
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *newsponse=(NSHTTPURLResponse*)response;
        
        STRLOG(@"状态码:%d",[newsponse statusCode]);
    }
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (_responseData) {
        if ([_delegate respondsToSelector:@selector(httpRequestDidFinished:)]) {
            [_delegate httpRequestDidFinished:self];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if ([_delegate respondsToSelector:@selector(httpRequestFailed:)]) {
        STRLOG(@"error:%@",error);
        [_delegate httpRequestFailed:self];
    }
}

#pragma mark -- ASIpost delegate

- (void)requestFinished:(ASIHTTPRequest *)request{

    if (request.responseData) {
        if ([_delegate respondsToSelector:@selector(httpRequestPostDidFinished:)]) {
            [_delegate httpRequestPostDidFinished:self];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest*)request{
    if ([_delegate respondsToSelector:@selector(httpRequestPostFailed:)]) {
        [_delegate httpRequestPostFailed:self];
    }
}

- (void)dealloc{
    
    [_urlConnection release];
    _delegate = nil;
    [_responseData release];
    [_url release];

    [super dealloc];
}

@end
