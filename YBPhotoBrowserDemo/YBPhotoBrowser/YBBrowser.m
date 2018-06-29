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

#pragma mark - --------- YBBrowserCollectionViewCell ---------
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


#pragma mark - --------- YBBrowser ---------
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
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        _collectionView.backgroundColor = [UIColor whiteColor];
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

- (void)setImages:(NSArray *)images {
    _images = images;
    [self.collectionView reloadData];
}

- (void)setOriginalUrls:(NSArray *)originalUrls
{
    _originalUrls = originalUrls;
}

- (void)setSmallUrls:(NSArray *)smallUrls
{
    _smallUrls = smallUrls;
}

- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
}

- (CGFloat)width {
    if (!_width) {
        _width = CGRectGetWidth(self.frame);
    }
    return _width;
}

- (BOOL)scrollEnabled {
    if (!_scrollEnabled) {
        _scrollEnabled = NO;
    }
    return _scrollEnabled;
}

- (void)setHeight:(CGFloat)height {
    _height = height;
}

- (CGFloat)perLineNum {
    if (!_perLineNum) {
        _perLineNum = itemCount;
    }
    return _perLineNum;
}

#pragma mark - private
- (void)creatView
{
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:self.collectionView];
}


- (void)configuration {
    self.collectionView.scrollEnabled = self.scrollEnabled;
    self.collectionView.alwaysBounceVertical = self.scrollEnabled;
    self.layout.minimumLineSpacing = _margin ;
    self.layout.minimumInteritemSpacing = _margin;
    
    CGFloat itemW = (self.width - ((itemCount - 1)* _margin) )/itemCount;
    self.layout.itemSize = CGSizeMake(itemW,itemW);
    
    NSInteger row;
    if (self.images) {
        row = self.images.count? (self.images.count- 1) / self.perLineNum + 1 :0;
    }else {
        row = self.smallUrls.count? (self.smallUrls.count- 1) / self.perLineNum + 1 :0;
    }
    
    CGFloat height = self.height?:row * (itemW  + _margin) - (row ==0 ?0:_margin);
    
    CGRect collectionViewFrame = self.collectionView.frame;
    collectionViewFrame.size = CGSizeMake(self.width, height);
    self.collectionView.frame = collectionViewFrame;
    self.collectionView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    
    [self.collectionView reloadData];
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
    if (self.images) {
        [cell.imgView setImage:[self.images objectAtIndex:indexPath.item]];
    }else {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.smallUrls[indexPath.item]]];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.images) {
        return self.images.count;
    }
    return self.smallUrls.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    YBPhotoBrowserView * photoView = [[YBPhotoBrowserView alloc]init];
    photoView.listView = collectionView;
    photoView.indexPath = indexPath;
    photoView.images = self.images;
    photoView.originalUrls = (self.smallUrls.count == self.originalUrls.count) ? self.originalUrls : self.smallUrls;
    photoView.smallUrls = self.smallUrls;
    
    // 添加自定义的view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 80)];
    customView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    photoView.customViewArray = @[customView];
    
    [photoView show];
}



@end
