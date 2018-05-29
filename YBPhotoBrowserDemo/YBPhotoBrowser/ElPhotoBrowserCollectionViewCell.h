//
//  YBPhotoBrowserCollectionViewCell.h
//  RACMVVMDemo
//
//  Created by 王迎博 on 2018/4/12.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ElPhotoBrowserCollectionViewCell;
@protocol ElPhotoBrowserCollectionViewCellDelegate <NSObject>

- (void)hiddenAction:(ElPhotoBrowserCollectionViewCell *)cell;

- (void)backgroundAlpha:(CGFloat)alpha;

@end

@interface ElPhotoBrowserCollectionViewCell : UICollectionViewCell

/** 第一次显示 需要动画效果 */
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) CGRect listCellF;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSString * smallURL;

@property (nonatomic, copy) NSString *picURL;

@property (nonatomic, weak) id<ElPhotoBrowserCollectionViewCellDelegate> delegate;

@end
