//
//  KKLiveSocketInfoModel.h
//  yunbaolive
//
//  Created by Peter on 2021/4/1.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKBaseModel.h"

#import "socketLive.h"

//主播端
NS_ASSUME_NONNULL_BEGIN


@protocol KKLiveSocketInfoDelegate <NSObject>

@optional;


//用户进入直播间
- (void)kkUserComeIn:(NSDictionary *)dic;

//顶部观众信息 和直播间人数
- (void)kkChangeLookLivePersion:(NSDictionary *)dic andPersionCount:(long long)count;

//socket消息
- (void)kkSocketMessageSuccess:(NSDictionary *)dic;

//房间被管理员关闭,关闭直播间
- (void)kkRoomCloseByAdmin;
//弹幕
- (void)kksendBarrage:(NSDictionary *)dic;

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


//增加影票
- (void)kkAddVotesTatal:(NSString *)votes;


//======================================================
//用户和主播连麦，主播同意
- (void)kkAnchor_agreeUserLink:(NSDictionary *)dic;
//用户和主播连麦,用户接到主播同意，发送自己的流，连麦， 连麦成功，拉取连麦用户的流
- (void)kkplayLinkUserUrl:(NSString *)playurl andUid:(NSString *)userid;
//用户下麦
- (void)kkusercloseConnect:(NSString *)uid;



//======================================================

//主播同意连麦
- (void)kkAnchor_agreeLink:(NSDictionary *)dic;
- (void)kkAnchor_stopLink:(NSDictionary *)dic;

//PK
//- (void)kkShowPKView:(NSDictionary *)dic;
- (void)kkShowPKView;
- (void)kkShowPKButton;
- (void)kkShowPKResult:(NSDictionary *)dic;
- (void)kkChangePkProgressViewValue:(NSDictionary *)dic;

@end

@interface KKLiveSocketInfoModel : KKBaseModel

@property(nonatomic,assign)id<KKLiveSocketInfoDelegate>kkSocketDelegate;

@property(strong,nonatomic)NSDictionary *kkLiveInfo;
//
@property(strong,nonatomic)socketLive *kkSocketLive;

- (void)kkLoadLiveViewerInfo:(NSDictionary *)liveInfo;

//点亮星星
- (void)kkStarMove;


@end

NS_ASSUME_NONNULL_END


