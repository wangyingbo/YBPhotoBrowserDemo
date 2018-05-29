//
//  YBBrowser.m
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import "YBBrowser.h"
#import "YBPhotoBrowserView.h"
#import <UIImageView+WebCache.h>
#define itemCount 3 //每行 3 张图片

@interface YBBrowserCollectionViewCell :UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation YBBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imgView];
        self.imgView.frame = self.contentView.bounds;
    }
    return self;
}

- (UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

@end


@interface YBBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@end


@implementation YBBrowser


#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YBBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    }
    return _collectionView;
}

#pragma mark - overwrite
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.margin = 3;
        [self creatView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - private
- (void)creatView
{
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:self.collectionView];
    
}



- (void)setOriginalUrls:(NSArray *)originalUrls
{
    _originalUrls = originalUrls;
}

- (void)setSmallUrls:(NSArray *)smallUrls
{
    _smallUrls = smallUrls;
    [self.collectionView reloadData];
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    
    self.layout.minimumLineSpacing = _margin ;
    self.layout.minimumInteritemSpacing = _margin;
    
    CGFloat itemW = (width - ((itemCount - 1)* _margin) )/itemCount;
    self.layout.itemSize = CGSizeMake(itemW,itemW);

    NSInteger row = self.smallUrls.count? (self.smallUrls.count- 1) / 3 + 1 :0;
    CGFloat height = row * (itemW  + _margin) - (row ==0 ?0:_margin);
    
    
    CGRect collectionViewFrame = self.collectionView.frame;
    collectionViewFrame.size = CGSizeMake(width, height);
    self.collectionView.frame = collectionViewFrame;
}

/**
 获取listCell 在window中的对应位置
 
 @param cell cell
 @return 对应的frame
 */
- (CGRect)listCellFrame:(UICollectionViewCell *)cell
{
    CGRect cell_window_rect = [self.collectionView convertRect:cell.frame toView:self.window];
    return cell_window_rect;
}

#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YBBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.smallUrls[indexPath.item]]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.smallUrls.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    YBPhotoBrowserView * photoView = [[YBPhotoBrowserView alloc]init];
    photoView.listView = self.collectionView;
    photoView.indexPath = indexPath;
    //photoView.originRect = [self listCellFrame:cell];
    //photoView.selectIndex = indexPath.item;
    photoView.originalUrls = (self.smallUrls.count == self.originalUrls.count) ? self.originalUrls : self.smallUrls;
    photoView.smallUrls = self.smallUrls;
    [photoView show];
}



@end
