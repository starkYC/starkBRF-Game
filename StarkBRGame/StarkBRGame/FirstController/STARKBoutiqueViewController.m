//
//  STARKBoutiqueViewController.m
//  StarkBRGame
//
//  Created by gaoyangchun on 14-1-15.
//  Copyright (c) 2014年 斯塔克互动科技有限公司. All rights reserved.
//

#import "STARKBoutiqueViewController.h"
#import "GDataXMLNode.h"
#import "DBManger.h"
#import "BoutiqueCell.h"
#import "BoutiqueModel.h"

#import "STARKAPPDetailViewController.h"
#import "ReachAble.h"
#import "MJRefresh.h"

@interface STARKBoutiqueViewController ()
{
    NSMutableArray *_dataArray;
    HttpRequest *request;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSInteger Flag;
}
@end

@implementation STARKBoutiqueViewController
@synthesize BoutiqueView = _BoutiqueView;

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

    _dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    // 1集成刷新控件
    // 1.1.下拉刷新
    [self addHeader];
    
    // 1.2.上拉加载更多
    [self addFooter];

}

#pragma mark

#pragma mark  下拉上拉刷新
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.BoutiqueView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        Flag = 1;
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
    footer.scrollView = self.BoutiqueView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        Flag = 0;
        NSString *strUrl = @"https://itunes.apple.com/br/rss/topfreeapplications/limit=10/genre=6014/xml";
        [self startRequest:strUrl];
      //  STRLOG(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.BoutiqueView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark

#pragma mark 网络请求和解析

- (void)startRequest:(NSString*)url{
    
    BOOL isConnect = [[ReachAble reachAble] isConnectionAvailable];
    if (isConnect == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您的网络异常，请检查后重新刷新" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert show];
        if (Flag == 1) {
            [self doneWithView:_header];
        }else{
            [self doneWithView:_footer];
        }
        return ;
    }
    STRLOG(@"数据请求");
    [[DBManger shareManger] addGetTask:url type:1 isASI:NO];
    [self addMessage:url method:@selector(updateData:)];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (NSString *)getValueWithElement:(GDataXMLElement *)element childName:(NSString *)name{
    
    NSArray *array = [element elementsForName:name];
    GDataXMLElement *child = (GDataXMLElement  *)[array objectAtIndex:0];
    return child.stringValue;
}

- (void)updateData:(NSNotification*)not{
    
    [self removeMessage:not.name];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSData *data = [[DBManger shareManger] objectForKey:not.name];
    if ([data isEqual:@"1"]) {
        
       UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"请求超时" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
          [self doneWithView:_header];
        return;
    }
    if (data) {
        STRLOG(@"data:%ld",(unsigned long)data.length);
        if (Flag == 1) {
              [_dataArray removeAllObjects];
        }
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        //拿到根元素(节点)
        GDataXMLElement *root = [doc rootElement];
        NSArray *entrys = [root elementsForName:@"entry"];
        NSMutableArray *array = [NSMutableArray array];
        for (GDataXMLElement *entry in entrys) {
            NSString *title = [self getValueWithElement:entry childName:@"title"];
            NSString *summary = [self getValueWithElement:entry childName:@"summary"];
            NSString *appID = [self getValueWithElement:entry childName:@"id"];
            NSString *imageAdr = [self getValueWithElement:entry childName:@"im:image"];
            NSString *price = [self getValueWithElement:entry childName:@"im:price"];
            BoutiqueModel *model = [[BoutiqueModel alloc] init];
            model.price = price;
            model.title = title;
            model.summary = summary;
            model.imageAdr = imageAdr;
            model.appID = appID;
            [array addObject:model];
            //  STRLOG(@"imageAdr:%@",imageAdr);
        }
        [_dataArray addObject:array];
        if (Flag == 1) {
             [self doneWithView:_header];
        }else{
             [self doneWithView:_footer];
        }
    }
}

#pragma mark tableView delegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    int count = (int)(section +1);
    NSString *title = [NSString stringWithFormat:@"第%d页",count];
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [_dataArray objectAtIndex:indexPath.section];
    BoutiqueModel *model = [array objectAtIndex:indexPath.row];
    STARKAPPDetailViewController *detail = [[STARKAPPDetailViewController alloc] initWithNibName:@"STARKAPPDetailViewController" bundle:nil];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES ];
    //设置为非选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
	
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [[_dataArray objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    BoutiqueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BoutiqueCell" owner:self options:0] lastObject];
    }
    NSArray *array  = [_dataArray objectAtIndex:indexPath.section];
    BoutiqueModel *model = [array objectAtIndex:indexPath.row];
    [cell fillData:model];
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
