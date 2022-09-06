//
//  KKLiveViewerView.h
//  yunbaolive
//
//  Created by Peter on 2021/3/17.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KKLiveRoomBottomFunctionModel.h"

@class KKHorizontalView;

NS_ASSUME_NONNULL_BEGIN

@protocol KKLiveViewerViewDelegate <NSObject>

//横屏
- (void)kkPortraitBtnClick;

//上下麦弹框
- (void)kkShowAlertMicrophone:(UIAlertController *)alert;


@end

@interface KKLiveViewerView : UIView

@property(nonatomic,assign)id<KKLiveViewerViewDelegate>kkViewerViewDelegate;

//关闭
//@property (nonatomic,copy) void(^kkCloseBtnClickBlock)(void );
//创建房间
@property (nonatomic,copy) void(^kkCreateBtnClickBlock)(NSString *model);

//房间信息
@property(strong,nonatomic)NSDictionary *kkLiveInfo;



//是否要播放视频
@property (nonatomic,assign) BOOL kkIsCanPlay;

//总的列表主播数据
@property(strong,nonatomic)NSMutableArray *kkScrollarray;

//kk记录当前选中的cell下标,由上层控制器赋值
@property (nonatomic,assign) NSInteger kkcurrentSelectItemIndex;


//遮罩点击
- (void)kkCoverBtnClick;

//内部属性，外部使用
@property(strong,nonatomic)KKLiveRoomBottomFunctionModel *kkBottomModel;

//横屏
- (void)kkShowHorizontalView:(KKHorizontalView *)kkHorizontalView;

@end

NS_ASSUME_NONNULL_END



