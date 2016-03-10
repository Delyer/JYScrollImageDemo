//
//  JXScroTabMoreView.h
//  JYScrollTabViewDemo
//
//  Created by Dely on 16/3/3.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXScrollerTabView.h"
@class JXScroTabMoreView;



typedef NS_ENUM(NSInteger,ButtonLayoutType) {
    Adaptation,     //自适应
    Changeless      //固定不变的
};


@protocol JXScroTabMoreViewDelegate <NSObject>

- (void)scroTabMoreView:(JXScroTabMoreView *)scroTabMoreView selectedButtonIndex:(NSInteger)buttonIndex;

- (void)removeFromSuperView:(JXScroTabMoreView *)scroTabMoreView;

@end

@interface JXScroTabMoreView : UIView

@property (nonatomic, strong) NSMutableArray *buttonArray;      //保存的按钮
@property (nonatomic, strong) NSMutableArray *buttonTitleArray; //按钮标题
@property (nonatomic, assign) NSInteger buttonIndex;            //当前点击ButtonTag
@property (nonatomic, assign) NSInteger buttonNum;              //按钮个数

@property (nonatomic, strong) NSMutableArray *buttonWidthArray; //按钮宽度数组
@property (nonatomic, strong) UIView *titileView;
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIButton *delButton;//删除按钮

@property (nonatomic, assign) CGRect lastRect;//保存最后一个词frame

@property (nonatomic, strong) id<JXScroTabMoreViewDelegate>delegate;


- (instancetype)initWithFrame:(CGRect)frame;


//更新视图
- (void)updateScroTabMoreViewWithArray:(NSArray *)array buttonLayoutType:(ButtonLayoutType)layoutType;


@end
