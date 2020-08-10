//
//  SLSwapHistoryTransactionCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/31.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

/// 计划委托列表 cell
class SLSwapPlanTransactionCell: UITableViewCell {
    
    /// 合约类型
    var transactionType: SLSwapTransactionType = .current {
        didSet {
            if transactionType == .current {
                self.cancelButton.isHidden = false
                self.orderTypeLabel.isHidden = true
                self.triggerTimeView.isHidden = true
            } else {
                self.cancelButton.isHidden = true
                self.orderTypeLabel.isHidden = false
                self.triggerTimeView.isHidden = false
            }
        }
    }
    
    /// 订单数据
    var orderModel: BTContractOrderModel?
    
    /// 撤单回调
    var cancelOrderCallback: ((BTContractOrderModel) -> ())?
    
    /// 多 空 类型
    lazy var dealTypeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.BodyRegular, textColor: nil, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 合约名称
    lazy var nameLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 创建时间
    lazy var timeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 撤单
    lazy var cancelButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_action_cancle".localized(), titleFont: UIFont.ThemeFont.BodyBold, titleColor: UIColor.ThemeBtn.highlight)
        button.backgroundColor = UIColor.ThemeNav.bg
        button.layer.cornerRadius = 1.5
        button.extUseAutoLayout()
        button.extSetAddTarget(self, #selector(clickCancelButton))
        return button
    }()
    
    /// 历史委托 - 订单状态
    lazy var orderTypeLabel: UILabel = {
        let label = UILabel(text: "contract_transaction_type_done".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
        label.isHidden = true
        return label
    }()
    
    /// 触发价格
    lazy var triggerPriceView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_trigger_price".localized())
        return view
    }()
    
    /// 执行价格
    lazy var excutivePriceView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_excutive_price".localized())
        return view
    }()
    
    /// 执行数量
    lazy var excutiveVolumeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_excutive_volume".localized() + "(" + "contract_text_volumeUnit".localized() + ")")
        return view
    }()
    
    /// 到期时间
    lazy var expireTimeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_expire_time".localized())
        return view
    }()
    
    /// 历史委托 - 触发时间
    lazy var triggerTimeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.setTopText("contract_trigger_time".localized())
        view.isHidden = true
        return view
    }()
    
    /// 横线
    lazy var horLineView: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.addSubViews([dealTypeLabel, nameLabel, timeLabel, cancelButton, orderTypeLabel, triggerPriceView, excutivePriceView, excutiveVolumeView, expireTimeView, triggerTimeView, horLineView])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        let horMargin = 15
        dealTypeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horMargin)
            make.height.equalTo(16)
            make.top.equalToSuperview().offset(horMargin)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dealTypeLabel.snp.right).offset(5)
            make.height.equalTo(19)
            make.centerY.equalTo(dealTypeLabel)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dealTypeLabel)
            make.height.equalTo(12)
            make.top.equalTo(dealTypeLabel.snp.bottom).offset(8)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(72)
            make.height.equalTo(32)
            make.right.equalToSuperview().offset(-horMargin)
            make.top.equalTo(dealTypeLabel)
        }
        orderTypeLabel.snp_makeConstraints { (make) in
            make.right.equalTo(-horMargin)
            make.height.equalTo(32)
            make.width.equalTo(100)
            make.centerY.equalTo(dealTypeLabel)
        }
        triggerPriceView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(timeLabel.snp_bottom).offset(15)
            make.height.equalTo(32)
        }
        excutivePriceView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(triggerPriceView.snp.right).offset(15)
            make.height.width.equalTo(triggerPriceView)
            make.top.equalTo(triggerPriceView)
        }
        excutiveVolumeView.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(triggerPriceView)
            make.top.equalTo(triggerPriceView.snp_bottom).offset(12)
        }
        expireTimeView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(excutiveVolumeView.snp.right).offset(15)
            make.height.width.equalTo(excutiveVolumeView)
            make.top.equalTo(excutiveVolumeView)
        }
        triggerTimeView.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(excutiveVolumeView)
            make.top.equalTo(excutiveVolumeView.snp_bottom).offset(12)
        }
        horLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func updataLayout() {
        excutivePriceView.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(triggerPriceView.snp.right).offset(15)
            make.height.width.equalTo(triggerPriceView)
            make.top.equalTo(excutiveVolumeView)
        }
        expireTimeView.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(excutiveVolumeView.snp.right).offset(15)
            make.height.width.equalTo(excutiveVolumeView)
            make.top.equalTo(triggerTimeView)
        }
    }
}


