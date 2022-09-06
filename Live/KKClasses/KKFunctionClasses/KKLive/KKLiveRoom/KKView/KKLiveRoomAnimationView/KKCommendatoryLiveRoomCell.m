//
//  KKCommendatoryLiveRoomCell.m
//  yunbaolive
//
//  Created by Peter on 2021/11/10.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKCommendatoryLiveRoomCell.h"


#import "hotModel.h"

@interface KKCommendatoryLiveRoomCell ()
//背景图
@property(weak,nonatomic)UIImageView *kkbgImgView;
//阴影遮罩
@property(weak,nonatomic)UIImageView *kkCoverImgV;
@property (nonatomic,weak) UILabel *kkUserNameLab;

@end

@implementation KKCommendatoryLiveRoomCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {

        [self setupUI];

    }
    return self;
}

- (void)setupUI
{
    UIImageView *kkbgImgView = [[UIImageView alloc]init];
    [self.contentView addSubview:kkbgImgView];
    self.kkbgImgView = kkbgImgView;
    kkbgImgView.contentMode = UIViewContentModeScaleAspectFill;
    kkbgImgView.clipsToBounds = YES;//要配合这个使用
    
    UIImageView *kkCoverV = [[UIImageView alloc]init];
    [self.contentView addSubview:kkCoverV];
    self.kkCoverImgV = kkCoverV;
    kkCoverV.image =[UIImage imageNamed:@"KK1V1Cover_public_icon"];

       
    UILabel *kkuserNameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:kkuserNameLabel];
    self.kkUserNameLab = kkuserNameLabel;
    kkuserNameLabel.font = kkFontBoldMT(12);
    kkuserNameLabel.textColor = KKWhiteColor;
    kkuserNameLabel.textAlignment  = NSTextAlignmentCenter;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat kkLeft = 5;
    [self.kkbgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];

    [self.kkCoverImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.kkbgImgView);
    }];
    
    [self.kkUserNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kkLeft);
        make.left.mas_equalTo(kkLeft);
        make.right.mas_equalTo(-kkLeft);
    }];

}

- (void)setKkProductModel:(hotModel *)kkProductModel
{
    _kkProductModel = kkProductModel;
    self.kkUserNameLab.text = kkProductModel.zhuboName;

    [self.kkbgImgView sd_setImageWithURL:[NSURL URLWithString:kkProductModel.zhuboIcon] placeholderImage:[UIImage imageNamed:kkPlaceholderHeadIconImageStr]];
}

@end
