//
//  SLContractListView.m
//  BTTest
//
//  Created by WWLy on 2019/9/6.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractListView.h"
#import "SLContractListHeaderView.h"
#import "SLContractListCell.h"
#import "SLContractPlanTypeCell.h"
#import "SLContractCurrentHaveCell.h"
#import "BTAlertView.h"
#import "BTContractAlertView.h"
#import "BTAssetPasswordView.h"

static NSString *const sl_contractList_reuseID = @"sl_contractList_SLContractListCell";
static NSString *const sl_contractList_planType_reuseID = @"sl_contractList_SLContractPlanTypeCell";
static NSString *const sl_contractList_currentHave_reuseID = @"sl_contractList_SLContractCurrentHaveCel";

@interface SLContractListView () <SLContractListHeaderViewDelegate, SLContractPlanTypeCellDelegate, UITableViewDelegate, UITableViewDataSource, SLContractListCellDelegate, SLContractCurrentHaveCellDelegate, BTContractAlertViewDelegate, BTAssetPasswordViewDelegate>

@property (nonatomic, strong) SLContractListHeaderView * headerView;
@property (nonatomic, strong) UITableView * contentTableView;
@property (nonatomic, strong) UIView * footerView;

/// 当前显示的委托数据类型
@property (nonatomic, assign) SLContractListType currentContractListType;

@property (nonatomic, strong) BTItemModel * itemModel;

/// 非当前持仓
@property (nonatomic, strong) NSArray <BTContractOrderModel *> * orderModelArray;

/// 当前持仓
@property (nonatomic, strong) NSArray <BTPositionModel *> * positionModelArray;

@property (nonatomic, strong) NSArray *entrustOrders;

@property (nonatomic, strong) BTPositionModel *positionModel;

@property (nonatomic, assign) BTContractOrderCategory closeCategory;

@end

@implementation SLContractListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveContractDataFromSocket:) name:SLSocketDataUpdate_Unicast_Notification object:nil];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    self.contentTableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.contentTableView.backgroundColor = [SLConfig defaultConfig].contentViewColor;
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    self.contentTableView.showsHorizontalScrollIndicator = NO;
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.contentTableView];
    
    [self.contentTableView registerClass:[SLContractListCell class] forCellReuseIdentifier:sl_contractList_reuseID];
    [self.contentTableView registerClass:[SLContractPlanTypeCell class] forCellReuseIdentifier:sl_contractList_planType_reuseID];
    [self.contentTableView registerClass:[SLContractCurrentHaveCell class] forCellReuseIdentifier:sl_contractList_currentHave_reuseID];
    
    self.contentTableView.contentInset = UIEdgeInsetsMake(0, 0, SL_SafeAreaBottomHeight, 0);
    
    if (@available(iOS 11.0, *)) {
        self.contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.currentContractListType = SLContractListTypeCurrent;
}


#pragma mark - Data

- (void)updateViewWithItemModel:(BTItemModel *)itemModel {
    self.itemModel = itemModel;
    [self requestContractListDataWithType:self.currentContractListType];
}

- (void)refreshContractInfo {
    // 刷新资产信息
    [[SLPlatformSDK sharedInstance]sl_loadUserContractPerpoty];
    // 刷新委托数据
    [self updateViewWithItemModel:self.itemModel];
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
        [BTContractTool getUserPositionWithcoinCode:self.itemModel.contractInfo.margin_coin contractID:self.itemModel.instrument_id status:BTPositionStatus_HoldSystem offset:0 size:0 success:^(NSArray<BTPositionModel *> *dataArr) {
            if (SLContractListTypeCurrentHave == self.currentContractListType) {
                self.positionModelArray = dataArr;
                [self.contentTableView reloadData];
            }
        } failure:^(NSError *error) {
            SLLog(@"error: %@", error);
        }];
    }
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

/// 取消全部计划委托
- (void)cancelAllPlanOrders {
    [BTContractTool cancelPlanOrders:self.orderModelArray contractOrderType:0 assetPassword:nil success:^(NSNumber *order_id) {
        [self requestContractListDataWithType:self.currentContractListType];
    } failure:^(id err) {
        SLLog(@"!!!!!!!!!!! 计划委托取消失败 !!!!!!!!!!!");
    }];
}


