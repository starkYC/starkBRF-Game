//
//  STARKLoginViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-16.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKLoginViewController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "STARKPersonalViewController.h"
#import "FMDBase.h"
#import "AccoutInfo.h"
#import "AppDelegate.h"

@interface STARKLoginViewController ()<GPPSignInDelegate>
{
    UIActivityIndicatorView *_indicatorView;
    BOOL canEnter;
}
@end

@implementation STARKLoginViewController
@synthesize userID = _userID;
@synthesize type = _type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        canEnter = NO;
    }
    return self;
}

- (void)gppInit{
    
    STRLOG(@"gppInit");
    
    [GPPSignIn class];
    [GPPSignInButton class];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGoogleUserID = YES;
    NSArray *actions = [[NSArray alloc] initWithObjects:
                        @"http://schemas.google.com/AddActivity",
                        @"http://schemas.google.com/BuyActivity",
                        @"http://schemas.google.com/CheckInActivity",
                        @"http://schemas.google.com/CommentActivity",
                        @"http://schemas.google.com/CreateActivity",
                        @"http://schemas.google.com/DiscoverActivity",
                        @"http://schemas.google.com/ListenActivity",
                        @"http://schemas.google.com/ReserveActivity",
                        @"http://schemas.google.com/ReviewActivity",
                        @"http://schemas.google.com/WantActivity",
                        nil];
    signIn.actions = actions;
    NSArray *scopes = [[NSArray alloc] initWithObjects:
                      @"https://www.googleapis.com/auth/plus.login",
                      @"https://www.googleapis.com/auth/plus.me", nil];
    signIn.scopes = scopes;
    signIn.delegate = self;
}

#pragma mark 注销代理

- (void)personSignout:(NSString*)type{

    STRLOG(@"注销");
    if ([type isEqualToString:@"google"]) {
        STRLOG(@"google 退出");
        [[GPPSignIn sharedInstance] signOut];
    }else{
        STRLOG(@"fb 退出");
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    self.nameLabel.text = @"";
    self.idLabel.text = @"";
    self.emailLabel.text = @"";
    canEnter = NO;
}

#pragma mark View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    /*初始化*/
    self.type = [[NSString alloc] init];
    self.userID = [[NSString alloc] init];
    /*对google登陆进行设置*/
    [self gppInit];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"fbbutton" ofType:@"png"];
//    [self.fbButton setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIndicatorView) name:@"google" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIndicatorView) name:@"facebook" object:nil];

    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 220, 100, 100)];
    _indicatorView.center = self.view.center;
    _indicatorView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_indicatorView];
   /*   开始读数据   */
    [self getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    self.googleButton.enabled = YES;
  }

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
   
    //尝试进入
    if (canEnter) {
        [self enterPersonCenter];
    }
    

}

- (void)viewDidDisappear:(BOOL)animated{
    //[_indicatorView stopAnimating];
     //self.view.userInteractionEnabled = YES;
     //[[GPPSignIn sharedInstance] signOut];
    [super viewDidDisappear:animated];
}
#pragma mark  FBLogin

- (IBAction)fbbuttonClicked:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
//    if (FBSession.activeSession.state == FBSessionStateOpen
//        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
//        STRLOG(@"%d",FBSession.activeSession.state );
//        // Close the session and remove the access token from the cache
//        // The session state handler (in the app delegate) will be called automatically
//        [FBSession.activeSession closeAndClearTokenInformation];
//        
//        // If the session state is not any of the two "open" states when the button is clicked
//    } else {
//        // Open a session showing the user the login UI
//        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             STRLOG(@"block");
            if (state == FBSessionStateOpen) {
                 [self requestUserInfo];
             }
         }];
//    }
}

