//
//  YBBrowser.m
//  RACMVVMDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import "YBBrowser.h"
#import "ElPhotoBrowserView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#define itemCount 3 //每行 3 张图片

@interface ElBrowserCollectionViewCell :UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ElBrowserCollectionViewCell

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.margin = 3;
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
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
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}



- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ElBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    }
    return _collectionView;
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ElBrowserCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.smallUrls[indexPath.item]]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.smallUrls.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ElPhotoBrowserView * photoView = [[ElPhotoBrowserView alloc]init];
    photoView.listCollectionView = self.collectionView;
    photoView.indexPath = indexPath;
    photoView.originalUrls = self.smallUrls.count == self.originalUrls.count ? self.originalUrls : self.smallUrls;
    photoView.smallUrls = self.smallUrls;
    [photoView show];
}



@end
