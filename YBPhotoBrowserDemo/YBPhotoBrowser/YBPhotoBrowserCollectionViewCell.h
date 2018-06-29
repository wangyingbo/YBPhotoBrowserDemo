//
//  YBPhotoBrowserCollectionViewCell.h
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBPhotoBrowserCollectionViewCell;
@protocol YBPhotoBrowserCollectionViewCellDelegate <NSObject>

- (void)hiddenAction:(YBPhotoBrowserCollectionViewCell *)cell;

- (void)backgroundAlpha:(CGFloat)alpha;

@end

@interface YBPhotoBrowserCollectionViewCell : UICollectionViewCell

/** 第一次显示 需要动画效果 */
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) CGRect listCellF;

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) NSString * smallURL;

@property (nonatomic, copy) NSString *picURL;

@property (nonatomic, strong) UIImage *img;

@property (nonatomic, weak) id<YBPhotoBrowserCollectionViewCellDelegate> delegate;

@end
