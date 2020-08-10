//
//  SLSwapLimitTransactionCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2019/12/21.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

enum BTContractTransactionDetailType: Int {
    case force
    case reduce
}

/// 限价委托列表 cell
class SLSwapLimitTransactionCell: UITableViewCell {
    
    /// 合约类型
    var transactionType: SLSwapTransactionType = .current {
        didSet {
            if transactionType == .current {
                self.cancelButton.isHidden = false
                self.dealTypeView.isHidden = true
            } else {
                self.cancelButton.isHidden = true
                self.dealTypeView.isHidden = false
            }
        }
    }
    
    /// 订单数据
    var orderModel: BTContractOrderModel?
    
    /// 点击明细回调
    var showDetailCallback: ((BTContractOrderModel, BTContractTransactionDetailType) -> ())?
    
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
    
    /// 取消按钮
    lazy var cancelButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "contract_action_cancle".localized(), titleFont: UIFont.ThemeFont.BodyBold, titleColor: UIColor.ThemeBtn.highlight)
        button.backgroundColor = UIColor.ThemeNav.bg
        button.layer.cornerRadius = 1.5
        button.extUseAutoLayout()
        button.extSetAddTarget(self, #selector(clickCancelButton))
        return button
    }()
    
    /// 历史委托 - 成交类型(已成交/未成交/部分成交)
    lazy var dealTypeView: UIView = {
        let view = UIView()
        let label = UILabel(text: "contract_text_dealDone".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
        let imageView = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_enter"))
        imageView.contentMode = .scaleAspectFit
        view.addSubViews([label, imageView])
        imageView.snp_makeConstraints { (make) in
            make.right.equalToSuperview()
            make.width.height.equalTo(9)
            make.centerY.equalToSuperview()
        }
        label.snp_makeConstraints { (make) in
            make.right.equalTo(imageView.snp_left).offset(-5)
            make.top.height.equalToSuperview()
        }
        view.isHidden = true
        return view
    }()
    
    /// 减仓明细，强平明细
    lazy var detailView: UIControl = {
        let detail = UIControl()
        let label = UILabel(text: "--", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        let imageView = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_prompt"))
        imageView.contentMode = .scaleAspectFit
        detail.addSubViews([label, imageView])
        
        label.snp_makeConstraints { (make) in
            make.left.top.height.equalToSuperview()
        }
        imageView.snp_makeConstraints { (make) in
            make.left.equalTo(label.snp_right).offset(5)
            make.right.equalToSuperview()
            make.width.height.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        detail.addTarget(self, action: #selector(clickDetailButton), for: .touchUpInside)
        detail.isHidden = true
        return detail
    }()
    
    lazy var promptView : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.themeImageNamed(imageName: "contract_prompt"), for: .normal)
        btn.addTarget(self, action: #selector(clickpromptButton), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    /// 委托价格
    lazy var priceView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_trustPrice".localized())
        return view
    }()
    
    /// 委托数量
    lazy var volumeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_transaction_order_volume".localized() + " (\("contract_text_volumeUnit".localized()))")
        return view
    }()
    
    /// 委托价值
    lazy var valueView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_entrustValue".localized() + " (USDT)")
        return view
    }()
    
    /// 成交数量
    lazy var dealVolumeView : SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_transaction_deal_volume".localized() + " (\("contract_text_volumeUnit".localized()))")
        return view
    }()
    
//    /// 成交均价
//    lazy var dealAverageView: SLSwapHorDetailView = {
//        let view = SLSwapHorDetailView()
//        view.extUseAutoLayout()
//        view.setLeftText("contract_text_dealAverage".localized())
//        return view
//    }()
    
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
        self.contentView.addSubViews([dealTypeLabel, nameLabel, timeLabel, cancelButton, dealTypeView, detailView, volumeView, priceView, dealVolumeView, promptView, valueView, horLineView])
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
        dealTypeView.snp_makeConstraints { (make) in
            make.right.equalTo(-horMargin)
            make.height.equalTo(32)
            make.width.equalTo(100)
            make.centerY.equalTo(dealTypeLabel)
        }
        detailView.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp_right).offset(8)
            make.height.equalTo(18)
            make.centerY.equalTo(nameLabel)
        }
        
        priceView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(timeLabel.snp_bottom).offset(15)
            make.height.equalTo(32)
        }
        volumeView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(priceView.snp.right).offset(15)
            make.top.height.width.equalTo(priceView)
        }
        
        valueView.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(priceView)
            make.top.equalTo(priceView.snp_bottom).offset(12)
        }
        dealVolumeView.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(volumeView)
            make.top.equalTo(valueView)
        }
//        dealAverageView.snp.makeConstraints { (make) in
//            make.left.right.equalTo(volumeView)
//            make.top.equalTo(dealVolumeView.snp_bottom).offset(12)
//            make.height.equalTo(volumeView)
//        }
        horLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
    }
}


// MARK: - Update Data

extension SLSwapLimitTransactionCell {
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
        self.timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (model.created_at ?? "0")), format: "yyyy-MM-dd HH:mm")
        self.volumeView.setBottomText((model.qty ?? "0").toSmallVolume(withContractID:model.instrument_id))
        if model.category == .market {
            self.priceView.setBottomText("contract_action_marketPrice".localized())
        } else {
            self.priceView.setBottomText((model.px ?? "0").toSmallPrice(withContractID:model.instrument_id))
        }
        self.dealVolumeView.setBottomText((model.cum_qty ?? "0").toSmallVolume(withContractID:model.instrument_id))
