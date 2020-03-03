//
//  SLContractTableViewController.m
//  BTTest
//
//  Created by 健 王 on 2019/9/18.
//  Copyright © 2019 wwly. All rights reserved.
//

#import "SLContractTableViewController.h"
#import "SLContractTableViewCell.h"
#import "SLBaseTableView.h"

@interface SLContractTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) SLBaseTableView *tableView;
@property (nonatomic, assign) SLNewTableViewType tableType;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation SLContractTableViewController

- (instancetype)initWithTableViewType:(SLNewTableViewType)type {
    if (self = [super init]) {
        self.tableType = type;
    }
    return self;
}

- (void)setupTableView {
    SLBaseTableView *tableView = [[SLBaseTableView alloc] initWithFrame:CGRectMake(0, SL_SafeAreaTopHeight, self.view.sl_width, self.view.sl_height - SL_SafeAreaTopHeight) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.view addSubview: self.tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = DARK_BARKGROUND_COLOR;
    if (self.tableType == SLNewTableViewContractTurnover) {
        self.tableView.rowHeight = SL_getHeightKeepWHAspectAndWidthEqualScreenW(120.f);
    } else if (self.tableType == SLNewTableViewContractLever) {
        self.tableView.rowHeight = SL_getHeightKeepWHAspectAndWidthEqualScreenW(50.f);
    } else {
        self.tableView.rowHeight = SL_getHeightKeepWHAspectAndWidthEqualScreenW(60.f);
    }
    self.tableView.separatorColor = [UIColor clearColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self registeCell];
}

- (void)registeCell{
    if (self.tableType == SLNewTableViewContractSetting) {
        [self.tableView registerClass:[SLContractTableViewCell class] forCellReuseIdentifier:SL_CONTRACTSETTING_CELL];
    } else if (self.tableType == SLNewTableViewContractTradeRule) {
        [self.tableView registerClass:[SLContractTableViewCell class] forCellReuseIdentifier:SL_CONTRACTTRADERULE_CELL];
    } else if (self.tableType == SLNewTableViewContractTurnover) {
        [self.tableView registerClass:[SLContractTableViewCell class] forCellReuseIdentifier:SL_CONTRACTTURNOVER_CELL];
    } else if (self.tableType == SLNewTableViewContractLever) {
        [self.tableView registerClass:[SLContractTableViewCell class] forCellReuseIdentifier:SL_CONTRACTSETTING_CELL];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self initNav];
}

- (void)initNav {
    [self changeLineHiddenStatus:NO];
    [self updateNavTitle:@"杠杆倍数"];
    if (self.tableType == SLNewTableViewContractLever) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 44, 44);
        [rightButton setImage:[UIImage imageWithName:@"icon-Q_white"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(LeverVcDidClickRightButton) forControlEvents:UIControlEventTouchUpInside];
        [self setCustomRightView:rightButton];
    }
    
}

- (void)LeverVcDidClickRightButton {
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableType == SLNewTableViewContractLever) {
        SLContractTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SL_CONTRACTSETTING_CELL];
        if (cell == nil) {
            cell = [[SLContractTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SL_CONTRACTSETTING_CELL];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = MAIN_GARY_TEXT_COLOR;
        cell.noIcon = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.dataArr[indexPath.row];
        if ([cell.textLabel.text isEqualToString:self.currentLever]) {
            cell.hasSelect = YES;
        } else {
            cell.hasSelect = NO;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableType == SLNewTableViewContractLever) {
        SLContractTableViewCell *cell = (SLContractTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.tag = indexPath.row;
        cell.hasSelect = YES;
        if (self.toSelectCell) {
            self.toSelectCell(cell);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.tableType == SLNewTableViewContractLever) {
        return 0.5;
    }
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - getter or setter

- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (void)setLeverArr:(NSMutableArray *)leverArr {
    _leverArr = leverArr;
    self.dataArr = leverArr;
}


@end
