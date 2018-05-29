//
//  YBPhotoBrowserView.m
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import "YBPhotoBrowserView.h"
#import "YBPhotoBrowserCollectionViewCell.h"

@interface YBPhotoBrowserView()<UICollectionViewDelegate,UICollectionViewDataSource,YBPhotoBrowserCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
@property (nonatomic, strong) UIPageControl *pageControl;


@end


@implementation YBPhotoBrowserView
{
    BOOL isFirstLoad;
}

#pragma mark - overwrite
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        isFirstLoad = YES;
        [self creatView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 90, [UIScreen mainScreen].bounds.size.width, 30);
    self.pageControl.center = CGPointMake(self.center.x, self.frame.size.height - 40);
    
    
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YBPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
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
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}

- (void)setOriginalUrls:(NSArray *)originalUrls
{
    _originalUrls = originalUrls;
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = originalUrls.count;
    self.pageControl.hidden = originalUrls.count <= 1 ? YES : NO;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * indexPath.item,0)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageControl.currentPage = indexPath.item;
    });
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * selectIndex,0)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageControl.currentPage = selectIndex;
    });
}


#pragma mark - private
- (void)creatView
{
    [self addSubview:self.collectionView];
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.backgroundColor = [UIColor blackColor];
    }];
    
    [self addSubview:self.pageControl];
}

/**
 隐藏

 @param cell 回到对应的cell
 */
- (void)hiddenAction:(YBPhotoBrowserCollectionViewCell *)cell
{
    for (int i = 0; i < self.originalUrls.count; i++)
    {
        UICollectionViewCell * listCell = [self.listView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
        if (i == indexPath.item) {
            [UIView animateWithDuration:0.4 animations:^{
                self.collectionView.backgroundColor = [UIColor clearColor];
                if (self.listView) {
                    cell.imageView.frame = [self listCellFrame:listCell];
                }else {
                    cell.imageView.frame = self.originRect;
                }
                
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
    CGRect cellRect = [self.listView convertRect:cell.frame toView:self.listView];
    CGRect cell_window_rect = [self.listView convertRect:cellRect toView:self.window];
    return cell_window_rect;
}

- (void)backgroundAlpha:(CGFloat)alpha
{
    self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    self.pageControl.alpha = alpha == 1 ?:0;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YBPhotoBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.isFirst = isFirstLoad;
    if (isFirstLoad) {
        isFirstLoad = NO;
    }
    if (self.listView) {
        cell.listCellF = [self listCellFrame:[self.listView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.indexPath.row inSection:self.indexPath.section]]];
    }else {
        cell.listCellF = self.originRect;
    }
    
    cell.smallURL = self.smallUrls[indexPath.item];
    cell.picURL = self.originalUrls[indexPath.item];
    cell.delegate = self;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.originalUrls.count;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = (int)scrollView.contentOffset.x / (int)[UIScreen mainScreen].bounds.size.width;
}


@end
