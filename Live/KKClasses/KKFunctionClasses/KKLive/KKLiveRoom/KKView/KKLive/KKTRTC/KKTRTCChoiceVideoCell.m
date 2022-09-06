//
//  KKTRTCChoiceVideoCell.m
//  yunbaolive
//
//  Created by Peter on 2021/4/26.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKTRTCChoiceVideoCell.h"

@interface KKTRTCChoiceVideoCell ()
@property(weak,nonatomic)UIImageView *kkIconImgV;
@property(weak,nonatomic)UILabel *kkNameLab;

@end

@implementation KKTRTCChoiceVideoCell

- (void)initializeViews
{
    [super initializeViews];
    [self setupUI];
}
- (void)setupUI
{
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *kkIconImgV = [[UIImageView alloc]init];
    [self.contentView addSubview:kkIconImgV];
    self.kkIconImgV = kkIconImgV;
    kkIconImgV.contentMode = UIViewContentModeScaleAspectFill;
    kkIconImgV.clipsToBounds = YES;
    
    UILabel *kkNameLab = [[UILabel alloc]init];
    self.kkNameLab = kkNameLab;
    [self.contentView addSubview:kkNameLab];
    kkNameLab.textColor = [UIColor colorWithHexString:@"#FDFDFD"];
    kkNameLab.font = KKLabelFont;
    kkNameLab.textAlignment = NSTextAlignmentCenter;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.kkIconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(60);
    }];
    self.kkIconImgV.layer.mask =  [[YBToolClass sharedInstance] kkSetViewCornerRadius:13 fromView:self.kkIconImgV];

    [self.kkNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.contentView);
    }];

}

- (void)updateWithCGXPageCollectionCellModel:(CGXPageCollectionBaseRowModel *)cellModel AtIndex:(NSInteger)index
{
    NSDictionary *kkmodel = cellModel.dataModel;
    [self.kkIconImgV sd_setImageWithURL:[NSURL URLWithString:kkmodel[@"shipinguanli_tubiao"]] placeholderImage:[UIImage imageNamed:kkPlaceholderCoverIconStr]];
    self.kkNameLab.text = kkmodel[@"shipinguanli_name"];
    
}
@end
