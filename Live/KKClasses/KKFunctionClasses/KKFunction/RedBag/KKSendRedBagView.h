//
//  KKSendRedBagView.h
//  LiveTV
//
//  Created by Peter on 2021/11/16.
//发红包

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKSendRedBagView : UIView
//弹窗回调
@property (nonatomic,copy) void(^kkPresentViewControllerBlock)(UIViewController *vc);
//发送红包回调
@property (nonatomic,copy) void(^kkSendRedBagBlock)(NSString *redBagID,NSString *message,NSString *coin);

-(void)kkShow;
-(void)kkDismiss;

@property (nonatomic,assign) BOOL kkIsGroup;


@end


NS_ASSUME_NONNULL_END


