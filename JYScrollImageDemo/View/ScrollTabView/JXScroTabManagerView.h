//
//  JXScroTabManagerView.h
//  JYScrollTabViewDemo
//
//  Created by Dely on 16/3/2.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXScrollerTabView.h"
#import "JXScroTabMoreView.h"
@class JXScroTabManagerView;

static CGFloat moreButtonWidth = 50.0;//更多按钮宽度
static CGFloat moreViewAnimationDuration = 1.0;//视图偏移动画时间

@protocol JXScroTabManagerViewDelegate <NSObject>

@optional
//从侧滑选择一个按钮
- (void)scroTabManagerViewFromScrollView:(JXScroTabManagerView *)scrollerTabManagerView selectedButtonIndex:(NSInteger)buttonIndex;

//更多按钮点击
- (void)scroTabManagerView:(JXScroTabManagerView *)scrollerTabManagerView moreButtonClicked:(UIButton *)sender;


//是否需要自己创建添加MoreView
- (BOOL)scroTabManagerViewIsCustomMoreView;

//从更多视图选择一个按钮
- (void)scroTabManagerViewFromMoreView:(JXScroTabManagerView *)scrollerTabManagerView selectedButtonIndex:(NSInteger)buttonIndex;

//视图从那个位置开始偏移 （也就是初始化位置。如果不匹配可自己计算返回创建）
- (CGRect)startScrollFromFrameWithScroTabManagerView:(JXScroTabManagerView *)scrollerTabManagerView;
                              
//视图偏移到那个位置
- (CGRect)stopScrollToFrameWithScroTabManagerView:(JXScroTabManagerView *)scrollerTabManagerView;
                              
//除了更多视图偏移事件的自定义事件，比如tableView偏移
- (void)scroTabManagerViewScrollAction;

@end

@interface JXScroTabManagerView : UIView<JXScrollerTabViewDelegate,JXScroTabMoreViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttonTitleArray; //按钮标题
@property (nonatomic, assign) NSInteger buttonIndex;            //当前点击ButtonTag

@property (nonatomic, strong) JXScrollerTabView *tabView;   //滑动视图

@property (nonatomic, strong) UIButton *moreButton; //更多按钮
@property (nonatomic, assign) ButtonLayoutType buttonLayoutType;

@property (nonatomic, strong) id<JXScroTabManagerViewDelegate>delegate;

@property (nonatomic, strong) JXScroTabMoreView *moreView;

@property (nonatomic, assign) BOOL isCustomMoreView;//默认不需要自己来创建moreview

- (instancetype)initWithFrame:(CGRect)frame;

//更新视图
- (void)updateScroTabManagerViewWithArray:(NSArray *)array buttonLayoutType:(ButtonLayoutType)layoutType;

//外部选取更新
- (void)updateScroTabManagerViewWithButtonIndex:(NSInteger)buttonIndex;



@end
