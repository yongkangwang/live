//
//  KKTRTCVoiceCollectionViewCell.m
//  yunbaolive
//
//  Created by Peter on 2021/3/26.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKTRTCVoiceCollectionViewCell.h"

#import "KKTRTCRoomCellModel.h"

@interface KKTRTCVoiceCollectionViewCell ()

@property(weak,nonatomic)UIImageView *kkUserImgV;
@property(weak,nonatomic)UILabel *kkNameLab;
//
@property(weak,nonatomic)UIImageView *kkGenderImgV;
@property(weak,nonatomic)UIImageView *kkLevelImgV;



@property(weak,nonatomic)UIImageView *kkLockImgV;

@end

@implementation KKTRTCVoiceCollectionViewCell



- (void)initializeViews
{
    [super initializeViews];
    [self setupUI];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self setupFrame];
}
- (void)setupUI
{
    UIImageView *kkUserImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:kkUserImgV];
    self.kkUserImgV = kkUserImgV;
    kkUserImgV.contentMode = UIViewContentModeScaleAspectFill;

    UILabel *kkNameLab = [[UILabel alloc]init];
    self.kkNameLab = kkNameLab;
    [self.contentView addSubview:kkNameLab];
    kkNameLab.textColor = [UIColor colorWithHexString:@"#B8CAE4"];
    kkNameLab.font = KKLab11Font;
    kkNameLab.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *kkGenderImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:kkGenderImgV];
    self.kkGenderImgV = kkGenderImgV;
    kkGenderImgV.contentMode = UIViewContentModeScaleAspectFill;

    UIImageView *kkLevelImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:kkLevelImgV];
    self.kkLevelImgV = kkLevelImgV;
    kkLevelImgV.contentMode = UIViewContentModeScaleAspectFill;

    UIImageView *kkLockImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:kkLockImgV];
    self.kkLockImgV = kkLockImgV;
    kkLockImgV.contentMode = UIViewContentModeScaleAspectFill;
    kkLockImgV.hidden = YES;
}

- (void)setupFrame
{
    [self.kkUserImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
    self.kkUserImgV.layer.mask =  [[YBToolClass sharedInstance] kkSetViewCornerRadius:25 fromView:self.kkUserImgV];

    [self.kkNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkUserImgV);
        make.top.mas_equalTo(self.kkUserImgV.mas_bottom).mas_offset(2);
        make.width.mas_equalTo(self.kkUserImgV);
    }];
    
    [self.kkGenderImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.kkUserImgV);
        make.width.height.mas_equalTo(15);
    }];

    [self.kkLevelImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.mas_equalTo(self.kkUserImgV);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(14);
    }];

    [self.kkLockImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkUserImgV);
    }];
    self.kkLockImgV.layer.mask =  [[YBToolClass sharedInstance] kkSetViewCornerRadius:25 fromView:self.kkLockImgV];

}

- (void)updateWithCGXPageCollectionCellModel:(CGXPageCollectionBaseRowModel *)cellModel AtIndex:(NSInteger)index
{

    KKTRTCRoomCellModel *kkmodel = cellModel.dataModel;
    
    [self.kkUserImgV sd_setImageWithURL:[NSURL URLWithString:kkmodel.pictureUrl] placeholderImage:[UIImage imageNamed:@"kkTRTCVoiceRoom_placeholder_icon"]];
    
    [self.kkLevelImgV sd_setImageWithURL:[NSURL URLWithString:kkmodel.level]];
    if (kkmodel.gender == 1) {//男
        self.kkGenderImgV.image = [UIImage imageNamed:@"kkTRTCVoiceRoom_man_icon"];;
    }else if (kkmodel.gender == 2){
        self.kkGenderImgV.image = [UIImage imageNamed:@"kkTRTCVoiceRoom_woman_icon"];;
    }

    if (index == 0) {
        self.kkNameLab.text = @"主播位";
        self.kkLevelImgV.hidden = NO;
        self.kkGenderImgV.hidden = NO;
    }else{
        if (kkmodel.status == 1) {
            self.kkNameLab.text = kkmodel.name;
            self.kkLevelImgV.hidden = NO;
            self.kkGenderImgV.hidden = NO;
        }else{
            self.kkNameLab.text = [NSString stringWithFormat:@"%zd号位",index];
            self.kkLevelImgV.hidden = YES;
            self.kkGenderImgV.hidden = YES;

        }
    }
    
    
    if (kkmodel.kkIsLock) {
        self.kkLockImgV.image = [UIImage imageNamed:@"kkTRTCVoiceRoom_lock_icon"];
        self.kkLockImgV.hidden = NO;
        self.kkNameLab.text = @"麦位已锁定";
    }else{
        self.kkLockImgV.hidden = YES;
        if (kkmodel.kkIsMute) {
            self.kkLockImgV.image = [UIImage imageNamed:@"kkTRTCVoiceRoom_lock_icon"];
            self.kkLockImgV.hidden = NO;
        }else{
            self.kkLockImgV.hidden = YES;
        }
    }
    
}
@end