#pragma mark - Click Events

/// 取消所有当前委托
- (void)didClickCancelAllOrders:(UIButton *)sender {
    [BTAlertView showTipsInfoWithTitle:@"确认取消" content:@"您确认取消这些订单么？" withCancelBlock:^{
        
    } andConfirmBlock:^{
        [self cancelAllCurrentOrders];
    }];
}


#pragma mark - <SLContractListHeaderViewDelegate>

/// 切换委托类型
- (void)headerView_buttonClick:(SLContractListType)contractListType {
    if (self.currentContractListType == contractListType) {
        return;
    }
    
    self.currentContractListType = contractListType;
    
    [self requestContractListDataWithType:contractListType];
}


#pragma mark - <SLContractPlanTypeCellDelegate>

/// 选择当前计划或历史计划
- (void)contractPlanTypeCell_selectedContractPlanType:(SLContractPlanType)contractPlanType {
    SLContractListType type = SLContractListTypePlanCurrent;
    if (contractPlanType == SLContractPlanTypeCurrent) {
        type = SLContractListTypePlanCurrent;
    } else if (contractPlanType == SLContractPlanTypeHistory) {
        type = SLContractListTypePlanHistory;
    }
    if (self.currentContractListType == type) {
        return;
    }
    self.currentContractListType = type;
    [self requestContractListDataWithType:self.currentContractListType];
}


#pragma mark - <SLContractListCellDelegate>

/// 取消当前委托
- (void)contractListCell_cancelButtonClickWithOrderModel:(BTContractOrderModel *)contractOrderModel {
    [BTAlertView showTipsInfoWithTitle:@"确认取消" content:@"您确认取消这条订单吗?" withCancelBlock:nil andConfirmBlock:^{
        [self cancelOneOrder:contractOrderModel];
    }];
}

#pragma mark - <UITableViewDelegate>

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // 当前委托会显示底部取消全部按钮
    if ((self.currentContractListType == SLContractListTypeCurrent) && self.orderModelArray.count >= 3) {
        return self.footerView;
    } else {
        return nil;
    }
}

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
    } else if (self.currentContractListType == SLContractListTypePlanCurrent || self.currentContractListType == SLContractListTypePlanHistory) {
        return self.orderModelArray.count + 1;
    }
    return self.orderModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentContractListType == SLContractListTypePlanCurrent || self.currentContractListType == SLContractListTypePlanHistory) {
        if (indexPath.row == 0) {
            SLContractPlanTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:sl_contractList_planType_reuseID forIndexPath:indexPath];
            if (self.currentContractListType == SLContractListTypePlanHistory) {
                [cell updateViewWithContractPlanType:SLContractPlanTypeHistory];
            } else {
                [cell updateViewWithContractPlanType:SLContractPlanTypeCurrent];
            }
            cell.delegate = self;
            return cell;
        } else {
            SLContractListCell *cell = [tableView dequeueReusableCellWithIdentifier:sl_contractList_reuseID forIndexPath:indexPath];
            cell.delegate = self;
            cell.contractListType = self.currentContractListType;
            [cell updateViewWithContractOrderModel:self.orderModelArray[indexPath.row - 1]];
            return cell;
        }
    } else if (self.currentContractListType == SLContractListTypeCurrentHave) {
        SLContractCurrentHaveCell *cell = [tableView dequeueReusableCellWithIdentifier:sl_contractList_currentHave_reuseID forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateViewWithPositionModel:self.positionModelArray[indexPath.row]];
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
    if ((self.currentContractListType == SLContractListTypePlanCurrent || self.currentContractListType == SLContractListTypePlanHistory) && indexPath.row == 0) {
        return 40;
    } else if (self.currentContractListType == SLContractListTypeCurrentHave) {
        return 487;
    } else {
        return 187;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(contractListView_scrollViewDidScroll:)]) {
        [self.delegate contractListView_scrollViewDidScroll:scrollView];
    }
}


