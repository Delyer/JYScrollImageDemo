//
//  JXPhoneExclusiveTableHeaderView.h
//  jiuxian
//
//  Created by 孙洋 on 16/3/8.
//  Copyright © 2016年 jiuxian.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXBannerView.h"
#import "JXPhoneExclusiveModel.h"
#import "JXPECommendView.h"

/**
 *  手机专享tableHeaderView(表头)上banner下今日推荐
 */
@interface JXPhoneExclusiveTableHeaderView : UIView<JXPECommendViewDelegate>

@property (strong, nonatomic) JXBannerView *bannerView;//轮播图
#warning 自定义今日推荐View

@property (strong, nonatomic) JXPECommendView *recommendView;//今日推荐
@property (strong, nonatomic) NSArray *bannerArr;//轮播图数组
@property (strong, nonatomic) NSArray *recommendArr;//今日推荐


/**
 *  刷新手机专享表头
 *
 *  @param bannerArr    轮播图数组
 *  @param recommendArr 今日推荐数组
 */
- (void)updateTableHeaderViewWithModel:(JXPhoneExclusiveModel *)model;

@end
