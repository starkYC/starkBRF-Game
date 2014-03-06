//
//  YCNotifyMsg.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-3-6.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "YCNotifyMsg.h"

@implementation YCNotifyMsg

YCNotifyMsg *__YCNotifyMsgCenter;

+ (YCNotifyMsg*)shareYCNotifyMsg
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __YCNotifyMsgCenter = [[YCNotifyMsg alloc] init];
    });
    return __YCNotifyMsgCenter;
}
//发送一个通知
+(void)postNotification:(NSString*)notifyName notifyObj:(YCNotifyMsg*)obj{

    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:obj];
}
@end
