# JYScrollImageDemo

1.创建

    self.scrollView = [[JYScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    //刷新表
    [self.scrollView reloadData];
    
2.代理方法

  #pragma mark - JYScrollViewDelegate

//返回items数量

    \- (NSInteger)numberOfItemsInScrollView:(JYScrollView *)scrollView{
         return _imageArray.count;
    }

    \- (UIView *)scrollView:(JYScrollView *)scrollView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
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

//返回自定义UIView的size
    \- (CGSize)subViewSizeInJYScrollView:(JYScrollView *)scrollView{
    
         return CGSizeMake(SCREEN_WIDTH * subViewWidthScale, 200);
     }

//点击事件
    \- (void)scrollView:(JYScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index{
         NSLog(@"didSelectItemAtIndex = %ld",index);
    }
![](http://s3.sinaimg.cn/orignal/001StBb2gy700p4PMJ432&690)
