//
//  SLMineAssetsController.m
//  BTTest
//
//  Created by WWLy on 2019/9/16.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMineAssetsController.h"
#import "SLMineAssetsTableView.h"
#import "SLMineRecordController.h"

@interface SLMineAssetsController ()

@property (nonatomic, strong) SLMineAssetsTableView * mineAssetsTableView;

@end

@implementation SLMineAssetsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self requestAssetsDataAndUpdateView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 监听资产数据
    [SLNoteCenter addObserver:self selector:@selector(didReceiveContractDataFromSocket:) name:SLSocketDataUpdate_Unicast_Notification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SLNoteCenter removeObserver:self name:SLSocketDataUpdate_Unicast_Notification object:nil];
}

- (void)initUI {
    [self initNav];
    [self initMineAssetsTableView];
}

- (void)initNav {
    // 显示分隔线
    [self changeLineHiddenStatus:NO];
    
    [self updateNavTitle:Launguage(@"BT_CA_AC")];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 80, 44);
    [rightButton setTitleColor:[SLConfig defaultConfig].lightTextColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:Launguage(@"ME_TR_DE") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightNavButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setCustomRightView:rightButton];
}

- (void)initMineAssetsTableView {
    self.mineAssetsTableView = [[SLMineAssetsTableView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, self.view.sl_height - SL_SafeAreaTopHeight)];
    
    [self.view addSubview:self.mineAssetsTableView];
}


#pragma mark - Update Data

- (void)requestAssetsDataAndUpdateView {
    [[SLPlatformSDK sharedInstance] sl_loadUserContractPerpotyCallBack:^(NSArray<BTItemCoinModel *> *coinModelArray) {
        if (coinModelArray != nil) {
            [self.mineAssetsTableView updateViewWithItemCoinModelArray:coinModelArray];
        } else {
            SLLog(@"合约资产请求失败");
        }
    }];
}


#pragma mark - Click Events

- (void)rightNavButtonClick:(UIButton *)sender {
    SLMineRecordController *recordVC = [SLMineRecordController new];
    [self.navigationController pushViewController:recordVC animated:YES];
}


#pragma mark - Socket Data

- (void)didReceiveContractDataFromSocket:(NSNotification *)notify {
    [self.mineAssetsTableView updateViewWithItemCoinModelArray:[BTMineAccountTool shareMineAccountTool].contractAccountArr];
//    NSArray <BTWebSocketModel *> *modelArray = notify.userInfo[@"data"];
//    if (modelArray.count == 0) {
//        return;
//    }
//    for (BTWebSocketModel *socketModel in modelArray) {
//        if (socketModel.c_assets) {
//            NSMutableArray *contractAsset = [[BTMineAccountTool shareMineAccountTool].contractAccountArr mutableCopy];
//            for (int i = 0; i < contractAsset.count; i++) {
//                BTItemCoinModel *coinModel = contractAsset[i];
//                if ([coinModel.symbol isEqualToString:socketModel.c_assets.symbol]) {
//                    [contractAsset replaceObjectAtIndex:i withObject:socketModel.c_assets];
//                    [BTMineAccountTool shareMineAccountTool].contractAccountArr = [contractAsset copy];
//                    break;
//                }
//            }
//        }
//    }
}



@end
