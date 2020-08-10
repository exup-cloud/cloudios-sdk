//
//  SLSwapPositionHistoryCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/3/27.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLSwapPositionHistoryCell: UITableViewCell {
    /// 多 空 类型
    lazy var dealTypeLabel: UILabel = {
        let label = UILabel(text: nil, font: UIFont.ThemeFont.HeadMedium, textColor: nil, alignment: NSTextAlignment.left)
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
    /// 开仓均价
    lazy var openAverageView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_openAveragePrice".localized())
        return view
    }()
    /// 平仓均价
    lazy var closeAverageView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_closeAveragePrice".localized())
        return view
    }()
    /// 已实现盈亏
    lazy var realizeView: SLSwapVerDetailView = {
        let view = SLSwapVerDetailView()
        view.extUseAutoLayout()
        view.setTopText("contract_text_realisedPNL".localized())
        return view
    }()
    /// 底部分隔视图
    lazy var bottomMarginView: UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        self.contentView.addSubViews([dealTypeLabel,nameLabel,timeLabel,openAverageView,closeAverageView,realizeView,bottomMarginView])
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func initLayout() {
        let horMargin = 15
        let verMargin = 10
        dealTypeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horMargin)
            make.top.equalToSuperview().offset(horMargin)
            make.height.equalTo(20)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dealTypeLabel.snp.right).offset(5)
            make.height.equalTo(19)
            make.centerY.equalTo(dealTypeLabel)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dealTypeLabel)
            make.height.equalTo(12)
            make.top.equalTo(dealTypeLabel.snp.bottom).offset(6)
        }
        openAverageView.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(timeLabel.snp.bottom).offset(15)
        }
        realizeView.snp.makeConstraints { (make) in
            make.height.width.top.equalTo(openAverageView)
            make.right.equalToSuperview().offset(-15)
            make.left.equalTo(openAverageView.snp.right).offset(15)
        }
        closeAverageView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(openAverageView)
            make.top.equalTo(openAverageView.snp.bottom).offset(verMargin)
        }
        bottomMarginView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(horMargin)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func updateCell(model: BTPositionModel) {
        if model.contractInfo == nil {
            return
        }
        var color = UIColor.ThemekLine.down
        if model.side == .openMore {
            color = UIColor.ThemekLine.up
            dealTypeLabel.text = "contract_openLong".localized()
        } else {
            dealTypeLabel.text = "contract_openShort".localized()
        }
        dealTypeLabel.textColor = color
        nameLabel.text = model.contractInfo?.symbol ?? ""
        timeLabel.text = BTFormat.date2localTimeStr(BTFormat.date(fromUTCString: (model.updated_at ?? "0")), format: "yyyy-MM-dd HH:mm")
        openAverageView.setTopText(String(format:"%@(%@)","contract_text_openAveragePrice".localized(),model.contractInfo.quote_coin))
        openAverageView.setBottomText(model.avg_open_px.toSmallPrice(withContractID:model.instrument_id))
        realizeView.setTopText(String(format:"%@(%@)","contract_text_realisedPNL".localized(),model.contractInfo.margin_coin))
        realizeView.setBottomText(model.realised_pnl.toSmallValue(withContract:model.instrument_id))
        closeAverageView.setTopText(String(format:"%@(%@)","contract_text_closeAveragePrice".localized(),model.contractInfo.quote_coin))
        if model.errorno == 5 || model.errorno == 6 {
             closeAverageView.setBottomText("--")
        } else {
             closeAverageView.setBottomText(model.avg_close_px.toSmallPrice(withContractID:model.instrument_id))
        }
    }
}
