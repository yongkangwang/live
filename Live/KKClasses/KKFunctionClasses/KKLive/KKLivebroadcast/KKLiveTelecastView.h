//
//  KKLiveTelecastView.h
//  yunbaolive
//
//  Created by Peter on 2021/10/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKLiveTelecastViewDelegate <NSObject>

//关闭预览
- (void)kkClosePreView;
//关闭直播间
- (void)kkCloseLiveRoom;

//
- (void)kkPresentAlertContro:(UIViewController *)alert;


@end


@interface KKLiveTelecastView : UIView
@property (nonatomic,weak) id<KKLiveTelecastViewDelegate> kkDelegate;

//初始化视图
- (void)kkInitPreview;

@end

NS_ASSUME_NONNULL_END