#pragma mark - <SLContractCurrentHaveCellDelegate>

/// 调整保证金
- (void)currentHaveCell_adjustMarginWithPositionModel:(BTPositionModel *)positionModel {
    self.positionModel = positionModel;
    [BTContractAlertView showContractAlertViewWithData:[positionModel mj_keyValues] andAlertType:BTContractAlertViewContractSupplementDeposit andSetDelegate:self];
}

/// 平仓
- (void)currentHaveCell_sellAllWithPositionModel:(BTPositionModel *)positionModel {
    self.positionModel = positionModel;
    [BTContractAlertView showContractAlertViewWithData:[positionModel mj_keyValues] andAlertType:BTContractAlertViewContractCloseHold andSetDelegate:self];
}


#pragma mark - <BTContractAlertViewDelegate>

/// 点击了取消
- (void)contractAlertViewDidClickCancelWithType:(BTContractAlertViewType)type {
    if (type == BTContractAlertViewContractCloseHold) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractCloseHold];
    } else if (type == BTContractAlertViewMarketPriceClose2) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose2];
    } else if (type == BTContractAlertViewMarketPriceClose1) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose1];
    } else if (type == BTContractAlertViewMarketPriceClose3) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose3];
    } else if (type == BTContractAlertViewMarketPriceClose4) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose4];
    } else if (type == BTContractAlertViewContractSupplementDeposit) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractSupplementDeposit];
    }
}

/// 点击了平仓
- (void)contractAlertViewDidClickComfirmWithType:(BTContractAlertViewType)type info:(NSDictionary *)info {
    if (type == BTContractAlertViewContractCloseHold) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractCloseHold];
        [self submitCloseOrderWithCategory:BTContractOrderCategoryNormal
                                     price:info[@"price"]
                                       vol:info[@"volume"] assetPassword:nil];
    } else if (type == BTContractAlertViewMarketPriceClose1) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose1];
        // 判断是否有该仓位未成交状态的平仓委托单
        self.entrustOrders = [SLFormula getCloseEntrustOrderWithPosition:self.positionModel];
        if (self.entrustOrders.count <= 0) { // 没有未成交的平仓委托单
            // 市价
            [self submitMarketClose];
        } else {
            NSDictionary *data = nil;
            NSString *vol = @"0";
            NSString *name = self.positionModel.name;
            for (BTContractOrderModel *model in self.entrustOrders) {
                vol = [vol bigAdd:[model.qty bigSub:model.cum_qty]];
            }
            data = @{@"type":@(self.positionModel.position_type),
                     @"name":name,
                     @"vol":vol};
            [BTContractAlertView showContractAlertViewWithData:data andAlertType:BTContractAlertViewMarketPriceClose2 andSetDelegate:self];
        }
    } else if (type == BTContractAlertViewMarketPriceClose2) {
        // 点击了全部撤销
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose2];
        // 弹出
        [BTContractAlertView showContractAlertViewWithData:nil andAlertType:BTContractAlertViewMarketPriceClose3 andSetDelegate:self];
        [BTContractTool cancelContractOrders:self.entrustOrders contractOrderType:BTDefineContractClose assetPassword:nil success:^(NSNumber *order_id) {
            // 隐藏弹框3
            [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose3];
            // 弹出市价全平
            [BTContractAlertView showContractAlertViewWithData:nil andAlertType:BTContractAlertViewMarketPriceClose4 andSetDelegate:self];
        } failure:^(id error) {
            SL_SHOW_ERROR_MESSAGE(error)
            [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose3];
        }];
    } else if (type == BTContractAlertViewMarketPriceClose4) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose4];
        [self submitMarketClose];
    } else if (type == BTContractAlertViewContractSupplementDeposit) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractSupplementDeposit];
        [self adjustDepositWithData:info];
    }
}

