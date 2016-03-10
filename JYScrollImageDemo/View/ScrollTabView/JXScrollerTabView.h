//
//  JXScrollerTabView.h
//  JYScrollTabViewDemo
//
//  Created by Dely on 16/3/2.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXScrollerTabView;

static NSInteger scroTabMinNum = 3;    //最小几个不滑动

@protocol JXScrollerTabViewDelegate <NSObject>

- (void)scrollerTabView:(JXScrollerTabView *)scrollerTabView selectedButtonIndex:(NSInteger)buttonIndex;

@end


@interface JXScrollerTabView : UIScrollView

@property (nonatomic, strong) NSMutableArray *buttonArray;      //保存的按钮
@property (nonatomic, strong) NSMutableArray *buttonTitleArray; //按钮标题
@property (nonatomic, assign) NSInteger buttonIndex;            //当前点击ButtonTag
@property (nonatomic, assign) NSInteger buttonNum;              //按钮个数

@property (nonatomic, strong) NSMutableArray *buttonWidthArray; //按钮宽度数组
@property (nonatomic, assign) CGFloat buttonTotalWidth;         //按钮总长度

@property (nonatomic ,strong) id<JXScrollerTabViewDelegate>stDelegate;


- (instancetype)initWithFrame:(CGRect)frame;

//更新视图
- (void)updateScrollerTabViewWithArray:(NSArray *)array;

//选取动画
- (void)setSelectedIndexAnimated:(NSInteger)buttonIndex;

//外部选取更新
- (void)updateScroTabViewWithButtonIndex:(NSInteger)buttonIndex;

@end
