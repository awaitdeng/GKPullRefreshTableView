

#import "GKPullRefreshHeaderView.h"


#define TEXT_COLOR	 [CommonHelp colorWithHexString:@"#949494"]//[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface GKPullRefreshHeaderView ()
{
	id _delegate;
	GKPullRefreshState _state;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
}

@end

@implementation GKPullRefreshHeaderView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor lightGrayColor];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = [UIColor blackColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = [UIColor blackColor];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
//		[label release];
        
//        [self addGuoKrImageWithFrame:frame];
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(90.0f, frame.size.height - 50.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
        
		[self setState:GKPullRefreshNormal];
    }
	
    return self;
}
//- (void) addGuoKrBgWithFrame:(CGRect) frame
//{
//    _guokrBg = (id)[UIImage imageNamed:@"下拉刷新-背景图.png"].CGImage;
//    
//    CALayer *bgLayer = [CALayer layer];
//    bgLayer.frame = CGRectMake(0.0f, frame.size.height - 234.0f, frame.size.width, 234.0f);
//    bgLayer.contentsGravity = kCAGravityResizeAspect;
//    
//    bgLayer.contents = _guokrBg;
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        bgLayer.contentsScale = [[UIScreen mainScreen] scale];
//    }
//#endif
//    
//    [[self layer] addSublayer:bgLayer];
//}
//
//- (void) addGuoKrImageWithFrame:(CGRect) frame
//{
//    _guokrNormal = (id)[UIImage imageNamed:@"下拉刷新-松果图.png"].CGImage;
//    _guokrExplod = (id)[UIImage imageNamed:@"下拉刷新-释放-松果裂开.png"].CGImage;
//    
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(111.5f, frame.size.height - 200.0f, 97.0f, 133.0f);
//    layer.contentsGravity = kCAGravityResizeAspect;
//    
//    layer.contents = _guokrNormal;
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        layer.contentsScale = [[UIScreen mainScreen] scale];
//    }
//#endif
//    
//    [[self layer] addSublayer:layer];
//    _arrowImage=layer;
//}

#pragma mark -
- (void)refreshAutoWith:(UIScrollView *)scrollView;
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(pullRefreshHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate pullRefreshHeaderDataSourceIsLoading:self];
    }
    
    if (!_loading) {
        if ([_delegate respondsToSelector:@selector(pullRefreshHeaderDidTriggerRefresh:)]) {
            [_delegate pullRefreshHeaderDidTriggerRefresh:self];
        }
        
        [self setState:GKPullRefreshLoading];
        
        [UIView animateWithDuration:.2 animations:^(void){
//            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            //            scrollView.contentOffset = CGPointMake(0, 60);
            scrollView.contentOffset = CGPointMake(0, -60);

        } completion:^(BOOL finished){
            
        }];
    }
    
}

- (void)setState:(GKPullRefreshState)aState{
	
	switch (aState) {
		case GKPullRefreshPulling:
			_statusLabel.text = @"释放刷新";
            //			[CATransaction begin];
            //			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            //			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            //			[CATransaction commit];
			
			break;
		case GKPullRefreshNormal:
            //            _arrowImage.contents = _guokrNormal;
            
            //			if (_state == EGOOPullRefreshPulling) {
            //				[CATransaction begin];
            //				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            //				_arrowImage.transform = CATransform3DIdentity;
            //				[CATransaction commit];
            //			}
			
			_statusLabel.text = @"下拉刷新";//NSLocalizedString(@"Pull down to refresh...", @"下拉刷新");
			[_activityView stopAnimating];
            //			[CATransaction begin];
            //			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            //			_arrowImage.hidden = NO;
            //			_arrowImage.transform = CATransform3DIdentity;
            //			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			break;
		case GKPullRefreshLoading:
            //            _arrowImage.contents = _guokrExplod;
            
			_statusLabel.text = @"正在载入…";
			[_activityView startAnimating];
            //			[CATransaction begin];
            //			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
            //			_arrowImage.hidden = YES;
            //			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)refreshLastUpdatedDate {
	if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate pullRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setAMSymbol:@"AM"];
//		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"yyyy.MM.dd hh:mm"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else {
		_lastUpdatedLabel.text = nil;
	}
}

#pragma mark -
#pragma mark ScrollView Methods
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_state == GKPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
//        scrollView.contentOffset = CGPointMake(0, -offset);
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(pullRefreshHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate pullRefreshHeaderDataSourceIsLoading:self];
		}
        
//        NSLog(@"offsetY:%f", scrollView.contentOffset.y);
		
		if (_state == GKPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:GKPullRefreshNormal];
		} else if (_state == GKPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:GKPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(pullRefreshHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate pullRefreshHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= -65.0f && !_loading) {
		if ([_delegate respondsToSelector:@selector(pullRefreshHeaderDidTriggerRefresh:)]) {
			[_delegate pullRefreshHeaderDidTriggerRefresh:self];
		}
		
		[self setState:GKPullRefreshLoading];
        
        [UIView animateWithDuration:.2 animations:^(void){
            scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
//            scrollView.contentOffset = CGPointMake(0, 60);
        } completion:^(BOOL finished){
            
        }];
	}
}

//  完成刷新
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:.3 animations:^(void){
        // 好神奇！！！
//        NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
//        NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
        
    } completion:^(BOOL finished){
    	[self setState:GKPullRefreshNormal];
    }];
}

@end
