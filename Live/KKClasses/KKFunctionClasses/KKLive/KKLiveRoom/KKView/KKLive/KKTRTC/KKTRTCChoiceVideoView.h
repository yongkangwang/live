//
//  KKTRTCChoiceVideoView.h
//  yunbaolive
//
//  Created by Peter on 2021/4/26.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKTRTCChoiceVideoView : UIView

//获取到的videoURL弹框
@property (nonatomic,copy) void(^kkShowVideoURLAlertBlock)(UIAlertController *alert);
//主播端选择视频
@property (nonatomic,copy) void(^kkSelectVideoURLBlock)(NSString *url);

@property (nonatomic,copy) void(^kkCloseViewBlock)(NSString *url);
//用户端选择视频
@property (nonatomic,copy) void(^kkUserSelectVideoBlock)(NSMutableDictionary *dic);

//
- (void)kkChangeWebURL:(NSDictionary *)dic;
//-(void)kkShow;
//- (void)kkDismiss;

//是否是主播端 yes 主播
@property (nonatomic,assign) BOOL kkIsAnchor;

//是否是私密房 1一起看，2私密房,默认1
@property (nonatomic,assign) int  kkRoomType;

//刷新数据
- (void)kkRefreshData;

@end

NS_ASSUME_NONNULL_END



