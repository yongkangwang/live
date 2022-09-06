//
//  KKLiveVideoView.h
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface KKLiveVideoView : UIView

@property(strong,nonatomic)NSDictionary *kkLiveInfo;
//是否要播放视频
@property (nonatomic,assign) BOOL kkIsCanPlay;


//视频播放视图
@property(weak,nonatomic)UIView *kkPlayerView;

- (void)kkPlay;
- (void)kkPause;

@end

NS_ASSUME_NONNULL_END


