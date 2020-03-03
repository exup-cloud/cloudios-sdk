//
//  SLContractRecordController.m
//  BTTest
//
//  Created by wwly on 2019/9/21.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractRecordController.h"
#import "SLSegment.h"
#import "SLContractListHeaderView.h"
#import "SLContractListCell.h"
#import "SLContractCurrentHaveCell.h"
#import "SLContractDoneRecordCell.h"

@interface SLContractRecordController () <UITableViewDelegate, UITableViewDataSource,SLContractListCellDelegate>

@property (nonatomic, strong) SLSegment * headerSegment;
@property (nonatomic, strong) UITableView * contentTableView;

@property (nonatomic, assign) SLContractListType currentContractListType;


@property (nonatomic, strong) NSArray <BTContractOrderModel *> * orderModelArray;
/// 当前持仓
@property (nonatomic, strong) NSArray <BTPositionModel *> * positionModelArray;
/// 成交记录
@property (nonatomic, strong) NSArray <BTContractRecordModel *> * doneRecordModelArray;

@end

static NSString *const sl_contractList_reuseID = @"sl_contractList_SLContractListCell";
static NSString *const sl_contractList_currentHave_reuseID = @"sl_contractList_SLContractCurrentHaveCell";
static NSString *const sl_contractList_doneRecord_reuseID = @"sl_contractList_SLContractDoneRecordCell";

@implementation SLContractRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    self.currentContractListType = SLContractListTypeCurrent;
    [self requestContractListDataWithType:self.currentContractListType];
}

- (void)initUI {
    [self initNav];
    [self initContentView];
}

- (void)initNav {
    [self updateNavTitle:@"合约记录"];
}

- (void)initContentView {
    __weak typeof(self) weakSelf = self;
    self.headerSegment = [[SLSegment alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, 40) Titles:@[Launguage(@"TD_OP_OR"), Launguage(@"ME_OR_HI"), Launguage(@"str_present_plan"), Launguage(@"str_history_plan"), Launguage(@"TD_OR_RE"), Launguage(@"str_holdings_history")] height:40 font:[UIFont systemFontOfSize:14] didClickAction:^(UIButton *sender, NSInteger index) {
        switch (sender.tag) {
            case 0:
                weakSelf.currentContractListType = SLContractListTypeCurrent;
                break;
            case 1:
                weakSelf.currentContractListType = SLContractListTypeHistory;
                break;
            case 2:
                weakSelf.currentContractListType = SLContractListTypePlanCurrent;
                break;
            case 3:
                weakSelf.currentContractListType = SLContractListTypePlanHistory;
                break;
            case 4:
                weakSelf.currentContractListType = SLContractListTypeDoneRecord;
                break;
            case 5:
                weakSelf.currentContractListType = SLContractListTypePositionsHistory;
                break;
            default:
                break;
        }
        [weakSelf requestContractListDataWithType:weakSelf.currentContractListType];
    }];
    [self.view addSubview:self.headerSegment];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerSegment.sl_maxY, self.view.sl_width, self.view.sl_height - self.headerSegment.sl_maxY)];
    self.contentTableView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.showsHorizontalScrollIndicator = NO;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contentTableView];
    
    [self.contentTableView registerClass:[SLContractListCell class] forCellReuseIdentifier:sl_contractList_reuseID];
    [self.contentTableView registerClass:[SLContractCurrentHaveCell class] forCellReuseIdentifier:sl_contractList_currentHave_reuseID];
    [self.contentTableView registerClass:[SLContractDoneRecordCell class] forCellReuseIdentifier:sl_contractList_doneRecord_reuseID];
    
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0, SL_SafeAreaBottomHeight, 0);
    
    if (@available(iOS 11.0, *)) {
        self.contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.currentContractListType = SLContractListTypeCurrent;
}


