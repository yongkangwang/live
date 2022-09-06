//
//  KKCommendatoryLiveRoomView.m
//  yunbaolive
//
//  Created by Peter on 2021/11/9.
//  Copyright © 2021 cat. All rights reserved.
//

#import "KKCommendatoryLiveRoomView.h"


#import "hotModel.h"

#import "KKCommendatoryLiveRoomCell.h"

#define KKCommendatoryLiveRoomCellIdentifier @"KKCommendatoryLiveRoomCellIdentifier"

@interface KKCommendatoryLiveRoomView ()<UICollectionViewDelegate,UICollectionViewDataSource,AJWaveRefreshProtocol>

@property(weak,nonatomic)UIButton *kkCoverBtn;
@property(weak,nonatomic)UIView *kkContentView;
@property(weak,nonatomic)UILabel *kkTitleLab;
@property(weak,nonatomic)UIButton *kkGoBackBtn;

@property(weak,nonatomic)UICollectionView *kkCollectionView;

@property (nonatomic,assign) NSInteger kkPage;
@property(strong,nonatomic)NSMutableArray *kkPrettyOriginalInfoArr;
@property(strong,nonatomic)NSMutableArray *kkLiveModelArr;



@end

@implementation KKCommendatoryLiveRoomView


-(void)kkShow
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo([UIApplication sharedApplication].keyWindow);
        make.left.mas_equalTo(KKScreenWidth);
        make.width.mas_equalTo(KKScreenWidth);
    }];
    

    [UIView animateWithDuration:0.5 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo([UIApplication sharedApplication].keyWindow);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(KKScreenWidth);
        }];
    }];
}

- (void)kkDismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo([UIApplication sharedApplication].keyWindow);
            make.left.mas_equalTo(KKScreenWidth);
            make.width.mas_equalTo(KKScreenWidth);
        }];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //添加子控件
        [self kksetupUI];
    }
    return self;
}

- (void)kksetupUI
{
    UIButton *kkCoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkCoverBtn = kkCoverBtn;
    [self addSubview:kkCoverBtn];
    [kkCoverBtn addTarget:self action:@selector(kkCoverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *kkContentView = [[UIView alloc]init];
    self.kkContentView = kkContentView;
    [self addSubview:kkContentView];
    kkContentView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    
    UIButton *kkGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kkGoBackBtn = kkGoBackBtn;
    [self addSubview:kkGoBackBtn];
    [kkGoBackBtn addTarget:self action:@selector(kkCoverBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kkGoBackBtn setBackgroundImage:[UIImage imageNamed:@"KKCommendatoryLiveRoomV_goBack"] forState:UIControlStateNormal];

    UILabel *kkTitleLab = [UILabel kkLabelWithText:@"为您推荐" textColor:[UIColor colorWithHexString:@"#FDFDFD"] textFont:KKPhoenFont13 andTextAlignment:NSTextAlignmentCenter];
    self.kkTitleLab = kkTitleLab;
    [self.kkContentView addSubview:kkTitleLab];
    
    [self createCollectionView];
    
}

-(void)createCollectionView{

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    //设置headerView的尺寸大小
//    flow.headerReferenceSize = CGSizeMake(KKScreenWidth, KKLiveTopHeaderH);

    flow.itemSize = CGSizeMake(90, 90);
    flow.minimumLineSpacing = 10;//排间距
    flow.minimumInteritemSpacing = 0;
    flow.sectionInset = UIEdgeInsetsMake(0, 5,0, 5);//设置外边距

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flow];
    [self.kkContentView addSubview:collectionView];
    self.kkCollectionView =collectionView;
//    collectionView.contentInset = UIEdgeInsetsMake(KKNavH, 0, 0, 0);
    collectionView.delegate   = self;
    collectionView.dataSource = self;

    [self.kkCollectionView registerClass:[KKCommendatoryLiveRoomCell class] forCellWithReuseIdentifier:KKCommendatoryLiveRoomCellIdentifier];
    if (@available(iOS 11.0, *)) {
        self.kkCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
//        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //下拉刷新动效
    [self.kkCollectionView setupRefreshHeader:self];
    [self.kkCollectionView setupRefreshFooter:self];
    [self.kkCollectionView startHeaderRefreshing];
    //滚动条间距
//    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.kkCollectionView.showsVerticalScrollIndicator = NO;
    self.kkCollectionView.backgroundColor = KKBgGrayColor;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.kkCoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    [self.kkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(self);
        make.width.mas_equalTo(100);
    }];

    [self.kkGoBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.kkContentView.mas_left);
        make.top.mas_equalTo(KKNavH+100);
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(40);
    }];

    [self.kkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.kkContentView);
//        make.top.mas_equalTo(KKNavH);
        make.top.mas_equalTo(kkStatusbarH);

    }];

    [self.kkCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.kkTitleLab.mas_bottom).mas_offset(10);
        make.left.right.bottom.mas_equalTo(self.kkContentView);
    }];
    
}

