//
//  YBPhotoBrowserView.m
//  RACMVVMDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import "ElPhotoBrowserView.h"
#import "ElPhotoBrowserCollectionViewCell.h"
#import <Masonry.h>

@interface ElPhotoBrowserView()<UICollectionViewDelegate,UICollectionViewDataSource,ElPhotoBrowserCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UIPageControl *pageControl;


@end


@implementation ElPhotoBrowserView
{
    BOOL isFirstLoad;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        isFirstLoad = YES;
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.backgroundColor = [UIColor blackColor];
    }];
    
    [self.collectionView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ElPhotoBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.isFirst = isFirstLoad;
    if (isFirstLoad) {
        isFirstLoad = NO;
    }
    cell.listCellF = [self listCellFrame:[self.listCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.indexPath.row inSection:self.indexPath.section]]];
    cell.smallURL = self.smallUrls[indexPath.item];
    cell.picURL = self.originalUrls[indexPath.item];
    cell.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.originalUrls.count;
}

- (void)setOriginalUrls:(NSArray *)originalUrls
{
    _originalUrls = originalUrls;
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = originalUrls.count;
    self.pageControl.hidden = originalUrls.count <= 1 ? YES : NO;
}

- (void)setListCollectionView:(UICollectionView *)listCollectionView
{
    _listCollectionView = listCollectionView;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * indexPath.item,0)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageControl.currentPage = indexPath.item;
    });
}


/**
 隐藏

 @param cell 回到对应的cell
 */
- (void)hiddenAction:(ElPhotoBrowserCollectionViewCell *)cell
{
    for (int i = 0; i < self.originalUrls.count; i++)
    {
        UICollectionViewCell * listCell = [self.listCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
        if (i == indexPath.item) {
            [UIView animateWithDuration:0.4 animations:^{
                self.collectionView.backgroundColor = [UIColor clearColor];
                cell.imageView.frame = [self listCellFrame:listCell];
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            return;
        }
        
    }
    
}


/**
 获取listCell 在window中的对应位置

 @param cell cell
 @return 对应的frame
 */
- (CGRect)listCellFrame:(UICollectionViewCell *)cell
{
    CGRect cellRect = [self.listCollectionView convertRect:cell.frame toView:self.listCollectionView];
    CGRect cell_window_rect = [self.listCollectionView convertRect:cellRect toView:self.window];
    return cell_window_rect;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)scrollView.contentOffset.x / (int)[UIScreen mainScreen].bounds.size.width;
}


- (void)backgroundAlpha:(CGFloat)alpha
{
    self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    self.pageControl.alpha = alpha == 1 ?:0;
}


- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ElPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        self.layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

@end