//        self.dealAverageView.setBottomText((model.avg_px ?? "0").toSmallPrice(withContractID:model.instrument_id))
        self.valueView.setBottomText((model.avai ?? "0").toSmallValue(withContract:model.instrument_id))
        self.priceView.setTopText("contract_text_trustPrice".localized() + "(" + model.contractInfo.quote_coin + ")")
//        self.dealAverageView.setTopText("contract_text_dealAverage".localized() + "(" + model.contractInfo.quote_coin + ")")
        self.valueView.setTopText("contract_text_entrustValue".localized() + "(" + model.contractInfo.margin_coin + ")")
        
        if let label = self.dealTypeView.subviews.first as? UILabel {
            // 先判断是否是部分成交
            if model.errorno == .cancel && BasicParameter.handleDouble(model.cum_qty) > 0 && BasicParameter.handleDouble(model.qty) > BasicParameter.handleDouble(model.cum_qty) {
                label.text = "contract_transaction_types_subDone".localized()
            } else {
                switch model.errorno {
                    case .noNoErr:
                        label.text = "contract_text_dealDone".localized()
                    case .cancel:
                        label.text = "contract_transaction_type_user_cancel".localized()
                case .timeout, .ASSETS, .FREEZE , .CLOSE, .reduce, .compensate, .positionErr, .FORBBIDN, .OPPSITE, .UNDO, .FOK, .IOC, .MARKET, .PASSIVE, .PLAY, .HANDOVER, .FORCE:
                        label.text = "contract_transaction_type_system_cancel".localized()
                    default: break
                }
            }
        }
        
        if (self.transactionType == .history) {
            promptView.isHidden = true
            let detailType = self.getDetailType(model: model)
            if detailType == .force {
                self.detailView.isHidden = false
                if let label = self.detailView.subviews.first as? UILabel {
                    label.text = "contract_transaction_force_detail".localized()
                }
                self.priceView.setBottomText("--")
                self.valueView.setBottomText("--")
            } else if detailType == .reduce {
                self.detailView.isHidden = false
                if let label = self.detailView.subviews.first as? UILabel {
                    label.text = "contract_transaction_reduce_detail".localized()
                }
            } else {
                self.detailView.isHidden = true
                if model.errorno != .noNoErr && model.errorno != .cancel {
                    promptView.isHidden = false
                    promptView.snp.makeConstraints { (make) in
                        make.left.equalTo(nameLabel.snp.right).offset(5)
                        make.height.width.equalTo(20)
                        make.centerY.equalTo(dealTypeLabel)
                    }
                }
            }
        } else {
            self.detailView.isHidden = true
        }
    }
    
    func getDetailType(model: BTContractOrderModel) -> BTContractTransactionDetailType? {
        if (model.category == .trigger || model.category == .break) {
            return .force
        } else if (model.category == .detail) {
            if BasicParameter.handleDouble(model.take_fee) > 0 {
                return .force
            } else {
                return .reduce
            }
        }
        return nil
    }
    
    func getErrNoStr(_ model : BTContractOrderModel) -> String {
        var errNoStr = ""
        switch model.errorno {
        case .noNoErr, .cancel:
            errNoStr = ""
        case .timeout:
            errNoStr = "contract_normal_order_timeout".localized()
        case .ASSETS:
            errNoStr = "contract_normal_order_ASSETS".localized()
        case .FREEZE:
            errNoStr = "contract_normal_order_FREEZE".localized()
        case .UNDO:
            errNoStr = "contract_normal_order_UNDO".localized()
        case .CLOSE:
            errNoStr = "contract_normal_order_CLOSE".localized()
        case .reduce:
            errNoStr = "contract_normal_order_reduce".localized()
        case .compensate:
            errNoStr = "contract_normal_order_compensate".localized()
        case .positionErr:
            errNoStr = "contract_normal_order_positionErr".localized()
        case .FORBBIDN:
            errNoStr = "contract_normal_order_FORBBIDN".localized()
        case .OPPSITE:
            errNoStr = "contract_normal_order_OPPSITE".localized()
        case .FOK: // 12
            errNoStr = "contract_normal_order_FOK".localized()
        case .IOC:
            errNoStr = "contract_normal_order_IOC".localized()
        case .MARKET:
            errNoStr = "contract_normal_order_MARKET".localized()
        case .PASSIVE:
            errNoStr = "contract_normal_order_PASSIVE".localized()
        case .FORCE:
            errNoStr = "contract_normal_order_FORCE".localized()
        case .PLAY:
            errNoStr = "contract_normal_order_PLAY".localized()
        case .HANDOVER:
            errNoStr = "contract_normal_order_HANDOVER".localized()
        default:
            errNoStr = ""
        }
        return errNoStr
    }
}


// MARK: - Click Events

extension SLSwapLimitTransactionCell {
    
    /// 点击明细
    @objc func clickDetailButton() {
        guard let tempOrderModel = self.orderModel else {
            return
        }
        let detailType = self.getDetailType(model: tempOrderModel)
        if detailType != nil {
            self.showDetailCallback?(tempOrderModel, detailType!)
        }
    }
    
    /// 点击撤单
    @objc func clickCancelButton() {
        guard let tempOrderModel = self.orderModel else {
            return
        }
        self.cancelOrderCallback?(tempOrderModel)
    }
    
    /// 点击取消原因
    @objc func clickpromptButton() {
        let tipsStr = getErrNoStr(self.orderModel!)
        let alert = EXNormalAlert()
        alert.configSigleAlert(title: "contract_transaction_type_system_cancel".localized(), message: tipsStr)
        EXAlert.showAlert(alertView: alert)
    }
}

