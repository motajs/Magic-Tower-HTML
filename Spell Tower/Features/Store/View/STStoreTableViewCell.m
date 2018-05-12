
//
//  STStoreTableViewCell.m
//  Spell Tower
//
//  Created by 熊典 on 2018/4/22.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "STStoreTableViewCell.h"
#import <Masonry.h>
#import "IDColorService.h"
#import <UIImageView+YYWebImage.h>
#import "STLocalGameManager.h"

@interface STStoreTableViewCell()

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UIButton *downloadButton;

@end

@implementation STStoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.thumbnailImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.downloadButton];
    
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@60);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.thumbnailImageView.mas_trailing).offset(10);
        make.top.equalTo(self.thumbnailImageView);
        make.trailing.lessThanOrEqualTo(self.downloadButton.mas_leading).offset(-10);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.trailing.lessThanOrEqualTo(self.downloadButton.mas_leading).offset(-10);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.authorLabel);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(10);
        make.trailing.lessThanOrEqualTo(self.downloadButton.mas_leading).offset(-10);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIImageView *)thumbnailImageView
{
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] init];
    }
    return _thumbnailImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _authorLabel.textColor = IDColorS10;
    }
    return _titleLabel;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:13];
        _authorLabel.textColor = IDColorS22;
    }
    return _authorLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = IDColorS12;
    }
    return _descLabel;
}

- (UIButton *)downloadButton
{
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _downloadButton.layer.borderWidth = 1;
        _downloadButton.layer.borderColor = _downloadButton.tintColor.CGColor;
        _downloadButton.layer.cornerRadius = 5;
        _downloadButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        [_downloadButton addTarget:self action:@selector(downloadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [_downloadButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _downloadButton;
}

- (void)configWithGame:(STGameModel *)game
{
    self.titleLabel.text = game.titleName;
    self.authorLabel.text = [NSString stringWithFormat:@"%@/%@", game.originAuthor, game.copiedAuthor];
    self.descLabel.text = game.descriptionString;
    [self.thumbnailImageView yy_setImageWithURL:game.thumbURL placeholder:[UIImage imageNamed:@"placeholder"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    if ([[STLocalGameManager sharedInstance].localGames containsObject:game]) {
        [self.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
    } else {
        [self.downloadButton setTitle:@"获取" forState:UIControlStateNormal];
    }
}

- (void)downloadButtonTapped
{
    if (self.downloadButtonTapBlock) {
        self.downloadButtonTapBlock();
    }
}

@end
