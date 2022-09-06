//
//  KKSocketChatView.h
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKTRTCRoomCellModel;

@protocol KKSocketChatViewDelegate <NSObject>

//遮罩事件
- (void)kkChatCoverClick;

//聊天消息事件
- (void)kkChatMessageClick:(NSDictionary *)dic;

@optional;
//主播 连麦消息事件
- (void)kkTRTCChatMessageClick:(KKTRTCRoomCellModel *)model;

@end

@interface KKSocketChatView : UIView

@property(nonatomic,assign)id<KKSocketChatViewDelegate>kkChatViewDelegate;

//添加socket 新消息
- (void)kkAddSocketMessage:(NSDictionary *)dic;

//是否是主播端，默认不是，
@property (nonatomic,assign) BOOL kkIsLive;

//添加TRTC 新消息
- (void)kkAddTRTCMessage:(KKTRTCRoomCellModel *)model;
//重置数据，清空聊天记录
- (void)kkResetData;

@end

NS_ASSUME_NONNULL_END
