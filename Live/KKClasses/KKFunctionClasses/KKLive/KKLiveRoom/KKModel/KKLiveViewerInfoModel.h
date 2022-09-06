//
//  KKLiveRoomInfoModel.h
//  yunbaolive
//
//  Created by Peter on 2021/3/19.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKBaseModel.h"

//@class socketMovieplay;
#import "socketLivePlay.h"

//用户端

NS_ASSUME_NONNULL_BEGIN


@protocol KKLiveViewerSocketDelegate <NSObject>

@optional;


//用户进入直播间
- (void)kkUserComeIn:(NSDictionary *)dic;

//顶部观众信息 和直播间人数
- (void)kkChangeLookLivePersion:(NSDictionary *)dic andPersionCount:(long long)count;

//零碎功能数据回调
- (void)kkLoadRoomFunctionDataSuccess:(NSDictionary *)dic;

//socket链接成功的信息回调
- (void)kkSocketSuccess:(NSDictionary *)dic;

//socket消息
- (void)kkSocketMessageSuccess:(NSDictionary *)dic;

//房间被管理员关闭,主播关闭直播间
- (void)kkRoomCloseByAdmin;

//僵尸粉
- (void)kkAddZombieByArray:(NSArray *)array;
//用户离开
- (void)kkUserDisconnect:(NSDictionary *)dic;
//点亮，星星飘屏
//- (void)kkSendLight;
//魅力值更新
- (void)kkVotesTatal:(NSString *)votes;
//送礼物 1是豪华，其他是连送
- (void)kkSendGift:(NSDictionary *)giftInfo andGiftType:(int )type;
//被踢出房间
- (void)kkKickOutRoomClose;
//刷新钻石数量
- (void)kkReloadChongzhi:(NSString *)coin;

//=========================用户和主播连麦==================
//用户发起的连麦，得到主播同意开始连麦
- (void)kkStartConnectvideo;
//用户发起的连麦，得到主播拒绝
- (void)kkEnabledlianmaibtn;
//主播或者用户断开连麦
- (void)kkNanchorHostout;//主播未响应（连麦）
//=============================================

//增加影票
- (void)kkAddVotesTatal:(NSString *)votes;
//连麦
- (void)kkplayLinkUserUrl:(NSString *)playurl andUid:(NSString *)userid;

//主播同意连麦
- (void)kkAnchor_agreeLink:(NSDictionary *)dic;
- (void)kkAnchor_stopLink:(NSDictionary *)dic;

//PK
- (void)kkShowPKView:(NSDictionary *)dic;
//- (void)kkShowPKButton;
- (void)kkShowPKResult:(NSDictionary *)dic;
- (void)kkChangePkProgressViewValue:(NSDictionary *)dic;

@end


@interface KKLiveViewerInfoModel : KKBaseModel

@property(nonatomic,assign)id<KKLiveViewerSocketDelegate>kkSocketDelegate;

//@"0";//房间类型 默认0普通房间
@property(nonatomic,strong)NSString *livetype;
//@"0";//收费房间价格，默认0
//@property(nonatomic,strong)NSString *type_val;

@property(strong,nonatomic)NSDictionary *kkLiveInfo;
//
@property(strong,nonatomic)socketMovieplay *socketDelegate;

- (void)kkLoadLiveViewerInfo:(NSDictionary *)liveInfo;

//点亮星星
- (void)kkStarMove;


@end

NS_ASSUME_NONNULL_END
