//
//  KKTRTCVoiceView.h
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KKTRTCRoomModel;
@class KKTRTCRoomCellModel;

//TRTC群消息指令类型
//typedef NS_ENUM(NSInteger, KKIMCMDType) {
//    KKIMCMD_VIDEO_SYNCHRONOUS       = 4,    //同步视频播放
//    KKIMCMD_VIDEO_PLAY              = 5,    //视频播放
//    KKIMCMD_USER_VIDEO_SYNCHRONOUS  = 6,    //观众同步主播视频进度
//    KKIMCMD_USER_VIDEO_PLAY         = 7,    //观众申请播放视频
//    KKIMCMD_ANCHOR_VIDEO_PLAY_PAUSE = 8,    //主播恢复播放或暂停
//};


@interface KKTRTCVoiceView : UIView

//TRTC语音房
@property(strong,nonatomic)KKTRTCRoomModel *kkTRTCModel;
//TRTC,sdk初始化信息
@property (nonatomic,strong) NSDictionary *kkRoomSDKDic;

//房间主播信息
@property(strong,nonatomic)NSDictionary *kkLiveInfo;
//是否是主播端，默认不是，
@property (nonatomic,assign) BOOL kkIsLive;

//新消息,用于主播端
@property (nonatomic,copy) void(^kkNewTRTCMessageBlock)(KKTRTCRoomCellModel *model);
//一起看视频内容
@property (nonatomic,copy) void(^kkVideoInfoBlock)(NSDictionary *dic);
//上下麦弹框
@property (nonatomic,copy) void(^kkShowAlertMicrophoneBlock)(UIAlertController *alert);
//发送视频信息给用户
@property (nonatomic,copy) void(^kkSendVideoInfoBlock)(NSString *uid);
// 用户同步主播视频进度
@property (nonatomic,copy) void(^kkVideoProgressChangeBlock)(NSString *progress);


//TRTC消息事件
- (void)kkTRTCChatMessageClick:(KKTRTCRoomCellModel *)model;
//退出TRTC
- (void)kkExitRoom;


//用户发送自定义消息
-(void)kkSendRoomCustomMsg:(NSMutableDictionary *)dic;

//主播同步用户视频,
-(void)kkSendVideoCustomMsg:(NSMutableDictionary *)dic andMsgUID:(NSString *)uid;


@property(strong,nonatomic)NSMutableDictionary *kkVideoInfoDic;



@end

NS_ASSUME_NONNULL_END
