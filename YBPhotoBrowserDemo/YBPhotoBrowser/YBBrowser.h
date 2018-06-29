//
//  YBBrowser.h
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBBrowser : UIView

/**本地图片数组，如果设置本地数组，则优先显示*/
@property (nonatomic, copy) NSArray *images;

/**
 大图图片数组
 */
@property (nonatomic, strong) NSArray *originalUrls;

/**
 小的图片数组
 */
@property (nonatomic, strong) NSArray *smallUrls;

/**
 图片间距
 */
@property (nonatomic, assign) CGFloat margin;

/**
 照片浏览器宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 照片浏览器高度，如果不设置则默认根据行数自动调整
 */
@property (nonatomic, assign) CGFloat height;

/**
 没行显示几个
 */
@property (nonatomic, assign) CGFloat perLineNum;

/**
 是否可滚动
 */
@property (nonatomic, assign) BOOL scrollEnabled;

/**
 最后一定要调用的方法
 */
- (void)configuration;

@end
