//
//  YBPhotoBrowserView.h
//  RACMVVMDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElPhotoBrowserView : UIView

@property (nonatomic, strong) UICollectionView *listCollectionView;

@property (nonatomic, strong) NSArray *originalUrls;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSArray *smallUrls;

- (void)show;

@end
