//
//  WhdeViewPager.m
//  ViewPager
//
//  Created by whde on 16/5/10.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "WhdeViewPager.h"
#define TitleHeight         50
#define ButtonOffsetTag     1000
#define ViewOffsetTag       2000
@interface WhdePagerButton : UIButton
@property (nonatomic, strong) UIView *lineView;
@end
@interface WhdePagerScrollView : UIScrollView
@end

@interface WhdeViewPager () <UIScrollViewDelegate>{
    NSArray *views_;
    NSArray *titles_;
    WhdePagerScrollView *scrollview_;
    NSMutableArray *btnArray_;
}
@end

@implementation WhdeViewPager
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    scrollview_ = [[WhdePagerScrollView alloc] initWithFrame:CGRectMake(0, TitleHeight, CGRectGetWidth(frame), CGRectGetHeight(frame)-TitleHeight)];
    scrollview_.pagingEnabled = YES;
    scrollview_.contentInset = UIEdgeInsetsZero;
    scrollview_.bounces = NO;
    scrollview_.showsVerticalScrollIndicator = NO;
    scrollview_.showsHorizontalScrollIndicator = NO;
    scrollview_.delegate = self;
    btnArray_ = [NSMutableArray arrayWithCapacity:0];
    [self addSubview:scrollview_];
    return self;
}
- (void)setItemsView:(NSArray *)views withTitle:(NSArray *)titles {
    views_ = [views mutableCopy];
    titles_ = [titles mutableCopy];
    scrollview_.contentSize = CGSizeMake(CGRectGetWidth(scrollview_.bounds)*views_.count, CGRectGetHeight(scrollview_.bounds));
}
- (void)didMoveToSuperview {
    [self initSubViews];

    /*addSubViews*/
    for (UIView *view in scrollview_.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<views_.count; i++) {
        UIView *view = [views_ objectAtIndex:i];
        view.tag = ViewOffsetTag+i;
        view.frame = CGRectOffset(scrollview_.bounds, CGRectGetWidth(scrollview_.bounds)*i, 0);
        [scrollview_ addSubview:view];
        
        WhdePagerButton *btn = [WhdePagerButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.tag = ButtonOffsetTag+i;
        NSString *title = [titles_ objectAtIndex:i];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        CGRect rect = [title boundingRectWithSize:CGSizeMake(120, TitleHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        btn.frame = CGRectMake(CGRectGetWidth(self.bounds)/2*(i+2), TitleHeight-CGRectGetHeight(rect)-6, CGRectGetWidth(rect)+20, CGRectGetHeight(rect)+4);
        [btn setTitle:title forState:UIControlStateNormal];
        btn.backgroundColor = self.backgroundColor;
        [self addSubview:btn];
        if (i == 0) {
            btn.center = CGPointMake(CGRectGetWidth(self.bounds)/2, btn.center.y);
            btn.lineView.alpha = 1;
        } else if (i == 1) {
            btn.center = CGPointMake(CGRectGetWidth(self.bounds)-CGRectGetWidth(btn.frame)/2+10, btn.center.y);
        }
        [btnArray_ addObject:btn];
    }
}

- (void)initSubViews {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.strokeColor = [UIColor redColor].CGColor;
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, nil, 0, TitleHeight);
    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(self.bounds), TitleHeight);
    layer.path = pathRef;
    layer.lineWidth = 1.0;
    [self.layer addSublayer:layer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollview_.decelerating) {
        /*NSLog(@"decelerating");*/
        NSInteger page = (scrollview_.contentOffset.x+CGRectGetWidth(scrollview_.bounds)/2)/CGRectGetWidth(scrollview_.bounds);
        WhdePagerButton *lastBtn = [self viewWithTag:ButtonOffsetTag+page-1];
        WhdePagerButton *currentBtn = [self viewWithTag:ButtonOffsetTag+page];
        WhdePagerButton *nextBtn = [self viewWithTag:ButtonOffsetTag+page+1];
        for (WhdePagerButton *btn in btnArray_) {
            if (btn==lastBtn || btn==currentBtn || btn==nextBtn) {
                btn.alpha = 1;
            } else {
                btn.alpha = 0;
            }
        }
        if (currentBtn) {
            UIView *currentView = [self viewWithTag:ViewOffsetTag+page];
            CGPoint viewCenter = currentView.center;
            if (viewCenter.x-scrollview_.contentOffset.x>=CGRectGetWidth(currentBtn.titleLabel.bounds)/2 &&viewCenter.x-scrollview_.contentOffset.x<=CGRectGetWidth(scrollview_.bounds)-CGRectGetWidth(currentBtn.titleLabel.bounds)/2) {
                currentBtn.center = CGPointMake(viewCenter.x-scrollview_.contentOffset.x, currentBtn.center.y);
                currentBtn.lineView.alpha = 1-(fabs((currentBtn.center.x-CGRectGetWidth(scrollview_.bounds)/2))/(CGRectGetWidth(scrollview_.bounds)/2));
                if (lastBtn) {
                    if (CGRectGetMinX(currentBtn.frame)<=CGRectGetMaxX(lastBtn.frame)) {
                        lastBtn.center = CGPointMake(currentBtn.center.x-(CGRectGetWidth(currentBtn.frame)+CGRectGetWidth(lastBtn.frame))/2, lastBtn.center.y);
                    } else if (lastBtn.center.x<CGRectGetWidth(lastBtn.titleLabel.bounds)/2) {
                        lastBtn.center = CGPointMake(currentBtn.center.x-(CGRectGetWidth(currentBtn.frame)+CGRectGetWidth(lastBtn.frame))/2, lastBtn.center.y);
                    }
                }
                if (nextBtn) {
                    if (CGRectGetMaxX(currentBtn.frame)>=CGRectGetMinX(nextBtn.frame)) {
                        nextBtn.center = CGPointMake(currentBtn.center.x+(CGRectGetWidth(currentBtn.frame)+CGRectGetWidth(nextBtn.frame))/2, nextBtn.center.y);
                    } else if (nextBtn.center.x>CGRectGetWidth(scrollview_.frame)-CGRectGetWidth(nextBtn.titleLabel.bounds)/2) {
                        nextBtn.center = CGPointMake(currentBtn.center.x+(CGRectGetWidth(currentBtn.frame)+CGRectGetWidth(nextBtn.frame))/2, nextBtn.center.y);
                    }
                }
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    /*NSLog(@"------%f", targetContentOffset->x);*/
    NSInteger page = targetContentOffset->x/CGRectGetWidth(scrollview_.bounds);
    WhdePagerButton *lastBtn = [self viewWithTag:ButtonOffsetTag+page-1];
    WhdePagerButton *currentBtn = [self viewWithTag:ButtonOffsetTag+page];
    WhdePagerButton *nextBtn = [self viewWithTag:ButtonOffsetTag+page+1];
    for (WhdePagerButton *btn in btnArray_) {
        if (btn==lastBtn || btn==currentBtn || btn==nextBtn) {
            btn.alpha = 1;
        } else {
            btn.alpha = 0;
        }
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (lastBtn) {
            lastBtn.center = CGPointMake(CGRectGetWidth(lastBtn.titleLabel.bounds)/2, lastBtn.center.y);
            lastBtn.lineView.alpha = 0;
        }
        if (currentBtn) {
            currentBtn.center = CGPointMake(CGRectGetWidth(scrollview_.bounds)/2, currentBtn.center.y);
            currentBtn.lineView.alpha = 1;
        }
        if (nextBtn) {
            nextBtn.center = CGPointMake(CGRectGetWidth(scrollview_.bounds)-CGRectGetWidth(nextBtn.titleLabel.bounds)/2, nextBtn.center.y);
            nextBtn.lineView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end

@interface WhdePagerButton ()
@end
@implementation WhdePagerButton
- (UIView *)lineView {
    if (_lineView==NULL) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.titleLabel.frame), 2)];
        _lineView.backgroundColor = [UIColor redColor];
        _lineView.alpha = 0;
        _lineView.center = CGPointMake(self.titleLabel.center.x, _lineView.center.y);
        [self addSubview:_lineView];
        [self addObserver:self forKeyPath:@"titleLabel.frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _lineView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqual:@"titleLabel.frame"]) {
        _lineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.titleLabel.frame), 2);
        _lineView.center = CGPointMake(self.titleLabel.center.x, _lineView.center.y);
    }
}
@end


@interface WhdePagerScrollView ()
@end
@implementation WhdePagerScrollView
- (void)layoutSubviews {
    [super layoutSubviews];
}
@end



