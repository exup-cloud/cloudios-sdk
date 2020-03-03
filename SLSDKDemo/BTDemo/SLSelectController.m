//
//  ViewController.m
//  BTDemo_Test
//
//  Created by WWLy on 2019/9/26.
//  Copyright © 2019 SL. All rights reserved.
//

#import "SLSelectController.h"
#import "SLContractMarketController.h"
#import "SLContractTradeController.h"

@interface SLSelectController ()

@property (nonatomic, strong) NSArray <BTItemModel *> * itemModelArray;

@end

@implementation SLSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self requestMarketData];
}

- (void)initUI {
    UIButton *marketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    marketButton.backgroundColor = [UIColor blackColor];
    [marketButton setTitle:@"市场" forState:UIControlStateNormal];
    [marketButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    marketButton.layer.cornerRadius = 2;
    [marketButton addTarget:self action:@selector(marketButtonClick) forControlEvents:UIControlEventTouchUpInside];
    marketButton.frame = CGRectMake(50, 200, self.view.sl_width - 100, 44);
    [self.view addSubview:marketButton];
    
    UIButton *tradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tradeButton.backgroundColor = [UIColor blackColor];
    [tradeButton setTitle:@"交易" forState:UIControlStateNormal];
    [tradeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tradeButton.layer.cornerRadius = 2;
    [tradeButton addTarget:self action:@selector(tradeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    tradeButton.frame = CGRectMake(marketButton.sl_x, marketButton.sl_maxY + 20, marketButton.sl_width, marketButton.sl_height);
    [self.view addSubview:tradeButton];
}

- (void)requestMarketData {
    [SMProgressHUD showHUD];
    [SLSDK sl_loadFutureMarketData:^(id result, NSError *error) {
        [SMProgressHUD hideHUD];
        if (result) {
            SLLog(@"---- result: %@", result);
            if ([result isKindOfClass:[NSArray class]]) {
                self.itemModelArray = [BTMaskFutureTool shareMaskFutureTool].futureArr;
            }
        } else {
            
        }
    }];
}

- (void)marketButtonClick {
    [self.navigationController pushViewController:[SLContractMarketController new] animated:YES];
}

- (void)tradeButtonClick {
    if (self.itemModelArray.count == 0) {
        [SMProgressHUD showInfoWithMessage:@"数据请求失败"];
        return;
    }
    SLContractTradeController *tradeVC = [SLContractTradeController new];
    tradeVC.itemModel = self.itemModelArray.firstObject;
    [self.navigationController pushViewController:tradeVC animated:YES];
}

@end
