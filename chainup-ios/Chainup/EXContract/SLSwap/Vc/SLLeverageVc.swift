//
//  SLLeverageVc.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/3/17.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

class SLLeverageVc: NavCustomVC {
    typealias ClickComfirmLeverage = (String,  String) -> ()
    var clickComfirmLeverage : ClickComfirmLeverage?
    
    var makeOrderViewModel : SLSwapMarkOrderViewModel?
    var openModel : BTContractsOpenModel?
    var currentPx : String = "0"
    var unit : String = "contract_text_volumeUnit".localized()
    var insterment_id : Int64 = 0
    /// 逐仓
    lazy var fixedButton: SLLeveageBtn = {
        let button = SLLeveageBtn()
        button.setTitle("contract_Fixed_position".localized(), for: .normal)
        button.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        button.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .selected)
        button.setTitleColor(UIColor.ThemeLabel.colorLite, for: .normal)
        button.setBackgroundImage(UIImage.themeImageNamed(imageName: "contract_fixed_normal"), for: .normal)
        button.setBackgroundImage(UIImage.themeImageNamed(imageName: "contract_fixed_select"), for: .selected)
        button.addTarget(self, action: #selector(clickPositionTypeButton), for: .touchUpInside)
        button.isSelected = true
        return button
    }()
    /// 逐仓提示
    lazy var fixedTipLabel: UILabel = {
        let max = makeOrderViewModel?.canOpenMore ?? "0"
        let min = makeOrderViewModel?.canOpenShort ?? "0"
        let label = UILabel(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        let attrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_currentleveage_canopen"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryRegular]).add(string: String(format: "%@%@ ", max,unit), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeState.warning, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold]).add(string: "contract_openShort_ins".localized(), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryRegular]).add(string: String(format: "%@%@", min,unit), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeState.warning, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
        label.attributedText = attrString
        label.numberOfLines = 0
        return label
    }()
    /// 全仓
    lazy var crossButton: SLLeveageBtn = {
        let button = SLLeveageBtn()
        button.setTitle("contract_Cross_position".localized(), for: .normal)
        button.titleLabel?.font = UIFont.ThemeFont.BodyRegular
        button.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .selected)
        button.setTitleColor(UIColor.ThemeLabel.colorLite, for: .normal)
        button.setBackgroundImage(UIImage.themeImageNamed(imageName: "contract_cross_normal"), for: .normal)
        button.setBackgroundImage(UIImage.themeImageNamed(imageName: "contract_cross_select"), for: .selected)
        button.addTarget(self, action: #selector(clickPositionTypeButton), for: .touchUpInside)
        return button
    }()
    /// 全仓提示
    lazy var crossTipLabel: UILabel = {
        let text = "contract_cross_risktips".localized()
        let label = UILabel(text: text, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    /// 杠杆输入
    lazy var leverageInput: SLLeverageField = {
        let input = SLLeverageField()
        let leverage = makeOrderViewModel?.leverage ?? "100"
        input.input.text = String(leverage)
        input.input.addTarget(self, action: #selector(leveageConTextChange), for: .editingChanged)
        return input
    }()
    
    lazy var leverageLabel : UILabel = {
        let label = UILabel(text: "100X", font: UIFont.ThemeFont.H1Bold, textColor: UIColor.ThemeLabel.colorLite, alignment: .center)
        return label
    }()
    
    /// 杠杆滑块
    lazy var slider : SLLeverageSliderView = {
        let leverage = Int(makeOrderViewModel?.itemModel?.contractInfo?.max_leverage ?? "100") ?? 100
        let currentLeverage = Float(makeOrderViewModel?.leverage ?? "10") ?? 10
        let v = SLLeverageSliderView(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 50), maxLevel: leverage)
        v.updateSliderValue(value:currentLeverage)
        if currentLeverage > 50 {
            self.tipLabel.isHidden = false
        } else {
            self.tipLabel.isHidden = true
        }
        v.valueChangedCallback = {[weak self] (value) in
            if value > 50 {
                self?.tipLabel.isHidden = false
            } else {
                self?.tipLabel.isHidden = true
            }
            
            if self?.leverageInput.input.isEditing == false {
                self?.leverageInput.input.text = String(value)
                self?.changeFixedTipLabel(leverage:String(value))
            }
        }
        v.startEdit = {[weak self]  in
            self?.leverageInput.input.resignFirstResponder()
        }
        return v
    }()
    /// 提示
    lazy var tipLabel: UILabel = {
        let text = "contract_highleveage_risk".localized()
        let label = UILabel(text: text, font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeState.fail, alignment: .left)
        label.numberOfLines = 0
        label.isHidden = true
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
        if makeOrderViewModel?.isCoin == true {
            unit = makeOrderViewModel?.itemModel?.contractInfo.base_coin ?? ""
        }
        self.contentView.addSubViews([fixedButton,crossButton,fixedTipLabel,crossTipLabel,leverageInput,slider,tipLabel,confirmButton,leverageLabel])
        self.initLayout()
        globleLeavel()
    }
    
    func globleLeavel()  {
        
        BTContractTool.getGlobalLeverage(insterment_id, success: { (levers) in
          
            print(levers ?? "---")
            
        }) { (error) in
            
            print(error ?? "222")
        }
        
    }
    
    override func setNavCustomV() {
        self.setTitle("contract_change_leveage".localized())
        self.navtype = .list
    }
}

extension SLLeverageVc {
    private func initLayout() {
        fixedButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(self.navCustomView.snp_bottom).offset(25)
            make.height.equalTo(36)
        }
        crossButton.snp.makeConstraints { (make) in
            make.left.equalTo(fixedButton.snp.right)
            make.right.equalToSuperview().offset(-25)
            make.top.width.height.equalTo(fixedButton)
        }
        fixedTipLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(fixedButton.snp.bottom).offset(12)
        }
        crossTipLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(fixedButton.snp.bottom).offset(12)
        }
        leverageInput.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(40)
            make.centerX.equalTo(SCREEN_WIDTH * 0.5+10)
            make.top.equalTo(fixedButton.snp.bottom).offset(84)
        }
        leverageLabel.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(40)
            make.centerX.equalTo(SCREEN_WIDTH * 0.5)
            make.top.equalTo(fixedButton.snp.bottom).offset(84)
        }
        slider.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(leverageInput.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
            make.top.equalTo(slider.snp.bottom).offset(40)
        }
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(30)
            make.top.equalTo(slider.snp.bottom)
        }
        if makeOrderViewModel?.leverage_type == .allType {
            clickPositionTypeButton(sender:crossButton)
        } else {
            clickPositionTypeButton(sender:fixedButton)
        }
    }
    /// 点击确认
    @objc func clickConfirmButton() {
        var leverage = self.leverageInput.input.text ?? "10"
        if leverage.lessThan("1") {
            leverage = "1"
        }
        var positionType = "contract_Fixed_position".localized() + leverage + "X"
        if self.crossButton.isSelected {
            leverage = makeOrderViewModel?.itemModel?.contractInfo?.max_leverage ?? "100"
            positionType = "contract_Cross_position".localized() + leverage + "X"
        }
        self.clickComfirmLeverage?(positionType,leverage)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickPositionTypeButton(sender : UIButton) {
        sender.isSelected = true
        if sender == self.fixedButton {
            self.crossButton.isSelected = false
            self.fixedTipLabel.isHidden = false
            self.crossTipLabel.isHidden = true
            self.leverageInput.isHidden = false
            self.leverageLabel.isHidden = true
            self.slider.isHidden = false
            let currentLeverage = Float(makeOrderViewModel?.leverage ?? "10") ?? 10
            if currentLeverage > 50 {
                self.tipLabel.isHidden = false
            } else {
                self.tipLabel.isHidden = true
            }
        } else {
            self.fixedButton.isSelected = false
            self.fixedTipLabel.isHidden = true
            self.crossTipLabel.isHidden = false
            self.leverageInput.isHidden = true
            self.leverageLabel.isHidden = false
            self.slider.isHidden = true
            self.tipLabel.isHidden = true
        }
    }
    
    @objc func leveageConTextChange(sender : UITextField) {
        let le = makeOrderViewModel?.itemModel?.contractInfo?.max_leverage ?? "100"
        if (sender.text ?? "0").greaterThan(le) {
            sender.text = le
        }
        let value = Float(sender.text ?? "0") ?? 0
        slider.updateSliderValue(value:value)
        changeFixedTipLabel(leverage:le)
    }
    
    func changeFixedTipLabel(leverage : String) {
        if makeOrderViewModel?.itemModel?.contractInfo == nil {
            return
        }
        let px = currentPx
        var max = SLFormula.calculateVolume(withAsset: makeOrderViewModel?.asset?.available_vol ?? "0", price: px, lever: leverage, advance: ContractOrderSize(), position: BTPositionModel(), positionType: .openMore, contractInfo: (makeOrderViewModel?.itemModel!.contractInfo!)!).toString(0) ?? "0"
        
        var min = SLFormula.calculateVolume(withAsset: makeOrderViewModel?.asset?.available_vol ?? "0", price: px, lever: leverage, advance: ContractOrderSize(), position: BTPositionModel(), positionType: .openEmpty, contractInfo: (makeOrderViewModel?.itemModel!.contractInfo!)!).toString(0) ?? "0"
        
        if makeOrderViewModel?.isCoin == true {
             max = SLFormula.ticket(toCoin: max, price: px, contract: (makeOrderViewModel?.itemModel?.contractInfo)!)
             min = SLFormula.ticket(toCoin: min, price: px, contract: (makeOrderViewModel?.itemModel?.contractInfo)!)
        }
        
        let attrString = NSMutableAttributedString().add(string: LanguageTools.getString(key: "contract_currentleveage_canopen"), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryRegular]).add(string: String(format: "%@%@ ", max,unit), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeState.warning, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold]).add(string: "contract_openShort_ins".localized(), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeLabel.colorMedium, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryRegular]).add(string: String(format: "%@%@", min,unit), attrDic: [NSAttributedStringKey.foregroundColor : UIColor.ThemeState.warning, NSAttributedStringKey.font : UIFont.ThemeFont.SecondaryBold])
        self.fixedTipLabel.attributedText = attrString
    }
}

class SLLeveageBtn: UIButton {
    override var isHighlighted: Bool {
        get {
            return false
        }
        set{
        }
    }
}
