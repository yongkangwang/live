//
//  KKTRTCLiveInvitationView.m
//  yunbaolive
//
//  Created by Peter on 2021/4/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKTRTCLiveInvitationView.h"

#import "KKTRTCRoomCellModel.h"
#import "KKTRTCLiveInvitationTableViewCell.h"

#import "TRTCVoiceRoom.h"


@interface KKTRTCLiveInvitationView ()<UITableViewDataSource,UITableViewDelegate>

@property(weak,nonatomic)UIView *kkContentV;

@property(weak,nonatomic)UITableView *kkTableView;
@property(strong,nonatomic)NSMutableArray *kkListArr;

@property(weak,nonatomic)UILabel *kkTitleLab;
@property(weak,nonatomic)UIButton *kkCloseBtn;

@end

@implementation KKTRTCLiveInvitationView


-(void)kkShow
{
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
//    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow);
        }];
    [self kkInitData];

    [self layoutIfNeeded];

}

- (void)kkDismiss
{
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [[UIColor colorWithHexString:@"1A1A1A "] colorWithAlphaComponent:0.4];

        [self kkInitView];
    }
    return self;
}


- (void)kkInitView
{
    
    UIView *kkContentV = [[UIView alloc]init];
    [self addSubview:kkContentV];
    self.kkContentV = kkContentV;
    kkContentV.backgroundColor = [UIColor colorWithHexString:@"#15233E"];
    
    UILabel *contentLab = [[UILabel alloc]init];
    self.kkTitleLab = contentLab;
    [self.kkContentV addSubview:contentLab];
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.textColor = KKWhiteColor;
    contentLab.font = KKTitleFont;
    contentLab.text = @"邀请上麦";
    
    UIButton *kkAdoptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.kkContentV addSubview:kkAdoptBtn];
    self.kkCloseBtn = kkAdoptBtn;
    [kkAdoptBtn setTitle:@"取消" forState:UIControlStateNormal];
    [kkAdoptBtn setTitleColor:KKWhiteColor forState:UIControlStateNormal];
    [kkAdoptBtn addTarget:self action:@selector(kkDismiss) forControlEvents:UIControlEventTouchUpInside];

    UITableView *kkTableView = [[UITableView alloc]initWithFrame:KKScreen_bounds];
    self.kkTableView = kkTableView;
    [self.kkContentV addSubview:self.kkTableView];
    kkTableView.delegate = self;
    kkTableView.dataSource = self;
    [self.kkTableView registerClass:[KKTRTCLiveInvitationTableViewCell class] forCellReuseIdentifier:@"KKTRTCLiveInvitationTableViewCell"];
    self.kkTableView.separatorStyle = UITableViewCellAccessoryNone;
//    self.kkTableView.backgroundColor=[UIColor colorWithHexString:@"#15233E"];
    self.kkTableView.backgroundColor=[UIColor clearColor];

    self.kkTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.kkTableView.estimatedRowHeight = 0;
    self.kkTableView.estimatedSectionHeaderHeight = 0;
    self.kkTableView.estimatedSectionFooterHeight = 0;
    self.kkTableView.showsVerticalScrollIndicator = NO;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.kkContentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(KKScreenHeight/1.5);
    }];
    
    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.equalTo(self.kkContentV);
    }];
    [self.kkCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTitleLab);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);

    }];
    
    [self.kkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkTitleLab.mas_bottom).mas_offset(10);
        make.left.right.equalTo(self.kkContentV);
        make.bottom.mas_equalTo(-(ShowDiff));
    }];

    [self.kkTableView reloadData];

}


- (void)kkInitData
{
    WeakSelf;
    [[TRTCVoiceRoom sharedInstance] getUserInfoList:nil callback:^(int code, NSString * _Nonnull message, NSArray<VoiceRoomUserInfo *> * _Nonnull userInfos) {
        NSMutableArray *kkListArr = [NSMutableArray array];
        for (VoiceRoomUserInfo *kkinfo in userInfos) {
            KKTRTCRoomCellModel *cellModel = [[KKTRTCRoomCellModel alloc]init];
                cellModel.uid = kkinfo.userId;
                cellModel.name = kkinfo.userName;
                cellModel.pictureUrl = kkinfo.userAvatar;
                cellModel.gender = kkinfo.gender;
                cellModel.level = kkinfo.level;
                cellModel.kkRoomID = weakSelf.kkRoomID;
                [kkListArr addObject:cellModel];
        }
        weakSelf.kkListArr = kkListArr;
        [weakSelf.kkTableView reloadData];
    }];

}

//MARK:-tableviewDateSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKTRTCLiveInvitationTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"KKTRTCLiveInvitationTableViewCell"];
    if(!cell){
        cell = [[KKTRTCLiveInvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KKTRTCLiveInvitationTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.kkListArr[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //kk分割线颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = KKRGB(245, 245, 245);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.kkListArr.count;
//    return 10;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.kkCellDidSelectClickBlock) {
        self.kkCellDidSelectClickBlock(self.kkListArr[indexPath.row]);
    }
    
    [self kkDismiss];
}

- (NSMutableArray *)kkListArr
{
    if (!_kkListArr) {
        _kkListArr = [NSMutableArray array];
    }
    return _kkListArr;
}
@end
