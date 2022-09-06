//
//  KKHorizontalView.h
//  yunbaolive
//
//  Created by Peter on 2020/9/28.
//  Copyright © 2020 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKLiveRoomBottomFunctionModel;

@protocol KKHorizontalViewDelegate <NSObject>

-(void)kkZhuboInfoClick;//点击主播弹窗
-(void)guanzhuZhuBo;//关注zhubo
-(void)kkgongxianbang;//跳贡献榜

//切换竖屏
- (void)kkPortraitBtnClickBlock;
  
//礼物
- (void)kkHorizontalGiftBtnClick;
//清屏，隐藏功能视图
- (void)kkContentViewClearClick;
//消息输入框
- (void)kkTextBtnClick;

//底部功能按钮
//- (void)kkBottomBtnClick:(KKLiveRoomBottomFunctionModel *)model;
//轮播图
- (void)kkHorizontalCycleScrollViewDidSelectWithUrl:(NSString *)url;


@end

@interface KKHorizontalView : UIView

@property (nonatomic,weak) id<KKHorizontalViewDelegate> kkHorizontalViewDelegate;

@property(strong,nonatomic)NSDictionary *kkLiveDic;

@property(strong,nonatomic)NSArray *kkRowDataArr;
@property(strong,nonatomic)NSMutableArray *bannerArray;


@end

NS_ASSUME_NONNULL_END
