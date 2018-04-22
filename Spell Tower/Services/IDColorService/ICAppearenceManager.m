//
//  ICAppearenceManager.m
//  Iodine Code
//
//  Created by 熊典 on 2018/2/3.
//  Copyright © 2018年 熊典. All rights reserved.
//

#import "ICAppearenceManager.h"
#import "IDColorService.h"
#import "ICSwizzle.h"

@implementation ICAppearenceManager

+ (void)initAppearence
{
    [UICollectionView appearance].backgroundColor = IDColorS10;
    [UITableView appearance].backgroundColor = IDColorS10;
    [UITableViewCell appearance].backgroundColor = IDColorS11;
    [UITableView appearance].separatorColor = IDColorS12;
    
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [UINavigationBar appearance].tintColor = IDColorS21;
    [UIToolbar appearance].barStyle = UIBarStyleBlack;
    [UIToolbar appearance].tintColor = IDColorS21;
    [UIBarButtonItem appearance].tintColor=[UIColor whiteColor];
    
    [UIPickerView appearance].backgroundColor = IDColorS10;
    [UIPickerView appearance].tintColor = IDColorS20;
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIPickerView class]]].textColor = IDColorS20;
    
    [UITableViewCell appearance].tintColor = IDColorS20;
    [UILabel appearance].textColor = IDColorS20;
    [UIImageView appearance].tintColor = IDColorS20;
    
    [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UITableViewCell class]]].textColor = IDColorS20;
    
    [ICSwizzle updateImplementationOfClass:[UITextField class] method:@selector(setPlaceholder:) newImplementation:^id(UITextField *self, id param, id (*originalFunc)(__strong id, SEL, __strong id)) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:param ?: @"" attributes:@{NSForegroundColorAttributeName: IDColorS21}];
        return nil;
    }];
    
    [UITextView appearance].backgroundColor = IDColorS10;
    [UITextView appearance].textColor = IDColorS20;
    
    [UISegmentedControl appearance].tintColor = IDColorS20;
    
    [UISearchBar appearance].barStyle = UIBarStyleBlack;
    [UISearchBar appearance].tintColor = IDColorS20;
    [UISearchBar appearance].barTintColor = IDColorS11;
    
    [UITableViewCell appearance].selectedBackgroundView = [[UIView alloc] init];
    [UITableViewCell appearance].selectedBackgroundView.backgroundColor = IDColorS17;
    
    [UITextField appearance].keyboardAppearance = UIKeyboardAppearanceDark;
    
    [UITableViewCell appearance].preservesSuperviewLayoutMargins = YES;
    [UITableViewCell appearance].contentView.preservesSuperviewLayoutMargins = YES;
}

@end
