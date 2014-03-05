//
//  Purchase.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-2-8.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "Purchase.h"
#import "DBManger.h"
@implementation Purchase
static Purchase *purchase = nil;
@synthesize delegate = _delegate;

@synthesize validProduct = _validProduct;

+ (Purchase*)instanceOfPurchase{

    if (purchase == nil) {
        purchase = [[Purchase alloc] init];
    }
    return purchase;
    
}
- (id)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark  请求id
-(BOOL) requestProduct:(NSString*)productId
{
    if (productId != nil) {
        
        STRLOG(@"Purchase requestProduct: %@", productId);
        
        if ([SKPaymentQueue canMakePayments]) {
            // Yes, In-App Purchase is enabled on this device.
            // Proceed to fetch available In-App Purchase items.
            
            // Initiate a product request of the Product ID.
            SKProductsRequest *prodRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
            prodRequest.delegate = self;
            [prodRequest start];
            return YES;
            
        } else {
            // Notify user that In-App Purchase is Disabled.
            
            STRLOG(@"EBPurchase requestProduct: IAP Disabled");
            
            return NO;
        }
        
    } else {
        
        STRLOG(@"EBPurchase requestProduct: productId = NIL");
        
        return NO;
    }
    
    
}

- (BOOL)checkFromLocalInfo:(NSString*)productIdentifier{
    int flag  = 0;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *array = (NSArray*)[def stringArrayForKey:@"products"];
    for(int count = 0;count<array.count;count++){
        
        NSString *identifier = [array objectAtIndex:count];
        if ([identifier isEqualToString:productIdentifier]) {
            flag = 1;
            break;
        }
    }
    
    return flag;
}
#pragma mark 购买产品
-(BOOL) purchaseProduct:(SKProduct*)requestedProduct
{
    if (requestedProduct != nil) {
        
        STRLOG(@"EBPurchase purchaseProduct: %@", requestedProduct.productIdentifier);
        
        if ([SKPaymentQueue canMakePayments]) {
            // Yes, In-App Purchase is enabled on this device.
            // Proceed to purchase In-App Purchase item.
            
            // Assign a Product ID to a new payment request.
            BOOL flag = [self checkFromLocalInfo:requestedProduct.productIdentifier];
            
            if (flag == 0) {
                
                SKPayment *paymentRequest = [SKPayment paymentWithProduct:requestedProduct];
                
                // Assign an observer to monitor the transaction status.
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                
                // Request a purchase of the product.
                [[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
                 return YES;

            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已经买过了" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return  NO;
            }
            
           
            
        } else {
            // Notify user that In-App Purchase is Disabled.
            
            STRLOG(@"EBPurchase purchaseProduct: IAP Disabled");
            
            return NO;
        }
        
    }
    else {
        
        STRLOG(@"EBPurchase purchaseProduct: SKProduct = NIL");
        
        return NO;
    }
}

-(BOOL) restorePurchase
{
    STRLOG(@"EBPurchase restorePurchase");
    
    if ([SKPaymentQueue canMakePayments]) {
        // Yes, In-App Purchase is enabled on this device.
        // Proceed to restore purchases.
        
        // Assign an observer to monitor the transaction status.
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        // Request to restore previous purchases.
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        
        return YES;
        
    } else {
        // Notify user that In-App Purchase is Disabled.
        return NO;
    }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate Methods
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    STRLOG(@"Error:%@",error);
}
// Store Kit returns a response from an SKProductsRequest.
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
	// Parse the received product info.
	self.validProduct = nil;
	NSUInteger count = [response.products count];
    STRLOG(@"反馈数量 %lu",(unsigned long) count);
   
    if (count>0) {
        // Grab the first product in the array.
		self.validProduct = [response.products objectAtIndex:0];
	}else{
    
    }
    
	if (self.validProduct) {
        
        if ([_delegate respondsToSelector:@selector(successfulRequestProduct:)]) {
             [_delegate successfulRequestProduct:self.validProduct];
        }else{
            STRLOG(@"代理未被触发");
        }
	}
    else {
        if ([_delegate respondsToSelector:@selector(failRequestProduct:)]) {
            [_delegate failRequestProduct:self.validProduct];
        }else{
        
        }
    }
}
#pragma mark
#pragma mark 验证

#pragma mark -
#pragma mark SKPaymentTransactionObserver Methods

// The transaction status of the SKPaymentQueue is sent here.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for(SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
				
			case SKPaymentTransactionStatePurchasing:
				STRLOG(@"StatePurchasing");
				break;
			case SKPaymentTransactionStatePurchased:
			    [self completeTransaction:transaction];
                break;
			case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
			case SKPaymentTransactionStateFailed:
                [self failTransaction:transaction];
                break;
		}
	}
}

