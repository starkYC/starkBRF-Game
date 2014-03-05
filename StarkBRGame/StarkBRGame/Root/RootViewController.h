//
//  RootViewController.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManger.h"

@interface RootViewController : UIViewController


//注册消息
- (void)addMessage:(NSString*)messageName method:(SEL)method;

//移除消息
- (void)removeMessage:(NSString*)messageName;


@end
