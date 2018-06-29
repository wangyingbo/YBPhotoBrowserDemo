//
//  ViewController.m
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "YBBrowser.h"
#import "YBPhotoBrowserView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showPhotoBrowser];
}

- (void)dealloc {
    NSLog(@"%@-被销毁了",[self class]);
}

/**
 测试图片浏览器
 */
- (void)showPhotoBrowser {
    
    NSArray * smallArr = @[
       @"http://o6l9fpo42.bkt.clouddn.com/image/test1.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test2.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test3.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test4.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test5.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test6.JPG",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test7.JPG",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test8.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test9.jpg"];
    
    YBBrowser * browser = [[YBBrowser alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 150, CGRectGetHeight(self.view.frame)/2 - 150, 300, 300)];
    browser.layer.borderColor = [UIColor lightGrayColor].CGColor;
    browser.layer.borderWidth = 0.75;
    browser.margin = 5;
    browser.width = 270;
    //url 图片
    browser.originalUrls = smallArr;//大图
    browser.smallUrls = smallArr;//小图
    [browser configuration];
    [self.view addSubview:browser];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];

    NSArray *images = @[[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"gao2"],[UIImage imageNamed:@"gao3"],[UIImage imageNamed:@"gao4"],[UIImage imageNamed:@"gao5"],[UIImage imageNamed:@"gao6"]];
    
    YBPhotoBrowserView * photoView = [[YBPhotoBrowserView alloc]init];
    CGRect originRect = CGRectMake(point.x - 25, point.y - 25, 50, 50);
    photoView.originRect = originRect;
    photoView.selectIndex = 0;
    //本地图片
    photoView.images = images;
    
    // 添加自定义的view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 80)];
    customView.backgroundColor = [UIColor colorWithWhite:.0 alpha:.5];
    photoView.customViewArray = @[customView];
    
    [photoView show];
}


@end
