//
//  AYYFPSIndicator.h
//  AYYUtils
//
//  Created by 艾呦呦 on 16/12/30.
//  Copyright © 2016年 none. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AYYFPSIndicatorPosition) {
    AYYFPSIndicatorPositionNormal = 0,      // 默认, 位置在屏幕左下角
    AYYFPSIndicatorPositionStatusBar = 1    // 位置在状态栏时间显示右侧
};

@interface AYYFPSIndicator : NSObject

+ (AYYFPSIndicator *)sharedInstance;

/** 开始监控并显示当前 fps 值 */
- (void)start;

/** 停止监控并隐藏 fps 值 */
- (void)stop;

/** FPS 指示器位置 默认为:AYYFPSIndicatorPositionNormal */
@property (nonatomic, assign) AYYFPSIndicatorPosition indicatorPosition;

@end
