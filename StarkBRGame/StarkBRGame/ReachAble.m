//
//  ReachAble.m
//  NetWork
//
//  Created by gaoyangchun on 14-1-21.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "ReachAble.h"

#import "Reachability.h"

static ReachAble *reachAble = nil;

@implementation ReachAble


+ (ReachAble*)reachAble{
    
    if (reachAble == nil) {
        reachAble = [[ReachAble alloc] init];
    }
    return reachAble;
}


- (BOOL)isConnectionAvailable{

    
    BOOL isExitNetWork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
     
            STRLOG(@"NotReachable");
            isExitNetWork = NO;
        }
            break;
            
        case ReachableViaWiFi  :{
            STRLOG(@"wifi");
            isExitNetWork = YES;
        }
            break;
           
        case ReachableViaWWAN:{
            STRLOG(@"3g");
            isExitNetWork = YES;
        }
            break;
            
        default:
            break;
    }
    
    
    return isExitNetWork;
}
@end
