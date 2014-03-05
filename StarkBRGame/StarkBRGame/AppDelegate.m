//
//  AppDelegate.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "AppDelegate.h"

#import "STARKBoutiqueViewController.h"
#import "STARKActivityViewController.h"
#import "STARKPersonalViewController.h"
#import "STARKSetterViewController.h"
#import "STARKLoginViewController.h"

#import "Reachability.h"
#import "RootViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>

@implementation AppDelegate

static NSString * const kClientID =
    @"803321454103-bm4tlrummv6s7neo4okm7kq0ohsuuck1.apps.googleusercontent.com";

#pragma mark Object life-cycle.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    

    [self createTabbar];

    //FB 登录 声明
     [FBLoginView class];
    
    //Google 登录
    [GPPSignIn class];
    [GPPSignIn sharedInstance].clientID = kClientID;
    [GPPURLHandler class];
    
    //清除FBSession
    [FBSession.activeSession closeAndClearTokenInformation];
    //清除google
    [[GPPSignIn sharedInstance] signOut];
    //注册push功能
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];
   
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{

    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    STRLOG(@"My token is :%@",newToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	STRLOG(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSDictionary* dict = (NSDictionary*)[userInfo objectForKey:@"aps"];
    NSString *alertInfo = [dict objectForKey:@"alert"];
    application.applicationIconBadgeNumber = 0;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"通知" message:alertInfo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)createTabbar{
    
    STARKBoutiqueViewController *boutique = [[STARKBoutiqueViewController alloc] initWithNibName:@"STARKBoutiqueViewController" bundle:nil];
    boutique.title = NSLocalizedString(@"精品", nil);
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:boutique];

    STARKActivityViewController *activity = [[STARKActivityViewController alloc] initWithNibName:@"STARKActivityViewController" bundle:nil];
    activity.title = NSLocalizedString(@"活动",nil);
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:activity];

    STARKLoginViewController *login = [[STARKLoginViewController alloc]
        initWithNibName:@"STARKLoginViewController" bundle:nil];
    login.title = NSLocalizedString(@"我的",nil);
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:login];
   
    STARKSetterViewController *setter = [[STARKSetterViewController alloc]
        initWithNibName:@"STARKSetterViewController" bundle:nil];
    setter.title = NSLocalizedString(@"设置",nil);
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:setter];
   
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    
    // NSArray *views = [[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4, nil];
    
    tabbar.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4, nil];
    
    [self.window setRootViewController:tabbar];
 
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
  
    NSString *urlstr = [url absoluteString];

    NSRange range = [urlstr rangeOfString:@"google"];

    if (range.location != NSNotFound) {
       STRLOG(@"google");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"google" object:nil];
        
        return [GPPURLHandler handleURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
    }
    else{
        STRLOG(@"facebook");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"facebook" object:nil];
         return [FBSession.activeSession handleOpenURL:url];
       // return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    STRLOG(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    STRLOG(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    STRLOG(@"Terminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
