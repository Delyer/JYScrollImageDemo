//
//  JXPhoneExclusiveTableHeaderView.m
//  jiuxian
//
//  Created by 孙洋 on 16/3/8.
//  Copyright © 2016年 jiuxian.com. All rights reserved.
//

#import "JXPhoneExclusiveTableHeaderView.h"
#import <Masonry.h>

@implementation JXPhoneExclusiveTableHeaderView

//- (instancetype)init {
//    if (self = [super init]) {
//        [self setup];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)updateTableHeaderViewWithModel:(JXPhoneExclusiveModel *)model {
    if (model.shufflingImgList > 0) {
        self.bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [self.bannerView setBannerViewData:model.shufflingImgList changeConstant:NO autoScrollTime:5.0];
    } else {
        self.bannerView = nil;
    }
    
    if (model.recommendImgList > 0) {
        [self recommendView];
    }
    
}

#pragma mark -- get

- (JXBannerView *)bannerView {
    if (!_bannerView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JXBannerView" owner:self options:nil];
        _bannerView = [nib safeObjectAtIndex:0];
        _bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    [self addSubview:_bannerView];
    }
    return _bannerView;
}

#warning 自定义今日推荐视图
- (JXPECommendView *)recommendView {
    if (!_recommendView) {
        _recommendView = [[JXPECommendView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_bannerView.frame), SCREEN_WIDTH, 200)];
        _recommendView.backgroundColor = [UIColor blueColor];
        _recommendView.delegate = self;
        [self addSubview:_recommendView];
        [_recommendView reloadData];
    }
    return _recommendView;
}


#pragma mark - JXPECommendViewDelegate

- (NSInteger)numberOfItemsInJXPECommendView:(JXPECommendView *)peCommendView{
    return 8;
}

- (UIView *)peCommendView:(JXPECommendView *)peCommendView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH *widthScale, 200)];
        view.backgroundColor = [UIColor yellowColor];
    }
    return view;
}

- (CGSize)subViewSizeInJXPECommendView:(JXPECommendView *)peCommendView{
    return CGSizeMake(SCREEN_WIDTH * widthScale, 200);
}


- (void)peCommendView:(JXPECommendView *)peCommendView didSelectItemAtIndex:(NSInteger)index{
    
}


- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
}

@end