- (void)requestUserInfo
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"basic_info", @"public_profile"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            
            if ([result isKindOfClass:[NSDictionary class]]) {
                self.userID = [result objectForKey:@"id"];
                self.nameLabel.text = [result objectForKey:@"name"];
                self.idLabel.text = self.userID;
                self.emailLabel.text = @"Fb Email...";
                self.type = @"facebook";
                [_indicatorView stopAnimating];
                [self enterPersonCenter];
            }
            else{
            }
        }
        else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
        }
    }];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        STRLOG(@"Error:%@",error);
    }else{
        if ([[GPPSignIn sharedInstance] authentication]) {
            
            GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
            
            STRLOG(@"image:%@",person.image.url);
            STRLOG(@"familyName:%@",person.name.familyName);
            STRLOG(@"givenName:%@",person.name.givenName);
            STRLOG(@"identifier:%@",person.identifier);
            STRLOG(@"name:%@",person.displayName);
            STRLOG(@"userID:%@",[GPPSignIn sharedInstance].userID);
            STRLOG(@"userEmail:%@",[GPPSignIn sharedInstance].userEmail);
            self.emailLabel.text = [GPPSignIn sharedInstance].userEmail;
            self.idLabel.text = [GPPSignIn sharedInstance].userID;
            self.nameLabel.text = person.displayName;
            
            self.type = @"google";
            self.userID = [GPPSignIn sharedInstance].userID;
            
            AccoutInfo *info = [[AccoutInfo alloc] init];
            info.userID = self.userID;
            info.userName = self.nameLabel.text;
            info.userEmail = self.emailLabel.text;
            
            if (self.userID.length != 0 ) {
                [self writeToGoogle:info];
                [self  enterPersonCenter];
            }else{
                STRLOG(@"id为空");
            }
        }else {
            STRLOG(@"认证失败");
        }
    }
}

- (void)setIndicatorView{
    
    STRLOG(@"indicatorView");
    [_indicatorView startAnimating];
    self.view.userInteractionEnabled = NO;
}

#pragma mark 更新与进入

- (void)enterPersonCenter{
    canEnter = YES;
    STRLOG(@"准备进入个人中心");
   
    if (self.tabBarController.selectedIndex == 2) {
        self.view.userInteractionEnabled = YES;
        [_indicatorView stopAnimating];
        STARKPersonalViewController *personal = [[STARKPersonalViewController alloc] initWithNibName:@"STARKPersonalViewController" bundle:nil];
        
        personal.type = self.type;
        personal.userID = self.userID;
        personal.name = self.nameLabel.text;
        personal.delegate = self;
        
        [self.navigationController presentViewController:personal animated:YES completion:^{
            
        }];
//        [self presentViewController:personal animated:YES completion:^{
//            
//        }];

    }else{
        STRLOG(@"index:%d",self.tabBarController.selectedIndex);
    }
}

#pragma mark 读写用户信息
//google用户信息写入本地
- (void)writeToGoogle:(AccoutInfo*)info{
  
    __block NSInteger flag = 0;
  
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
       NSArray *array = [[FMDBase shareDBManger] fetchAllUsers];
       for(AccoutInfo *accout in array){
           if ([info.userID isEqualToString:accout.userID]) {
               flag = 1;
               break;
           }else{
           
           }
       }
    if (flag == 0) {
            [[FMDBase shareDBManger] insertDataWithModel:info];
        }
   });
}
//facebook用户信息写入本地
- (void)writeToFacebook{
    
}

//删除google用户信息
- (void)removeGoogleInfo{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    STRLOG(@"removeGoogleInfo");
    [def removeObjectForKey:@"Google"];
    [def removeObjectForKey:@"GoogleID"];
    [def synchronize];
}

- (void)removeFacebookInfo{
    

}

//从本地读取用户信息
- (void)getUserInfo{
    
   STRLOG(@"getUserInfo");

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSArray *array = [[FMDBase shareDBManger] fetchAllUsers];
    
        for(AccoutInfo *info in array  ){
            NSLog(@"infoID:%@",info.userID);
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
     STRLOG(@"warning");
}

@end
