//
//  LBLaunchImageAdView.m
//  LBLaunchImageAd
//  技术交流群：534926022（免费） 511040024(0.8/人付费)
//  Created by gold on 16/6/8.
//  Copyright © 2016年 Bison. All rights reserved.
//  iOS开发学习app下载https://itunes.apple.com/cn/app/it-blog-for-ios-developers/id1067787090?mt=8

#import "LBLaunchImageAdView.h"

@interface LBLaunchImageAdView()
{
    NSTimer *countDownTimer;
}
@property (strong, nonatomic) NSString *isClick;
@property (assign, nonatomic) NSInteger secondsCountDown; //倒计时总时长
@property (readonly, nonatomic, copy) NSString *kAdsImageKey;

@end

@implementation LBLaunchImageAdView

- (instancetype)initWithWindow:(UIWindow *)window andType:(NSInteger)type andImgUrl:(NSString *)url
{
    self = [super init];
    if (self) {
      
      // 如果网络不好，或者没有请求到广告图，那么应该跳过广告图迅速进入应用，而非展示空的广告页面
      [[SDImageCache sharedImageCache] queryDiskCacheForKey:self.kAdsImageKey done:^(UIImage *image, SDImageCacheType cacheType) {
        // 如果拿到，创建UI
        if (image) {
          self.window = window;
          _secondsCountDown = 0;
          [window makeKeyAndVisible];
          [self setupAppearance:type];
          [self.aDImgView setImage:[self imageCompressForWidth:image targetWidth:mainWidth]];
        } else {
          
        }
        
      }];
      
      // 请求数据
      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      [manager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
      } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
//          [self.aDImgView setImage:[self imageCompressForWidth:image targetWidth:mainWidth]];
          [[SDImageCache sharedImageCache] storeImage:image forKey:self.kAdsImageKey];
        }
      }];
      
      
      
    }
    return self;
}

#pragma mark - UI

- (void)setupAppearance: (NSInteger)type {
  //获取启动图片
  CGSize viewSize = _window.bounds.size;
  //横屏请设置成 @"Landscape"
  NSString *viewOrientation = @"Portrait";
  
  NSString *launchImageName = nil;
  
  NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
  for (NSDictionary* dict in imagesDict)
    
  {
    CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
    if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
      
    {
      launchImageName = dict[@"UILaunchImageName"];
    }
    
  }
  UIImage * launchImage = [UIImage imageNamed:launchImageName];
  self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
  self.frame = CGRectMake(0, 0, mainWidth, mainHeight);
  if (type == FullScreenAdType) {
    self.aDImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
    
  }else{
    self.aDImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight - mainWidth/3)];
  }
  
  self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  self.skipBtn.frame = CGRectMake(mainWidth - 70, 20, 60, 30);
  self.skipBtn.backgroundColor = [UIColor brownColor];
  self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
  [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
  [self.aDImgView addSubview:self.skipBtn];
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = self.skipBtn.bounds;
  maskLayer.path = maskPath.CGPath;
  self.skipBtn.layer.mask = maskLayer;
//  SDWebImageManager *manager = [SDWebImageManager sharedManager];
//  [manager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    
//  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//    if (image) {
//      [self.aDImgView setImage:[self imageCompressForWidth:image targetWidth:mainWidth]];
//    }
//  }];
  self.aDImgView.tag = 1101;
  self.aDImgView.backgroundColor = [UIColor redColor];
  [self addSubview:self.aDImgView];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activiTap:)];
  // 允许用户交互
  self.aDImgView.userInteractionEnabled = YES;
  [self.aDImgView addGestureRecognizer:tap];
  
  CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  opacityAnimation.duration = 0.8;
  opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
  opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
  
  opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  
  [self.aDImgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
  countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
  [self.window addSubview:self];
}

#pragma mark - 点击广告
- (void)activiTap:(UITapGestureRecognizer*)recognizer{
    _isClick = @"1";
    [self startcloseAnimation];
}

#pragma mark - 开启关闭动画
- (void)startcloseAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.3];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [self.aDImgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:opacityAnimation.duration
                                     target:self
                                   selector:@selector(closeAddImgAnimation)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void)skipBtnClick{
    _isClick = @"2";
    [self startcloseAnimation];
}

#pragma mark - 关闭动画完成时处理事件
-(void)closeAddImgAnimation
{
    [countDownTimer invalidate];
    countDownTimer = nil;
    self.hidden = YES;
    self.aDImgView.hidden = YES;
    self.hidden = YES;
    if ([_isClick integerValue] == 1) {
        
        if (self.clickBlock) {//点击广告
            self.clickBlock(1100);
        }
    }else if([_isClick integerValue] == 2){
        if (self.clickBlock) {//点击跳过
            self.clickBlock(1101);
        }
    }else{
        if (self.clickBlock) {//点击跳过
            self.clickBlock(1102);
        }
    }
    
    
    
}

- (void)onTimer {
    
    if (_adTime == 0) {
        _adTime = 6;
    }
    if (_secondsCountDown < _adTime) {
        _secondsCountDown++;
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_secondsCountDown)] forState:UIControlStateNormal];
    }else{
        
        [countDownTimer invalidate];
        countDownTimer = nil;
        [self startcloseAnimation];
        
    }
}

#pragma mark - 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)kAdsImageKey {
  return @"adsImageKey";
}

@end
