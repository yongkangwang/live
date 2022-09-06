//
//  KKTRTCLiveInvitationView.h
//  yunbaolive
//
//  Created by Peter on 2021/4/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KKTRTCRoomCellModel;
//邀请
@interface KKTRTCLiveInvitationView : UIView

/**
 *显示
 */
-(void)kkShow;
-(void)kkDismiss;

@property (nonatomic,copy) void(^kkCellDidSelectClickBlock)(KKTRTCRoomCellModel *model);

@property (nonatomic,copy) NSString * kkRoomID;


@end

NS_ASSUME_NONNULL_END
