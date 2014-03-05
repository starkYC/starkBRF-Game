//
//  Purchase.h
//  StarkBRGame
//
//  Created by gaoyangchun on 14-2-8.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol PurchaseDelegate;

@interface Purchase : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver,NSURLConnectionDelegate>

@property(nonatomic,weak) id<PurchaseDelegate> delegate;

@property (nonatomic, strong) SKProduct *validProduct;
@property (nonatomic,copy) NSString *receive;

@property (nonatomic,copy) NSMutableData *data;
- (BOOL) requestProduct:(NSString*)productId;
- (BOOL) purchaseProduct:(SKProduct*)requestedProduct;
- (BOOL) restorePurchase;

+ (Purchase*)instanceOfPurchase;
@end



@protocol PurchaseDelegate<NSObject>

@optional

- (void)successfulRequestProduct:(SKProduct*)requestedProduct;

- (void)failRequestProduct:(SKProduct*)requestedProduct;

- (void)provideProduct:(SKProduct*)product;

-(void) incompleteRestore:(Purchase*)ebp;

-(void) failedRestore:(Purchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage;



@end

