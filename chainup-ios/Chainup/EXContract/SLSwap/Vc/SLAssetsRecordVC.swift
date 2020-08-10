//
//  SLAssetsRecordVC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/6.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 资金记录
class SLAssetsRecordVC: NavCustomVC, EXEmptyDataSetable {
    
    var coinModelArray: [SLMinePerprotyModel] = {
        var modelArr: [SLMinePerprotyModel] = []
        guard let coinArr = SLPersonaSwapInfo.sharedInstance().getAllSwapAssetItem() else {
            return modelArr
        }
        for coinModel in coinArr {
            let property = SLMinePerprotyModel()
            property.conversionContractAssetsWithitemModel(coinModel)
            modelArr.append(property)
        }
        return modelArr
    }()
    
    private var currentCoinModel: SLMinePerprotyModel?
    
    var recordWay : BTContractRecordWay = .CONTRACT_TRADE_WAY_UN_KNOW
    
    var isBouns = false
    
    private var tableViewRowDatas: [BTCashBooksModel] = []
    
    private let cellReUseID = "SLAssetsRecordCell_ID"
    
    lazy var sectionHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 46))
        view.backgroundColor = UIColor.ThemeNav.bg
        view.addSubview(self.screeningView)
        return view
    }()
    
    lazy var screeningView: SLSwapScreeningView = {
        let view = SLSwapScreeningView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 36))
        view.isHiddenPriceType = true
        return view
    }()
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.rowHeight = 131
        tableView.extSetTableView(self, self)
        tableView.extRegistCell([SLAssetsRecordCell.classForCoder()], [cellReUseID])
        tableView.mj_header = EXRefreshHeaderView(refreshingBlock: {
            [weak self] in
            guard let mySelf = self else { return }
            mySelf.requestAssetsRecordData(way: mySelf.recordWay, coinCode: mySelf.currentCoinModel?.itemCoinModel.coin_code ?? "")
        })
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubViews([self.contentTableView])
        
        self.initLayout()
        
        self.exEmptyDataSet(self.contentTableView)
        
        var names: [String] = []
        for perprotyModel in self.coinModelArray {
            names.append(perprotyModel.coin_code ?? "--")
        }
        self.screeningView.swapNameArray = names
        self.screeningView.orderTypeArray = ["contract_transaction_all_types".localized(), "contract_buy_openMore".localized(), "contract_buy_closeLess".localized(), "contract_sell_closeMore".localized(), "contract_sell_openLess".localized(), "contract_assets_record_transfer_from_swap_account".localized(), "contract_assets_record_transfer_to_swap_account".localized(), "contract_action_decreaseMargin".localized(), "contract_action_increaseMargin".localized(),"contract_action_airdrop".localized(),"contract_fee_share".localized(),"contract_text_getBouns".localized(),"contract_text_outBouns".localized(), "contract_asset_recprd_transfer_yunContractIn".localized(), "contract_asset_recprd_transfer_yunContractOut".localized()]
    
        self.screeningView.screeningValueChanged = {[weak self]
            (swapNameIndex: Int, pirceTypeIndex: Int, orderTypeIndex: Int) in
            guard let mySelf = self else { return }
            
            let perprotyModel = mySelf.coinModelArray[swapNameIndex]
            mySelf.currentCoinModel = perprotyModel
            
            switch orderTypeIndex {
                case 0:
                    mySelf.recordWay = .CONTRACT_TRADE_WAY_UN_KNOW
                case 1:
                    mySelf.recordWay = .CONTRACT_ORDER_WAY_BUY_OPEN_LONG
                case 2:
                    mySelf.recordWay = .CONTRACT_ORDER_WAY_BUY_CLOSE_SHORT
                case 3:
                    mySelf.recordWay = .CONTRACT_ORDER_WAY_SELL_CLOSE_LONG
                case 4:
                    mySelf.recordWay = .CONTRACT_ORDER_WAY_SELL_OPEN_SHORT
                case 5:
                    mySelf.recordWay = .CONTRACT_WAY_BB_TRANSFER_IN
                case 6:
                    mySelf.recordWay = .CONTRACT_WAY_TRANSFER_TO_BB
                case 7:
                    mySelf.recordWay = .CONTRACT_WAY_REDUCE_DEPOSIT_TRANSFER
                case 8:
                    mySelf.recordWay = .CONTRACT_WAY_INCREA_DEPOSIT_TRANSFER
                case 9:
                    mySelf.recordWay = .CONTRACT_WAY_AIR_DROP
                case 10:
                    mySelf.recordWay = .CONTRACT_WAY_FEE_TENTHS
                case 11:
                    mySelf.recordWay = .CONTRACT_WAY_BOUNS_IN
                case 12:
                    mySelf.recordWay = .CONTRACT_WAY_BOUNS_OUT
                case 13:
                    mySelf.recordWay = .CONTRACT_WAY_ASSET_SWAP_IN
                case 14:
                    mySelf.recordWay = .CONTRACT_WAY_ASSET_SWAP_OUT
                default: break
            }
            
            mySelf.requestAssetsRecordData(way: mySelf.recordWay, coinCode: mySelf.currentCoinModel?.itemCoinModel.coin_code ?? "")
        }
        
        if isBouns == true {
            self.recordWay = .CONTRACT_WAY_BOUNS_IN
            self.screeningView.orderTypeButton.text(content: self.screeningView.orderTypeArray[11])
        }
        
        self.currentCoinModel = self.coinModelArray.first
        
        var property = BTItemCoinModel()
        if recordWay == .CONTRACT_WAY_BOUNS_IN {
            for model in SLPersonaSwapInfo.sharedInstance()!.getAllSwapAssetItem() {
                if model.bonus_vol.greaterThan(BT_ZERO) {
                    property = model
                    break;
                }
            }
        } else {
            if self.coinModelArray.count > 0  {
                if let model = self.coinModelArray.first?.itemCoinModel {
                    property = model
                }
            }
        }
        self.requestAssetsRecordData(way: self.recordWay, coinCode: property.coin_code ?? "")
    }

    override func setNavCustomV() {
        self.setTitle("contract_assets_record".localized())
        self.lastVC = true
        self.xscrollView = self.contentTableView
        self.navCustomView.backgroundColor = UIColor.ThemeNav.bg
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.navCustomView.snp_bottom).offset(18)
        }
    }
}


// MARK: - Update Data

extension SLAssetsRecordVC {
    /// 获取资金记录
    private func requestAssetsRecordData(way: BTContractRecordWay, coinCode: String) {
        var action: [NSNumber] = []
        if way != .CONTRACT_TRADE_WAY_UN_KNOW {
            action.append(NSNumber.init(value: way.rawValue))
        }
        BTContractTool.getCashBooks(withContractID: 0, refID: nil, action: action, coinCode: coinCode, limit: 100, offset: 0, start: nil, end: nil, success: { (result: [BTCashBooksModel]?) in
            guard let modelArray = result else {
                self.endRefresh()
                return
            }
            self.tableViewRowDatas = modelArray
            self.contentTableView.reloadData()
            self.endRefresh()
        }) { (error) in
            self.endRefresh()
        }
    }
    
    private func endRefresh() {
        self.contentTableView.mj_header?.endRefreshing()
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension SLAssetsRecordVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReUseID, for: indexPath) as! SLAssetsRecordCell
        cell.updateCell(model: self.tableViewRowDatas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
}
