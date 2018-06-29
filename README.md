# YBPhotoBrowserDemo

> ***图片浏览器***

![预览图](https://raw.githubusercontent.com/wangyingbo/YBPhotoBrowserDemo/master/pregif.gif)

![预览图](https://raw.githubusercontent.com/wangyingbo/YBPhotoBrowserDemo/master/gif.gif)

### 自定义了一个图片浏览器，可以显示本地图片或者网络图片，支持单击消失，双击放大，下拉隐藏，双指放大等功能，支持自定义view配置UI。

可以用`YBBrowser`设置一个九宫格的缩略图显示：

	YBBrowser * browser = [[YBBrowser alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
    browser.center = self.view.center;
    browser.originalUrls = originArr;//大图
    browser.smallUrls = smallArr;//小图
    browser.width = 300; // 控件宽度
    [browser configuration];
    [self.view addSubview:browser];

也可以直接初始化一个图片浏览器：

	YBPhotoBrowserView * photoView = [[YBPhotoBrowserView alloc]init];
	photoView.listView = collectionView;
	photoView.indexPath = indexPath;
	photoView.originalUrls = (self.smallUrls.count == self.originalUrls.count) ? self.originalUrls : self.smallUrls;
	photoView.smallUrls = self.smallUrls;
    
    // 添加自定义的view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 80)];
    customView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    photoView.customViewArray = @[customView];
    
    [photoView show];
    
在浏览器里可以配置自定义的参数

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
	
	
	
	@property (nonatomic, strong) NSArray *originalUrls;
	
	@property (nonatomic, strong) NSArray *smallUrls;
	
	@property (nonatomic, weak) id<YBPhotoBrowserDelegate> delegate;
	
	@property (nonatomic, copy) NSArray<__kindof UIView *> *customViewArray;
	
	- (void)show;

可以实现代理方法，拿到当前显示的位置和图片

	@protocol YBPhotoBrowserDelegate <NSObject>
	@optional;
	- (void)photoBrowserCurrentPage:(NSInteger)currentPage currentImage:(UIImage *)currentImage;
	@end


最后，放上下载链接：[DEMO](https://github.com/wangyingbo/YBPhotoBrowserDemo)，欢迎star。