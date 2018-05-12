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
#import "STLocalGameManager.h"
#import "ICMacros.h"
#import "ICUIUtils.h"
#import <MJRefresh.h>

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
    self.title = @"获取新游戏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initialFetch
{
    [ICUIUtils loading];
    [self.dataController initFetchWithCompletion:^(NSArray<STGameModel *> *result, NSError *error) {
        [ICUIUtils endLoading];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [ICUIUtils toast:@"加载失败，请稍后重试"];
        } else {
            [self.tableView reloadData];
            [self.tableView.mj_footer resetNoMoreData];
        }
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.allowsSelection = NO;
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self initialFetch];
        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.dataController loadMoreWithCompletion:^(NSArray<STGameModel *> *result, NSError *error) {
                if (!self.dataController.hasMore) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
                [self.tableView reloadData];
            }];
        }];
        
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
    @weakify(self);
    cell.downloadButtonTapBlock = ^{
        @strongify(self);
        STGameModel *game = self.dataController.games[indexPath.row];
        if ([[STLocalGameManager sharedInstance].localGames containsObject:game]) {
            [IDRouter transferToURL:@"tower://game" withParams:@{@"model": game}];
        } else {
            [ICUIUtils loadingWithStatus:@"正在下载"];
            [[STLocalGameManager sharedInstance] downloadGame:self.dataController.games[indexPath.row] progress:^(float progress) {
                [ICUIUtils loadingWithProgress:progress status:@"正在下载"];
            } withCompletionBlock:^{
                [ICUIUtils endLoading];
                [ICUIUtils toast:@"下载成功"];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    };
    return cell;
}

@end
