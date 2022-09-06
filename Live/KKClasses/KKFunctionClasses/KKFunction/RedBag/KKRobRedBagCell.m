//
//  KKRobRedBagCell.m
//  yunbaolive
//
//  Created by Peter on 2021/11/19.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKRobRedBagCell.h"


@interface KKRobRedBagCell ()

@property (nonatomic,weak) UIImageView *kkUserImgV;
@property (nonatomic,weak) UILabel *kkNameLab;
@property (nonatomic,weak) UILabel *kkTimeLab;

@property (nonatomic,weak) UILabel *kkCoinLab;
@property (nonatomic,weak) UILabel *kkBestLab;
@property (nonatomic,weak) UIImageView *kkBestImgV;

@end

@implementation KKRobRedBagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"KKRobRedBagCell";
    KKRobRedBagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        KKRobRedBagCell *cell = [[KKRobRedBagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = KKRGB(51, 51, 51);
        cell.backgroundColor = KKWhiteColor;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UIAccessibilityTraitNone;
    self.backgroundColor = KKWhiteColor;

    [self setUI];
    return self;
}

-(void)setUI
{
    UIImageView *kkUserImgV = [[UIImageView alloc]init];
    self.kkUserImgV = kkUserImgV;
    [self.contentView addSubview:kkUserImgV];

    
    UILabel *kkNameLab = [UILabel kkLabelWithText:@"name" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont systemFontOfSize:14] andTextAlignment:NSTextAlignmentLeft];
    self.kkNameLab = kkNameLab;
    [self.contentView addSubview:kkNameLab];

    UILabel *kkTimeLab = [UILabel kkLabelWithText:@"16:23" textColor:[UIColor colorWithHexString:@"#999999"] textFont:[UIFont systemFontOfSize:12] andTextAlignment:NSTextAlignmentLeft];
    self.kkTimeLab = kkTimeLab;
    [self.contentView addSubview:kkTimeLab];

    UILabel *kkCoinLab = [UILabel kkLabelWithText:@"100" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont systemFontOfSize:14] andTextAlignment:NSTextAlignmentRight];
    self.kkCoinLab = kkCoinLab;
    [self.contentView addSubview:kkCoinLab];

    UILabel *kkBestLab = [UILabel kkLabelWithText:@"手气最佳" textColor:[UIColor colorWithHexString:@"#333333"] textFont:[UIFont systemFontOfSize:12] andTextAlignment:NSTextAlignmentRight];
    self.kkBestLab = kkBestLab;
    [self.contentView addSubview:kkBestLab];
    kkBestLab.hidden = YES;

    UIImageView *kkBestImgV = [[UIImageView alloc]init];
    self.kkBestImgV = kkBestImgV;
    [self.contentView addSubview:kkBestImgV];
    kkBestImgV.image = [UIImage imageNamed:@"KKRedPacket_BestImgV"];
    kkBestImgV.hidden = YES;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.kkUserImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(37);
    }];
    
    [self.kkNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkUserImgV);
        make.left.mas_equalTo(self.kkUserImgV.mas_right).mas_offset(11);
    }];

    [self.kkTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkUserImgV);
        make.left.mas_equalTo(self.kkNameLab);
    }];

    [self.kkCoinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkNameLab);
        make.right.mas_equalTo(-15);
    }];

    [self.kkBestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTimeLab);
        make.right.mas_equalTo(self.kkCoinLab);
    }];

    [self.kkBestImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkBestLab);
        make.right.mas_equalTo(self.kkBestLab.mas_left).mas_offset(-5);
        make.width.height.mas_equalTo(11);
    }];

    
}

- (void)setKkDic:(NSDictionary *)kkDic
{
    _kkDic = kkDic;
    
    self.kkNameLab.text = kkDic[@"user_nicename"];
    self.kkTimeLab.text = kkDic[@"hongbaoever_time"];
    [self.kkUserImgV sd_setImageWithURL:[NSURL URLWithString:kkDic[@"avatar_thumb"]]];
    self.kkCoinLab.text = [NSString stringWithFormat:@"%@币",kkDic[@"hongbaoever_money"]];
    if ([kkDic[@"shouqi"] intValue] == 1) {
        self.kkBestLab.hidden = NO;
        self.kkBestImgV.hidden = NO;
    }else{
        self.kkBestLab.hidden = YES;
        self.kkBestImgV.hidden = YES;

    }
    
}

@end


