//
//  ContractTransactionTC.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/10.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

class ContractTransactionTC: UITableViewCell {
    
    typealias ClickCancelBlock = (ContractCurrentEntity) -> ()
    var clickCancelBlock : ClickCancelBlock?
    
    var entity = ContractCurrentEntity()
    //多 空
    lazy var dealTypeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadRegular
        return label
    }()
    
    //名字
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.HeadBold
//        label.layoutIfNeeded()
        return label
    }()
    
//    //时间
//    lazy var timeLabel : UILabel = {
//        let label = UILabel()
//        label.extUseAutoLayout()
//        label.textColor = UIColor.ThemeLabel.colorMedium
//        label.font = UIFont.ThemeFont.SecondaryRegular
//        return label
//    }()
    
    //合约类型
    lazy var contractTypeLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    //取消按钮
    lazy var cancelBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, #selector(clickCancelBtn))
        btn.backgroundColor = UIColor.ThemeNav.bg
        btn.setTitle(LanguageTools.getString(key: "contract_action_cancle"), for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeBtn.highlight, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.BodyBold
        return btn
    }()
    
    //状态
    lazy var rightLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.BodyRegular
        label.isHidden = true
        label.textAlignment = .right
        label.layoutIfNeeded()
        return label
    }()
    
    //时间
    lazy var timeView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        view.setLeft("kline_text_dealTime".localized())
        return view
    }()
    
    //委托价格
    lazy var priceView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        return view
    }()
    
    //仓位数量
    lazy var volumView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        view.setLeft(LanguageTools.getString(key: "contract_text_positionNumber") + " (\("contract_text_volumeUnit".localized()))")
        return view
    }()
    
    //价值
    lazy var valueView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        return view
    }()
    
    //已成交
    lazy var dealView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        view.setLeft(LanguageTools.getString(key: "contract_text_dealDone") + " (\("contract_text_volumeUnit".localized()))")
        return view
    }()
    
    //成交均价
    lazy var dealAverageView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        return view
    }()
    
    //剩余
    lazy var remainingView : ContractTransactionTCDetailView = {
        let view = ContractTransactionTCDetailView()
        view.setLeft(LanguageTools.getString(key: "contract_text_remaining") + " (\("contract_text_volumeUnit".localized()))")
        return view
    }()
    
    lazy var lineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.extSetCell()
        contentView.addSubViews([dealTypeLabel,nameLabel,contractTypeLabel,cancelBtn,rightLabel,timeView,priceView,volumView,valueView,dealView,dealAverageView,remainingView,lineV])
        dealTypeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(16)
            make.top.equalToSuperview().offset(15)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(dealTypeLabel.snp.right).offset(5)
            make.centerY.equalTo(dealTypeLabel)
            make.height.equalTo(16)
            make.right.lessThanOrEqualTo(cancelBtn.snp.left).offset(-10)
        }
        
//        timeLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(nameLabel.snp.right).offset(5)
//            make.height.equalTo(12)
//            make.right.lessThanOrEqualTo(cancelBtn.snp.left).offset(-5)
////            equalTo(cancelBtn.snp.left).offset(-5)
//            make.centerY.equalTo(nameLabel)
//        }
        
        contractTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.height.equalTo(17)
            make.right.right.lessThanOrEqualTo(cancelBtn.snp.left).offset(-5)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(72)
            make.height.equalTo(32)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(16)
            make.centerY.equalTo(dealTypeLabel)
        }
        
        timeView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(cancelBtn.snp.bottom).offset(15)
        }
        
        priceView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(timeView.snp.bottom).offset(10)
        }
        
        volumView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(priceView.snp.bottom).offset(10)
        }
        
        valueView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(volumView.snp.bottom).offset(10)
        }
        
        dealView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(valueView.snp.bottom).offset(10)
        }
        
        dealAverageView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(dealView.snp.bottom).offset(10)
        }
        
        remainingView.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(dealAverageView.snp.bottom).offset(10)
        }
        lineV.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setCell(_ entity : ContractCurrentEntity){
        
        self.entity = entity
        
        if entity.side == "BUY"{
//            dealTypeLabel.text = "contract_text_long".localized()
            dealTypeLabel.textColor = UIColor.ThemekLine.up
        }else{
//            dealTypeLabel.text = "contract_text_short".localized()
            dealTypeLabel.textColor = UIColor.ThemekLine.down
        }
        dealTypeLabel.text = entity.getSideStatus()
        
        nameLabel.text = entity.baseSymbol + entity.quoteSymbol
        timeView.setRight(entity.fmsctime())
        
        if entity.status == "0" || entity.status == "1" || entity.status == "3"{
            if entity.type == "1"{//限价
                cancelBtn.isHidden = false
            }else{//市价单不展示撤销按钮
                cancelBtn.isHidden = true
            }
            rightLabel.isHidden = true
        }else{
            cancelBtn.isHidden = true
            rightLabel.isHidden = false
            rightLabel.text = entity.statusText
        }
        if ContractPublicInfoManager.manager.getContractPositionType() == "1"{
             contractTypeLabel.text = ContractPublicInfoManager.manager.getContractWithContractId(entity.contractId).getContractTitle() + " (\(entity.leverageLevel)X)"
        }else{
             contractTypeLabel.text = ContractPublicInfoManager.manager.getContractWithContractId(entity.contractId).getContractTitle()
        }
        
        priceView.setLeft("contract_text_trustPrice".localized() + "(\(entity.quoteSymbol))")
        if entity.type == "1"{//限价
            priceView.setRight(entity.fmsPrice())
        }else{//市价
            priceView.setRight("contract_action_marketPrice".localized())
        }
        
        volumView.setRight(entity.volume)
        
        valueView.setLeft("contract_text_value".localized() + "(BTC)")
        valueView.setRight(entity.fmsOrderPriceValue())
        
        dealView.setRight(entity.dealVolume)
        
        dealAverageView.setLeft("contract_text_dealAverage".localized() + "(\(entity.quoteSymbol))")
        dealAverageView.setRight(entity.fmsAvgPrice())
        
        remainingView.setRight(entity.undealVolume)
    }
    
    //点击撤销按钮
    @objc func clickCancelBtn(){
        self.clickCancelBlock?(self.entity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class ContractTransactionTCDetailView : UIView {
    
    lazy var leftLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryRegular
        return label
    }()
    
    lazy var rightLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.font = UIFont.ThemeFont.BodyRegular
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([leftLabel,rightLabel])
        let width = (SCREEN_WIDTH - 30) / 2
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(14)
            make.width.equalTo(width)
            make.centerY.equalToSuperview()
        }
        rightLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(16)
            make.width.equalTo(width)
            make.centerY.equalToSuperview()
        }
    }
    
    func setLeft(_ left : String){
        leftLabel.text = left
    }
    
    func setRight(_ right : String){
        rightLabel.text = right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
