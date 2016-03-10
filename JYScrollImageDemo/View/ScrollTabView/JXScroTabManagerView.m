//
//  JXScroTabManagerView.m
//  JYScrollTabViewDemo
//
//  Created by Dely on 16/3/2.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "JXScroTabManagerView.h"

@implementation JXScroTabManagerView

- (NSMutableArray *)buttonTitleArray{
    if (!_buttonTitleArray) {
        _buttonTitleArray = [NSMutableArray array];
    }
    return _buttonTitleArray;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
        
    }
    return self;
}

- (void)initSelf{
    self.backgroundColor = [UIColor blueColor];
    self.buttonIndex = 0;
    self.isCustomMoreView = NO;
}


- (void)updateScroTabManagerViewWithArray:(NSArray *)array buttonLayoutType:(ButtonLayoutType)layoutType{
    
    CGRect tmpFrame = self.frame;
    self.buttonLayoutType = layoutType;
    [self.buttonTitleArray addObjectsFromArray:array];
    
    if (array.count <= scroTabMinNum) {
        self.tabView = [[JXScrollerTabView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tmpFrame), CGRectGetHeight(tmpFrame))];
        self.tabView.stDelegate = self;
    }else{
        self.tabView = [[JXScrollerTabView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tmpFrame)- moreButtonWidth, CGRectGetHeight(tmpFrame))];
        self.tabView.stDelegate = self;
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.moreButton.frame = CGRectMake(CGRectGetMaxX(self.tabView.frame), 0, moreButtonWidth,  CGRectGetHeight(tmpFrame));
        [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [self.moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.moreButton];
    }
    [self.tabView updateScrollerTabViewWithArray:array];
    [self addSubview:self.tabView];
}

//外部选取更新
- (void)updateScroTabManagerViewWithButtonIndex:(NSInteger)buttonIndex{
    [self.tabView updateScroTabViewWithButtonIndex:buttonIndex];
}

//更多按钮点击
- (void)moreButtonClicked:(UIButton *)sender{
    
    //创建更多视图
    [self addScroMoreViewToSuperView];
    
    //用户自定义额外事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroTabManagerView:moreButtonClicked:)]) {
        [self.delegate scroTabManagerView:self moreButtonClicked:sender];
    }
}


//添加更多视图
- (void)addScroMoreViewToSuperView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroTabManagerViewIsCustomMoreView)]) {
        self.isCustomMoreView = [self.delegate scroTabManagerViewIsCustomMoreView];
    }
    
    if (!self.isCustomMoreView) {
        //默认不自定义创建
        NSLog(@"scrollerTabManagerView:%@",NSStringFromCGRect(self.frame));
        
        //默认开始位置,也就是创建位置
        CGRect fromFrame = self.frame;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(startScrollFromFrameWithScroTabManagerView:)]) {
            fromFrame = [self.delegate startScrollFromFrameWithScroTabManagerView:self];
        }
        
        
        if (!self.moreView && self.superview) {
            self.moreView = [[JXScroTabMoreView alloc] initWithFrame:CGRectMake(CGRectGetMinX(fromFrame), CGRectGetMaxY(fromFrame), CGRectGetWidth(fromFrame), SCREEN_HEIGHT-CGRectGetMaxY(fromFrame))];
            self.moreView.delegate = self;
            self.moreView.buttonIndex = self.buttonIndex;
            [self.moreView updateScroTabMoreViewWithArray:[self.buttonTitleArray copy] buttonLayoutType:self.buttonLayoutType];
            UIWindow *keywindow = [[[UIApplication sharedApplication] delegate] window];
            [keywindow addSubview:self.moreView];
        }
        
        //默认移动位置
        CGRect toFrame = CGRectMake(0, 0, CGRectGetWidth(fromFrame), CGRectGetHeight(fromFrame));
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(stopScrollToFrameWithScroTabManagerView:)]) {
            toFrame = [self.delegate stopScrollToFrameWithScroTabManagerView:self];
        }
        
        CGFloat time = moreViewAnimationDuration * fabs(CGRectGetMinY(fromFrame) - CGRectGetMinY(toFrame))/667;
        
        [UIView animateWithDuration:time animations:^{
            self.frame = toFrame;
            self.moreView.frame = CGRectMake(0, CGRectGetMinY(toFrame),  CGRectGetWidth(toFrame), SCREEN_HEIGHT);
        }];
    }
}


//删除更多视图
- (void)removeScroMoreViewFromSuperView{
    if (self.moreView) {
        [self.moreView removeFromSuperview];
        self.moreView = nil;
    }
}

#pragma mark - JXScroTabMoreViewDelegate
- (void)scroTabMoreView:(JXScroTabMoreView *)scroTabMoreView selectedButtonIndex:(NSInteger)buttonIndex{
    
    self.buttonIndex = buttonIndex;
    [self.tabView updateScroTabViewWithButtonIndex:buttonIndex];
    [self removeScroMoreViewFromSuperView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroTabManagerViewFromScrollView:selectedButtonIndex:)]) {
        [self.delegate scroTabManagerViewFromScrollView:self selectedButtonIndex:self.buttonIndex];
    }
}

- (void)removeFromSuperView:(JXScroTabMoreView *)scroTabMoreView{
    [self removeScroMoreViewFromSuperView];
}

#pragma mark - JXScrollerTabViewDelegate
- (void)scrollerTabView:(JXScrollerTabView *)scrollerTabView selectedButtonIndex:(NSInteger)buttonIndex{
    self.buttonIndex = buttonIndex;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroTabManagerViewFromScrollView:selectedButtonIndex:)]) {
        [self.delegate scroTabManagerViewFromScrollView:self selectedButtonIndex:self.buttonIndex];
    }
}

@end
