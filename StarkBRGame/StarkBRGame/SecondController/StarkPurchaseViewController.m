//
//  StarkPurchaseViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-2-17.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "StarkPurchaseViewController.h"
#import "Purchase.h"


@interface StarkPurchaseViewController ()<PurchaseDelegate>
{
   
    UILabel *proIDLabel;
    UILabel *transLabel;
    UIButton *buyButton;
    
}
@end

@implementation StarkPurchaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
   
    [self uiInit];
  
   
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successfulRequestProduct:) name:@"successRequest" object:nil];
}

- (void)uiInit{
    
    UILabel *labelID  = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 30)];
    labelID.text = @"产品ID:";
    [self.view addSubview:labelID];
    
    UILabel *trans = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 50, 30)];
    trans.text  = @"状态:";
    [self.view addSubview:trans];
    
    buyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [buyButton setFrame:CGRectMake(50, 200, 220 , 30)];
    buyButton.enabled = NO;
    [buyButton setTitle:[NSString stringWithFormat:@"购买此产品 :%@",self.productID] forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
    proIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 200, 30)];
    proIDLabel.text = @"";
    [self.view addSubview:proIDLabel];
    
    transLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 300, 200, 30)];
    transLabel.text = @"尚未交易";
    [self.view addSubview:transLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(50, 250, 220, 30)];
    [btn setTitle:@"restore" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(restore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [Purchase instanceOfPurchase].delegate = self;
    //请求产品
    [ [Purchase instanceOfPurchase] requestProduct:self.productID];
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [Purchase instanceOfPurchase].delegate = nil;
    [super viewWillDisappear:YES];
}

- (void)restore{
    
    if ([[Purchase instanceOfPurchase] restorePurchase]) {
        
    }
}

- (void)buyProduct:(UIButton*)btn{
   
      
    if ( [[Purchase instanceOfPurchase] purchaseProduct:[Purchase instanceOfPurchase].validProduct]) {
        transLabel.text = @"现在开始购买";
    }else{
        transLabel.text = @"产品信息错误";
    }
    
}
- (NSString*)localPrice:(SKProduct*)product{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:product.price];
    return formattedString;
}
#pragma mark 
#pragma mark  请求产品的回调

- (void)successfulRequestProduct:(SKProduct *)requestedProduct{
    
    STRLOG(@"success product info");
    STRLOG(@"SKProduct 描述信息%@", [requestedProduct description]);
    STRLOG(@"产品标题 %@" , requestedProduct.localizedTitle);
    STRLOG(@"产品描述信息: %@" , requestedProduct.localizedDescription);
    STRLOG(@"价格: %@" , requestedProduct.price);
    STRLOG(@"Product id: %@" , requestedProduct.productIdentifier);
    NSString *localPrice =   [self localPrice:requestedProduct];
    STRLOG(@"本地价格:%@",localPrice);
    if (requestedProduct.price!=nil) {
        buyButton.enabled = YES;
        proIDLabel.text = requestedProduct.productIdentifier;
    }
}

- (void)failRequestProduct:(SKProduct *)requestedProduct{
 
    STRLOG(@"fail product info");
    STRLOG(@"SKProduct 描述信息%@", [requestedProduct description]);
    STRLOG(@"产品标题 %@" , requestedProduct.localizedTitle);
    STRLOG(@"产品描述信息: %@" , requestedProduct.localizedDescription);
    STRLOG(@"价格: %@" , requestedProduct.price);
    STRLOG(@"Product id: %@" , requestedProduct.productIdentifier);
    
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil message:@"产品信息错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)updateState{
    
    if (buyButton.enabled == YES) {
        transLabel.text = @"开始交易";
    }else{
        transLabel.text = @"尚未交易";
    }
}

#pragma mark 
#pragma mark  购买产品的回调


-(void) incompleteRestore:(Purchase*)ebp{

}

-(void) failedRestore:(Purchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage{

}

- (void)provideProduct:(SKProduct *)product{
    
    //给用户提供产品
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"购买成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];

    transLabel.text = @"Success...";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
