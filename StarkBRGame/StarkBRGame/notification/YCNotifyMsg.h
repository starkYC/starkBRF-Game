//
//  YCNotifyMsg.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-6.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCNotifyMsg : NSObject


#define NOTIFY_CODE_OK 0
#define NOTIFY_CODE_HTTP_ERR       1           //HTTP 请求失败返回200以外的值（例如：403，404等等）
#define NOTIFY_CODE_RESPONDATA_ERR 2           //HTTP 返回的数据体格式不能正确解析


@property (nonatomic,assign) NSInteger code;

//发送一个通知

+(YCNotifyMsg*)shareYCNotifyMsg;
+(void)postNotification:(NSString*)notifyName notifyObj:(YCNotifyMsg*)obj;

@end