#pragma mark 根据购买状态触发的事件
- (void)completeTransaction:(SKPaymentTransaction*)transaction{
    STRLOG(@"购买完成");
    //验证
    
    [self validTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failTransaction:(SKPaymentTransaction*)transaction{
    
    STRLOG(@"购买失败");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        STRLOG(@"error:%@",transaction.error);
    }else{
        STRLOG(@"用户取消购买");
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction*)transaction{
 
    STRLOG(@"交易恢复处理");
}
- (void)validTransaction:(SKPaymentTransaction*)transaction{
    
    NSString* jsonReceipt = [self encode:(uint8_t *)transaction.transactionReceipt.bytes
                                  length:transaction.transactionReceipt.length];
   // STRLOG(@"jsonReceipt:%@",jsonReceipt);

    self.receive =[[NSString alloc] initWithFormat:@"%@",jsonReceipt ] ;
    
    if ([self.receive isEqualToString:jsonReceipt]) {
        STRLOG(@"euqal");
    }
    [self postToappStore:jsonReceipt stutus:21007];
    
    
}
- (void)postToappStore:(NSString*)ObjectString stutus:(int)status{
    
    _data = [[NSMutableData alloc] init];
    
    
    NSString* sendString = [[NSString alloc] initWithFormat:@"{\"receipt-data\":\"%@\"}",ObjectString ];
    
    NSURL *sandboxStoreURL = [[NSURL alloc] initWithString: @"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSURL *StoreURL = [[NSURL alloc] initWithString: @"https://buy.itunes.apple.com/verifyReceipt"];
	
    /*
        上线审核,也是用的这个地址sandboxStoreURL，
                
        StoreURL 返回的status 21007
     */
    
    NSData *postData = [NSData dataWithBytes:[sendString UTF8String] length:[sendString length]];
	
    STRLOG(@"status:%d",status);
    NSMutableURLRequest *connectionRequest = [[NSMutableURLRequest alloc] init];
    if (status == 0) {
        [connectionRequest setURL:StoreURL];
    }else if(status == 21007){
        [connectionRequest setURL:sandboxStoreURL];
    }
    
	[connectionRequest setHTTPMethod:@"POST"];
	[connectionRequest setTimeoutInterval:120.0];
	[connectionRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
	[connectionRequest setHTTPBody:postData];
    
	NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:connectionRequest delegate:self];
}
#pragma mark NSURLConnection Delegate


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //通过http协议，返回的响应其实是一个NSHTTPURLResponse的实例.NSURLResponse是所有响应的基类
    NSHTTPURLResponse *httpR = (NSHTTPURLResponse *)response;
    //从服务器收到的状态码,200 请求成功,可以进行数据的接收;404 请求资源没有找到; 400 客户端request语法错误;500 服务器错误
    NSInteger code =  [httpR statusCode];
    STRLOG(@"code:%ld",(long)code);
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    STRLOG(@"connection error:%@",error);
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
   // NSString *receive = [[NSString alloc ] initWithData:_data encoding:NSUTF8StringEncoding];
   // STRLOG(@"Apple 认证结果 :%@",receive);
    
    id result = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)result;
        NSString *status = [dic objectForKey:@"status"];
        STRLOG(@"status:%@",status);
        if ([status intValue] == 0) {
            //记录
           [self recordLocalInfo:self.validProduct];
            
            if ([_delegate respondsToSelector:@selector(provideProduct:)]) {
                [_delegate provideProduct:self.validProduct];
            }
            
            
        }else if([status intValue] == 21007){
           
            [self postToappStore:self.receive stutus:21007];
            STRLOG(@"..认证失败");
        }
    }

    
}
//
- (void)recordLocalInfo:(SKProduct*)product{

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    STRLOG(@"记录");
    if ([product.productIdentifier isEqualToString:@"com.stark.test5"]) {
        NSMutableArray *array = (NSMutableArray*)[def stringArrayForKey:@"products"];
        if (array==nil) {
            array = [[NSMutableArray alloc] init];
        }
        NSString *identifier = [NSString stringWithFormat:@"%@",product.productIdentifier];
        [array addObject:identifier];
        [def setObject:array forKey:@"products"];
        [def synchronize];
    }else{
        STRLOG(@"Non-consumable");
    }
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length
{
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

// Called when one or more transactions have been removed from the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    STRLOG(@"EBPurchase removedTransactions");
    
    // Release the transaction observer since transaction is finished/removed.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// Called when SKPaymentQueue has finished sending restored transactions.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    
    STRLOG(@"EBPurchase paymentQueueRestoreCompletedTransactionsFinished");
    
    if ([queue.transactions count] == 0) {
        // Queue does not include any transactions, so either user has not yet made a purchase
        // or the user's prior purchase is unavailable, so notify app (and user) accordingly.
        
        STRLOG(@"EBPurchase restore queue.transactions count == 0");
        
        // Release the transaction observer since no prior transactions were found.
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        if ([_delegate respondsToSelector:@selector(incompleteRestore:)]) {
            [_delegate incompleteRestore:self];
        }else{
        
        }
        
    }
    else {
        // Queue does contain one or more transactions, so return transaction data.
        // App should provide user with purchased product.
        
        STRLOG(@"EBPurchase restore queue.transactions available");
        
        for(SKPaymentTransaction *transaction in queue.transactions) {
            
            STRLOG(@"Identifier:%@",transaction.payment.productIdentifier);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}
// Called if an error occurred while restoring transactions.

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // Restore was cancelled or an error occurred, so notify user.
    
    STRLOG(@"EBPurchase restoreCompletedTransactionsFailedWithError");
    if ([_delegate respondsToSelector:@selector(failedRestore:error:message:)]) {
        
        [_delegate failedRestore:self error:error.code message:error.localizedDescription];
    }
    

}



@end
