
#import <UIKit/UIKit.h>

typedef enum{
	GKPullRefreshPulling = 0,
	GKPullRefreshNormal,
	GKPullRefreshLoading,	
} GKPullRefreshState;

@protocol GKPullRefreshHeaderDelegate;

@interface GKPullRefreshHeaderView : UIView

@property(nonatomic,strong) id <GKPullRefreshHeaderDelegate> delegate;

- (void)refreshAutoWith:(UIScrollView *)scrollView;


- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

// delegate
@protocol GKPullRefreshHeaderDelegate
//
- (void)pullRefreshHeaderDidTriggerRefresh:(GKPullRefreshHeaderView *)view;

//  是否在刷新
- (BOOL)pullRefreshHeaderDataSourceIsLoading:(GKPullRefreshHeaderView *)view;

@optional
//  返回刷新日期
- (NSDate*)pullRefreshTableHeaderDataSourceLastUpdated:(GKPullRefreshHeaderView *)view;

@end
