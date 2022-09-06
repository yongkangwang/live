//
//  KKLiveAPI.h
//  yunbaolive
//
//  Created by Peter on 2019/12/21.
//  Copyright © 2019 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface KKLiveAPI : NSObject

//关注的正在开播的主播
+ (void)kk_PostLiveAttentionInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//直播间在线人员
+ (void)kk_GetLiveUserOnlineInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//首页直播synew
+ (void)kk_PostHomeLiveInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//发送弹幕
+ (void)kk_PostSendBarrageIDInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//  发红包
+ (void)kk_GetRedEnvelopeInfoURL:(NSString *)url successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 解析视频链接
+ (void)kk_PostVideoURLInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// TRTC房间一起看视频列表
+ (void)kk_PostTRTCVideoListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// 检查直播间
+ (void)kk_PostCheckLiveInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// 搜索音乐
+ (void)kk_GetMusicInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 一键打招呼
+ (void)kk_PostHelloInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// 竞技分类获取
+ (void)kk_PostSportsClassInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// 游戏试玩
+ (void)kk_PostGameTryToPlayInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// 游戏类型下的列表数据
+ (void)kk_GetLiveGameListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// 开始花币转换
+ (void)kk_PostLiveGameStartConversionMoneyInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 花币转换信息展示
+ (void)kk_PostLiveGameConversionMoneyInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 游戏分类列表
+ (void)kk_GetLiveGameClassListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 游戏评论
+ (void)kk_PostLiveGameSendCommentInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 游戏评论列表
+ (void)kk_GetLiveGameCommentInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 游戏收藏
+ (void)kk_PostLiveGameCollectInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 游戏详情数据
+ (void)kk_PostLiveGameDetailsInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 游戏list数据
+ (void)kk_PostLiveGameListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


// 首页轮播、游戏 热门数据
+ (void)kk_PostLiveTopInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

// 娱乐
+ (void)kk_PostAmusementInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//用户背包
+ (void)kk_PostUserKnapsackListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

//首页新开数据
+ (void)kk_GetNewStartListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

//开播直播间 底部数据
+ (void)kk_PostLiveBroadcastRoomBottomInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

//请求用户观看的直播间 底部数据
+ (void)kk_PostLiveRoomBottomInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

//请求公司网址水印图片
+ (void)kk_PostCompanyURLImageInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//直播间列表数据
+ (void)kk_PostLiveRoomListInfoApiURL:(NSString *)kkURL Withparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//创建直播间接口
+ (void)kk_PostCreateLiveRoomInfoURL:(NSString *)parametStr  Withparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

//复制分享的链接接口
+ (void)kk_PostShearURLInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//首页轮播图
+ (void)kk_GetLiveTopViewInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

//首页列表数据
+ (void)kk_getLiveListInfoApiWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//进入房间需要调用的接口，里边有用户的全部信息，还有socket链接地址
+ (void)kk_playRoomWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;


//直播间内主播肉票榜API
+ (void)kk_GetLiveRoomRankListInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

//关闭直播间
+ (void)kk_GetLiveStopRoomInfoWithparameters:(NSDictionary * _Nullable )parameters successBlock:(_Nullable SuccessBlock)successBlock failureBlock:(_Nullable FailureBlock)failureBlock mainView:(nullable UIView *)mainView;

@end

NS_ASSUME_NONNULL_END
