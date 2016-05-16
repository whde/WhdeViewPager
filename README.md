# WhdeViewPager
类似安卓的 <code>ViewPager</code> <code>(Android ViewPager)</code>，效果如下
<p align="center">
<image src="https://raw.githubusercontent.com/whde/WhdeViewPager/master/Screen.gif" width=200 heght=100%/>
</p>
# 使用
```objective-c
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

```
