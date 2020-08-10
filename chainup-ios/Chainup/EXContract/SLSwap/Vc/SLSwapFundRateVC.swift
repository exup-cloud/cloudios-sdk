//
//  SLSwapFundRateVC.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/3.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 资金费率
class SLSwapFundRateVC: NavCustomVC {
    
    var itemModel: BTItemModel? {
        didSet {
            self.updateBaseInfo()
        }
    }

    private var baseInfo = [(String, String)]()
    
    private var tableViewRowDatas = [BTIndexDetailModel]()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.contentView.height), style: .plain)
        tableView.extSetTableView(self, self)
        tableView.tableHeaderView = self.tableHeaderView
        tableView.extRegistCell([SLSwapFundRateCell.classForCoder()], [self.reuseID])
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
        }
        return tableView
    }()
    
    private let reuseID = "SLSwapFundRateCell_ID"
    
    private lazy var tableHeaderView: SLSwapFundRateHeader = SLSwapFundRateHeader(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 335))
    
    private lazy var sectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeView.bg
        return view
    }()
    
    private lazy var selectionTitleBar: EXSelectionTitleBar = {
        let view = EXSelectionTitleBar()
        view.setSelected(atIdx: 0)
        view.bindTitleBar(with: ["contract_fund_rate_base_info".localized(), "contract_fund_rate_insurance_fund".localized(), "contract_fund_rate".localized()])
        view.titleBarCallback = {
            [weak self] index in
            guard let mySelf = self else{return}
            mySelf.selectedIndex = index
            if index == 0 {
                mySelf.updateBaseInfo()
            } else if (index == 1) {
                mySelf.requestInsuranceFund()
            } else if (index == 2) {
                mySelf.requestFundRate()
            }
        }
        return view
    }()
    
    private var selectedIndex: Int = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sectionView.addSubview(self.selectionTitleBar)
        self.contentView.addSubViews([self.contentTableView])
        self.initLayout()
        if #available(iOS 11.0, *) {
            self.contentTableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if let _itemModel = self.itemModel {
            self.tableHeaderView.updateView(itemModel: _itemModel)
            BTMaskFutureTool.getMonthData(withContractID: _itemModel.instrument_id, success: {[weak self] (model: BTItemModel?) in
                if let _model = model {
                    self?.tableHeaderView.updateThirtyDaysInfo(itemModel: _model)
                }
            }) { (error) in
                
            }
        }
    }
    
    override func setNavCustomV() {
        self.setTitle("contract_fund_rate".localized())
        self.xscrollView = self.contentTableView
    }
    
    private func initLayout() {
        self.contentTableView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.selectionTitleBar.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}


// MARK: - Update Data

extension SLSwapFundRateVC {
    private func updateBaseInfo() {
        let coinName = self.itemModel?.contractInfo.base_coin ?? "--"
        let marginName = self.itemModel?.contractInfo.margin_coin ?? "--"
        let type = (self.itemModel?.contractInfo.is_reverse ?? false) ? "contract_isReverse_swap".localized() : "contract_lunar_direct_swap".localized()
        let size = String(format: "1%@=%@%@", "contract_text_volumeUnit".localized(), self.itemModel?.contractInfo.face_value ?? "--", self.itemModel?.contractInfo.price_coin ?? "--")
        let level = String(format: "%@%@", self.itemModel?.contractInfo.leverageArr.first ?? "--", "contract_position_level".localized())
        let source = self.itemModel?.index_market ?? "--"
        var info = [("contract_fund_rate_coin_name_title".localized(), coinName),
                    ("contract_fund_rate_margin_name_title".localized(), marginName),
                    ("contract_fund_rate_contract_type".localized(), type),
                    ("contract_fund_rate_contract_size".localized(), size),
                    ("contract_fund_rate_max_level".localized(), level),
                    ("contract_fund_rate_index_source".localized(), source)]
        self.baseInfo = info
        BTMaskFutureTool.getIndexesInfo(withIndexId: self.itemModel?.contractInfo.index_id ?? 0, success: { (res) in
            info.removeLast()
            info.append(("contract_fund_rate_index_source".localized(), res ?? "--"))
            self.baseInfo = info
            self.contentTableView.reloadData()
        }) { (error) in
            self.contentTableView.reloadData()
        }
    }
    
