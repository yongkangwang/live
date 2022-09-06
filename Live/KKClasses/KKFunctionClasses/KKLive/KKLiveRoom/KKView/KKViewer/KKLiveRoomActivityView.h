//
//  KKLiveRoomActivityView.h
//  yunbaolive
//
//  Created by Peter on 2021/6/11.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveRoomActivityView : UIView
//主播信息
@property(strong,nonatomic)NSDictionary *kkAnchorDic;
//房间信息
@property(strong,nonatomic)NSDictionary *kkRoomDic;

@end

NS_ASSUME_NONNULL_END
