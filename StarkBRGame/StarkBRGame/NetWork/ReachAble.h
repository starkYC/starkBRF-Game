//
//  ReachAble.h
//  NetWork
//
//  Created by gaoyangchun on 14-1-21.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReachAble : NSObject


+ (ReachAble*)reachAble;

- (BOOL)isConnectionAvailable;

@end
