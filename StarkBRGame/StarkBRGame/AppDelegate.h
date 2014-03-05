//
//  AppDelegate.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class GTMOAuth2Authentication;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@property (strong, nonatomic) UIWindow *window;

@end
