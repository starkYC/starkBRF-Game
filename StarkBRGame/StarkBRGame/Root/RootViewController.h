//
//  RootViewController.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefreshBaseView.h"

@interface RootViewController : UIViewController

//注册消息
- (void)addMessage:(NSString*)messageName method:(SEL)method;

//移除消息
- (void)removeMessage:(NSString*)messageName;
//当前请求页数
@property (nonatomic,assign) NSInteger reqPage;
//当前已经请求过的页数
@property (nonatomic,assign) NSInteger locPage ;
@property (nonatomic,strong) NSMutableData *gameData ;

- (void)GameDataReceicve:(NSNotification*)Notifi;
- (void)startRequest:(NSString*)url;
- (BOOL)checkOutLocalData:(NSInteger)page;
- (void)showAlert:(NSInteger)code;
- (BOOL)checkNetWork;

@end
