//
//  KKTRTCChatTableViewCell.h
//  yunbaolive
//
//  Created by Peter on 2021/3/29.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KKTRTCRoomCellModel;

@interface KKTRTCChatTableViewCell : UITableViewCell

@property(strong,nonatomic)KKTRTCRoomCellModel *model;

@end

NS_ASSUME_NONNULL_END
