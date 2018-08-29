//
//  YBPhotoBrowserView.h
//  YBPhotoBrowserDemo
//
//  Created by 王迎博 on 2018/5/29.
//  Copyright © 2018年 王迎博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBPhotoBrowserDelegate <NSObject>
@optional;
- (void)photoBrowserCurrentPage:(NSInteger)currentPage currentImage:(UIImage *)currentImage;
@end


@interface YBPhotoBrowserModel : NSObject
/**UIImage实例*/
@property (nonatomic, strong) UIImage *image;
/**大图url*/
@property (nonatomic, copy) NSString *originalUrl;
/**小图url*/
@property (nonatomic, copy) NSString *smallUrl;
@end


@interface YBPhotoBrowserView : UIView

/** listView为UICollectionView或者UITableView的实例，listView和indexPath是一组，需同时设置indexPath*/
@property (nonatomic, strong) id listView;
/** 设置初始选中的位置，需同时设置listView */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**若设置了上面的两个属性，就不必设置下面的两个属性*/
/** 原来的imageView相对于window的frame，需要和selectIndex同时设置 */
@property (nonatomic, assign) CGRect originRect;
/** 设置初始选中的位置，需同时设置originRect */
@property (nonatomic, assign) NSInteger selectIndex;

/**本地图片数组*/
@property (nonatomic, copy) NSArray *images;

/**大图url*/
@property (nonatomic, strong) NSArray *originalUrls;

/**小图url*/
@property (nonatomic, strong) NSArray *smallUrls;

/**模型数组*/
@property (nonatomic, copy) NSArray<YBPhotoBrowserModel *> *modelArray;

@property (nonatomic, weak) id<YBPhotoBrowserDelegate> delegate;

/**自定义的view*/
@property (nonatomic, copy) NSArray<__kindof UIView *> *customViewArray;

/**
 显示方法
 */
- (void)show;

@end


