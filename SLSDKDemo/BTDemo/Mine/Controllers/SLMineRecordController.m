//
//  SLMineRecordController.m
//  BTTest
//
//  Created by WWLy on 2019/9/19.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLMineRecordController.h"
#import "SLMineRecordHeaderView.h"
#import "SLDefinePickerView.h"
#import "SLMineRecordCell.h"
#import "SLBaseTableView.h"

@interface SLMineRecordController () <SLMineRecordHeaderViewDelegate, SLDefinePickerViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SLBaseTableView * recordTableView;

@property (nonatomic, strong) SLMineRecordHeaderView * recordHeaderView;

@property (nonatomic, strong) SLDefinePickerView *pickerView;

@property (nonatomic, strong) NSArray * coinCodeArr;
@property (nonatomic, strong) NSArray * typeArr;

@property (nonatomic, copy) NSString * currentCoinCode;
@property (nonatomic, assign) NSUInteger currentAction;

@property (nonatomic, assign) SLMineRecordHeaderType currentHeaderType;

@property (nonatomic, strong) NSArray <BTCashBooksModel *> * cashBookModelArray;

@end

static NSString *const reuseID = @"SLMineRecordCell_ID";

@implementation SLMineRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self reqeustRecordDataWithCoinCode:@"USDT" action:0];
}

- (void)initUI {
    [self initNav];
    [self initRecordTableView];
}

- (void)initNav {
    // 显示分隔线
    [self changeLineHiddenStatus:NO];
    [self updateNavTitle:Launguage(@"ME_TR_DE")];
}

- (void)initRecordTableView {
    self.recordTableView = [[SLBaseTableView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, self.view.sl_height - SL_SafeAreaTopHeight)];
    self.recordTableView.showsHorizontalScrollIndicator = NO;
    [self.recordTableView registerClass:[SLMineRecordCell class] forCellReuseIdentifier:reuseID];
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    [self.view addSubview:self.recordTableView];
}


#pragma mark - Data

- (void)reqeustRecordDataWithCoinCode:(NSString *)coinCode action:(NSUInteger)action {
    NSArray *actionArr = nil;
    if (action > 0) {
        actionArr = @[@(action)];
    }
    [BTContractTool getCashBooksWithContractID:0
                                         refID:nil
                                        action:actionArr
                                      coinCode:coinCode
                                         limit:100
                                        offset:0
                                         start:nil
                                           end:nil success:^(id result) {
        self.cashBookModelArray = result;
        [self.recordTableView reloadData];
    } failure:^(id error) {
//        self.cashBookModelArray = result;
        SLLog(@"error:%@",error);
    }];
}


#pragma mark - Click Events

- (void)leftNavButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - <SLMineRecordHeaderViewDelegate>

- (void)mineRecordsHeaderView_DidClick:(SLMineRecordHeaderType)headerType {
    self.currentHeaderType = headerType;
    if (headerType == SLMineRecordHeaderTypeNone) {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
    } else if (headerType == SLMineRecordHeaderTypeCoin) {
        if (self.pickerView) {
            [self.pickerView removeFromSuperview];
            self.pickerView = nil;
        }
        SLDefinePickerView *pickerView = [[SLDefinePickerView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight + SL_getWidth(50), SL_SCREEN_WIDTH, 300) titles:self.coinCodeArr];
        self.pickerView = pickerView;
        self.pickerView.pickerView_delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
    } else if (headerType == SLMineRecordHeaderTypeRecordType) {
        if (self.pickerView) {
            [self.pickerView removeFromSuperview];
            self.pickerView = nil;
        }
        SLDefinePickerView *pickerView = [[SLDefinePickerView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight + SL_getWidth(50), SL_SCREEN_WIDTH, 300) titles:self.typeArr];
        self.pickerView = pickerView;
        self.pickerView.pickerView_delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
    }
}


#pragma mark - <SLDefinePickerViewDelegate>

- (void)pickerView_didSelectItem:(NSString *)title index:(NSUInteger)index {
    if (self.currentHeaderType == SLMineRecordHeaderTypeCoin) {
        self.recordHeaderView.leftStr = title;
        self.currentCoinCode = title;
    } else if (self.currentHeaderType == SLMineRecordHeaderTypeRecordType) {
        self.recordHeaderView.rightStr = title;
        self.currentAction = index;
    }
    if (self.pickerView) {
        [self.pickerView removeFromSuperview];
        self.pickerView = nil;
    }
    [self.recordHeaderView reset];
    // 重新请求数据
    [self reqeustRecordDataWithCoinCode:self.currentCoinCode action:self.currentAction];
}


#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cashBookModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SLMineRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cashBookModel = self.cashBookModelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SL_getWidth(120);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.recordHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SL_getWidth(50);
}


#pragma mark - lazy load

- (SLMineRecordHeaderView *)recordHeaderView {
    if (_recordHeaderView == nil) {
        _recordHeaderView = [[SLMineRecordHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.sl_width, SL_getWidth(50))];
        _recordHeaderView.leftStr = @"USDT";
        _recordHeaderView.rightStr = Launguage(@"BT_WD_A");
        _recordHeaderView.delegate = self;
    }
    return _recordHeaderView;
}

- (NSArray *)coinCodeArr {
    if (_coinCodeArr == nil) {
        NSArray *tempArr = [BTMaskFutureTool shareMaskFutureTool].futureArr;
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:tempArr.count];
        for (BTItemModel *model in tempArr) {
            if (model.contractInfo.margin_coin) {
                [mArr addObject:model.contractInfo.margin_coin];
            }
        }
        // 数组去重
        NSSet *set = [NSSet setWithArray:mArr.copy];
        _coinCodeArr = [set allObjects];
    }
    return _coinCodeArr;
}

- (NSArray *)typeArr {
    if (_typeArr == nil) {
        _typeArr = @[Launguage(@"BT_WD_A"), Launguage(@"BT_CA_KDMR"), @"买入平空", @"卖出平多", Launguage(@"BT_CA_KKMC"), @"现货转入", @"转出到现货", @"合约转入", @"转出到合约", Launguage(@"str_transferim_position2contract"), @"增加保证金"];
    }
    return _typeArr;
}

@end
