//
//  KKLiveBottomMenuView.h
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKLiveBottomMenuViewDelegate <NSObject>

@optional;
//显示礼物功能
- (void)kkGiftBtnClick;
//聊天
- (void)kkChatBtnClick;

//TRTC设置
- (void)kkTRTCAudioEffectSettingClick;
//更多
- (void)kkMoreBtnClick;

@end

@interface KKLiveBottomMenuView : UIView
@property(nonatomic,assign)id<KKLiveBottomMenuViewDelegate>kkBottomMenuViewDelegate;

@property (nonatomic,assign) BOOL kkIsTRTC;

@property(weak,nonatomic)UIButton *kkMoreBtn;

@end

NS_ASSUME_NONNULL_END
