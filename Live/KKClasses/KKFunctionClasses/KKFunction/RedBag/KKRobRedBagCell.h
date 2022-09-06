//
//  KKRobRedBagCell.h
//  yunbaolive
//
//  Created by Peter on 2021/11/19.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRobRedBagCell : UITableViewCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@property (nonatomic,strong) NSDictionary *kkDic;

@end

NS_ASSUME_NONNULL_END
