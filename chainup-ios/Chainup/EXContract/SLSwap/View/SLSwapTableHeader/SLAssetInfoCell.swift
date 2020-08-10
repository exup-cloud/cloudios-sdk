//
//  SLAssetInfoCell.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/1/8.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLAssetInfoCell: UITableViewCell {
    
    var assetModel : SLMinePerprotyModel? {
        didSet {
            if assetModel != nil {
                let privacy = XUserDefault.assetPrivacyIsOn()
                let entity = PublicInfoManager.sharedInstance.coinPrecision(assetModel!.coin_code)
                coinLabel.text = assetModel!.coin_code ?? "--"
                accountNum.text = !privacy ? (assetModel!.total_amount ?? "0").decimalString(entity) : String.privacyString()
                walletNum.text = !privacy ? (assetModel!.walletBalance ?? "0").decimalString(entity) : String.privacyString()
                depositNum.text = !privacy ? (assetModel!.avail_funds ?? "0").decimalString(entity) : String.privacyString()
            }
        }
    }
    
    /// 币种
    lazy var coinLabel: UILabel = {
        let label = UILabel(text: "USDT", font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorHighlight, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    /// 账户权益
    lazy var accountRights: UILabel = {
        let label = UILabel(text: "contract_assets_account_equity".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    lazy var accountNum: UILabel = {
        let label = UILabel(text: "--", font: self.themeHNMediumFont(size: 14), textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 钱包余额
    lazy var walletBalance: UILabel = {
        let label = UILabel(text: "contract_assets_wallet_balance".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    lazy var walletNum: UILabel = {
        let label = UILabel(text: "--", font: self.themeHNMediumFont(size: 14), textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.left)
        label.extUseAutoLayout()
        return label
    }()
    
    /// 保证金余额
    lazy var depositBalance: UILabel = {
        let label = UILabel(text: "contract_assets_margin_balance".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorDark, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    lazy var depositNum: UILabel = {
        let label = UILabel(text: "--", font: self.themeHNMediumFont(size: 14), textColor: UIColor.ThemeLabel.colorLite, alignment: NSTextAlignment.right)
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.ThemeView.seperator
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func initLayout() {
        self.contentView.addSubViews([coinLabel,
                                      accountRights,
                                      accountNum,
                                      walletBalance,
                                      walletNum,
                                      depositBalance,
                                      depositNum,
                                      lineView])
        extSetCell()
        coinLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
        }
        accountRights.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(coinLabel.snp.bottom).offset(16)
            make.height.equalTo(12)
        }
        walletBalance.snp.makeConstraints { (make) in
            make.left.equalTo(accountRights.snp.right).offset(20)
            make.top.equalTo(accountRights.snp.top)
            make.height.equalTo(accountRights.snp.height)
            make.width.equalTo(accountRights.snp.width)
        }
        depositBalance.snp.makeConstraints { (make) in
            make.left.equalTo(walletBalance.snp.right).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(accountRights.snp.top)
            make.height.equalTo(accountRights.snp.height)
            make.width.equalTo(accountRights.snp.width)
        }
        
        accountNum.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(accountRights.snp.bottom).offset(7)
            make.height.equalTo(16)
            make.width.equalTo(accountRights.snp.width)
        }
        walletNum.snp.makeConstraints { (make) in
            make.left.equalTo(accountNum.snp.right).offset(20)
            make.top.equalTo(accountNum.snp.top)
            make.height.equalTo(accountNum.snp.height)
            make.width.equalTo(accountNum.snp.width)
        }
        depositNum.snp.makeConstraints { (make) in
            make.left.equalTo(walletNum.snp.right).offset(20)
            make.top.equalTo(accountNum.snp.top)
            make.height.equalTo(accountNum.snp.height)
            make.width.equalTo(accountNum.snp.width)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
