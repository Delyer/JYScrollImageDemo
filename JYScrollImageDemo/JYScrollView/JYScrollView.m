//
//  JYScrollView.m
//  jiuxian
//
//  Created by Dely on 16/3/9.
//  Copyright © 2016年 jiuxian.com. All rights reserved.
//

#import "JYScrollView.h"

static CGFloat adSpace = 10.0;       //广告间距
static CGFloat heightSapce = 10.0;  //上下偏移

@interface JYScrollView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic, strong, nonnull) iCarousel *carousel;

@property (nonatomic, assign) CGSize subViewSize;//子视图大小

@end

@implementation JYScrollView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpWithFrame:frame];
    }
    return self;
}

- (void)setUpWithFrame:(CGRect)frame{
    
    
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _carousel.backgroundColor = [UIColor orangeColor];
        _carousel.pagingEnabled = YES;
        _carousel.bounces = YES;
        _carousel.scrollSpeed = 0.5;
        _carousel.type = iCarouselTypeRotaryCustom;
        _carousel.delegate = self;
        _carousel.dataSource = self;
//        _carousel.contentOffset = CGSizeMake(-20, 0);
        _carousel.viewpointOffset = CGSizeMake(0, 0);
        [self addSubview:_carousel];
    }
}

- (void)reloadData{
    _subViewSize = CGSizeZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(subViewSizeInJYScrollView:)]) {
        _subViewSize = [self.delegate subViewSizeInJYScrollView:self];
    }
    CGFloat padding = (CGRectGetWidth(self.frame) - _subViewSize.width - 2*adSpace)/2.0;
    _carousel.viewpointOffset = CGSizeMake(padding, 0);
    
    [_carousel reloadData];
}

#pragma mark -iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInScrollView:)]) {
        return [self.delegate numberOfItemsInScrollView:self];
    }
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{

    if (!view ){
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollView:viewForItemAtIndex:reusingView:)]) {
            return [self.delegate scrollView:self viewForItemAtIndex:index reusingView:view];
        }
        return nil;
    }
    return view;
}

#pragma mark -iCarouselDelegate
- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{

    static CGFloat max_sacle = 1.0f;
    CGFloat heightScale = 2*heightSapce/_subViewSize.height;
    CGFloat widthScale = heightScale*_subViewSize.height/_subViewSize.width + adSpace/_subViewSize.width;
    CGFloat min_scale = 1-heightScale;
    
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
        
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);

    }
    
    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * (1+widthScale), 0.0, 0.0);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollView:didSelectItemAtIndex:)]) {
        return [self.delegate scrollView:self didSelectItemAtIndex:index];
    }
}

@end
