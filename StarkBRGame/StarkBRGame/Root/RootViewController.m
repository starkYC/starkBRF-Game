//
//  RootViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "Reachability.h"
#import "ReachAble.h"
#import "MJRefresh.h"
#import "YCGameMgr.h"
#import "YCFileMgr.h"
#import "YCNotifyMsg.h"

@interface RootViewController ()
{
    NSMutableArray *_dataArray;
    
   
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSInteger Flag;
}
@end

@implementation RootViewController

@synthesize reqPage = _reqPage;
@synthesize locPage = _locPage;
@synthesize gameData = _gameData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        Flag = 1;
        self.locPage = 0;
        self.reqPage = 0;
        self.gameData = [[NSMutableData alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (BOOL)checkOutLocalData:(NSInteger)page{
   
    NSString *fileName = [NSString stringWithFormat:@"page%ld.txt",(long)page];
    NSString *gameDataPath = [YCFileMgr getGameDataFile];
    NSString *pagePath = [gameDataPath stringByAppendingPathComponent:fileName];
    NSData   *gamedata = [NSData dataWithContentsOfFile:pagePath];
    
    if (gamedata) {
        self.gameData = (NSMutableData*)gamedata;
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)checkNetWork{
    
    BOOL isConnect = [[ReachAble reachAble] isConnectionAvailable];
    return isConnect;
}
- (void)startRequest:(NSString*)url{

    if (![self checkNetWork]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的网络异常，请检查后重新刷新" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    /*
     下拉刷新
     */
    if (self.reqPage == 1 && (self.locPage == 0 || self.reqPage<=self.locPage) ) {
        //清除gameData目录下游戏数据
        [YCFileMgr removeFile:[YCFileMgr getGameDataFile]];
    }
    if (![self checkOutLocalData:self.reqPage]) {
        STRLOG(@"%ld页,请求",self.reqPage);
        [self addMessage:url method:@selector(GameDataReceicve:)];
        [[YCGameMgr sharedInstance]getGameDataFromServer:url andPage:self.reqPage];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}
- (void)GameDataReceicve:(NSNotification*)Notifi{
    
    [self removeMessage:Notifi.name];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    STRLOG(@"GameDataReceicve");
    self.gameData = [[YCGameMgr sharedInstance].dict objectForKey:Notifi.name];
    
    STRLOG(@"code:%ld",[YCNotifyMsg shareYCNotifyMsg].code);
    switch ([YCNotifyMsg shareYCNotifyMsg].code) {
        case 0:
            self.locPage = self.reqPage;
            break;
        case 1:
            STRLOG(@"NOTIFY_CODE_HTTP_ERR");
            [self showAlert:1];
            return;
            break;
        case 2:
            STRLOG(@"NOTIFY_CODE_RESPONDATA_ERR");
            [self showAlert:2];
            return;
            break;
        default:
            break;
    }
}

- (void)showAlert:(NSInteger)code{
  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 100;
    [alert show];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    UIAlertView *alert = (UIAlertView *)[self.view viewWithTag:100];
     [alert removeFromSuperview];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark  Custom Method

#pragma mark  NSNotificationCenter
- (void)addMessage:(NSString*)messageName method:(SEL)method{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:method name:messageName object:nil];
}

- (void)removeMessage:(NSString *)messageName{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:messageName object:nil];
}@end
