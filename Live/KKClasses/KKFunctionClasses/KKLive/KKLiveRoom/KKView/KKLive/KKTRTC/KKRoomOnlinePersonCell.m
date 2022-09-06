//
//  KKRoomOnlinePersonCell.m
//  yunbaolive
//
//  Created by Peter on 2021/5/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKRoomOnlinePersonCell.h"


@interface KKRoomOnlinePersonCell ()

@property(weak,nonatomic)UILabel *kkRankLab;
@property(weak,nonatomic)UIImageView *kkIconImgV;
//@property(weak,nonatomic)UIImageView *kkLeveImgV;
@property(weak,nonatomic)UILabel *kkNameLab;
@property(weak,nonatomic)UILabel *kkContributionLab;//消费贡献票数

@end

@implementation KKRoomOnlinePersonCell

- (void)initializeViews
{
    [super initializeViews];
    [self setupUI];
}
- (void)setupUI
{
//    self.contentView.backgroundColor = [UIColor clearColor];
    
    UILabel *kkRankLab = [UILabel kkLabelWithText:@"" textColor:KKBlackLabColor textFont:KKTitleFont14 andTextAlignment:NSTextAlignmentCenter];
    self.kkRankLab = kkRankLab;
    [self.contentView addSubview:kkRankLab];

    UIImageView *kkIconImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:kkIconImgV];
    self.kkIconImgV = kkIconImgV;
    kkIconImgV.contentMode = UIViewContentModeScaleAspectFill;
    kkIconImgV.clipsToBounds = YES;

//    UIImageView *kkLeveImgV = [[UIImageView alloc]init];
//    [self.contentView addSubview:kkLeveImgV];
//    self.kkLeveImgV = kkLeveImgV;
//    kkLeveImgV.contentMode = UIViewContentModeScaleAspectFill;
//    kkLeveImgV.clipsToBounds = YES;

    UILabel *kkNameLab = [[UILabel alloc]init];
    self.kkNameLab = kkNameLab;
    [self.contentView addSubview:kkNameLab];
    kkNameLab.textColor = KKBlackLabColor;
    kkNameLab.font = KKTitleFont14;
    kkNameLab.textAlignment = NSTextAlignmentLeft;
    
    UILabel *kkContributionLab = [UILabel kkLabelWithText:@"" textColor:[UIColor colorWithHexString:@"#000000"] textFont:KKTitleFont14 andTextAlignment:NSTextAlignmentRight];
    self.kkContributionLab = kkContributionLab;
    [self.contentView addSubview:kkContributionLab];

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.kkRankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(15);
    }];

    [self.kkIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRankLab);
        make.left.mas_equalTo(self.kkRankLab.mas_right).mas_offset(8);
        make.width.height.mas_equalTo(37);
    }];
    self.kkIconImgV.layer.mask =  [[YBToolClass sharedInstance] kkSetViewCornerRadius:37/2 fromView:self.kkIconImgV];
//    [self.kkLeveImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.kkRankLab);
//        make.left.mas_equalTo(self.kkIconImgV.mas_right).mas_offset(10);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(14);
//    }];

    [self.kkNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRankLab);
        make.left.mas_equalTo(self.kkIconImgV.mas_right).mas_offset(10);
    }];
    [self.kkContributionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkRankLab);
        make.right.mas_equalTo(-15);
    }];

    
}

- (void)updateWithCGXPageCollectionCellModel:(CGXPageCollectionBaseRowModel *)cellModel AtIndex:(NSInteger)index
{
    NSDictionary *kkmodel = cellModel.dataModel;
    [self.kkIconImgV sd_setImageWithURL:[NSURL URLWithString:kkmodel[@"avatar_thumb"]] placeholderImage:[UIImage imageNamed:kkPlaceholderCoverIconStr]];
    self.kkNameLab.text = kkmodel[@"user_nicename"];
    self.kkContributionLab.text = kkmodel[@"contribution"];
    self.kkRankLab.text = [NSString stringWithFormat:@"%zd",(index +1)];
    if (index ==0) {
        self.kkRankLab.textColor = [UIColor colorWithHexString:@"#FF1438"];
    }else if (index == 1){
        self.kkRankLab.textColor = [UIColor colorWithHexString:@"#FF6F44"];
    }else if (index == 2){
        self.kkRankLab.textColor = [UIColor colorWithHexString:@"#FBC849"];
    }else{
        self.kkRankLab.textColor = [UIColor colorWithHexString:@"#999999"];
    }
//    leve
//    NSDictionary *levelDic = [common getUserLevelMessage:kkmodel[@"leve"]];
//    [self.kkLeveImgV sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
    
}
@end
