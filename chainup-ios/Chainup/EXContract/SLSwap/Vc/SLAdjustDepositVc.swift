//
//  SLAdjustDepositVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/3/27.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLAdjustDepositVc: NavCustomVC {
    
    typealias ClickAdjustDeposit = (Bool) -> ()
    var clickAdjustDeposit : ClickAdjustDeposit?
    
    var positionModel : BTPositionModel?{
        didSet {
            depositInput.symbol = positionModel?.contractInfo.margin_coin ?? ""
        }
    }
    
    
    var asset : BTItemCoinModel? {
        get {
            return SLPersonaSwapInfo.sharedInstance()?.getSwapAssetItem(withCoin: positionModel?.contractInfo.margin_coin)
        }
    }
    
    var less_qty = ""
    
    var most_qty = ""
    
    lazy var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    /// 调整后强平价格
    lazy var forceLabel: UILabel = {
        let text = String(format: "%@(%@)", "contract_adjust_close_price".localized(),positionModel?.contractInfo?.quote_coin ?? "USDT")
        let label = UILabel(text: text, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    lazy var forcePrice: UILabel = {
        let text = "--"
        let label = UILabel(text: text, font: UIFont.ThemeFont.BodyBold, textColor: UIColor.ThemeState.warning, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    
    /// 调整后杠杆
    lazy var levelLabel: UILabel = {
        let text = "contract_after_adjust_leveage".localized()
        let label = UILabel(text: text, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .right)
        label.numberOfLines = 0
        return label
    }()
    lazy var level: UILabel = {
        let text = "--"
        let label = UILabel(text: text, font: UIFont.ThemeFont.BodyBold, textColor: UIColor.ThemeState.warning, alignment: .right)
        label.numberOfLines = 0
        return label
    }()
    
    /// 保证金数量
    lazy var depositInput: EXTextField = {
        let input = EXTextField()
        input.enableTitleModel = true
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.titleLabel.secondaryRegular()
        input.setTitle(title: "contract_deposit_volume".localized())
        input.setPlaceHolder(placeHolder: "contract_deposit_volume".localized())
        input.maxLenth = 9
        
        input.input.rx.text.orEmpty.asObservable().subscribe{ [ weak self] (event) in
            
            if let str = event.element{
                if str.greaterThan(self?.most_qty){
                    input.input.text = self?.most_qty
                    EXAlert.showFail(msg: self?.depositLabel.text ?? "")
                }
            }
        }.disposed(by: self.disposeBag)
        input.textfieldValueChangeBlock = {[weak self]str in
            guard let mySelf = self else{return}
            mySelf.textFieldValueHasChanged(textField: input.input)
        }
        return input
    }()
    /// 保证金范围
    lazy var depositLabel: UILabel = {
        let text = String(format:"%@ 0 %@","contract_deposit_range".localized(),positionModel?.contractInfo?.margin_coin ?? "USDT")
        let label = UILabel(text: text, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        label.numberOfLines = 0
        return label
    }()
    /// 确认
    lazy var confirmButton: EXButton = {
        let button = EXButton()
        button.setTitle("common_text_btnConfirm".localized(), for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.addSubViews([headerView,forceLabel,depositInput,depositLabel,levelLabel,level,confirmButton,forcePrice])
        self.initLayout()
        //        self.depositInput.input.delegate = infoVaild
        // 当websocket合约ticker的时候刷新
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLessAndMore),
                                               name: NSNotification.Name(rawValue: BTSocketDataUpdate_Contract_Ticker_Notification),
                                               object: nil)
    }
    
    override func setNavCustomV() {
        self.setTitle("contract_adjust_deposit".localized())
        self.navtype = .list
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}


extension SLAdjustDepositVc {
    private func initLayout() {
        headerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.navCustomView.snp_bottom).offset(15)
            make.height.equalTo(60)
        }
        forceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(self.navCustomView.snp_bottom).offset(25)
            make.height.equalTo(15)
        }
        forcePrice.snp.makeConstraints { (make) in
            make.left.height.equalTo(forceLabel)
            make.top.equalTo(forceLabel.snp.bottom).offset(10)
        }
        levelLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(self.navCustomView.snp_bottom).offset(25)
            make.height.equalTo(15)
        }
        level.snp.makeConstraints { (make) in
            make.right.height.equalTo(levelLabel)
            make.top.equalTo(levelLabel.snp.bottom).offset(10)
        }
        depositInput.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(self.headerView.snp_bottom).offset(15)
        }
        depositLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(self.depositInput.snp_bottom).offset(5)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
            make.top.equalTo(depositLabel.snp.bottom).offset(20)
        }
    }
    
    func updateLessAndMore() {
        
        if let positionModel = self.positionModel{
            let im = positionModel.im.toSmallValue(withContract: positionModel.instrument_id) ?? ""
//            self.depositInput.input.text = im
            if self.positionModel!.reduceDeposit_Max.greaterThan(im) {
                return
            }
            less_qty = im.bigSub(positionModel.reduceDeposit_Max).toSmallValue(withContract: self.positionModel!.instrument_id)
            less_qty = less_qty.bigAdd(self.positionModel?.contractInfo?.value_unit ?? "0") // 进一位
            most_qty = im.bigAdd(self.asset!.contract_avail).toSmallValue(withContract: self.positionModel!.instrument_id)
            depositLabel.text = String(format:"%@ %@-%@%@","contract_deposit_range".localized(),less_qty,most_qty,positionModel.contractInfo.margin_coin)
        }
        
    }
    
    func updatePositionModel(_ positionModel : BTPositionModel) {
        self.positionModel = BTPositionModel.mj_object(withKeyValues: positionModel.mj_keyValues())
        forceLabel.text = String(format:"%@(%@)","contract_adjust_close_price".localized(),positionModel.contractInfo.quote_coin)
        forcePrice.text = positionModel.liquidate_price.toSmallPrice(withContractID:positionModel.instrument_id) ?? "--"
        let im = positionModel.im.toSmallValue(withContract: positionModel.instrument_id) ?? ""
        self.depositInput.input.text = im
//        textFieldValueHasChanged(textField: self.depositInput.input)
        if self.positionModel!.reduceDeposit_Max.greaterThan(im) {
            return
        }
        less_qty = im.bigSub(positionModel.reduceDeposit_Max).toSmallValue(withContract: self.positionModel!.instrument_id)
        less_qty = less_qty.bigAdd(self.positionModel?.contractInfo?.value_unit ?? "0") // 进一位
        most_qty = im.bigAdd(self.asset!.contract_avail).toSmallValue(withContract: self.positionModel!.instrument_id)
        depositLabel.text = String(format:"%@ %@-%@%@","contract_deposit_range".localized(),less_qty,most_qty,positionModel.contractInfo.margin_coin)
        
        
        var reality = self.positionModel?.realityLeverage ?? "1"
        let arrLeverage = reality.components(separatedBy: ".")
        if arrLeverage.count == 2 {
            reality = arrLeverage[0].bigAdd(DecimalOne)
        }
        
        if reality.greaterThan(positionModel.contractInfo.max_leverage) {
            
            reality = positionModel.contractInfo.max_leverage
        }
        
        
        self.level.text = String(format:"%@X",reality)
    }
    
    func textFieldValueHasChanged(textField:UITextField) {
        if self.positionModel == nil {
            return
        }
        if textField == self.depositInput.input {
            let text = textField.text ?? "0"
            if text.lessThan(less_qty) || text.greaterThan(most_qty) {
                forcePrice.text = "--"
                self.level.text = "--"
                confirmButton.isUserInteractionEnabled = false
                confirmButton.color = UIColor.ThemeBtn.disable
                return
            }
            confirmButton.isUserInteractionEnabled = true
            confirmButton.color = UIColor.ThemeBtn.highlight
            let position = BTPositionModel.mj_object(withKeyValues: self.positionModel!.mj_keyValues())
            position!.im = text
            forcePrice.text = position!.liquidate_price.toSmallPrice(withContractID:position!.instrument_id) ?? "--"
            if position!.position_type == .allType { // 全仓
                return
            }
            
            var reality = position?.realityLeverage ?? "1"
            let arrLeverage = reality.components(separatedBy: ".")
            if arrLeverage.count == 2 {
                reality = arrLeverage[0].bigAdd(DecimalOne)
            }
            
            if reality.greaterThan(positionModel?.contractInfo.max_leverage) {
                
                reality = positionModel?.contractInfo.max_leverage ?? ""
            }
            self.level.text = String(format:"%@X",reality)
        }
    }
    
    @objc func clickConfirmButton() {
        if self.positionModel != nil {
            var oper_type = 2
            let im = self.positionModel!.im ?? "0"
            
            if self.depositInput.input.text == "" {
                EXAlert.showFail(msg: "redpacket_send_inputAmount".localized())
                return
            }
            
            let currentIM = self.depositInput.input.text ?? "0"
            var qty = "0"
            if im.lessThan(currentIM) {
                oper_type = 1
                qty = currentIM.bigSub(im)
            } else if im.greaterThan(currentIM)  {
                qty = im.bigSub(currentIM)
            }
            if qty.isLessThanOrEqualZero() == true || (qty.lessThan(self.positionModel?.contractInfo?.value_unit)) {
                self.navigationController?.popViewController(animated: true)
                return
            }
            confirmButton.isUserInteractionEnabled = false
            BTContractTool.marginDeposit(withContractID: self.positionModel!.instrument_id, positionID: self.positionModel!.pid, vol: qty, operType: oper_type, success: {[weak self]  (result) in
                guard let mySelf = self else {return}
                mySelf.confirmButton.isUserInteractionEnabled = true
                print(result ?? "")
                mySelf.clickAdjustDeposit?(true)
                mySelf.navigationController?.popViewController(animated: true)
            }) { (error) in
                self.confirmButton.isUserInteractionEnabled = true
                print(error ?? "")
                self.clickAdjustDeposit?(false)
            }
        }
    }
}
