//
//  YBPhotoBrowserCollectionViewCell.m
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import "YBPhotoBrowserCollectionViewCell.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#define ImageW [UIScreen mainScreen].bounds.size.width - 10

@interface YBPhotoBrowserCollectionViewCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;
@property (nonatomic, strong) UITapGestureRecognizer *tapSingle;
@property (nonatomic, strong) MBProgressHUD *hud;

@end


@implementation YBPhotoBrowserCollectionViewCell
{
    CGRect  imgOriginF; //在中心时候的坐标
    CGPoint imgOriginCenter;
    CGPoint firstTouchPoint;//手指第一次按的位置 用来判断方向
    CGPoint moveImgFirstPoint; //记录移动图片 的第一次接触的位置
    NSTimer * _timer; //计时器 根据时长来判断是否删除图片
    CGFloat timeCount;
}

#pragma mark - lazy
- (MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        _hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.contentColor = [UIColor whiteColor];
        _hud.label.font = [UIFont systemFontOfSize:11];
    }
    return _hud;
}


- (UIImageView *)imageV
{
    if(!_imageV)
    {
        _imageV = [[UIImageView alloc] init];
        [self.scrollView addSubview:_imageV];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.clipsToBounds = YES;
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}


- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.maximumZoomScale = 2;
        _scrollView.minimumZoomScale = 1;
    }
    return _scrollView;
}

#pragma mark - overwrite && overide
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.scrollView];

        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewPressAction:)];
        panGes.delegate = self;
        [self.scrollView addGestureRecognizer:panGes];
        self.panGes = panGes;
        
        UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewSingleTapAction:)];
        tapSingle.delegate = self;
        tapSingle.numberOfTapsRequired = 1;
        [self.scrollView addGestureRecognizer:tapSingle];
        self.tapSingle = tapSingle;
        
        UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTapAction:)];
        tapDouble.numberOfTapsRequired = 2;
        [tapSingle requireGestureRecognizerToFail:tapDouble];
        [self.scrollView addGestureRecognizer:tapDouble];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.frame.size.height);
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - private

/**
 拖动手势
 
 @param ges ges description
 */
-(void)imageViewPressAction:(UIPanGestureRecognizer *)ges
{
    CGPoint movePoint = [ges locationInView:self.window];
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(redurecd) userInfo:nil repeats:YES];
            moveImgFirstPoint = [ges locationInView:self.window];
            break;
        case UIGestureRecognizerStateChanged:
        {
            //缩放比例(背景的渐变比例)
            CGFloat offset = fmin((1 - movePoint.y/([UIScreen mainScreen].bounds.size.height)) * 2, 1);
            //设置最小的缩放比例为0.5
            CGFloat offset_y = fmax(offset, 0.5);
            
            CGAffineTransform transform1 = CGAffineTransformMakeTranslation((movePoint.x - moveImgFirstPoint.x), (movePoint.y - moveImgFirstPoint.y));
            self.imageV.transform = CGAffineTransformScale(transform1, offset_y, offset_y);
            
            //设置alpha的值
            if (self.delegate && [self.delegate respondsToSelector:@selector(backgroundAlpha:)])
            {
                [self.delegate backgroundAlpha:offset_y];
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (timeCount > 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(0,0);
                    self.imageV.transform = CGAffineTransformScale(transform1, 1, 1);
                    [self.delegate backgroundAlpha:1];
                }];
            }else
            {
                [self hiddenAction];
            }
            timeCount = 0;
            [_timer invalidate];
            _timer = nil;
        }
            break;
            
        default:
            break;
    }
    
}

/**
 点击一次手势

 @param ges 手势
 */
- (void)imageViewSingleTapAction:(UITapGestureRecognizer *)ges
{
    [self.scrollView setZoomScale:1 animated:YES];
    [self.scrollView setContentOffset:CGPointZero];
    [self hiddenAction];
}

/**
 双击时的手势

 @param ges 手势
 */
- (void)imageViewDoubleTapAction:(UITapGestureRecognizer *)ges
{
    if (self.scrollView.zoomScale == 1) {
        [self.scrollView setZoomScale:2 animated:YES];
    }else {
        [self.scrollView setZoomScale:1 animated:YES];
    }
}

- (void)setSmallURL:(NSString *)smallURL
{
    _smallURL = smallURL;
}

- (void)setListCellF:(CGRect)listCellF
{
    _listCellF = listCellF;
}

- (void)setPicURL:(NSString *)picURL
{
    _picURL = picURL;
    //从缓存中读取图片
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:self.smallURL]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    if ([[cache imageFromDiskCacheForKey:key] isKindOfClass:[UIImage class]]) {
        [self updateImageViewWithImage:[cache imageFromDiskCacheForKey:key]];
    }
    
    //下载图片
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:picURL] placeholderImage:[cache imageFromDiskCacheForKey:key] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.label.text = [NSString stringWithFormat:@"%.f%%",(((float)receivedSize/(float)expectedSize) * 100.f) > 0 ?(float)receivedSize/(float)expectedSize * 100:0.f];
            self.hud.progress = (float)receivedSize/(float)expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.hud hideAnimated:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateImageViewWithImage:image];
        });
    }];
}

/**
 更新图片frame

 @param image image大小改变
 */
- (void)updateImageViewWithImage:(UIImage *)image
{
    self.imageV.image = image;
    CGFloat imageViewY = 0;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat fitWidth = ImageW;
    CGFloat fitHeight = fitWidth * imageHeight / imageWidth;
    
    if (fitHeight < [UIScreen mainScreen].bounds.size.height) {
        imageViewY = ([UIScreen mainScreen].bounds.size.height - fitHeight) * 0.5;
    }
    imgOriginF = CGRectMake(5, imageViewY, fitWidth, fitHeight);
    self.imageV.frame = self.listCellF;
    //如果是第一次加载需要动画
    if (self.isFirst) {
        self.isFirst = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.imageV.frame = self->imgOriginF;
            self->imgOriginCenter = self.imageV.center;
        }];
    }else
    {
        self.imageV.frame = imgOriginF;
        imgOriginCenter = self.imageV.center;
    }
    self.scrollView.contentSize = CGSizeMake(fitWidth, fitHeight);
}

/**
 隐藏
 */
- (void)hiddenAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenAction)]) {
        [self.delegate hiddenAction:self];
    }
    
}


/**
 缩放图片的时候将图片放在中间

 @param scrollView 背景scrollView
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageV.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    //返回需要缩放的view
    return self.imageV;
}

- (void)redurecd
{
    timeCount += 0.1;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.panGes) {
        //记录刚接触时的坐标
        firstTouchPoint = [touch locationInView:self.window];
    }
    return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //判断是否是左右滑动  滑动区间设置为+-10
    CGPoint touchPoint = [gestureRecognizer locationInView:self.window];
    CGFloat dirTop = firstTouchPoint.y - touchPoint.y;
    if (dirTop > -10 && dirTop < 10) {
        return NO;
    }
    //判断是否是上下滑动
    CGFloat dirLift = firstTouchPoint.x - touchPoint.x;
    if (dirLift > -10 && dirLift < 10 && self.imageV.frame.size.height > [UIScreen mainScreen].bounds.size.height) {
        return NO;
    }
    
    return YES;
}

@end
