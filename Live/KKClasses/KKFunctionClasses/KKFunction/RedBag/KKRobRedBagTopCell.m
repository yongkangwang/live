//
//  KKRobRedBagCell.m
//  yunbaolive
//
//  Created by Peter on 2021/11/19.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKRobRedBagTopCell.h"


@interface KKRobRedBagTopCell ()

@property (nonatomic,weak) UILabel *kkDescribeLab;
@property (nonatomic,weak) UIImageView *kkSenderImgV;
@property (nonatomic,weak) UILabel *kkSenderNameLab;
@property (nonatomic,weak) UIImageView *kkBadNumMoneyLeftImgV;

@property (nonatomic,weak) UILabel *kkCoinNumLab;
@property (nonatomic,weak) UILabel *kkCoinLab;

@property (nonatomic,weak) UILabel *kkCoinStatusLab;

@property (nonatomic,weak) UIView *kkLineV;
@property (nonatomic,weak) UILabel *kkPacketStatusLab;

@end

@implementation KKRobRedBagTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"KKRobRedBagTopCell";
    KKRobRedBagTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        KKRobRedBagTopCell *cell = [[KKRobRedBagTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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

    UIImageView *kkSenderImgV = [[UIImageView alloc]init];
    self.kkSenderImgV = kkSenderImgV;
    [self.contentView addSubview:kkSenderImgV];

    
    UILabel *kkSenderNameLab = [UILabel kkLabelWithText:@"" textColor:[UIColor colorWithHexString:@"#F5DFAB"] textFont:[UIFont systemFontOfSize:16] andTextAlignment:NSTextAlignmentCenter];
    self.kkSenderNameLab = kkSenderNameLab;
    [self.contentView addSubview:kkSenderNameLab];

    UIImageView *kkBadNumMoneyLeftImgV = [[UIImageView alloc]init];
    self.kkBadNumMoneyLeftImgV = kkBadNumMoneyLeftImgV;
    [self.contentView addSubview:kkBadNumMoneyLeftImgV];
    kkBadNumMoneyLeftImgV.image = [UIImage imageNamed:@"KKSendRedBagView_lock"];
    kkBadNumMoneyLeftImgV.hidden = YES;
    
    UILabel *kkDescribeLab = [UILabel kkLabelWithText:@"恭喜发财,大吉大利" textColor:[UIColor colorWithHexString:@"#999999"] textFont:[UIFont systemFontOfSize:13] andTextAlignment:NSTextAlignmentCenter];
    self.kkDescribeLab = kkDescribeLab;
    [self.contentView addSubview:kkDescribeLab];

    UILabel *kkCoinNumLab = [UILabel kkLabelWithText:@"123" textColor:[UIColor colorWithHexString:@"#CBAD76"] textFont:[UIFont systemFontOfSize:54] andTextAlignment:NSTextAlignmentCenter];
    self.kkCoinNumLab = kkCoinNumLab;
    [self.contentView addSubview:kkCoinNumLab];

    UILabel *kkCoinLab = [UILabel kkLabelWithText:@"币" textColor:[UIColor colorWithHexString:@"#C8AC77"] textFont:[UIFont systemFontOfSize:16] andTextAlignment:NSTextAlignmentCenter];
    self.kkCoinLab = kkCoinLab;
    [self.contentView addSubview:kkCoinLab];
    
    UILabel *kkCoinStatusLab = [UILabel kkLabelWithText:@"已存入[我的钱包]" textColor:[UIColor colorWithHexString:@"#C8AC77"] textFont:[UIFont systemFontOfSize:16] andTextAlignment:NSTextAlignmentCenter];
    self.kkCoinStatusLab = kkCoinStatusLab;
    [self.contentView addSubview:kkCoinStatusLab];

    UIView *kkLineV = [[UIView alloc]init];
    self.kkLineV = kkLineV;
    [self.contentView addSubview:kkLineV];
    kkLineV.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UILabel *kkPacketStatusLab = [UILabel kkLabelWithText:@"2个红包共21215币，5分钟被抢完" textColor:[UIColor colorWithHexString:@"#999999"] textFont:[UIFont systemFontOfSize:13] andTextAlignment:NSTextAlignmentLeft];
    self.kkPacketStatusLab = kkPacketStatusLab;
    [self.contentView addSubview:kkPacketStatusLab];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.kkSenderNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(80+20);
    }];
    [self.kkSenderImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkSenderNameLab.mas_left).mas_offset(-5);
        make.centerY.mas_equalTo(self.kkSenderNameLab);
        make.width.height.mas_equalTo(21);
    }];

    [self.kkBadNumMoneyLeftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkSenderNameLab.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.kkSenderNameLab);
        make.width.height.mas_equalTo(15);
    }];

    [self.kkDescribeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(140);
    }];
    
    [self.kkCoinNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkDescribeLab.mas_bottom).mas_offset(11);
        make.centerX.mas_equalTo(self.kkDescribeLab);
    }];

    [self.kkCoinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kkCoinNumLab.mas_right).mas_offset(5);
        make.bottom.mas_equalTo(self.kkCoinNumLab.mas_bottom).mas_offset(-5);
    }];
    
    [self.kkCoinStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkCoinNumLab.mas_bottom).mas_offset(5);
        make.centerX.mas_equalTo(self.kkDescribeLab);
    }];

    [self.kkPacketStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-2);
    }];
    [self.kkLineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.kkPacketStatusLab.mas_top).mas_offset(-10);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];


}


-(void)setKkDic:(NSMutableDictionary *)kkDic
{
    _kkDic = kkDic;

    self.kkDescribeLab.text = kkDic[@"message"];
    self.kkSenderNameLab.text = [NSString stringWithFormat:@"%@发出的红包",kkDic[@"sendUserName"]];
    [self.kkSenderImgV sd_setImageWithURL:[NSURL URLWithString:kkDic[@"sendavatar"]]];
    
}
- (void)setKkDetailDic:(NSDictionary *)kkDetailDic
{
    _kkDetailDic = kkDetailDic;
    
    if ([[NSString kk_isNullString:kkDetailDic[@"hongbao_type"]] intValue] == 2) {
//        1平均红包,2拼手气，3单聊红包
        self.kkBadNumMoneyLeftImgV.hidden = NO;
    }
//
    if ([kkDetailDic[@"kkmoney"] isEqualToString:@""]) {
        self.kkCoinNumLab.hidden = YES;
        self.kkCoinLab.hidden = YES;
        self.kkCoinStatusLab.hidden = YES;
    }else{
        self.kkCoinNumLab.text = kkDetailDic[@"kkmoney"];
    }
   int kknum =  [kkDetailDic[@"yilingqu"] intValue];
   int kktotalnum =  [kkDetailDic[@"hongbao_nums"] intValue];
    if (kknum == kktotalnum) {
//        NSInteger kkdatetime =  [NSDate daysFromDate:[NSDate dateFromString:kkDetailDic[@"hongbao_time"]] toDate:[NSDate date]];
//          NSInteger kkdonetime = kkdatetime/60;
        
        self.kkPacketStatusLab.text = [NSString stringWithFormat:@"%d个红包共%@币,%@内被抢完",kktotalnum,kkDetailDic[@"hongbao_money"],kkDetailDic[@"jiesushijian"]];

//        [NSString stringWithFormat:@"%d个红包共%@币,%zd分钟被抢完",kktotalnum,kkDetailDic[@"hongbao_money"],kkdonetime];
    }else{
        self.kkPacketStatusLab.text = [NSString stringWithFormat:@"已领取%d/%d个",kknum,kktotalnum];
    }
    
}


@end

