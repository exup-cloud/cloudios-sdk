//
//  SLSwapTransactionListView.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation

enum SLSwapTransactionType: Int {
    /// 当前委托
    case current
    /// 历史委托
    case history
}

enum SLSwapTransactionPriceType: Int {
    /// 限价委托
    case limit
    /// 计划委托
    case plan
}

/// 委托列表
class SLSwapTransactionListView: UIView {
    /// 委托类型
    var transactionType = SLSwapTransactionType.current {
        didSet {
            self.contentTableView.reloadData()
        }
    }
    /// 限价委托/计划委托
    var transactionPriceType = SLSwapTransactionPriceType.limit
    
    /// 取消单个委托
    var cancelTransactionCallback: ((BTContractOrderModel, SLSwapTransactionPriceType) -> ())?
    
    var tableViewRowDatas: [BTContractOrderModel] = []
    
    /// 点击历史委托
    var selectHistoryTransactionCallback: ((BTContractOrderModel) -> ())?
    
    private let limitCellReUseID = "SLSwapLimitTransactionCell_ID"
    private let planCellReUseID = "SLSwapPlanTransactionCell_ID"
    
    lazy var contentTableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: UITableViewStyle.plain)
        tableView.extUseAutoLayout()
        tableView.extSetTableView(self, self)
        tableView.backgroundColor = UIColor.ThemeView.bg
        tableView.extRegistCell([SLSwapLimitTransactionCell.classForCoder(), SLSwapPlanTransactionCell.classForCoder()], [limitCellReUseID, planCellReUseID])
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentTableView)
        self.contentTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Data
    func updateView(modelArray: [BTContractOrderModel]) {
        self.tableViewRowDatas = modelArray
        self.contentTableView.reloadData()
    }
    
    
    private func showDetailAlert(model: BTContractOrderModel, detailType: BTContractTransactionDetailType) {
        // 强平明细
        if detailType == .force {
            self.showForceDetailAlert(model: model)
        }
        // 减仓明细
        else if detailType == .reduce {
            self.showReduceDetailAlert(model: model)
        }
    }
    
    /// 显示强平明细
    private func showForceDetailAlert(model: BTContractOrderModel) {
        BTContractTool.getEserLiqRecords(withContractID: model.contractInfo.instrument_id, orderID: model.oid, success: { (result) in
            if let array = result as? Array<BTContractLipRecordModel> {
                let liprecord = array.first
                liprecord?.coinCode = model.name
                liprecord?.marginCoin = model.contractInfo.margin_coin

                var message = ""
                  
                var tip1 = "contract_transaction_force_detail_tip0".localized()
                var tip2 = "contract_transaction_force_detail_tip1".localized()
                
                let time = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: liprecord?.created_at), format: "yyyy-MM-dd HH:mm") ?? "--"
                tip1 = tip1.replacingOccurrences(of: "%1$s", with: time)
                tip1 = tip1.replacingOccurrences(of: "%2$s", with: liprecord?.coinCode ?? "-")
                tip1 = tip1.replacingOccurrences(of: "%3$s", with: String(format: "%@%@", liprecord?.trigger_px.toSmallPrice(withContractID:model.instrument_id) ?? "-", liprecord?.marginCoin ?? "-"))
                tip1 = tip1.replacingOccurrences(of: "%4$s", with: liprecord?.coinCode ?? "-")
                tip1 = tip1.replacingOccurrences(of: "%5$s", with: ((liprecord?.mmr ?? "-") as NSString).toPercentString(2))
                
                tip2 = tip2.replacingOccurrences(of: "%1$s", with: String(format: "%@%@", liprecord?.order_px ?? "-", liprecord?.marginCoin ?? "-"))
                
                message.append(tip1)
                message.append("\n\n")
                message.append(tip2)
                
                let alert = EXNormalAlert()
//                alert.configAlert(title: "contract_transaction_force_detail".localized(), message: message, positiveBtnTitle: "contract_transaction_force_introduce".localized())
                alert.configAlert(title: "contract_transaction_force_detail".localized(), message: message)
                alert.alertCallback = {[weak self] idx in
                    if idx == 0 {
                        // 跳转至强平机制介绍页
                        let vc = WebVC()
                        vc.title = "contract_transaction_force_detail".localized()
                        vc.loadUrl(PublicInfoEntity.sharedInstance.online_swap_Close)
                        self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
        }) { (error) in
        }
    }
    
    /// 显示减仓明细
    private func showReduceDetailAlert(model: BTContractOrderModel) {
        BTContractTool.getEserLiqRecords(withContractID: model.contractInfo.instrument_id, orderID: model.oid, success: { (result) in
            if let array = result as? Array<BTContractLipRecordModel> {
                let liprecord = array.first
                liprecord?.coinCode = model.name
                liprecord?.marginCoin = model.contractInfo.margin_coin
                liprecord?.forcePrice = model.markPrice
                
                var tip = "contract_transaction_reduce_detail_tip".localized()
                
                let time = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: liprecord?.created_at), format: "yyyy-MM-dd HH:mm") ?? "--"
                tip = tip.replacingOccurrences(of: "%1$s", with: time)
                tip = tip.replacingOccurrences(of: "%2$s", with: String(format: "%@%@", liprecord?.forcePrice.toSmallPrice(withContractID:model.instrument_id) ?? "-", liprecord?.marginCoin ?? "-"))
                tip = tip.replacingOccurrences(of: "%3$s", with: String(format: "%@%@", liprecord?.order_px.toSmallPrice(withContractID:model.instrument_id) ?? "-", liprecord?.marginCoin ?? "-"))
                
                let alert = EXNormalAlert()
//                alert.configAlert(title: "contract_transaction_reduce_detail".localized(), message: tip, positiveBtnTitle: "contract_transaction_reduce_introduce".localized())
                alert.configAlert(title: "contract_transaction_reduce_detail".localized(), message: tip)
                alert.alertCallback = {[weak self] idx in
                    if idx == 0 {
                        // 跳转至自动减仓机制介绍页
                        let vc = WebVC()
                        vc.title = "contract_transaction_reduce_detail".localized()
                        vc.loadUrl(PublicInfoEntity.sharedInstance.online_swap_ADL)
                        self?.yy_viewController?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
        }) { (error) in
        }
    }
}


// MARK: - <UITableViewDelegate & UITableViewDataSource>

extension SLSwapTransactionListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.transactionPriceType == .plan {
            if self.transactionType == .current {
                return 160
            } else {
                return 200
            }
        } else {
            return 160
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRowDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.transactionPriceType == .limit {
            let cell = tableView.dequeueReusableCell(withIdentifier: limitCellReUseID, for: indexPath) as! SLSwapLimitTransactionCell
            cell.transactionType = self.transactionType
            let model = tableViewRowDatas[indexPath.row]
            cell.updateCell(model: model)
            // 查看明细
            cell.showDetailCallback = { [weak self] orderModel, detailType in
                self?.showDetailAlert(model: orderModel, detailType: detailType)
            }
            cell.cancelOrderCallback = { [weak self] orderModel in // 取消普通委托
                guard let mySelf = self else {return}
                let alert = EXNormalAlert()
                alert.configAlert(title: "common_text_tip".localized(), message: "contract_alert_cancel_order".localized())
                alert.alertCallback = {idx in
                    if idx == 0 {
                        mySelf.cancelTransactionCallback?(orderModel, mySelf.transactionPriceType)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: planCellReUseID, for: indexPath) as! SLSwapPlanTransactionCell
            cell.transactionType = self.transactionType
            let model = tableViewRowDatas[indexPath.row]
            cell.updateCell(model: model)
            cell.cancelOrderCallback = { [weak self] orderModel in // 取消计划委托
                guard let mySelf = self else {return}
                let alert = EXNormalAlert()
                alert.configAlert(title: "common_text_tip".localized(), message: "contract_alert_cancel_order".localized())
                alert.alertCallback = {idx in
                    if idx == 0 {
                        mySelf.cancelTransactionCallback?(orderModel, mySelf.transactionPriceType)
                    }
                }
                EXAlert.showAlert(alertView: alert)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 只有历史限价委托才能查看详情
        if self.transactionType == .history && self.transactionPriceType == .limit {
            self.selectHistoryTransactionCallback?(self.tableViewRowDatas[indexPath.row])
        }
    }
}
