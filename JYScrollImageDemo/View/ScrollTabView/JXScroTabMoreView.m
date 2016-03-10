//
//  JXScroTabMoreView.m
//  JYScrollTabViewDemo
//
//  Created by Dely on 16/3/3.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "JXScroTabMoreView.h"

static CGFloat moreViewButtonFont = 15.0;//moreViewButtonFont字体大小
static CGFloat moreViewBtnMargin = 20.f;//Btn间距
static CGFloat moreViewBtnLeftMargin = 20.0;//左右边距
static CGFloat moreViewBtnHeight = 45.0;//按钮高度
static CGFloat titleViewHeight = 42.0;//标题高度

static CGFloat separateLineSize = 1.f;//分割线宽高
static NSInteger paginalNum = 4;//每行button数


@implementation JXScroTabMoreView

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
    //titleView
    self.titileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), titleViewHeight)];
    self.titileView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.titileView];
    
    UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, titleViewHeight)];
    allLabel.text = @"全部分类";
    allLabel.font = [UIFont systemFontOfSize:14.0];
    allLabel.textColor = [UIColor redColor];
    [self.titileView addSubview:allLabel];
    
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delButton.frame = CGRectMake(CGRectGetWidth(self.titileView.frame)-50, 0, 50, titleViewHeight);
    [self.delButton setTitle:@"删除" forState:UIControlStateNormal];
    self.delButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.delButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.delButton addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titileView addSubview:self.delButton];
    
    //bodyView
    self.lastRect = CGRectMake(moreViewBtnLeftMargin, 0, 0, moreViewBtnHeight);
    self.buttonNum = 0;
    self.buttonIndex = 0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.bodyView = [[UIView alloc] init];
    self.bodyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bodyView];
}

- (void)updateScroTabMoreViewWithArray:(NSArray *)array buttonLayoutType:(ButtonLayoutType)layoutType{
    
    if (self.buttonWidthArray) {
        [self.buttonWidthArray removeAllObjects];
    }
    
    if (self.buttonTitleArray) {
        [self.buttonTitleArray removeAllObjects];
    }
    if (self.buttonArray) {
        [self.buttonArray removeAllObjects];
    }

    self.buttonNum = array.count;
    [self.buttonTitleArray addObjectsFromArray:array];
    
    [self createButtonView:layoutType];
}

