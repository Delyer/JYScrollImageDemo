//
//  JYScrollView.h
//  jiuxian
//
//  Created by Dely on 16/3/9.
//  Copyright © 2016年 jiuxian.com. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "iCarousel.h"
@class JYScrollView;

static CGFloat subViewWidthScale = 0.733; //290/375 屏幕宽度比，可修改

@protocol JYScrollViewDelegate <NSObject>

@required

//items数量
- (NSInteger)numberOfItemsInScrollView:(JYScrollView *)scrollView;

//items视图
- (UIView *)scrollView:(JYScrollView *)scrollView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;

//items长度
- (CGSize)subViewSizeInJYScrollView:(JYScrollView *)scrollView;

@optional
//点击代理
- (void)scrollView:(JYScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;


@end

@interface JYScrollView : UIView

@property (nonatomic, weak) id<JYScrollViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadData;

@end
