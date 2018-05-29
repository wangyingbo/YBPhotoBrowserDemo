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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showPhotoBrowser];
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
       @"http://o6l9fpo42.bkt.clouddn.com/image/test6.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test7.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test8.jpg",
       @"http://o6l9fpo42.bkt.clouddn.com/image/test9.jpg"];
    
    NSArray * originArr = @[
        @"http://o6l9fpo42.bkt.clouddn.com/image/test1.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test2.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test3.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test4.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test5.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test6.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test7.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test8.jpg",
        @"http://o6l9fpo42.bkt.clouddn.com/image/test9.jpg"];
    
    YBBrowser * browser = [[YBBrowser alloc]init];
    browser.originalUrls = originArr;//大图
    browser.smallUrls = smallArr;//小图
    browser.width = 200; // 控件宽度
    [self.view addSubview:browser];
    
    browser.frame = CGRectMake(0, 0, 200, 200);
    browser.center = self.view.center;
}


@end
