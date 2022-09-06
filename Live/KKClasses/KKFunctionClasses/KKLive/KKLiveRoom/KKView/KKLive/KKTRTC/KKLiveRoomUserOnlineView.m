//
//  KKLiveRoomUserOnlineView.m
//  yunbaolive
//
//  Created by Peter on 2021/5/12.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKLiveRoomUserOnlineView.h"

#import "CGXPageCollectionWaterView.h"
#import "CGXPageCollectionHeaderModel.h"

#import "KKRoomOnlinePersonCell.h"


@interface KKLiveRoomUserOnlineView ()<CGXPageCollectionUpdateViewDelegate>

@property(weak,nonatomic)UIButton *kkBGCoverBtn;

@property(weak,nonatomic)UIView *kkContentView;
@property(weak,nonatomic)UILabel *kkTitleLab;
@property(weak,nonatomic)UIView *kkTopView;
@property(weak,nonatomic)UILabel *kkOnlineLab;
@property(weak,nonatomic)UILabel *kkTicketLab;


@property(weak,nonatomic)CGXPageCollectionWaterView *generalView;
@property(strong,nonatomic)NSMutableArray *kkPersonListArr;


@end

@implementation KKLiveRoomUserOnlineView


-(void)kkShow{
            
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
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

        //添加子控件
        [self kkInitView];
//        [self kkInitData];
    }
    return self;
}

- (void)kkInitView
{
//    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kkDismiss)];
//    [self addGestureRecognizer:tapges];
    
    [kkNotifCenter addObserver:self selector:@selector(kkDismiss) name:@"KKLiveRoomUserOnlineViewDissmiss" object:nil];
    
    UIButton *kkBGCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:kkBGCoverBtn];
    self.kkBGCoverBtn = kkBGCoverBtn;
    [kkBGCoverBtn addTarget:self action:@selector(kkDismiss) forControlEvents:UIControlEventTouchUpInside];

    UIView *kkContentView = [[UIView alloc] init];
    self.kkContentView = kkContentView;
    [self addSubview:kkContentView];
    kkContentView.backgroundColor = KKWhiteColor;
    
    UILabel *kkTitleLab = [UILabel kkLabelWithText:@"在线观众" textColor:KKBlackLabColor textFont:KKTitleFont14 andTextAlignment:NSTextAlignmentCenter];
    self.kkTitleLab = kkTitleLab;
    [self.kkContentView addSubview:kkTitleLab];

    UIView *kkTopView = [[UIView alloc] init];
    self.kkTopView = kkTopView;
    [self.kkContentView addSubview:kkTopView];
    kkTopView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];

    UILabel *kkOnlineLab = [UILabel kkLabelWithText:@"在线观众" textColor:[UIColor colorWithHexString:@"#999999"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentLeft];
    self.kkOnlineLab = kkOnlineLab;
    [self.kkTopView addSubview:kkOnlineLab];
    
    UILabel *kkTicketLab = [UILabel kkLabelWithText:@"票数" textColor:[UIColor colorWithHexString:@"#999999"] textFont:KKLab11Font andTextAlignment:NSTextAlignmentRight];
    self.kkTicketLab = kkTicketLab;
    [self.kkTopView addSubview:kkTicketLab];

    

    [self setupLayoutAndCollectionView];
    
}

/**
 * 创建布局和collectionView
 */
- (void)setupLayoutAndCollectionView{
    
    CGXPageCollectionWaterView *generalView = [[CGXPageCollectionWaterView alloc]  init];
    self.generalView = generalView;
    [self.kkContentView addSubview:self.generalView];

    self.generalView.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight/2);
   self.generalView.viewDelegate = self;
   self.generalView.isShowDifferentColor = NO;
   self.generalView.isRoundEnabled = YES;

    [self.generalView registerCell:[KKRoomOnlinePersonCell class] IsXib:NO];
    

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.kkBGCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(KKScreenHeight/1.5);
    }];
    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.kkContentView);
    }];
    [self.kkTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkTitleLab.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(22);
        make.left.right.mas_equalTo(self.kkContentView);
    }];

    [self.kkOnlineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTopView);
        make.left.mas_equalTo(15);
    }];
    [self.kkTicketLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.kkTopView);
        make.right.mas_equalTo(-15);
    }];

    [self.generalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.kkContentView);
        make.top.mas_equalTo(self.kkTopView.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(-ShowDiff);
    }];

}

- (void)kkInitData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"liveuid"]  = self.kkLiveID;
    param[@"stream"]  = self.kkStream;

    [KKLiveAPI kk_GetLiveUserOnlineInfoWithparameters:param successBlock:^(id  _Nullable response) {
        if ([response[@"ret"] intValue] == 200) {
           NSArray *kkarr = response[@"data"][@"info"];
            NSMutableArray *listArr = kkarr.firstObject[@"userlist"];


            NSMutableArray *kkVideoListArr = [self loadDealWithList:listArr];
            self.kkPersonListArr = kkVideoListArr;

            [self.generalView updateDataArray:kkVideoListArr IsDownRefresh:YES Page:1];
        }
    } failureBlock:^(NSError * _Nullable error) {
    } mainView:self];
}

//处理数据源
- (NSMutableArray<CGXPageCollectionWaterSectionModel *> *)loadDealWithList:(NSMutableArray *)kkRowArr
{
    NSMutableArray *dateAry = [NSMutableArray array];
    int x = 1;//分多少组
    for (int i = 0; i<x; i++) {
        CGXPageCollectionWaterSectionModel *sectionModel = [[CGXPageCollectionWaterSectionModel alloc] init];
        
        sectionModel.insets = UIEdgeInsetsMake(2,2,2,2);
        sectionModel.minimumLineSpacing = 10;
        sectionModel.minimumInteritemSpacing = 10;
                //collectionview 边距
        sectionModel.borderEdgeInserts = UIEdgeInsetsMake(0, 0, 0, 0);

        NSMutableArray *itemArr = [NSMutableArray array];
        
        UIColor*randColor = [UIColor clearColor];
        sectionModel.row = 1;
        for (int j = 0; j<kkRowArr.count; j++) {
            CGXPageCollectionWaterRowModel *item = [[CGXPageCollectionWaterRowModel alloc] initWithCelllass:[KKRoomOnlinePersonCell class] IsXib:NO];
            item.dataModel= kkRowArr[j];
            item.cellHeight = 60;
            item.cellColor =  randColor;
            [itemArr addObject:item];
        }
            
        sectionModel.rowArray = [NSMutableArray arrayWithArray:itemArr];
        [dateAry addObject:sectionModel];
    }
    return dateAry;
}

- (void)gx_PageCollectionBaseView:(CGXPageCollectionBaseView *)baseView DidSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了分组%zd,行%zd",indexPath.section,indexPath.row);
    
    CGXPageCollectionWaterSectionModel *kkmodel = self.kkPersonListArr.lastObject;
    CGXPageCollectionWaterRowModel *kkrowModel = (CGXPageCollectionWaterRowModel *)kkmodel.rowArray[indexPath.row];
    NSDictionary *kkdic = kkrowModel.dataModel;
    
    NSDictionary *subdic = @{@"id":kkdic[@"id"]};
    if (self.kkDidSelectItemBlock) {
        self.kkDidSelectItemBlock(subdic);
    }
}



- (NSMutableArray *)kkPersonListArr
{
    if (!_kkPersonListArr) {
        _kkPersonListArr = [NSMutableArray array];
    }
    return _kkPersonListArr;
}
@end
