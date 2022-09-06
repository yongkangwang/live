//
//  KKMacroDefinition.h
//  yunbaolive
//
//  Created by Peter on 2019/12/19.
//  Copyright © 2019 cat. All rights reserved.
//

#ifndef KKMacroDefinition_h
#define KKMacroDefinition_h

#ifdef DEBUG
//测试
# define KKLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
//生产
//#define BaseUrl @"/"
# define KKLog(...)

#endif



//缓存的域名类型，1、2、3
#define kkCacheNetworkURLType @"kkCacheNetworkURLType"

#define kkOneHDNetworkURL @""
#define kkOneHLNetworkURL @""


//设备唯一标识，app删掉后会重置
#define kkIDFAstring @"kkIDFstring"

//2.8.1-823
#define LiveRoomLocalize(Context) [NSString stringWithFormat:@"%@",Context]

//相芯美颜
#define FUNSLocalizedString(Context,comment)  [NSString stringWithFormat:@"%@", [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(Context) value:nil table:nil]]


//字号
#define KKTitleFont24 [UIFont systemFontOfSize:24]

#define KKTitleFont18 [UIFont systemFontOfSize:18]
#define KKTitleFont15 [UIFont systemFontOfSize:15]

#define KKTitleFont [UIFont systemFontOfSize:16]
#define KKTitleFont14 [UIFont systemFontOfSize:14]
#define KKPhoenFont13  [UIFont systemFontOfSize:13]

#define KKPhoenFont  [UIFont systemFontOfSize:13.3]
#define KKLabelFont  [UIFont systemFontOfSize:12]
#define KKLab11Font  [UIFont systemFontOfSize:11]

#define KKSmallFont  [UIFont systemFontOfSize:8]
//字体
#define kkFontWithName(Name,sizeThin)   [UIFont fontWithName:(Name) size:(sizeThin)]

//苹方-简 中粗体 PingFangSC-Semibold   加粗Helvetica-Bold这个字重不存在
#define kkFontBoldMT(sizeThin)   [UIFont fontWithName:@"PingFangSC-Semibold" size:(sizeThin)]
//常规字体，苹果默认的就是这个
#define kkFontRegularMT(sizeThin)   [UIFont fontWithName:@"PingFangSC-Regular" size:(sizeThin)]


//颜色
//主题色
#define KKNormalColorStr @"#f32d70"

#define KKNormalColor [UIColor colorWithHexString:@"#f32d70"]
//文字白色
#define KKWhiteColor [UIColor colorWithHexString:@"#ffffff"]
#define KKBgGrayColor [UIColor colorWithHexString:@"#f5f5f5"]


#define KKPinkColor [UIColor colorWithHexString:@"f49a2f"]
#define KKBgViewColor [UIColor colorWithHexString:@"#fd6c9c"]
#define KKBlackLabColor [UIColor colorWithHexString:@"#333333"]
#define KKBlackTitleLabColor [UIColor colorWithHexString:@"#000000"]
#define KKBtnColor [UIColor colorWithHexString:@"#e13a71"]
#define KKDividingLineColor [UIColor colorWithHexString:@"#e5e5e5"]
#define KKDivideLineColor2 [UIColor colorWithHexString:@"#EDEDED"]

#define KKRGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define KKRGB(r, g, b) KKRGBA(r,g,b,1)
//
#define GKColorRGBA(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define GKColorRGB(r, g, b)     GKColorRGBA(r, g, b, 1.0)

// 屏幕适配
#define KKScreen_bounds [[UIScreen mainScreen] bounds]
#define KKScreenHeight [UIScreen mainScreen].bounds.size.height
#define KKScreenWidth [UIScreen mainScreen].bounds.size.width

//pageviewcontroller宽度
#define _pageBarWidth  (KKScreenWidth *0.9)
//kk六道修改 导航栏分页控制器宽度
//#define _pageBarWidth  KKScreenWidth

// 以6、6s、7、7s、8的宽度为基准进行比例缩放
///针对iphone7适配     iphonex  375   812( 734 )   分辨率1125x2436
#define  KKScale_Width_i7(obj)  ([UIScreen mainScreen].bounds.size.width/375.0f)*obj
#define  KKScale_Height_i7(obj) ([UIScreen mainScreen].bounds.size.height/812.0f)*obj


//底部安全高度
#define ShowDiff (iPhoneX ? 34: 0)
//这个在接入抖音视频后就获取不准了，导致导航高度不够，具体原因未查。
#define statusbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height-20)

//导航栏+状态栏高度
#define KKNavH (kkNavHeight + kkStatusbarH)
/*TabBar高度*/
#define kkTabBarHeight (49.0 + ShowDiff)

/** 获取状态栏高度,顶部安全区域远离高度*/
#define kkStatusbarH (iPhoneX ? 44.f: 20.f)
//导航栏高度
#define kkNavHeight 44.f


///字符串判空
#define KKVALUE_STRING(valueString) valueString && ![valueString isKindOfClass:[NSNull class]] ?  [valueString description]:@""


//基础标识
#define KKBaseTag 200

//缓存用户手机号
#define KKUserDefaults [NSUserDefaults standardUserDefaults]

///以下是缓存数据

#define KKFloatCache @"KKFloatCache"
#define KKFloatCacheKey @"KKFloatCacheKey"

