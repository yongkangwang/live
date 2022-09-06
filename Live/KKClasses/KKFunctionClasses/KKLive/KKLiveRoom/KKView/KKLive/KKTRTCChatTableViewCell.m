//
//  KKTRTCChatTableViewCell.m
//  yunbaolive
//
//  Created by Peter on 2021/3/29.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKTRTCChatTableViewCell.h"

#import "KKTRTCRoomCellModel.h"

@interface KKTRTCChatTableViewCell ()

@property(weak,nonatomic)UIView *kkContentView;

@property(weak,nonatomic)UILabel *contentLab;
@property(weak,nonatomic)UIButton *kkAdoptBtn;


@end

@implementation KKTRTCChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    
//    kkContentView
    UIView *kkContentView = [[UIView alloc]init];
    self.kkContentView = kkContentView;
    [self.contentView addSubview:kkContentView];
    self.kkContentView.backgroundColor = [KKBlackTitleLabColor colorWithAlphaComponent:0.3];//设置父视图透明而子视图不受影响

    UILabel *contentLab = [[UILabel alloc]init];
    self.contentLab = contentLab;
    [self.kkContentView addSubview:contentLab];
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.textColor = KKWhiteColor;
    contentLab.font = KKLab11Font;
    
    UIButton *kkAdoptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:kkAdoptBtn];
    self.kkAdoptBtn = kkAdoptBtn;
    [kkAdoptBtn setTitle:@"同意" forState:UIControlStateNormal];
    [kkAdoptBtn setTitleColor:KKWhiteColor forState:UIControlStateNormal];
    kkAdoptBtn.titleLabel.font = KKLab11Font;
    kkAdoptBtn.backgroundColor = [UIColor colorWithHexString:@"#FF3E35"];
    kkAdoptBtn.userInteractionEnabled = NO;

}
- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.kkAdoptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);//10
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    self.kkAdoptBtn.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:3 fromView:self.kkAdoptBtn];

    [self.kkContentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(25);
        make.top.left.bottom.mas_equalTo(self.contentView);
    }];

    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(self.kkContentView);
        make.right.mas_equalTo(self.kkContentView.mas_right).mas_offset(-5);
    }];
    if (self.contentLab.width> self.width-40) {
        [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.width -40);
        }];
    }
    self.kkContentView.layer.mask = [[YBToolClass sharedInstance] kkSetViewCornerRadius:5 fromView:self.kkContentView];
//    self.kkContentView.backgroundColor = [KKBlackTitleLabColor colorWithAlphaComponent:0.3];//设置父视图透明而子视图不受影响

}

-(void)setModel:(KKTRTCRoomCellModel *)model
{
    _model = model;
    //1上麦，2下麦，3进房，4离房，5禁言，6封麦 ,7申请上麦，8用户拒绝主播邀请
    
    self.kkAdoptBtn.hidden = YES;
    NSString *kkContent = @"";
    switch (model.kkType) {
        case 1:
            kkContent = [NSString stringWithFormat:@"%@上%zd号麦",model.name,model.index];
            break;
        case 2:
            kkContent = [NSString stringWithFormat:@"%@下%zd号麦",model.name,model.index];
            break;
        case 3:
            kkContent = [NSString stringWithFormat:@"%@进房",model.name];
            break;
        case 4:
            kkContent = [NSString stringWithFormat:@"%@退房",model.name];
            break;
        case 5:
            if (model.kkIsMute) {
                kkContent = [NSString stringWithFormat:@"%zd号位被禁言",model.index];
            }else{
                kkContent = [NSString stringWithFormat:@"%zd号位解除禁言",model.index];
            }

            break;
        case 6:
            if (model.kkIsLock) {
                kkContent = [NSString stringWithFormat:@"房主封禁%zd号位",model.index];
            }else{
                kkContent = [NSString stringWithFormat:@"房主解禁%zd号位",model.index];
            }
            break;
        case 7:
            kkContent = [NSString stringWithFormat:@"%@:申请上%zd号麦",model.name,model.index];
            self.kkAdoptBtn.hidden = NO;
            break;
        case 8:
            kkContent = [NSString stringWithFormat:@"%@拒绝了上%zd号麦",model.name,model.index];
            break;
        case 9:
            kkContent = [NSString stringWithFormat:@"%@:申请一起看%@",model.name,model.kkVideoName];
            self.kkAdoptBtn.hidden = NO;

            break;

        default:
            
            break;
    }
    if (model.kkChangeCellType == 2) {
        self.kkAdoptBtn.hidden  = YES;
    }
    
    self.contentLab.text = kkContent;
    [self layoutIfNeeded];
    
}

@end
