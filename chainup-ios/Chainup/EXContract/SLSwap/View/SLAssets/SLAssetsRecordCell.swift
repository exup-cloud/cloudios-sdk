//
//  SLAssetsRecordCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/6.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 资金记录 cell
class SLAssetsRecordCell: UITableViewCell {

    /// 多 空 类型
    lazy var dealTypeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadMedium, textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 创建时间
    lazy var timeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 金额
    lazy var amountView: SLSwapHorDetailView = {
        let view = SLSwapHorDetailView()
        view.extUseAutoLayout()
        view.setLeftText("journalAccount_text_amount".localized())
        return view
    }()
    
    /// 手续费
    private lazy var feeView: SLSwapHorDetailView = {
        let view = SLSwapHorDetailView()
        view.extUseAutoLayout()
        view.setLeftText("withdraw_text_fee".localized())
        return view
    }()
    
    /// 余额
    private lazy var balanceView: SLSwapHorDetailView = {
        let view = SLSwapHorDetailView()
        view.extUseAutoLayout()
        view.setLeftText("contract_assets_record_balance".localized())
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
        
        self.addSubViews([dealTypeLabel, timeLabel, amountView, feeView, balanceView, horLineView])
        
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
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-horMargin)
            make.height.equalTo(12)
            make.centerY.equalTo(dealTypeLabel)
        }
        amountView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(timeLabel.snp_bottom).offset(16)
            make.height.equalTo(16)
        }
        feeView.snp_makeConstraints { (make) in
            make.left.right.equalTo(amountView)
            make.top.equalTo(amountView.snp_bottom).offset(10)
            make.height.equalTo(amountView)
        }
        balanceView.snp_makeConstraints { (make) in
            make.left.right.equalTo(amountView)
            make.top.equalTo(feeView.snp_bottom).offset(10)
            make.height.equalTo(amountView)
        }
        horLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    // MARL: - Update Data
    func updateCell(model: BTCashBooksModel) {
        var typeStr = "--"
        switch model.action {
        case .CONTRACT_ORDER_WAY_BUY_OPEN_LONG:
            typeStr = "contract_buy_openMore".localized();
        case .CONTRACT_ORDER_WAY_BUY_CLOSE_SHORT:
            typeStr = "contract_buy_closeLess".localized();
        case .CONTRACT_ORDER_WAY_SELL_CLOSE_LONG:
            typeStr = "contract_sell_closeMore".localized();
        case .CONTRACT_ORDER_WAY_SELL_OPEN_SHORT:
            typeStr = "contract_sell_openLess".localized();
        case .CONTRACT_WAY_BB_TRANSFER_IN:
            typeStr = "contract_assets_record_transfer_from_swap_account".localized();
        case .CONTRACT_WAY_TRANSFER_TO_BB:
            typeStr = "contract_assets_record_transfer_to_swap_account".localized();
        case .CONTRACT_WAY_REDUCE_DEPOSIT_TRANSFER:
            typeStr = "contract_action_decreaseMargin".localized();
        case .CONTRACT_WAY_INCREA_DEPOSIT_TRANSFER:
            typeStr = "contract_action_increaseMargin".localized();
        case .CONTRACT_WAY_AIR_DROP:
            typeStr = "contract_action_airdrop".localized();
        case .CONTRACT_WAY_FEE_TENTHS:
            typeStr = "contract_fee_share".localized();
        case .CONTRACT_WAY_BOUNS_IN:
            typeStr = "contract_text_getBouns".localized();
        case .CONTRACT_WAY_BOUNS_OUT:
            typeStr = "contract_text_outBouns".localized();
        case .CONTRACT_WAY_ASSET_SWAP_IN:
            typeStr = "contract_assets_record_transfer_from_swap_account".localized()
        case.CONTRACT_WAY_ASSET_SWAP_OUT:
            typeStr = "contract_assets_record_transfer_to_swap_account".localized()
        default:
            break
        }
        
        
        self.dealTypeLabel.text = typeStr
        self.timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: model.created_at), format: "yyyy-MM-dd HH:mm")
        self.amountView.setRightText((model.deal_count as NSString).toDecimalString(8))
        self.feeView.setRightText((model.fee as NSString).toDecimalString(8))
        self.balanceView.setRightText((model.last_assets as NSString).toDecimalString(8))
    }
}
