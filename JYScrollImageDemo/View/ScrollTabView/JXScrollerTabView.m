//
//  JXScrollerTabView.m
//  JYScrollTabViewDemo
//
//  Created by Dely on 16/3/2.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "JXScrollerTabView.h"

static CGFloat scrollBtnMargin = 20.f;//超过scroTabMinNum之间Btn间距
static CGFloat buttonFont = 15.0;//Button字体大小
static CGFloat lineHeight = 1.0;//下划线高度

@interface JXScrollerTabView()

@property (nonatomic, strong) UIButton *selectedButton;//选择的安钮
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation JXScrollerTabView

- (UIButton *)selectedButton{
    
    if (self.buttonArray.count > self.buttonIndex && self.buttonIndex >=0) {
        return self.buttonArray[self.buttonIndex];
    }
    return nil;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)buttonTitleArray{
    if (!_buttonTitleArray) {
        _buttonTitleArray = [NSMutableArray array];
    }
    return _buttonTitleArray;
}

- (NSMutableArray *)buttonWidthArray{
    if (!_buttonWidthArray) {
        _buttonWidthArray = [NSMutableArray array];
    }
    return _buttonWidthArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
        
    }
    return self;
}

- (void)initSelf{
    self.buttonNum = 0;
    self.buttonTotalWidth = 0.0;
    self.backgroundColor = [UIColor yellowColor];
    self.buttonIndex = 0;
    self.showsHorizontalScrollIndicator = NO;//边缘指示器隐藏
    self.showsVerticalScrollIndicator = NO;
    self.bounces = YES;//反弹效果
}

- (void)updateScrollerTabViewWithArray:(NSArray *)array{
    
    if (self.buttonWidthArray) {
        [self.buttonWidthArray removeAllObjects];
    }
    
    if (self.buttonTitleArray) {
        [self.buttonTitleArray removeAllObjects];
    }
    if (self.buttonArray) {
        [self.buttonArray removeAllObjects];
    }
    self.buttonTotalWidth = 0.0;
    self.buttonNum = array.count;
    [self.buttonTitleArray addObjectsFromArray:array];
    
    [self createButton];
}

- (void)createButton{
    
    //计算Button宽度
    for (NSInteger i = 0; i < self.buttonNum; i++) {
        NSString *string = [self.buttonTitleArray safeObjectAtIndex:i];
        CGSize size = [self sizeWithString:string font:[UIFont systemFontOfSize:buttonFont]];
        NSNumber *buttonWidth = [NSNumber numberWithFloat:size.width];
        [self.buttonWidthArray addObject:buttonWidth];
        
        self.buttonTotalWidth += size.width;
    }
    
    //Button间距 如果小于scroTabMinNum不用滑动
    CGFloat margin = 0;
    
    if ((self.buttonNum <= scroTabMinNum) && (self.buttonTotalWidth < CGRectGetWidth(self.frame))) {
        margin = (CGRectGetWidth(self.frame) - self.buttonTotalWidth)/(self.buttonNum*2);
    }else{
        margin = scrollBtnMargin;
    }
    
    float x = margin;
    
    for (NSInteger i = 0; i < self.buttonNum; i++) {

        NSString *title = [self.buttonTitleArray safeObjectAtIndex:i];
        CGFloat btnWidth = [[self.buttonWidthArray safeObjectAtIndex:i] floatValue];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:buttonFont];
        
        button.frame = CGRectMake(x, 0, btnWidth, CGRectGetHeight(self.frame) - lineHeight);
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self buttonStyleDidSelected:button];
            //下划线
            [self createLineWithFrame:button.frame];
        }else{
            [self buttonStyleWillSelected:button];
        }
        [self.buttonArray addObject:button];
        [self addSubview:button];
        
        //更新位置
        x += btnWidth+2*margin;
    }
    
    CGFloat length = 2*self.buttonNum*margin + self.buttonTotalWidth;
    self.contentSize = CGSizeMake(length, CGRectGetHeight(self.frame));
}

- (void)createLineWithFrame:(CGRect)frame{
    
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(self.frame)- lineHeight, CGRectGetWidth(frame), lineHeight)];
    self.lineLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.lineLabel];
}

// label的大小
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font {
    CGSize size;
    if (IOS7_OR_EARLIER) {
        size = [string sizeWithFont:font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame) - 20, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    } else {
        CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame))//限制最大的宽度和高度
                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                        attributes:@{NSFontAttributeName : font}//传人的字体字典
                                           context:nil];
        size = CGSizeMake(CGRectGetWidth(rect)+10.0, CGRectGetHeight(rect));
    }
    return size;
}

//外部选取更新
- (void)updateScroTabViewWithButtonIndex:(NSInteger)buttonIndex{
    self.buttonIndex = buttonIndex;
    [self setSelectedIndexAnimated:self.buttonIndex];
}

//buttonAction
- (void)buttonAction:(UIButton *)sender{
    
    if (sender.tag != self.buttonIndex) {
        self.buttonIndex = sender.tag;
        [self setSelectedIndexAnimated:self.buttonIndex];
        if (self.stDelegate && [self.stDelegate respondsToSelector:@selector(scrollerTabView:selectedButtonIndex:)]) {
            [self.stDelegate scrollerTabView:self selectedButtonIndex:self.buttonIndex];
        }
    }
}

- (void)setSelectedIndexAnimated:(NSInteger)buttonIndex{
    
    for (int i = 0; i < self.buttonNum; i++) {
        //改变Button
        UIButton *button = [self.buttonArray safeObjectAtIndex:i];
        if (i == buttonIndex) {
            [self buttonStyleDidSelected:button];
        }else{
            [self buttonStyleWillSelected:button];
        }
    }
    
    //动态更新位置
    CGRect  rect = [self  convertRect: CGRectMake(CGRectGetMinX(self.selectedButton.frame) - CGRectGetWidth(self.frame)/2.0 + 20, CGRectGetMinY(self.selectedButton.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.selectedButton.frame)) toView:self];
    
    [self scrollRectToVisible:rect  animated:YES];
    
}

//- (void)willMoveToSuperview:(UIView *)newSuperview{
//    CGRect tmpFrame = self.frame;
//    self.frame = CGRectMake(CGRectGetMinX(tmpFrame), CGRectGetMinY(tmpFrame), newSuperview.frame.size.width, CGRectGetHeight(tmpFrame));
//}


//Button选中样式
- (void)buttonStyleDidSelected:(UIButton *)sender{
    sender.backgroundColor = [UIColor orangeColor];
    //更新下划线
    [UIView animateWithDuration:0.3 animations:^{
        self.lineLabel.frame = CGRectMake(CGRectGetMinX(sender.frame), CGRectGetHeight(self.frame)- lineHeight, CGRectGetWidth(sender.frame), lineHeight);
    }];
}

//Button未选中样式
- (void)buttonStyleWillSelected:(UIButton *)sender{
    sender.backgroundColor = [UIColor purpleColor];
}

@end
