//
//  GKHomeController.m
//  GKPullRefreshTableView
//
//  Created by hour on 13-12-5.
//  Copyright (c) 2013年 hour. All rights reserved.
//

#import "GKHomeController.h"


@interface GKHomeController ()
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_dataForTable;
    
    GKPullRefreshHeaderView *_headerView;
    BOOL _refreshing;
    GKLoadMoreFooterView *_footerView;
    BOOL _loading;
    BOOL _canLoad;
    
    
    NSArray *_array;
}

@end

@implementation GKHomeController

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
    // Do any additional setup after loading the view from its nib.
    
    if ([UIDevice version] > 7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _array = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    _dataForTable = [NSMutableArray arrayWithArray:_array];
    
    _refreshing = NO;
    _loading = NO;
    _canLoad = YES;
    [self addHeaderView];
    [self addFooterView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
////    _tableView.contentMode
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    
//    NSLog(@"%@", NSStringFromCGSize(_tableView.contentSize));
//    NSLog(@"%@", NSStringFromUIEdgeInsets(_tableView.contentInset));
    
    //  自动下拉刷新
    [_headerView refreshAutoWith:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - self methods
- (void)addHeaderView
{
	if (_headerView == nil) {
        GKPullRefreshHeaderView *view = [[GKPullRefreshHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
//        NSLog(@"%@", NSStringFromCGRect(view.frame));
        
		view.delegate = self;
		[_tableView addSubview:view];
		_headerView = view;
	}
    
    //  update the last update date
	[_headerView refreshLastUpdatedDate];
}

- (void)addFooterView
{
    _footerView  = [[GKLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    _footerView.delegate = self;
    _tableView.tableFooterView = _footerView;
}

#pragma mark -
#pragma mark refresh header
#pragma mark refresh完成后调用
- (void)doneRefreshingTableViewData
{
    if(_refreshing){
        _refreshing = NO;
        [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    }
}

#pragma mark Header Delegate 系统调用
- (void)pullRefreshHeaderDidTriggerRefresh:(GKPullRefreshHeaderView*)view
{
	_refreshing = YES;
    
    dispatch_queue_t serverDelaySimulationThread = dispatch_queue_create("com.xxx.serverDelay", nil);
    dispatch_async(serverDelaySimulationThread, ^{
        [NSThread sleepForTimeInterval:5.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Your server communication code here
            [self doneRefreshingTableViewData];
        });
    });
}
- (BOOL)pullRefreshHeaderDataSourceIsLoading:(GKPullRefreshHeaderView*)view{
	return _refreshing; // should return if data source model is reloading
}
- (NSDate*)pullRefreshTableHeaderDataSourceLastUpdated:(GKPullRefreshHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed 返回刷新时间
}

#pragma mark - 
#pragma mark load more完成后调用
- (void)doneLoadingingTableViewData
{
    _canLoad = NO;
    
    if(_loading){
        _loading = NO;
        [_footerView loadMoreFooterScrollViewDataSourceDidFinishedLoading:_tableView];
    }
    
    [_dataForTable addObjectsFromArray:_array];
    [_tableView reloadData];
}
#pragma mark loadmore
- (void)loadMoreFooterDidTriggerLoading:(GKLoadMoreFooterView *)view
{
    _loading = YES;
//    if(_footerView) [_footerView beginLoadMore];
    // 这里添加用户操作
    // 网络请求
    
    dispatch_queue_t serverDelaySimulationThread = dispatch_queue_create("com.xxx.serverDelay", nil);
    dispatch_async(serverDelaySimulationThread, ^{
        [NSThread sleepForTimeInterval:5.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Your server communication code here
            [self doneLoadingingTableViewData];
        });
    });
}
- (BOOL)loadMoreFooterDataSourceIsLoading:(GKLoadMoreFooterView *)view
{
    return _loading;
}
- (BOOL)loadMoreFooterDataSourceCanLoad:(GKLoadMoreFooterView *)view
{
    return _canLoad;
}

#pragma mark ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_footerView loadMoreFooterScrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_headerView egoRefreshScrollViewDidScroll:scrollView];
    [_footerView loadMoreScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
    [_footerView loadMoreFooterScrollViewDidEndDragging:scrollView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataForTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row:%i, count:%@", indexPath.row, [_dataForTable objectAtIndex:indexPath.row]];
    
    return cell;
}


@end