//1 url链接 2显示游戏列表
#define KKGameCenterType  @"KKGameCenterType"

//用户手机号
#define KKUserPhoneNum @"userPhoneNum"

// 1主播端 2 聊端 nil 普通用户
#define KKUserLoginType @"UserLoginType"

//渠道统计
#define KKtuijianuserid @"tuijianuserid"//推荐用户id
#define KKqudaoid  @"qudaoid"//来源渠道id
#define KKCompanyURLImage  @"KKCompanyURLImage"//公司网址水印图片

//一键登录
#define KKJVAuthConfigAPPKEY @"KKJVAuthConfigAPPKEY"



//用来复用首页热门视图  1.直播热门  2。聊在线
#define KKPushLiveType @"KKPushLiveType"

//数盟 2.7.6废弃了
#define KKShuMengCDID @"KKShuMengCDID"

//游戏提醒群
#define KKLiveGroupMessageID @"KKLiveGroupMessageID"
//聊天大群
#define KKLiveGroupChatID @"KKLiveGroupChatID"
//聊天大群名字
#define KKLiveGroupChatName @"KKLiveGroupChatName"

//客服id、名字、头像
#define KKPhoneServiceChatID @"KKPhoneServiceChatID"
#define KKPhoneServiceChatName @"KKPhoneServiceChatName"
#define KKPhoneServiceChatIcon @"KKPhoneServiceChatIcon"



//聊天上边提示文字
#define KKLiveChatPromptString @"KKLiveChatPromptString"

#define KKRedBagMessageCellIDFA @"KKRedBagMessageCellIDFA"



///以上是缓存数据

//检查版本更新的密匙
#define KKAppVersionCheckingkey @""

//视图封面默认图
#define kkPlaceholderCoverIconStr @"kkplaceholder_cover_icon"
//头像默认图
#define kkPlaceholderHeadIconImageStr @"KKPlaceholder_Face_icon"
//聊头像默认图
#define kkPlaceholderChatHeadIconImageStr @"KKChatPlaceholder_Face_icon"

#define kkTakeScreenshotImageName @"kkTakeScreenshotImageName"


//悬浮窗开关，1开启 0关闭，默认关闭
#define kkPIPSwitch @"kkPIPSwitch"
//礼物动效， 1开启，0关闭，默认开启
#define kkGiftDynamic @"kkGiftDynamic"

//上传的图片压缩系数，1-0，越小越模糊,但数据量越小，
#define kkImageCompress 1


//kk通知
#define kkNotifCenter [NSNotificationCenter defaultCenter]

//竖屏
#define kkVerticalBtnClickNotif  @"kkVerticalBtnClickNotif"

#define kkLaunchAdShowFinish  @"kkLaunchAdShowFinish"
#define kkAppVersionShowFinish @"kkAppVersionShowFinish"//app版本检查完毕
#define kkStartPipWithObject @"kkStartPipWithObject"//开启画中画
#define kkClosePIPViewNotifi @"kkClosePIPViewNotifi"//关闭画中画
#define kkLoginVideoStopPlay @"kkLoginVideoStopPlay"//关闭登录页视频播放
#define kkTakeScreenshotImage @"kkTakeScreenshotImage"//截图通知

#define kkMusicPlayNotif @"kkMusicPlayNotif"//直播BGM播放


#define kkDeleteAllConversationNotifi @"kkDeleteAllConversationNotifi"//清空会话列表
#define kkIsRefreshMessageViewController @"kkIsRefreshMessageViewController"//刷新会话列表
#define kkGroupChatUnreadNumNotifi @"kkGroupChatUnreadNumNotifi"//获取群未读计数
#define kkNotification_onChangeUnReadCount @"kkNotification_onChangeUnReadCount"//更新总的未读计数
#define kkNotification_V2IMMessageListener @"kkNotification_V2IMMessageListener"//新消息

#define kkNotification_WXApiDelegatePayMessageListener @"kkNotification_WXApiDelegatePayMessageListener"//微信支付回调

#define kkChatListUnreadNumNotifi @"kkChatListUnreadNumNotifi"//获取会话列表未读计数


#define kkCalledAgreeNotfi @"kkCalledAgreeNotfi"//被叫视频、语音同意

//TRTC视频群消息指令类型,用于一起看公开房
#define KKIMCMD_VIDEO_SYNCHRONOUS       4    //同步视频播放
#define KKIMCMD_VIDEO_PLAY              5    //视频播放
#define KKIMCMD_USER_VIDEO_SYNCHRONOUS  6    //观众同步主播视频进度
#define KKIMCMD_USER_VIDEO_PLAY         7    //观众申请播放视频
#define KKIMCMD_ANCHOR_VIDEO_PLAY_PAUSE 8    //主播恢复播放或暂停

//TRTC视频群消息指令类型,用于一起看私密房
#define KKIMCMD_PRIVATE_VIDEO_PLAY              21    //视频播放
#define KKIMCMD_PRIVATE_USER_VIDEO_SYNCHRONOUS  22    //同步主播视频进度
#define KKIMCMD_PRIVATE_ANCHOR_VIDEO_PLAY_PAUSE 23    //主播恢复播放或暂停
#define KKIMCMD_PRIVATE__VIDEO_PLAYING          24    //进入房间就开始播放视频


#define KKCallStateChange @"KKCallStateChange"//1V1通话状态


#endif /* KKMacroDefinition_h */

