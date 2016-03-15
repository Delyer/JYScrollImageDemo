//
//  ViewController.m
//  JYScrollImageDemo
//
//  Created by Dely on 16/3/7.
//  Copyright © 2016年 Dely. All rights reserved.
//

#import "ViewController.h"
#import "JYScrollView.h"


#import "iCarousel.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<JYScrollViewDelegate>

@property (strong, nonatomic) JYScrollView *scrollView;
@property (strong, nonatomic) NSArray *imageArray;
@property (assign, nonatomic) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"偏移轮播Demo";
    
    _imageArray = @[@"sakula.jpg",@"tenten.jpg",@"hinata.jpg",@"konan.jpg",@"sakula.jpg",@"tenten.jpg",@"hinata.jpg",@"konan.jpg"];
    self.scrollView = [[JYScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView reloadData];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 350,100, 30);
    [button setTitle:@"改变当前索引" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.index = 0;
}

- (void)buttonAction{
    self.index ++ ;
    self.index = self.index % _imageArray.count;
    [self.scrollView updateScrollViewWithItemIndex:self.index];
}

#pragma mark - JYScrollViewDelegate

- (NSInteger)numberOfItemsInScrollView:(JYScrollView *)scrollView{
    return _imageArray.count;
}

- (UIView *)scrollView:(JYScrollView *)scrollView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    //自己自定义UIView返回即可
    if (!view) {
        float a = arc4random()%255/255.0;
        float b = arc4random()%255/255.0;
        float c = arc4random()%255/255.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * subViewWidthScale, 200)];
        label.backgroundColor = [UIColor colorWithRed:a green:b blue:c alpha:1.0];
        label.text = [NSString stringWithFormat:@"%ld",index];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:100.0];
        view = label;
    }
    return view;
}

- (CGSize)subViewSizeInJYScrollView:(JYScrollView *)scrollView{
    
    return CGSizeMake(SCREEN_WIDTH * subViewWidthScale, 200);
}


- (void)scrollView:(JYScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"didSelectItemAtIndex = %ld",index);
}





@end
