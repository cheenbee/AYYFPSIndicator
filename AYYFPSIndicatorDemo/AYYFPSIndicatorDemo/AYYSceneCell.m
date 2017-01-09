//
//  AYYSceneCell.m
//  AYYFPSIndicatorDemo
//
//  Created by 艾呦呦 on 17/1/9.
//  Copyright © 2017年 none. All rights reserved.
//

#import "AYYSceneCell.h"

@implementation AYYSceneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithWhite:0.865 alpha:1.000].CGColor;
    
    UIImageView *imageview = [[UIImageView alloc] init];
    self.sceneImageView = imageview;
    imageview.clipsToBounds = YES;
    imageview.layer.borderWidth = 1;
    imageview.layer.borderColor = [UIColor cyanColor].CGColor;
    imageview.layer.cornerRadius = 1;
    imageview.layer.shadowColor = [UIColor colorWithWhite:0.865 alpha:1.000].CGColor;
    [self.contentView addSubview:imageview];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.sceneImageView.frame = self.bounds;
}

@end
