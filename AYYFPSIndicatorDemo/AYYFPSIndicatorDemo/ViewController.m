//
//  ViewController.m
//  AYYFPSIndicatorDemo
//
//  Created by 艾呦呦 on 17/1/6.
//  Copyright © 2017年 none. All rights reserved.
//

#import "ViewController.h"
#import "AYYSceneCell.h"

static NSString *reuseId = @"AYYSceneCell";

#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define KISiPhoneX (kStatusBarHeight == 20.f ? NO : YES)

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - kStatusBarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.images = @[].mutableCopy;
    
    [self addCellWithImage:@"cicle_a.jpeg"];
    [self addCellWithImage:@"cicle_b.jpeg"];
    [self addCellWithImage:@"cicle_c.jpeg"];
    [self addCellWithImage:@"cicle_d.jpeg"];
    [self addCellWithImage:@"cicle_e.jpeg"];
    [self addCellWithImage:@"cicle_f.jpeg"];
    
    for (int i = 0; i < 5; i++) {
        [self.images addObjectsFromArray:self.images];
    }
}

- (void)addCellWithImage:(NSString *)imageName {
    [self.images addObject:[UIImage imageNamed:imageName]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AYYSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[AYYSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }

    cell.sceneImageView.image = _images[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.height * 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