// 点击了市价全平
- (void)contractAlertViewDidClickMarketPriceCloseWithtype:(BTContractAlertViewType)type {
    if (type == BTContractAlertViewContractCloseHold) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewContractCloseHold];
        NSDictionary *dict = @{@"name":self.positionModel.name};
        [BTContractAlertView showContractAlertViewWithData:dict andAlertType:BTContractAlertViewMarketPriceClose1 andSetDelegate:self];
    } else if (type == BTContractAlertViewMarketPriceClose1) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose1];
    } else if (type == BTContractAlertViewMarketPriceClose2) {
        [BTContractAlertView hideContractAlertViewWithType:BTContractAlertViewMarketPriceClose2];
    }
}


// 提交市价全平
- (void)submitMarketClose {
    NSString *price = [BTMaskFutureTool marketPriceWithContractID:self.positionModel.instrument_id];
    // 可平仓量
    NSString *vol = [self.positionModel.cur_qty bigSub:self.positionModel.freeze_qty];
    [self submitCloseOrderWithCategory:BTContractOrderCategoryMarket
                                 price:price
                                   vol:vol assetPassword:nil];
}

// 提交平仓订单
- (void)submitCloseOrderWithCategory:(BTContractOrderCategory)category  price:(NSString *)price vol:(NSString *)vol assetPassword:(NSString *)password {
//    __weak BTHoldPositionView *weakSelf = self;
    BTContractOrderWay way = 0;
    if (self.positionModel.position_type == BTPositionType_OpenMore) {
        way = BTContractOrderWaySell_CloseLong;
    } else {
        way = BTContractOrderWayBuy_CloseShort;
    }
    BTContractOrderModel *orderModel = [BTContractOrderModel newContractCloseOrderWithContractId:self.positionModel.instrument_id category:category way:way positionID:self.positionModel.pid price:price vol:vol];
    orderModel.position_type = self.positionModel.position_type;
    self.positionModel.closeVol = vol;
    self.positionModel.closePrice = price;
    self.closeCategory = category;
    __weak typeof(self) weakSelf = self;
    [BTPreloadingView showPreloadingViewToView:[UIApplication sharedApplication].keyWindow];
    [BTContractTool sendContractsOrder:orderModel contractOrderType:BTDefineContractClose assetPassword:password success:^(NSNumber *order_id) {
        [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
        [weakSelf refreshContractInfo];
    } failure:^(id error) {
        if ([error isEqualToString:SHOW_FUND_PWD]) {
            [BTAssetPasswordView showAssetPasswordViewToView:[UIApplication sharedApplication].keyWindow delegate:weakSelf type:BTAssetPasswordVerifyType];
        } else {
            SL_SHOW_ERROR_MESSAGE(error);
        }
        [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
    }];
}

// 点击调整保证金
- (void)adjustDepositWithData:(NSDictionary *)data {
    __weak typeof(self) weakSelf = self;
    [BTPreloadingView showPreloadingViewToView:[UIApplication sharedApplication].keyWindow];
    [BTContractTool marginDepositWithContractID:self.positionModel.instrument_id positionID:self.positionModel.pid vol:data[@"vol"] operType:[data[@"oper_type"] integerValue] success:^(id result) {
        [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
        [weakSelf refreshContractInfo];
    } failure:^(id error) {
        [BTPreloadingView hidePreloadingViewToView:[UIApplication sharedApplication].keyWindow];
        SL_SHOW_ERROR_MESSAGE(error)
    }];
}


#pragma mark - <BTAssetPasswordViewDelegate>

- (void)assetPasswordViewDidClickConfirmWithType:(BTAssetPasswordViewType)type password:(NSString *)pwd {
    
}

- (void)assetPasswordViewDidClickCancel {
    [BTAssetPasswordView hideAssetViewFromView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - Socket

- (void)didReceiveContractDataFromSocket:(NSNotification *)notify {
    NSDictionary *userInfo = notify. userInfo;
    NSArray <BTWebSocketModel *> *modelArray = userInfo[@"data"];
    if (modelArray.count == 0) {
        return;
    }
    // 1. 获取到订单数据更新后先根据订单 id 替换之前的订单
    NSMutableArray *orderModelArray_M = [NSMutableArray arrayWithArray:self.orderModelArray];
    int orderModelArray_count = (int)orderModelArray_M.count;
    NSMutableArray *positionModelArray_M = [NSMutableArray arrayWithArray:self.positionModelArray];
    int positionModelArray_count = (int)positionModelArray_M.count;
    for (BTWebSocketModel *socketModel in modelArray) {
        BTContractOrderModel *newOrderModel = socketModel.order;
        if (newOrderModel != nil) {
            int i = 0;
            for (; i < orderModelArray_count; ++i) {
                BTContractOrderModel *oldOrderModel = orderModelArray_M[i];
                if (oldOrderModel.oid == newOrderModel.oid) {
                    [orderModelArray_M replaceObjectAtIndex:i withObject:newOrderModel];
                }
            }
            // 如果没找到相同 ID 的订单, 则把数据添加进来
            if (i == orderModelArray_count) {
                [orderModelArray_M insertObject:newOrderModel atIndex:0];
            }
        }
        BTPositionModel *newPositionModel = socketModel.position;
        if (newPositionModel != nil) {
            int i = 0;
            for (; i < positionModelArray_count; ++i) {
                BTPositionModel *oldPositionModel = positionModelArray_M[i];
                if (oldPositionModel.pid == newPositionModel.pid) {
                    [positionModelArray_M replaceObjectAtIndex:i withObject:newPositionModel];
                }
            }
            // 如果没找到相同 ID 的订单, 则把数据添加进来
            if (i == orderModelArray_count) {
                [positionModelArray_M insertObject:newPositionModel atIndex:0];
            }
        }
    }
    // 2. 对数据进行筛选, 移除状态不匹配的数据
    switch (self.currentContractListType) {
        case SLContractListTypeCurrent:
            for (int i = 0; i < orderModelArray_M.count; ++i) {
                BTContractOrderModel *model = orderModelArray_M[i];
                if (model.status != BTContractOrderStatusWait || model.cycle!= nil) {
                    [orderModelArray_M removeObject:model];
                }
            }
            break;
        case SLContractListTypeHistory:
            for (int i = 0; i < orderModelArray_M.count; ++i) {
                BTContractOrderModel *model = orderModelArray_M[i];
                if (model.status != BTContractOrderStatusFinished || model.cycle) {
                    [orderModelArray_M removeObject:model];
                }
            }
            break;
        case SLContractListTypePlanCurrent:
            for (int i = 0; i < orderModelArray_M.count; ++i) {
                BTContractOrderModel *model = orderModelArray_M[i];
                if (model.status != BTContractOrderStatusWait || !model.cycle) {
                    [orderModelArray_M removeObject:model];
                }
            }
            break;
        case SLContractListTypePlanHistory:
            for (int i = 0; i < orderModelArray_M.count; ++i) {
                BTContractOrderModel *model = orderModelArray_M[i];
                if (model.status != BTContractOrderStatusFinished || !model.cycle) {
                    [orderModelArray_M removeObject:model];
                }
            }
            break;
        case SLContractListTypeCurrentHave:
            for (int i = 0; i < positionModelArray_M.count; ++i) {
                BTPositionModel *model = positionModelArray_M[i];
                if (model.status != BTPositionStatus_Holding && model.status != BTPositionStatus_System && model.status != BTPositionStatus_HoldSystem) {
                    [positionModelArray_M removeObject:model];
                }
            }
            break;
        default:
            break;
    }
    self.orderModelArray = orderModelArray_M.copy;
    self.positionModelArray = positionModelArray_M.copy;
    [self.contentTableView reloadData];
}


#pragma mark - lazy load

- (SLContractListHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[SLContractListHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, 35)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sl_width, 40)];
        UIButton *button = [UIButton buttonExtensionWithTitle:@"取消所有委托订单" TitleColor:[SLConfig defaultConfig].lightGrayTextColor Image:nil font:[UIFont systemFontOfSize:13] target:self action:@selector(didClickCancelAllOrders:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(20, 5, self.sl_width - 40, 30);
        button.layer.cornerRadius = 2;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [SLConfig defaultConfig].lightGrayTextColor.CGColor;
        [_footerView addSubview:button];
    }
    return _footerView;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
