//
//  JXPECommendView.h
//  jiuxian
//
//  Created by Dely on 16/3/9.
//  Copyright © 2016年 Dely. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "iCarousel.h"
@class JXPECommendView;

static CGFloat widthScale = 0.733; //290/375

@protocol JXPECommendViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInJXPECommendView:(JXPECommendView *)peCommendView;

- (UIView *)peCommendView:(JXPECommendView *)peCommendView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;

- (CGSize)subViewSizeInJXPECommendView:(JXPECommendView *)peCommendView;

@optional
- (void)peCommendView:(JXPECommendView *)peCommendView didSelectItemAtIndex:(NSInteger)index;


@end

@interface JXPECommendView : UIView

@property (nonatomic, weak) id<JXPECommendViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadData;

@end
