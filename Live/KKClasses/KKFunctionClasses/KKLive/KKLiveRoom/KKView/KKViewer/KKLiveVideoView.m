//
//  KKLiveVideoView.m
//  yunbaolive
//
//  Created by Peter on 2021/3/18.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveVideoView.h"


#import <TXLiteAVSDK_Professional/TXLiveBase.h>
#import <TXLiteAVSDK_Professional/TXVodPlayer.h>
#import <TXLiteAVSDK_Professional/TXVodPlayListener.h>

@interface KKLiveVideoView ()<TXVodPlayListener>


@property (nonatomic, strong) TXVodPlayer   *kkPlayer;

@end
@implementation KKLiveVideoView



- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        UIView *kkPlayerView = [[UIView alloc]init];
        self.kkPlayerView = kkPlayerView;
        [self addSubview:kkPlayerView];
        kkPlayerView.backgroundColor = [UIColor clearColor];
        
        //添加子控件
//        [self kkInitView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.kkPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setKkIsCanPlay:(BOOL)kkIsCanPlay
{
    _kkIsCanPlay = kkIsCanPlay;
    
    if (kkIsCanPlay) {
        [self onPlayVideo];
    }else{
        [self kkPause];
    }
    
}

- (void)setKkLiveInfo:(NSDictionary *)kkLiveInfo
{
    _kkLiveInfo = kkLiveInfo;
}


- (void)onPlayVideo
{
    NSString *kkURL =  [minstr([self.kkLiveInfo valueForKey:@"pull"])  stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLQueryAllowedCharacterSet]];
//    六道2.7.5
    if (self.kkPlayer) {
        [self kkPause];
    }
    [TXLiveBase setLogLevel:LOGLEVEL_NULL];
    [TXLiveBase setConsoleEnabled:NO];
    
    _kkPlayer = [TXVodPlayer new];
    [_kkPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    _kkPlayer.loop = YES;
    [self.kkPlayer setupVideoWidget:self.kkPlayerView insertIndex:0];
    _kkPlayer.vodDelegate = self;

    if ([self.kkPlayer startPlay:kkURL] == 0) {
        KKLog(@"播放成功");
    }else{
        KKLog(@"失败");
    }
    
    
}

- (void)kkPlay
{
    NSString *kkURL =  [minstr([self.kkLiveInfo valueForKey:@"pull"])  stringByAddingPercentEncodingWithAllowedCharacters:[ NSCharacterSet URLQueryAllowedCharacterSet]];
    if ([self.kkPlayer startPlay:kkURL] == 0) {
        // 这里可加入缓冲视图
    }else {
    }

}
- (void)kkPause
{
    if (_kkPlayer) {
        [self.kkPlayer stopPlay];
        // 移除播放视图
        [self.kkPlayer removeVideoWidget];
        self.kkPlayer = nil;
    }

}


#pragma mark - TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    switch (EvtID) {
        case PLAY_EVT_CHANGE_RESOLUTION: {  // 视频分辨率改变
            float width  = [param[@"EVT_PARAM1"] floatValue];
            float height = [param[@"EVT_PARAM2"] floatValue];

            if (width > height) {
                [player setRenderMode:RENDER_MODE_FILL_EDGE];
            }else {
                [player setRenderMode:RENDER_MODE_FILL_SCREEN];
            }
        }
            break;
        case PLAY_EVT_PLAY_LOADING:{    // loading
//            if (self.status == GKDYVideoPlayerStatusPaused) {
//                [self playerStatusChanged:GKDYVideoPlayerStatusPaused];
//            }else {
//                [self playerStatusChanged:GKDYVideoPlayerStatusLoading];
//            }
        }
            break;
        case PLAY_EVT_PLAY_BEGIN:{    // 开始播放
//            [self playerStatusChanged:GKDYVideoPlayerStatusPlaying];
        }
            break;
        case PLAY_EVT_PLAY_END:{    // 播放结束
//            if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
//                [self.delegate player:self currentTime:self.duration totalTime:self.duration progress:1.0f];
//            }
//
//            [self playerStatusChanged:GKDYVideoPlayerStatusEnded];
        }
            break;
        case PLAY_ERR_NET_DISCONNECT:{    // 失败，多次重连无效
//            [self playerStatusChanged:GKDYVideoPlayerStatusError];
        }
            break;
        case PLAY_EVT_PLAY_PROGRESS:{    // 进度

        }
            break;
            
        default:
            break;
    }
}
-(void) onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*)param
{
    
}

@end


