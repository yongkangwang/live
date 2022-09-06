//
//  KKTRTCVideoView.h
//  yunbaolive
//
//  Created by Peter on 2021/4/22.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKTRTCVideoView : UIView

//是否是主播端
@property (nonatomic,assign) BOOL kkIsAnchor;

/// 视频当前播放时间
//@property (nonatomic) CGFloat playCurrentTime;
@property(strong,nonatomic)NSMutableDictionary *kkCurrentVideoDic;

// 主播同步播放进度
@property (nonatomic,copy) void(^kkVideoProgressChangeBlock)(CGFloat progress);
//获取到的videoURL弹框
@property (nonatomic,copy) void(^kkShowVideoURLAlertBlock)(UIAlertController *alert);
//显示选择视频视图
@property (nonatomic,copy) void(^kkChoiceVideoBlock)(NSString *str);
//切换视频网页
@property (nonatomic,copy) void(^kkChangeWebURLBlock)(NSDictionary *dic);
//切换视频
@property (nonatomic,copy) void(^kkChangeVideoBlock)(NSMutableDictionary *dic);
//视频播放状态1播放，2暂停
@property (nonatomic,copy) void(^kkVideoStateBlock)(NSInteger state);



//切换videoURL
//- (void)kkChangeVideoURL:(NSString *)url;

//主播同步用户端视频
- (void)kkChangeVideoInfo:(NSDictionary *)dic;

//用户同步视频进度
- (void)kkVideoProgressChange:(NSString *)progress;

//暂停
- (void)kkPause;
//播放
- (void)kkResume;

//重置player
- (void)kkResetPlayer;



@end

NS_ASSUME_NONNULL_END