- (void)createButtonView:(ButtonLayoutType)layoutType{
    
    if (layoutType == Adaptation) {
        
        //计算Button宽度
        for (NSInteger i = 0; i < self.buttonNum; i++) {
            NSString *string = [self.buttonTitleArray safeObjectAtIndex:i];
            CGSize size = [self sizeWithBtnString:string font:[UIFont systemFontOfSize:moreViewButtonFont]];
            NSNumber *buttonWidth = [NSNumber numberWithFloat:size.width];
            [self.buttonWidthArray addObject:buttonWidth];
        }
        
        //初始化视图
        for (int i = 0; i < self.buttonWidthArray.count; i++) {
            NSString *string = [self.buttonTitleArray safeObjectAtIndex:i];
            CGFloat width = [[self.buttonWidthArray safeObjectAtIndex:i] floatValue];
            
            CGFloat total = CGRectGetMaxX(self.lastRect) + width + moreViewBtnMargin;
            
            if (total >= (SCREEN_WIDTH - moreViewBtnLeftMargin)) {
                
                self.lastRect = CGRectMake(moreViewBtnLeftMargin, self.lastRect.origin.y + moreViewBtnHeight + 10, width, moreViewBtnHeight);
            }else {
                
                CGRect tmpRect = self.lastRect;
                if (i != 0) {
                    tmpRect.origin.x += self.lastRect.size.width + moreViewBtnMargin;
                }
                tmpRect.size.width = width;
                tmpRect.size.height = moreViewBtnHeight;
                
                self.lastRect = tmpRect;
                
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.tag = i;
            button.frame = self.lastRect;
            [button setTitle:string forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:moreViewButtonFont];
            if (i == self.buttonIndex) {
                [self buttonStyleDidSelected:button];
            }else{
                [self buttonStyleWillSelected:button];
            }
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.bodyView addSubview:button];
        }
        
        self.bodyView.frame = CGRectMake(0, titleViewHeight, CGRectGetWidth(self.frame), CGRectGetMaxY(self.lastRect));
        
    }else{
        
        CGFloat btnWidth = (CGRectGetWidth(self.frame) - 3*separateLineSize)/paginalNum;
        NSInteger rows = (NSInteger)ceilf(1.0*self.buttonNum/paginalNum);
        
        for (NSInteger i = 0; i < rows; i++) {
            for (NSInteger j = 0; j < paginalNum; j++) {
                
                NSInteger index = i*paginalNum + j;
                if (index > (self.buttonNum - 1)) {
                    break;
                }
                NSString *string = [self.buttonTitleArray safeObjectAtIndex:index];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.tag = index;
                button.frame = CGRectMake(j*(btnWidth + separateLineSize), i*(moreViewBtnHeight + separateLineSize), btnWidth, moreViewBtnHeight);
                button.titleLabel.font = [UIFont systemFontOfSize:moreViewButtonFont];
                [button setTitle:string forState:UIControlStateNormal];
                
                if (index == self.buttonIndex) {
                    [self buttonStyleDidSelected:button];
                }else{
                    [self buttonStyleWillSelected:button];
                }
        
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.bodyView addSubview:button];
                
                UILabel *lineLabel = [self createLine:CGRectMake(j*(btnWidth + separateLineSize)+btnWidth, i*(moreViewBtnHeight + separateLineSize), separateLineSize, moreViewBtnHeight)];
                [self.bodyView addSubview:lineLabel];
            }
            
            if (i != (rows - 1)) {
                UILabel *lineLabel = [self createLine:CGRectMake(0, (i+1)*(moreViewBtnHeight + separateLineSize)-separateLineSize, CGRectGetWidth(self.frame), separateLineSize)];
                [self.bodyView addSubview:lineLabel];
            }
        }
        
        self.bodyView.frame = CGRectMake(0, titleViewHeight, CGRectGetWidth(self.frame), rows*(moreViewBtnHeight+separateLineSize)-separateLineSize);
    }
    
    //创建一个点击手势
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame),CGRectGetMaxY(self.bodyView.frame), CGRectGetWidth(self.frame), SCREEN_HEIGHT-CGRectGetHeight(self.bodyView.frame)-CGRectGetHeight(self.titileView.frame))];
    tapView.backgroundColor = [UIColor clearColor];
    [self addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapView addGestureRecognizer:tap];
}

- (CGSize)sizeWithBtnString:(NSString *)string font:(UIFont *)font {
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

- (UILabel *)createLine:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor redColor];
    return label;
}

//buttonAction
- (void)buttonAction:(UIButton *)sender{
    
    self.buttonIndex = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scroTabMoreView:selectedButtonIndex:)]) {
        [self.delegate scroTabMoreView:self selectedButtonIndex:self.buttonIndex];
    }

}

//Button选中样式
- (void)buttonStyleDidSelected:(UIButton *)sender{
    sender.backgroundColor = [UIColor orangeColor];
}

//Button未选中样式
- (void)buttonStyleWillSelected:(UIButton *)sender{
    sender.backgroundColor = [UIColor purpleColor];
}

//tap手势
- (void)tapAction:(UITapGestureRecognizer *)sender{
    [self removeSelfFromSuperview];
}

//删除事件
- (void)delButtonClick:(UIButton *)sender{

    [self removeSelfFromSuperview];
}

- (void)removeSelfFromSuperview{
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeFromSuperView:)]) {
        [self.delegate removeFromSuperView:self];
    }
}

@end
