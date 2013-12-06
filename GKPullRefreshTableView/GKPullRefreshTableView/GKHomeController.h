//
//  GKHomeController.h
//  GKPullRefreshTableView
//
//  Created by hour on 13-12-5.
//  Copyright (c) 2013年 hour. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GKPullRefreshHeaderView.h"
#import "GKLoadMoreFooterView.h"

/*
 这个项目是为了实现一个好用的上拉、下拉
 
 */

@interface GKHomeController : UIViewController <UITableViewDataSource,UITableViewDelegate,GKPullRefreshHeaderDelegate,GKLoadMoreFooterDelegate>

@end
