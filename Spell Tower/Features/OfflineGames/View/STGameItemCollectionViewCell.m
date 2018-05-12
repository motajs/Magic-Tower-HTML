//
//  STGameItemCollectionViewCell.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STGameItemCollectionViewCell.h"
#import <Masonry.h>
#import <UIImageView+YYWebImage.h>
#import "IDColorService.h"

@interface STGameItemCollectionViewCell()

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UILabel *gameTitle;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation STGameItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCell:)];
    }
    return _longPress;
}

- (void)longPressCell:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }
}

- (void)setupUI
{
    [self.contentView addSubview:self.thumbImageView];
    [self.contentView addSubview:self.gameTitle];
    
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        
        make.height.equalTo(@(128));
    }];
    
    [self.gameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thumbImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.thumbImageView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self addGestureRecognizer:self.longPress];
}

- (UIImageView *)thumbImageView
{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.clipsToBounds = YES;
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbImageView;
}

- (UILabel *)gameTitle
{
    if (!_gameTitle) {
        _gameTitle = [[UILabel alloc] init];
        _gameTitle.font = [UIFont systemFontOfSize:13];
        _gameTitle.textColor = IDColorS10;
    }
    return _gameTitle;
}

- (void)setupWithModel:(STGameModel *)model
{
    [self.thumbImageView yy_setImageWithURL:model.imageURL placeholder:[UIImage imageNamed:@"placeholder"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    self.gameTitle.text = model.titleName;
}

@end
