//
//  KKTRTCVideoView.m
//  yunbaolive
//
//  Created by Peter on 2021/4/22.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKTRTCVideoView.h"

#import "SuperPlayerView.h"

//
@interface KKTRTCVideoView ()<SuperPlayerDelegate>

@property(weak,nonatomic)UIImageView *kkBGImgV;

//
@property(weak,nonatomic)UIView *kkSelectVideoView;
@property(weak,nonatomic)UILabel *kkTitleLab;

@property(weak,nonatomic)UIButton *kkSelectVideoBtn;

@property(weak,nonatomic)SuperPlayerView *playerView;

@property(strong,nonatomic)NSMutableDictionary *kkVideoInfoDic;

@end

@implementation KKTRTCVideoView

- (void)setKkIsAnchor:(BOOL)kkIsAnchor
{
    _kkIsAnchor = kkIsAnchor;
    self.playerView.kkIsAnchor = kkIsAnchor;
    
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        self.kkIsAnchor = NO;
        //添加子控件
        [self kkInitView];
    }
    return self;
}

- (void)kkInitView
{
    UIImageView *kkBGImgV = [[UIImageView alloc]init];
    [self addSubview:kkBGImgV];
    self.kkBGImgV = kkBGImgV;
    kkBGImgV.contentMode = UIViewContentModeScaleAspectFill;
    kkBGImgV.clipsToBounds = YES;
    kkBGImgV.image = [UIImage imageNamed:@"KKTRTCVideoView_BGImage_icon"];
    
    
    UIView *kkSelectVideoView = [[UIView alloc] init];
    self.kkSelectVideoView = kkSelectVideoView;
    [self addSubview:kkSelectVideoView];
    kkSelectVideoView.backgroundColor = [UIColor clearColor];

    UILabel *kkTitleLab = [[UILabel alloc]init];
    [self.kkSelectVideoView addSubview:kkTitleLab];
    self.kkTitleLab = kkTitleLab;
    kkTitleLab.textColor = [UIColor colorWithHexString:@"#FDFDFD"];
    kkTitleLab.font = KKPhoenFont13;
    kkTitleLab.textAlignment = NSTextAlignmentCenter;
    kkTitleLab.numberOfLines = 2;
    kkTitleLab.text = @" “独特的品味  要让更多人看到”";
    
    UIButton *kkSelectVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkSelectVideoView addSubview:kkSelectVideoBtn];
    self.kkSelectVideoBtn = kkSelectVideoBtn;
    [kkSelectVideoBtn setImage:[UIImage imageNamed:@"KKTRTCVideoView_selectBtn_icon"] forState:UIControlStateNormal];
    [kkSelectVideoBtn addTarget:self action:@selector(kkSelectVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    SuperPlayerView *playerView = [[SuperPlayerView alloc] init];
    self.playerView = playerView;
    playerView.hidden = YES;
    // 设置代理，用于接受事件
    playerView.delegate = self;
    // 设置父 View，_playerView 会被自动添加到 holderView 下面
    playerView.fatherView = self;
    playerView.kkVideoProgressChangeBlock = ^(CGFloat progress) {
//        if (self.kkChangeVideoBlock) {
//            self.kkChangeVideoBlock(self.kkCurrentVideoDic);
//        }
            if (self.kkVideoProgressChangeBlock) {
                self.kkVideoProgressChangeBlock(progress);
            }

    };

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.kkBGImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.kkSelectVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkSelectVideoView);
//        make.top.mas_equalTo(self.kkSelectVideoView.height/3);
        make.top.mas_equalTo(self.height/3);

        make.width.mas_equalTo(100);
    }];
    [self.kkSelectVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkTitleLab);
        make.top.mas_equalTo(self.kkTitleLab.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

}
  
//视频播放状态1播放，2暂停
- (void)kkVideoState:(NSInteger )state
{
    if (self.kkVideoStateBlock) {
        self.kkVideoStateBlock(state);
    }
}

//点击视频名字，弹出视频网页
- (void)kkVideoTitleClick:(NSDictionary *)videoDic
{
    if (self.kkChangeWebURLBlock) {
        self.kkChangeWebURLBlock(videoDic);
    }
}

//
- (void)kkPlayerChangeVideoBtnClick:(SuperPlayerView *)player
{
    [self kkSelectVideoBtnClick];
}
- (void)kkSelectVideoBtnClick
{
    if (self.kkChoiceVideoBlock) {
        self.kkChoiceVideoBlock(@"");
    }
}

//切换videoURL
- (void)kkChangeVideoURL:(NSString *)url
{
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
//    // 设置播放地址，直播、点播都可以
//        playerModel.videoURL = @"http://200024424.vod.myqcloud.com/200024424_709ae516bdf811e6ad39991f76a4df69.f20.mp4";
    playerModel.videoURL = url;
//    // 开始播放
    [self.playerView playWithModel:playerModel];
    self.playerView.hidden = NO;
    
    
}

//主播同步用户端视频
- (void)kkChangeVideoInfo:(NSDictionary *)dic
{
    if (!dic[@"url"]) {
        return;
    }
    self.kkVideoInfoDic = dic.mutableCopy;
//    [self.playerView kkPlayWithVideoInfo:dic];
    self.playerView.kkVideoInfoDic = dic;
    self.playerView.hidden = NO;

    if (self.kkChangeVideoBlock) {
        self.kkChangeVideoBlock(self.kkCurrentVideoDic);
    }
}

//用户同步视频进度
- (void)kkVideoProgressChange:(NSString *)progress
{
//    NSMutableDictionary *kkdic = self.kkVideoInfoDic;
//    kkdic[@"progress"] = progress;
    self.playerView.state = StatePlaying;
    [self.playerView seekToTime:[progress integerValue]];
}

//暂停
- (void)kkPause
{
    [self.playerView pause];
}
//播放
- (void)kkResume
{
    [self.playerView resume];
}

//重置player
- (void)kkResetPlayer
{
    [self.playerView resetPlayer];
}

- (CGFloat)playCurrentTime
{
    return self.playerView.playCurrentTime;
}

-(NSMutableDictionary *)kkCurrentVideoDic
{
    if (!_kkCurrentVideoDic) {
        _kkCurrentVideoDic = [NSMutableDictionary dictionary];
    }
    [self.kkVideoInfoDic setValue:[NSString stringWithFormat:@"%.f",self.playerView.playCurrentTime] forKey:@"progress"];
    if (self.playerView.state == StatePause) {
        [self.kkVideoInfoDic setValue:[NSString stringWithFormat:@"2"] forKey:@"playState"];
    }else{
        [self.kkVideoInfoDic setValue:[NSString stringWithFormat:@"1"] forKey:@"playState"];
    }
    
    _kkCurrentVideoDic = self.kkVideoInfoDic;
    return _kkCurrentVideoDic;
}



- (NSMutableDictionary *)kkVideoInfoDic
{
    if (!_kkVideoInfoDic) {
        _kkVideoInfoDic = [NSMutableDictionary dictionary];
    }
    return _kkVideoInfoDic;
}

@end
