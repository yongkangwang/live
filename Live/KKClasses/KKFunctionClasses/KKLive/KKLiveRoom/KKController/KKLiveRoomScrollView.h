//
//  KKLiveRoomScrollView.h
//  yunbaolive
//
//  Created by Peter on 2021/3/19.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKHorizontalView;

NS_ASSUME_NONNULL_BEGIN

@protocol KKLiveRoomScrollViewDelegate <NSObject>

//上下麦弹框
- (void)kkShowAlertMicrophone:(UIViewController *)alert;
//横屏
- (void)kkPortraitBtnClick:(NSString *)str;


@end



@interface KKLiveRoomScrollView : UIView

@property(nonatomic,assign)id<KKLiveRoomScrollViewDelegate>kkDelegate;

//上层控制器需要传的参数===================
//1是直播 2是一起看,默认首页
@property (nonatomic,assign) int kkLiveType;

//kk记录当前选中的cell下标,由上层控制器赋值
@property (nonatomic,assign) NSInteger kkcurrentSelectItemIndex;
//请求更多主播数据的分页控制
@property (nonatomic,assign) NSInteger kkLoadPage;
//竞技分类跳转进来时需要传这个参数，分类id
@property (nonatomic,copy) NSString * kkLiveSportsClassID;
//请求数据的服务器接口
//@property (nonatomic,copy) NSString * kkRoomListInfoURL;

// **总的主播数组
@property(nonatomic,strong)NSMutableArray *scrollarray;
//当前选中的主播信息
@property(nonatomic,strong)NSDictionary *playDoc;


//@property (nonatomic,copy) void(^kkShowAlertMicrophoneBlock)(UIAlertController *alert);

//横屏
//@property (nonatomic,copy) void(^kkPortraitBtnClickBlock)(NSString *str);

//
- (void)kkInitData;

//横屏
- (void)kkShowHorizontalView:(KKHorizontalView *)horizontalV;
//竖屏
- (void)kkShowPortrait;
@end

NS_ASSUME_NONNULL_END
