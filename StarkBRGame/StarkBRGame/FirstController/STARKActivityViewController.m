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

@interface STARKActivityViewController ()
{
    NSMutableArray *_dataArray;
}

@end

@implementation STARKActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;

    _dataArray  = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", nil];
    
   
}

- (void)startRequest:(NSString*)url{
    
    [[DBManger shareManger] addGetTask:url type:1 isASI:NO];
    [self addMessage:url method:@selector(updateData:)];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)updateData:(NSNotification*)not{


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
