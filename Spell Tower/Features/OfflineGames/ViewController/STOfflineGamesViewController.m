//
//  STOfflineGamesViewController.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STOfflineGamesViewController.h"
#import "IDRouter.h"
#import <Masonry.h>
#import "IDColorService.h"
#import "STGameItemCollectionViewCell.h"
#import "STFindMoreGamesCollectionViewCell.h"
#import "ICMacros.h"
#import "STLocalGameManager.h"
#import "ICMessageCenter.h"
#import "STGameMessage.h"
#import "AWEBubbleManager.h"

#define DROP_BAR_HEIGHT (60 + BOTTOM_OFFSET)

NSString * const editColor = @"0f94e6";
NSString * const deleteColor = @"db1717";

NSString * const editActiveColor = @"0b75b6";
NSString * const deleteActiveColor = @"a91212";



@interface STOfflineGamesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate, STGameMessage>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *localGames;
@property (nonatomic, strong) UIView *dropTargetView;
@property (nonatomic, strong) UIView *deleteDropView;
@property (nonatomic, assign) BOOL isMovingItem;
@property (nonatomic, strong) UILabel *emptyLabel;

@end

@implementation STOfflineGamesViewController

+ (void)load
{
    [IDRouter registerViewControllerClass:self forURLPattern:@"tower://offline-games"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.localGames = [STLocalGameManager sharedInstance].localGames;
    IC_REGISTER_MESSAGE(self, STGameMessage);
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"所有游戏";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Project_List_Settings"] style:UIBarButtonItemStyleDone target:self action:@selector(settingsButtonTapped:)];
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    
    [self.view addSubview:self.emptyLabel];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.leading.greaterThanOrEqualTo(self.view).offset(10);
        make.trailing.lessThanOrEqualTo(self.view).offset(-10);
    }];
}

- (void)addButtonTapped:(UIBarButtonItem *)button
{
    [IDRouter transferToURL:@"tower://store"];
}

- (void)settingsButtonTapped:(UIBarButtonItem *)button
{
    [IDRouter transferToURL:@"tower://settings"];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(150, 170);
        layout.minimumInteritemSpacing=10;
        layout.minimumLineSpacing=20;
        layout.sectionInset=UIEdgeInsetsMake(20, 30, 20, 30);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[STGameItemCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([STGameItemCollectionViewCell class])];
        [_collectionView registerClass:[STFindMoreGamesCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([STFindMoreGamesCollectionViewCell class])];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.dragInteractionEnabled = YES;
        _collectionView.dragDelegate = self;
        _collectionView.dropDelegate = self;
    }
    return _collectionView;
}

- (UILabel *)emptyLabel
{
    if (!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.hidden = self.localGames.count > 0;
        _emptyLabel.font = [UIFont systemFontOfSize:14];
        _emptyLabel.text = @"没有离线的游戏，快点击添加一个吧~";
        _emptyLabel.textColor = IDColorS22;
    }
    return _emptyLabel;
}

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath
{
    NSItemProvider *provider = [[NSItemProvider alloc] init];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:provider];
    dragItem.localObject = indexPath;
    return @[dragItem];
}

- (void)collectionView:(UICollectionView *)collectionView dragSessionWillBegin:(id<UIDragSession>)session
{
    [self showDropView];
}

- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnd:(id<UIDropSession>)session
{
    [self hideDropView];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session
{
    return self.collectionView.hasActiveDrag && session.localDragSession;
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator
{
    NSIndexPath *indexPath = coordinator.items.firstObject.dragItem.localObject;
    if (indexPath) {
        self.isMovingItem = YES;
        [[STLocalGameManager sharedInstance] moveGameAtIndex:indexPath.item toIndex:coordinator.destinationIndexPath.item];
        self.localGames = [STLocalGameManager sharedInstance].localGames;
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:coordinator.destinationIndexPath];
        [coordinator dropItem:coordinator.items.firstObject.dragItem toItemAtIndexPath:coordinator.destinationIndexPath];
        self.isMovingItem = NO;
    }
}

- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath {
    if (destinationIndexPath && destinationIndexPath.item < self.localGames.count) {
        return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    return [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationForbidden];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.item < self.localGames.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [IDRouter transferToURL:@"tower://game" withParams:@{@"model": self.localGames[indexPath.item]}];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.localGames.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < self.localGames.count) {
        // Game item
        STGameItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([STGameItemCollectionViewCell class]) forIndexPath:indexPath];
        [cell setupWithModel:self.localGames[indexPath.row]];
        return cell;
    } else {
        // New game item
        STFindMoreGamesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([STFindMoreGamesCollectionViewCell class]) forIndexPath:indexPath];
        return cell;
    }
}

- (UIView *)dropTargetView
{
    if (!_dropTargetView) {
        _dropTargetView = [[UIView alloc] init];
        [_dropTargetView addSubview:self.deleteDropView];
        
        UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
        [_dropTargetView addInteraction:dropInteraction];
        
        [self.deleteDropView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_dropTargetView);
        }];
    }
    return _dropTargetView;
}

- (UIView *)deleteDropView
{
    if (!_deleteDropView) {
        _deleteDropView = [[UIView alloc] init];
        _deleteDropView.backgroundColor = [UIColor colorWithHexString:deleteColor];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drop_delete_icon"]];
        iconView.tintColor = IDColorS20;
        
        [_deleteDropView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_deleteDropView);
            make.centerY.equalTo(self->_deleteDropView).offset(-BOTTOM_OFFSET / 2);
        }];
    }
    return _deleteDropView;
}

- (void)showDropView
{
    [self.view addSubview:self.dropTargetView];
    [self.dropTargetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(DROP_BAR_HEIGHT));
    }];
    [self.view layoutSubviews];
    
    [self.dropTargetView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(DROP_BAR_HEIGHT));
    }];
    
    self.deleteDropView.backgroundColor = [UIColor colorWithHexString:deleteColor];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutSubviews];
    }];
}

- (void)hideDropView
{
    [self.dropTargetView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(DROP_BAR_HEIGHT));
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutSubviews];
    }];
}

#pragma mark - UIDropInteraction
- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session
{
    return session.localDragSession;
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session
{
    self.deleteDropView.backgroundColor = [UIColor colorWithHexString:deleteColor];
    CGPoint location = [session locationInView:self.dropTargetView];
    UIView *target = [self.dropTargetView hitTest:location withEvent:nil];
    if (target == self.deleteDropView) {
        self.deleteDropView.backgroundColor = [UIColor colorWithHexString:deleteActiveColor];
        return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationCopy];
    }
    return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationForbidden];
}

- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidExit:(id<UIDropSession>)session
{
    self.deleteDropView.backgroundColor = [UIColor colorWithHexString:deleteColor];
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session
{
    UIDragItem *item = session.localDragSession.items.firstObject;
    NSIndexPath *indexPath = item.localObject;
    if (!indexPath) {
        return;
    }
    CGPoint location = [session locationInView:self.dropTargetView];
    UIView *target = [self.dropTargetView hitTest:location withEvent:nil];
    STGameModel *targetGame = self.localGames[indexPath.row];
    if (target == self.deleteDropView) {
        // Delete Project
        self.isMovingItem = YES;
        [[STLocalGameManager sharedInstance] deleteGame:targetGame];
        self.isMovingItem = NO;
        self.localGames = [STLocalGameManager sharedInstance].localGames;
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        self.emptyLabel.hidden = self.localGames.count > 0;
    }
}

#pragma mark - STGameMessage
- (void)gameListDidChange
{
    self.localGames = [STLocalGameManager sharedInstance].localGames;
    [self.collectionView reloadData];
    self.emptyLabel.hidden = self.localGames.count > 0;
}

@end
