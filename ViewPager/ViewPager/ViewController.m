//
//  ViewController.m
//  ViewPager
//
//  Created by whde on 16/5/10.
//  Copyright © 2016年 whde. All rights reserved.
//

#import "ViewController.h"
#import "WhdeViewPager.h"
@interface ViewController () {
    WhdeViewPager *viewPager_;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewPager_ = [[WhdeViewPager alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor lightGrayColor];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor whiteColor];
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor yellowColor];
    UIView *view4 = [[UIView alloc] init];
    view4.backgroundColor = [UIColor grayColor];
    UIView *view5 = [[UIView alloc] init];
    view5.backgroundColor = [UIColor magentaColor];

    [viewPager_ setItemsView:@[view1, view2, view3, view4, view5] withTitle:@[@"第一页面", @"第二页面", @"第三页面", @"第四页面", @"第五页面"]];
    [self.view addSubview:viewPager_];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