    /// 获取保险基金
    private func requestInsuranceFund() {
        guard let instrument_id = self.itemModel?.instrument_id else {
            return
        }
        BTContractTool.getRiskReserves(withContractID: instrument_id, success: { (result: [Any]?) in
            if let array = result as? Array<BTIndexDetailModel> {
                self.tableViewRowDatas = array
                self.contentTableView.reloadData()
            }
        }) { (error) in
            
        }
    }
    
    /// 获取资金费率
    private func requestFundRate() {
        guard let instrument_id = self.itemModel?.instrument_id else {
            return
        }
        BTContractTool.getFundingrateWithContractID(instrument_id, success: { (result: Any?) in
            if let array = result as? Array<BTIndexDetailModel> {
                self.tableViewRowDatas = array
                self.contentTableView.reloadData()
            }
        }) { (error) in
            
        }
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource

extension SLSwapFundRateVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedIndex == 0 {
            return self.baseInfo.count
        } else if self.selectedIndex == 1 {
            return self.tableViewRowDatas.count + 1
        } else if self.selectedIndex == 2 {
            return self.tableViewRowDatas.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! SLSwapFundRateCell
        if self.selectedIndex == 0 {
            cell.middleLabel.isHidden = true
            cell.leftLabel.font = UIFont.ThemeFont.SecondaryRegular
            cell.leftLabel.textColor = UIColor.ThemeLabel.colorMedium
            cell.rightLabel.font = UIFont.ThemeFont.BodyRegular
            cell.rightLabel.textColor = UIColor.ThemeLabel.colorLite
            cell.leftLabel.text = self.baseInfo[indexPath.row].0
            cell.rightLabel.text = self.baseInfo[indexPath.row].1
        } else if self.selectedIndex == 1 {
            cell.middleLabel.isHidden = true
            if indexPath.row == 0 {
                cell.leftLabel.font = UIFont.ThemeFont.SecondaryRegular
                cell.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
                cell.rightLabel.textColor = UIColor.ThemeLabel.colorMedium
                cell.leftLabel.text = "kline_text_dealTime".localized()
                cell.rightLabel.text = "contract_fund_rate_insurance_balance".localized()
            } else {
                cell.leftLabel.font = UIFont.ThemeFont.BodyRegular
                cell.rightLabel.font = UIFont.ThemeFont.BodyRegular
                cell.rightLabel.textColor = UIColor.ThemeLabel.colorLite
                let model = self.tableViewRowDatas[indexPath.row-1]
                cell.leftLabel.text = BTFormat.timeOnlyDate(fromDateStr: model.timestamp.stringValue)
                cell.rightLabel.text = (model.qty ?? "-") + (self.itemModel?.contractInfo.margin_coin ?? "-")
            }
        } else if self.selectedIndex == 2 {
            cell.middleLabel.isHidden = false
            if indexPath.row == 0 {
                cell.leftLabel.font = UIFont.ThemeFont.SecondaryRegular
                cell.middleLabel.font = UIFont.ThemeFont.SecondaryRegular
                cell.middleLabel.textColor = UIColor.ThemeLabel.colorMedium
                cell.rightLabel.font = UIFont.ThemeFont.SecondaryRegular
                cell.rightLabel.textColor = UIColor.ThemeLabel.colorMedium
                cell.leftLabel.text = "kline_text_dealTime".localized()
                cell.middleLabel.text = "contract_fund_rate_time_interval".localized()
                cell.rightLabel.text = "contract_fund_rate".localized()
            } else {
                cell.leftLabel.font = UIFont.ThemeFont.BodyRegular
                cell.middleLabel.font = UIFont.ThemeFont.BodyRegular
                cell.middleLabel.textColor = UIColor.ThemeLabel.colorLite
                cell.rightLabel.font = UIFont.ThemeFont.BodyRegular
                cell.rightLabel.textColor = UIColor.ThemeLabel.colorLite
                let model = self.tableViewRowDatas[indexPath.row-1]
                cell.leftLabel.text = BTFormat.timeOnlyDate(fromDateStr: model.timestamp.stringValue)
                cell.middleLabel.text = "contract_fund_rate_8_hours".localized()
                cell.rightLabel.text = ((model.rate ?? "--") as NSString).toPercentString(4)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 29
    }
}
