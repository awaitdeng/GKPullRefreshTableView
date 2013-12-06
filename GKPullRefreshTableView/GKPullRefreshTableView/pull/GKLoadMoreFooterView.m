//
//  FooterView.m
//  GuoKrJingXuan
//
//  Created by guokr on 13-1-31.
//  Copyright (c) 2013年 guokr. All rights reserved.
//

#import "GKLoadMoreFooterView.h"

@interface GKLoadMoreFooterView ()
{
    int offsetY;
    
    id _delegate;
}
@end

@implementation GKLoadMoreFooterView

@synthesize delegate = _delegate;

#define FONT [UIFont systemFontOfSize: 15.0]

@synthesize button = _button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setSubview];
    }
    return self;
}

- (void) setSubview
{
    self.backgroundColor = [UIColor lightGrayColor];//[CommonHelp colorWithHexString:@"#f6f6f6"];
    
    UIColor *color = [UIColor blackColor];//[CommonHelp colorWithHexString:@"#aeaeae"];
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [_button setTitle:@"下拉或点击加载更多" forState:UIControlStateNormal];
    [_button setTitleColor:color forState:UIControlStateNormal];
    [_button setTitle:@"下拉或点击加载更多" forState:UIControlStateHighlighted];
    [_button setTitleColor:color forState:UIControlStateHighlighted];
    [_button addTarget:self action:@selector(actionLoadMore:) forControlEvents:UIControlEventTouchUpInside];
    _button.titleLabel.font = FONT;
    [_button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self addSubview:_button];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = CGRectMake(100, 20, 20, 20);
    [self addSubview:_activityIndicator];
    
    _lLoading = [[UILabel alloc] initWithFrame:CGRectMake(140, 20, 100, 20)];
    _lLoading.text = @"正在载入……";
    _lLoading.backgroundColor = [UIColor clearColor];
    _lLoading.textColor = color;
    _lLoading.font = FONT;
    [self addSubview:_lLoading];
    
    _lStop = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    _lStop.text = @"没有更多了";
    _lStop.backgroundColor = [UIColor clearColor];
    _lStop.textAlignment = UITextAlignmentCenter;
    _lStop.textColor = color;
    _lStop.font = FONT;
    [self addSubview:_lStop];
    
    _button.hidden = NO;
    _lLoading.hidden = YES;
    _activityIndicator.hidden = YES;
    _lStop.hidden = YES;
}

- (void) beginLoadMore
{
    BOOL canload = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreFooterDataSourceCanLoad:)]) {
        canload = [_delegate loadMoreFooterDataSourceCanLoad:self];
        if (!canload) {
            return;
        }
    }
    
    BOOL loading = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreFooterDataSourceIsLoading:)]) {
        loading = [_delegate loadMoreFooterDataSourceIsLoading:self];
        if (loading) {
            return;
        }
    }
    
    if ([_delegate respondsToSelector:@selector(loadMoreFooterDidTriggerLoading:)]) {
        [_delegate loadMoreFooterDidTriggerLoading:self];
    }
    
    _button.hidden = YES;
    _lLoading.hidden = NO;
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    
    _lStop.hidden = YES;
}

- (void) resetLoadState
{
    BOOL canLoad = NO;
    if ([_delegate respondsToSelector:@selector(loadMoreFooterDataSourceCanLoad:)]) {
        canLoad = [_delegate loadMoreFooterDataSourceCanLoad:self];
    }
    
    if(canLoad){
        _lStop.hidden = YES;
        _button.hidden = NO;
        _lLoading.hidden = YES;
        _activityIndicator.hidden = YES;
        if([_activityIndicator isAnimating]) [_activityIndicator stopAnimating];
    }else{
        _lStop.hidden = NO;
        _button.hidden = YES;
        _lLoading.hidden = YES;
        _activityIndicator.hidden = YES;
        if([_activityIndicator isAnimating]) [_activityIndicator stopAnimating];
    }
}

//- (void)setNoMoreText:(NSString *)text{
//    _lStop.text = text;
//}

- (void)actionLoadMore:(UIButton *) button
{
    [self beginLoadMore];
}

#pragma mark -
#pragma mark ScrollView Methods
- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)loadMoreFooterScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"BeginDragging");
    offsetY = scrollView.contentOffset.y;
}

- (void)loadMoreFooterScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    /*判断依据
     1、向上拖动
     2、开始拖动时，已处于底部
     */
    if (offsetY < scrollView.contentOffset.y) {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - offsetY;
        if (scrollPosition<self.frame.size.height) {
            [self beginLoadMore];
        }
    }
}

- (void)loadMoreFooterScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [self resetLoadState];
}
@end