- (void)requestContractListDataWithType:(SLContractListType)contractListType {
    BTContractOrderStatus status = BTContractOrderStatusWait;
    switch (contractListType) {
        case SLContractListTypeCurrent:
            status = 3;
            break;
        case SLContractListTypeHistory:
            status = BTContractOrderStatusFinished;
            break;
        case SLContractListTypePlanCurrent:
            status = 3;
            break;
        case SLContractListTypePlanHistory:
            status = BTContractOrderStatusFinished;
            break;
        default:
            break;
    }
    // 当前委托和历史委托
    if (SLContractListTypeCurrent == contractListType || SLContractListTypeHistory == contractListType) {
        [BTContractTool getUserContractOrdersWithContractID:self.itemModel.instrument_id status:status offset:0 size:0 success:^(NSArray<BTContractOrderModel *> *ordersArr) {
            if (contractListType == self.currentContractListType) {
                self.orderModelArray = ordersArr;
                [self.contentTableView reloadData];
            }
        } failure:^(NSError *error) {
            SLLog(@"error: %@", error);
        }];
    }
    // 计划委托
    else if (SLContractListTypePlanCurrent == contractListType || SLContractListTypePlanHistory == contractListType) {
        [BTContractTool getUserPlanContractOrdersWithContractID:self.itemModel.instrument_id status:status offset:0 size:0 success:^(NSArray<BTContractOrderModel *> *ordersArr) {
            if (contractListType == self.currentContractListType) {
                self.orderModelArray = ordersArr;
                [self.contentTableView reloadData];
            }
        } failure:^(NSError *error) {
            SLLog(@"error: %@", error);
        }];
    }
    // 当前持仓
    else if (SLContractListTypeCurrentHave == contractListType) {
        [BTContractTool getUserPositionWithcoinCode:self.itemModel.symbol contractID:self.itemModel.instrument_id status:BTPositionStatus_HoldSystem offset:0 size:0 success:^(NSArray<BTPositionModel *> *dataArr) {
            if (SLContractListTypeCurrentHave == self.currentContractListType) {
                self.positionModelArray = dataArr;
                [self.contentTableView reloadData];
            }
        } failure:^(NSError *error) {
            SLLog(@"error: %@", error);
        }];
    } else if (SLContractListTypeDoneRecord == contractListType) {
        [BTContractTool getContractUserRecordWithContractID:self.itemModel.instrument_id orderID:0 success:^(NSArray<BTContractRecordModel *> *dataArr) {
            self.doneRecordModelArray = dataArr;
            [self.contentTableView reloadData];
        } failure:^(NSError *error) {
            SLLog(@"error:%@",error);
        }];
    } else if (SLContractListTypePositionsHistory == contractListType) {
        [BTContractTool getUserPositionWithContractID:self.itemModel.instrument_id status:BTPositionStatus_Close offset:0 size:0 success:^(NSArray<BTPositionModel *> *dataArr) {
            self.positionModelArray = dataArr;
            [self.contentTableView reloadData];
        } failure:^(NSError *error) {
            SLLog(@"error:%@",error);
        }];
    }
}

#pragma mark - <delegate>
- (void)contractListCell_cancelButtonClickWithOrderModel:(BTContractOrderModel *)contractOrderModel {
    [BTAlertView showTipsInfoWithTitle:@"确认取消" content:@"您确认取消这条订单吗?" withCancelBlock:nil andConfirmBlock:^{
        [self cancelOneOrder:contractOrderModel];
    }];
}

/// 取消某条委托
- (void)cancelOneOrder:(BTContractOrderModel *)orderModel {
    if (orderModel == nil) {
        return;
    }
    [SMProgressHUD showHUD];
    if (orderModel.cycle != nil && orderModel.trigger_type != 0) {
        [BTContractTool cancelPlanOrders:@[orderModel] contractOrderType:0 assetPassword:nil success:^(NSNumber *order_id) {
            [SMProgressHUD hideHUD];
            [self requestContractListDataWithType:self.currentContractListType];
        } failure:^(id err) {
            [SMProgressHUD hideHUD];
            SLLog(@"!!!!!!!!!!! 计划委托取消失败 !!!!!!!!!!!");
        }];
    } else {
        [BTContractTool cancelContractOrders:@[orderModel] contractOrderType:0 assetPassword:nil success:^(NSNumber *order_id) {
            [SMProgressHUD hideHUD];
            [self requestContractListDataWithType:self.currentContractListType];
        } failure:^(id err) {
            [SMProgressHUD hideHUD];
            SLLog(@"!!!!!!!!!!! 委托取消失败 !!!!!!!!!!!");
        }];
    }
}

/// 取消全部当前委托
- (void)cancelAllCurrentOrders {
    [BTContractTool cancelContractOrders:self.orderModelArray contractOrderType:0 assetPassword:nil success:^(NSNumber *order_id) {
        [self requestContractListDataWithType:self.currentContractListType];
    } failure:^(id err) {
        SLLog(@"!!!!!!!!!!! 委托取消失败 !!!!!!!!!!!");
    }];
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((self.currentContractListType == SLContractListTypeCurrent) && self.orderModelArray.count >= 3) {
        return 40;
    } else {
        return 0.f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentContractListType == SLContractListTypeCurrentHave) {
        return self.positionModelArray.count;
    } else if (self.currentContractListType == SLContractListTypeDoneRecord) {
        return self.doneRecordModelArray.count;
    }
    return self.orderModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentContractListType == SLContractListTypeCurrentHave) {
        SLContractCurrentHaveCell *cell = [tableView dequeueReusableCellWithIdentifier:sl_contractList_currentHave_reuseID forIndexPath:indexPath];
        [cell updateViewWithPositionModel:self.positionModelArray[indexPath.row]];
        return cell;
    } else if (self.currentContractListType == SLContractListTypeDoneRecord) {
        SLContractDoneRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:sl_contractList_doneRecord_reuseID forIndexPath:indexPath];
        [cell updateViewWithDoneRecordModel:self.doneRecordModelArray[indexPath.row]];
        return cell;
    } else {
        SLContractListCell *cell = [tableView dequeueReusableCellWithIdentifier:sl_contractList_reuseID forIndexPath:indexPath];
        cell.delegate = self;
        cell.contractListType = self.currentContractListType;
        [cell updateViewWithContractOrderModel:self.orderModelArray[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentContractListType == SLContractListTypeCurrentHave) {
        return 487;
    } else {
        return 187;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
