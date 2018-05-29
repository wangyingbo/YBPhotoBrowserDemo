//
//  YBBrowser.h
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBBrowser : UIView

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
 控件宽度
 */
@property (nonatomic, assign) CGFloat width;

@end
