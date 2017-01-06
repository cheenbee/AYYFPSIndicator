//
//  ViewController.m
//  AYYFPSIndicatorDemo
//
//  Created by 艾呦呦 on 17/1/6.
//  Copyright © 2017年 none. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height)];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.titles = @[].mutableCopy;
    self.images = @[].mutableCopy;
    
    [self addCell:@"camera" image:@"camera"];
    [self addCell:@"clubs" image:@"clubs"];
    [self addCell:@"feed" image:@"feed"];
    [self addCell:@"file-music" image:@"file-music"];
    [self addCell:@"headphones" image:@"headphones"];
    [self addCell:@"pacman" image:@"pacman"];
    
    for (int i = 0; i < 5; i++) {
        [self.titles addObjectsFromArray:self.titles];
        [self.images addObjectsFromArray:self.images];
    }
}

- (void)addCell:(NSString *)title image:(NSString *)imageName {
    [self.titles addObject:title];
    [self.images addObject:[UIImage imageNamed:imageName]];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AYY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.shadowOffset = CGSizeMake(0, 2);
    cell.textLabel.layer.cornerRadius = 5.0f;
    cell.textLabel.layer.shadowOpacity = 1;
    
    cell.imageView.image = _images[indexPath.row];
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    cell.imageView.layer.shadowOpacity = 1;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = 48 / 2;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
