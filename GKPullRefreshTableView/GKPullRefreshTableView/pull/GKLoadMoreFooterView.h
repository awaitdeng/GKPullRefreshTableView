//
//  FooterView.h
//  GuoKrJingXuan
//
//  Created by guokr on 13-1-31.
//  Copyright (c) 2013年 guokr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GKLoadMoreFooterDelegate;

@interface GKLoadMoreFooterView : UIView{
    UIButton *_button;
    
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_lLoading,*_lStop;
}

@property (strong,nonatomic) UIButton *button;

@property(nonatomic,strong) id <GKLoadMoreFooterDelegate> delegate;

- (void)resetLoadState;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)loadMoreFooterScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)loadMoreFooterScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)loadMoreFooterScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol GKLoadMoreFooterDelegate
//
- (void)loadMoreFooterDidTriggerLoading:(GKLoadMoreFooterView *)view;
//  是否在刷新
- (BOOL)loadMoreFooterDataSourceIsLoading:(GKLoadMoreFooterView *)view;
//  返回刷新日期
- (BOOL)loadMoreFooterDataSourceCanLoad:(GKLoadMoreFooterView *)view;

@end
