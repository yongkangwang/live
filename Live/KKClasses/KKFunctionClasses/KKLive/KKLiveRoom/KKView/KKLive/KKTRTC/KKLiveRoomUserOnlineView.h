//
//  KKLiveRoomUserOnlineView.h
//  yunbaolive
//
//  Created by Peter on 2021/5/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveRoomUserOnlineView : UIView

// 房间主播id
@property (nonatomic,copy) NSString * kkLiveID;
// 房间主播id
@property (nonatomic,copy) NSString * kkStream;

//选中了cell
@property (nonatomic,copy) void(^kkDidSelectItemBlock)(NSDictionary *dic);


-(void)kkShow;
- (void)kkDismiss;

@end

NS_ASSUME_NONNULL_END
