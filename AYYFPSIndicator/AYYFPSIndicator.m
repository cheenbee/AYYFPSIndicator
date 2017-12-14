//
//  AYYFPSIndicator.m
//  AYYUtils
//
//  Created by 艾呦呦 on 16/12/30.
//  Copyright © 2016年 none. All rights reserved.
//

#import "AYYFPSIndicator.h"
#import <UIKit/UIKit.h>

#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define kISiPhoneX (kStatusBarHeight == 20.f ? NO : YES)
#define kNavigationBarHeight (kStatusBarHeight + 44)
#define kTabBarHeight (kISiPhoneX ? (49.f+34.f) : 49.f)

#define kFPSLabelNormalWidth 60
#define kFPSLabelNormalHeight 30
#define kFPSLabelInStatusBarHeight 20
#define kFPSLabelInStatusBarWidth 50
#define kFPSLabelIniPhoneXStatusBarY 28



@interface AYYFPSIndicator ()

@property (nonatomic, strong) UILabel *fpsLabel;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTimeStamp;

@end

@implementation AYYFPSIndicator

- (void)dealloc {
    [_displayLink invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
        [self setupDisplayLink];
        [self observeNotifications];
    }
    
    return self;
}

+ (AYYFPSIndicator *)sharedInstance {
    static AYYFPSIndicator *indicator;
    
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        indicator = [[AYYFPSIndicator alloc] init];
    });
    
    return indicator;
}

- (void)setIndicatorPosition:(AYYFPSIndicatorPosition)indicatorPosition {
    _indicatorPosition = indicatorPosition;
    [self setupFPSLabel:_fpsLabel indicatorPosition:indicatorPosition];
}


#pragma mark - private methods
- (void)setupSubviews {
    _indicatorPosition = AYYFPSIndicatorPositionNormal;
    
    _fpsLabel = [[UILabel alloc] init];
    [self setupFPSLabel:_fpsLabel indicatorPosition:_indicatorPosition];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [_fpsLabel addGestureRecognizer:panGesture];
    
    [[UIApplication sharedApplication].delegate.window addSubview:_fpsLabel];
}

- (void)setupFPSLabel:(UILabel *)fpsLabel indicatorPosition:(AYYFPSIndicatorPosition)position {
    if (position == AYYFPSIndicatorPositionStatusBar) {
        
        CGFloat fpsLabelInNormalStatusBarX = (kUIScreenSize.width - kFPSLabelInStatusBarWidth) *0.5 + kFPSLabelInStatusBarWidth;
        
        // 和 statusBar 上信号强度显示点左对齐 (- kFPSLabelInStatusBarWidth + 10)
        CGFloat fpsLabelIniPhoneXStatusBarX = (kUIScreenSize.width - kFPSLabelInStatusBarWidth) - kFPSLabelInStatusBarWidth + 10;
        CGFloat fpsLabelInStatusBarX = kISiPhoneX ? fpsLabelIniPhoneXStatusBarX : fpsLabelInNormalStatusBarX;
        CGFloat fpsLabelInStatusBarY = kISiPhoneX ? kFPSLabelIniPhoneXStatusBarY : 0;
        
        fpsLabel.frame = CGRectMake(fpsLabelInStatusBarX, fpsLabelInStatusBarY, kFPSLabelInStatusBarWidth, kFPSLabelInStatusBarHeight);
        fpsLabel.backgroundColor = [UIColor clearColor];
        fpsLabel.font = [UIFont boldSystemFontOfSize:12];
        fpsLabel.textAlignment = NSTextAlignmentRight;
        fpsLabel.textColor = [UIColor greenColor];
        fpsLabel.userInteractionEnabled = NO;
        
    } else {
        CGFloat fpsLabelNormalPositionY = kUIScreenSize.height - (kNavigationBarHeight + kTabBarHeight);
        fpsLabel.frame = CGRectMake(0, fpsLabelNormalPositionY, kFPSLabelNormalWidth, kFPSLabelNormalHeight);
        fpsLabel.layer.cornerRadius = 5;
        fpsLabel.clipsToBounds = YES;
        fpsLabel.textAlignment = NSTextAlignmentCenter;
        fpsLabel.textColor = [UIColor whiteColor];
        fpsLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        fpsLabel.font = [UIFont systemFontOfSize:14];
        fpsLabel.textColor = [UIColor whiteColor];
        fpsLabel.userInteractionEnabled = YES;
    }
}

- (void)setupDisplayLink {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkTick:(CADisplayLink *)displayLink {
    if (_lastTimeStamp == 0) {
        _lastTimeStamp = displayLink.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = displayLink.timestamp - _lastTimeStamp;
    if (delta < 1) return;
    _lastTimeStamp = displayLink.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    UIColor *fpsColor;
    if (fps >= 55) {
        fpsColor = [UIColor greenColor];
    } else if (fps >= 45) {
        fpsColor = [UIColor yellowColor];
    } else {
        fpsColor = [UIColor redColor];
    }
    
    NSString *fpsStr = [NSString stringWithFormat:@"%d", (int)roundf(fps)];
    NSString *displayStr = [fpsStr stringByAppendingString:@" FPS"];
    NSRange fpsRange = [displayStr rangeOfString:fpsStr];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:displayStr];
    [attributedText addAttribute:NSForegroundColorAttributeName value:fpsColor range:fpsRange];
    [_fpsLabel setAttributedText:attributedText];
    
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:_fpsLabel];
}

- (void)observeNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}


#pragma mark - operation
- (void)start {
    if (!_displayLink) {
        [self setupDisplayLink];
    }
    
    if (!_displayLink.isPaused) return;
    
    _count = 0;
    _lastTimeStamp = 0;
    
    [self show];
}

- (void)stop {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    [self hide];
}

- (void)show {
    if (_displayLink.isPaused) {
        [_displayLink setPaused:NO];
    }
    
    [_fpsLabel removeFromSuperview];
    [[UIApplication sharedApplication].delegate.window addSubview:_fpsLabel];
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:_fpsLabel];
}

- (void)hide {
    [_displayLink setPaused:YES];
    [_fpsLabel removeFromSuperview];
}


#pragma mark - notification
- (void)applicationDidBecomeActiveNotification {
    if (_displayLink.isPaused) {
        [_displayLink setPaused:NO];
    }
}

- (void)applicationWillResignActiveNotification {
    [_displayLink setPaused:YES];
}


#pragma mark - gesture
- (void)didPan:(UIPanGestureRecognizer *)gesture {
    UIWindow *superView = [UIApplication sharedApplication].delegate.window;
    CGPoint position = [gesture locationInView:superView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _fpsLabel.alpha = 0.5;
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            _fpsLabel.center = position;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            CGFloat fpsLabelX = 0;
            if (position.x > kUIScreenSize.width * 0.5) {
                fpsLabelX = kUIScreenSize.width - _fpsLabel.frame.size.width;
            }
            
            // 防止和 statusBar 下拉手势冲突 , 上方始终保持 20 间距
            CGFloat fpsLabelY = position.y + kStatusBarHeight;
            if (position.y > kUIScreenSize.height - _fpsLabel.frame.size.height) {
                fpsLabelY = kUIScreenSize.height - _fpsLabel.frame.size.height;
            }
            
            CGRect newFrame = CGRectMake(fpsLabelX, fpsLabelY, _fpsLabel.frame.size.width, _fpsLabel.frame.size.height);
            [UIView animateWithDuration:0.25 animations:^{
                _fpsLabel.frame = newFrame;
                _fpsLabel.alpha = 1;
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
