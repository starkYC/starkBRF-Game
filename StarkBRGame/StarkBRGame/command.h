//
//  command.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-4.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#ifndef StarkBRGame_command_h
#define StarkBRGame_command_h


//输出调试信息
#define PRINT_DEBUG
#ifdef PRINT_DEBUG
#define STRLOG( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define STRLOG( s, ... )
#endif

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

#endif

