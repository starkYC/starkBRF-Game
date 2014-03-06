//
//  STARKActivityViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKActivityViewController.h"
#import "ActivityCell.h"
#import "STARKActivityDetailViewController.h"

#import "MJRefresh.h"
#import "YCGameMgr.h"
#import "YCFileMgr.h"
#import "YCNotifyMsg.h"

@interface STARKActivityViewController ()
{
    NSMutableArray *_dataArray;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger Flag;
}

@end

@implementation STARKActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         Flag = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;

    _dataArray  = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    
    // 1集成刷新控件
    // 1.1.下拉刷新
    [self addHeader];    
    // 1.2.上拉加载更多
    [self addFooter];
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [[MJRefreshHeaderView alloc] init];
    header.scrollView = self.activityTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        Flag = 1;
        STRLOG(@"active");
        self.reqPage  = 190;
        NSString *str =@"https://itunes.apple.com/br/rss/topfreeapplications/limit=10/genre=6014/xml";
        [self startRequest:str];
        //  STRLOG(@"%@----开始进入刷新状态", refreshView.class);
    };
    [header beginRefreshing];
    _header = header;
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.activityTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSString *strUrl = @"https://itunes.apple.com/br/rss/topfreeapplications/limit=80/genre=6014/xml";
        Flag = 0;
        self.reqPage ++;
        [self startRequest:strUrl];
        //  STRLOG(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}
- (void)startRequest:(NSString *)url{
   
    [super startRequest:url];
    
    if ([self checkOutLocalData:self.reqPage]) {
        [self reloadData:self.gameData];
    }
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{  STRLOG(@"done");

  // [super doneWithView:refreshView];
    [refreshView endRefreshing];
    // 刷新表格
    [self.activityTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
}

- (void)GameDataReceicve:(NSNotification*)Notifi{
    
    [super GameDataReceicve:Notifi];
    if ( [YCNotifyMsg shareYCNotifyMsg].code == 0) {
        [self reloadData:self.gameData];
    }else{
        if (Flag == 1) {
            [self doneWithView:_header];
        }else{
            [self doneWithView:_footer];
        }
    }
    
}

- (void)reloadData:(NSData*)data{
    STRLOG(@"flag:%d",Flag);
    if (Flag == 1) {
        [self doneWithView:_header];
    }else{
        [self doneWithView:_footer];
    }

}


#pragma mark --tableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   STARKActivityDetailViewController *detail = [[STARKActivityDetailViewController alloc] initWithNibName:@"STARKActivityDetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark --tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    
    ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle ] loadNibNamed:@"ActivityCell" owner:self options:nil] lastObject];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