- (void)headerRereshing
{
    self.kkPage = 1;
    [self pullInternet];

}
- (void)footerRereshing
{
    self.kkPage ++;
    [self pullInternet];
}

//获取主播列表网络数据
-(void)pullInternet{

    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
//    parame[@"type"] = @(self.kkLiveType); //type  1是颜值  2是一起看   不传是首页
    parame[@"p"] = @(self.kkPage);

    [KKLiveAPI  kk_PostHomeLiveInfoWithparameters:parame successBlock:^(id  _Nullable response) {
        [self.kkCollectionView.mj_header endRefreshing];
        [self.kkCollectionView.mj_footer endRefreshing];

        if ([response[@"status"] integerValue] == 1) {//1表示服务器正常返回
            NSArray *list = response[@"rezhibo"];
            if (list.count == 0) {
                [MBProgressHUD kkshowMessage:@"没有更多数据了"];
                return ;
            }

            NSMutableArray *kkPrettyArr = [NSMutableArray array];
            for (NSDictionary *kkdic in list) {
                hotModel *model = [[hotModel alloc]initWithDic:kkdic];
                [kkPrettyArr addObject:model];
            }

            if (self.kkPage == 1) {
                self.kkLiveModelArr = kkPrettyArr;
                [self.kkPrettyOriginalInfoArr removeAllObjects];
            }else{
                [self.kkLiveModelArr addObjectsFromArray:kkPrettyArr];
            }
            [self.kkPrettyOriginalInfoArr addObjectsFromArray:list];
            [self.kkCollectionView reloadData];
            
        }else{
            [MBProgressHUD kkshowMessage:response[@"cont"]];

        }
    } failureBlock:^(NSError * _Nullable error) {
        [self.kkCollectionView.mj_header endRefreshing];
        [self.kkCollectionView.mj_footer endRefreshing];
        NSString *kkstr = [NSString stringWithFormat:@"code:%zd,%@",error.code,error.userInfo[@"NSLocalizedDescription"]];
        [MBProgressHUD kkshowMessage:kkstr];

    } mainView:self];

}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.kkLiveModelArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KKCommendatoryLiveRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KKCommendatoryLiveRoomCellIdentifier forIndexPath:indexPath];
    cell.kkProductModel = self.kkLiveModelArr[indexPath.item];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    if (self.kkDidSelectItemBlock) {
        self.kkDidSelectItemBlock(self.kkPrettyOriginalInfoArr[indexPath.item]);
    }
    [self kkDismiss];
}

- (void)kkCoverBtnClick
{
    [self kkDismiss];
}


- (NSMutableArray *)kkPrettyOriginalInfoArr
{
    if (!_kkPrettyOriginalInfoArr) {
        _kkPrettyOriginalInfoArr = [NSMutableArray array];
    }
    return _kkPrettyOriginalInfoArr;
}

- (NSMutableArray *)kkLiveModelArr
{
    if (!_kkLiveModelArr) {
        _kkLiveModelArr = [NSMutableArray array];
    }
    return _kkLiveModelArr;
}

@end
