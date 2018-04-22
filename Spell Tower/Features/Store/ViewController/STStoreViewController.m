//
//  STStoreViewController.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STStoreViewController.h"
#import "IDRouter.h"
#import "STGameModel.h"
#import "STStoreTableViewCell.h"
#import "STStoreDataController.h"
#import <Masonry.h>

@interface STStoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) STStoreDataController *dataController;

@end

@implementation STStoreViewController

+ (void)load
{
    [IDRouter registerViewControllerClass:self forURLPattern:@"tower://store"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataController = [[STStoreDataController alloc] init];
    [self setupUI];
    [self initialFetch];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initialFetch
{
    [self.dataController initFetchWithCompletion:^(NSArray<STGameModel *> *result, NSError *error) {
        [self.tableView reloadData];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        [_tableView registerClass:STStoreTableViewCell.class forCellReuseIdentifier:NSStringFromClass(STStoreTableViewCell.class)];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataController.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(STStoreTableViewCell.class)];
    [cell configWithGame:self.dataController.games[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.dataController.games.count - 3) {
        [self.dataController loadMoreWithCompletion:^(NSArray<STGameModel *> *result, NSError *error) {
            [self.tableView reloadData];
        }];
    }
}

@end