// MARK: - Data

extension SLSwapPlanTransactionCell {
    func updateCell(model: BTContractOrderModel) {
        self.orderModel = model
        var color = UIColor.ThemekLine.up
        var typeStr = "contract_buy_openMore".localized()
        if model.side == .sell_OpenShort {
            color = UIColor.ThemekLine.down
            typeStr = "contract_sell_openLess".localized()
        } else if model.side == .buy_CloseShort {
            color = UIColor.ThemekLine.up
            typeStr = "contract_buy_closeLess".localized()
        } else if model.side == .sell_CloseLong {
            color = UIColor.ThemekLine.down
            typeStr = "contract_sell_closeMore".localized()
        }
        self.dealTypeLabel.textColor = color
        self.dealTypeLabel.text = typeStr
        self.nameLabel.text = model.name
        self.timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: model.created_at), format: "yyyy-MM-dd HH:mm")
        
        var priceTypeStr = ""
        if model.trigger_type == .tradePriceType {
            priceTypeStr = "home_text_dealLatestPrice".localized()
        } else if model.trigger_type == .markPriceType {
            priceTypeStr = "contract_fair_px".localized()
        } else if model.trigger_type == .indexPriceType {
            priceTypeStr = "contract_index_px".localized()
        }
        
        self.triggerPriceView.setBottomText(String(format: "%@ %@", priceTypeStr,(model.px ?? "0").toSmallPrice(withContractID:model.instrument_id)))
        if model.category == .market {
            self.excutivePriceView.setBottomText("contract_action_marketPrice".localized())
        } else {
            self.excutivePriceView.setBottomText((model.exec_px ?? "0").toSmallPrice(withContractID:model.instrument_id))
        }
        
        var qty = (model.qty ?? "0").toSmallVolume(withContractID:model.instrument_id)
        if model.type == .profitType || model.type == .lossType {
            qty = "100%"
        }
        self.excutiveVolumeView.setBottomText(qty!)
        self.expireTimeView.setBottomText(BTFormat.datelocalTimeStr(BTFormat.date(fromUTCString: (model.created_at ?? "0")), format: "yyyy-MM-dd HH:mm", addDate:Double((model.cycle?.stringValue ?? "0").bigMul("3600"))!))
        if !self.triggerTimeView.isHidden {
            self.triggerTimeView.setBottomText(BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: model.finished_at), format: "yyyy-MM-dd HH:mm"))
            updataLayout()
        }
        self.triggerPriceView.setTopText("contract_trigger_price".localized() + "(" + model.contractInfo.quote_coin + ")")
        self.excutivePriceView.setTopText("contract_excutive_price".localized() + "(" + model.contractInfo.quote_coin + ")")
        
        var dealType = ""
        // 先判断是否是部分成交
        if model.errorno == .cancel && BasicParameter.handleDouble(model.cum_qty) > 0 && BasicParameter.handleDouble(model.qty) > BasicParameter.handleDouble(model.cum_qty) {
            dealType = "contract_transaction_types_subDone".localized()
        } else {
            switch model.errorno {
                case .noNoErr:
                    dealType = "contract_text_dealDone".localized()
                case .cancel:
                    dealType = "contract_transaction_type_user_cancel".localized()
                case .timeout, .ASSETS, .FREEZE , .CLOSE, .reduce, .compensate, .positionErr, .FORBBIDN, .OPPSITE, .UNDO, .FOK , .FORCE , .MARKET, .IOC , .PLAY,.HANDOVER,.PASSIVE:
                    dealType = "contract_transaction_type_system_cancel".localized()
                default: break
            }
        }
        self.orderTypeLabel.text = dealType
    }
}

// MARK: - Click Events

extension SLSwapPlanTransactionCell {
    /// 撤单
    @objc func clickCancelButton() {
        guard let tempOrderModel = self.orderModel else {
            return
        }
        self.cancelOrderCallback?(tempOrderModel)
    }
}
