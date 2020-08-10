//
//  SLStopProfitOrLossV.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/5/25.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import Foundation

enum SLStopProfitOrLossVType {
    case profit
    case loss
}

class SLStopProfitOrLossV: UIView {
    
    let infoVaild:SLInputLimitDelegate = SLInputLimitDelegate()
    
    var px_unit : String? {
        didSet{
            
            profitPriceInput.setExtraText(px_unit ?? "")
            profitExcutiveInput.setExtraText(px_unit ?? "")
        }
    }
    
    var px_unitValue:String? {
        
        didSet {
            
            infoVaild.decail = px_unitValue ?? "0.01"
        }
    
    }
    
    
    var forceClosePrice:String?
    var lastPrice:String?
    var side:BTContractOrderWay = .buy_OpenLong
    var isProfit:Bool = true
    
    var idx = 0
    // 止盈止损开关按钮
    lazy var stopProfitBtn : UIButton = {
        let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "Checkbox_default"))
        button.setImage(UIImage.themeImageNamed(imageName: "Checkbox_Focus"), for: .selected)
        button.extSetAddTarget(self, #selector(stopProfitOrLoss))
        return button
    }()
    
    lazy var stopProfitLabel : UILabel = {
        let object = UILabel.init(text: "contract_open_stop_profit".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return object
    }()
    
    
    /// 止盈止损触发价格
    lazy var profitPriceInput : EXTextField = {
        let textField = EXTextField()
        textField.isUserInteractionEnabled = false
        textField.setPlaceHolder(placeHolder: "contract_trigger_placeHolder".localized())
        textField.input.textColor = UIColor.ThemeLabel.colorLite
        textField.input.rx.text.orEmpty.changed.asObservable().subscribe { [weak self] (event) in
         
                self?.priceDidChange()

        }.disposed(by: self.disposeBag)
        textField.input.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    
    lazy var profitMarketLabel : UILabel = {
        let marketLabel = UILabel.init(text: "", font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorHighlight, alignment: .right)
        return marketLabel
    }()
    
    lazy var profitMarketCover : UILabel = {
        let marketCover = UILabel.init(text: "contract_action_marketPrice".localized(), font: UIFont.ThemeFont.BodyRegular, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        marketCover.backgroundColor = UIColor.ThemeView.bg
        marketCover.isHidden = true
        return marketCover
    }()
    
    lazy var marketBtn :UIButton = {
       
        let button = UIButton()
        
        button.setTitle("contract_action_marketPrice".localized(), for: .normal)
        button.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        button.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: .normal)
        button.addTarget(self, action: #selector(clickProfitMarketBtn), for: .touchUpInside)
        button.isHidden = true
        return button
        
    }()
    
    lazy var profitExcutiveInput: EXTextField = {
        let input = EXTextField()
        input.input.keyboardType = UIKeyboardType.decimalPad
        input.setPlaceHolder(placeHolder: "contract_excutive_price".localized())
    
        let verLine = UIView()
        verLine.backgroundColor = UIColor.ThemeView.seperator
        input.addSubview(profitMarketLabel)
        input.addSubview(verLine)
        profitMarketLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.centerY.equalTo(input.input)
            make.width.equalTo(40)
        }
        verLine.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(input.input)
            make.right.equalTo(profitMarketLabel.snp.left)
        }
        input.extraLabel.snp.updateConstraints { (make) in
            make.right.equalTo(verLine.snp.left).offset(-10)
        }
        input.titleLabel.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        profitMarketLabel.isUserInteractionEnabled = true
        
        input.addSubview(profitMarketCover)
        profitMarketCover.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(input.input)
            make.height.equalTo(25)
        }
        
        
        input.input.rx.text.orEmpty.changed.asObservable().subscribe { [weak self] (event) in
                  
                      self?.priceDidChange()
            
               }.disposed(by: self.disposeBag)
        
        input.isHidden = true
        return input
    }()
    
    

    /// 预计盈利
    lazy var anticipateProfit : UILabel = {
        let object = UILabel.init(text: "预计盈利：-- USDT", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeState.warning, alignment: .left)
        object.isHidden = true
        return object
    }()
    /// 预计回报率我
    lazy var anticipateLoss : UILabel = {
        let object = UILabel.init(text: "", font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeState.warning, alignment: .left)
        object.numberOfLines = 0
        object.isHidden = true
        return object
    }()
    /// 最新价， 合理价， 指数家
    lazy var lastPriceBtn : UIButton = {
        let btn = self.createTypeBtn("contract_tiggertype_latest".localized(),#selector(clickTiggerPriceTypeBtn))
        btn.isSelected = true
        btn.isHidden = true
        return btn
    }()
    lazy var fairPriceBtn : UIButton = {
        let btn = self.createTypeBtn("contract_tiggertype_fair".localized(),#selector(clickTiggerPriceTypeBtn))
        btn.isHidden = true
        return btn
    }()
    lazy var indexPriceBtn : UIButton = {
        let btn = self.createTypeBtn("contract_tiggertype_index".localized(),#selector(clickTiggerPriceTypeBtn))
        btn.isHidden = true
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviewsLayout()
        
        self.profitPriceInput.input.delegate = infoVaild
        self.profitExcutiveInput.input.delegate = infoVaild
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviewsLayout() {
        addSubViews([stopProfitBtn,
                     stopProfitLabel,
                     profitPriceInput,
                     profitExcutiveInput,
                     marketBtn,

            anticipateLoss,
            lastPriceBtn,
            fairPriceBtn,
            indexPriceBtn])
        stopProfitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.height.equalTo(22)
            make.top.equalToSuperview()
        }
        stopProfitLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stopProfitBtn)
            make.left.equalTo(stopProfitBtn.snp.right).offset(4)
            make.height.equalTo(14)
        }
        profitPriceInput.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(stopProfitBtn.snp.bottom).offset(6)
            make.bottom.equalToSuperview().offset(-5)
        }
        indexPriceBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(20)
            make.centerY.equalTo(stopProfitBtn)
            make.width.equalTo(60)
        }
        fairPriceBtn.snp.makeConstraints { (make) in
            make.right.equalTo(indexPriceBtn.snp.left)
            make.height.width.centerY.equalTo(indexPriceBtn)
        }
        lastPriceBtn.snp.makeConstraints { (make) in
            make.right.equalTo(fairPriceBtn.snp.left)
            make.height.width.centerY.equalTo(indexPriceBtn)
        }
        profitExcutiveInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(profitPriceInput)
            make.height.equalTo(30)
            make.top.equalTo(profitPriceInput.snp.bottom).offset(12)
        }
        marketBtn.snp.makeConstraints { (make) in
            
            make.right.equalToSuperview()
            make.height.centerY.equalTo(profitExcutiveInput)
            make.width.equalTo(40)
            
        }

        anticipateLoss.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(profitExcutiveInput.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    
    
    func setView(_ type :SLStopProfitOrLossVType) {
        if type == .profit {
            self.stopProfitLabel.text = "contract_open_stop_profit".localized()
        } else if type == .loss {
            self.stopProfitLabel.text = "contract_open_stop_loss".localized()
        }
    }
}

extension SLStopProfitOrLossV {
    
    @objc func clickProfitMarketBtn() {
      
        profitMarketCover.isHidden = !profitMarketCover.isHidden
        self.priceDidChange()
        self.profitExcutiveInput.isUserInteractionEnabled = profitMarketCover.isHidden
        if profitMarketCover.isHidden == true {
            self.profitExcutiveInput.input.endEditing(true)
        } else {
            //  self.profitExcutiveInput.input.text = positionModel?.lastPrice ?? "0"
        }
    }
    private func createTypeBtn(_ title: String ,_ selector : Selector) -> UIButton {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetAddTarget(self, selector)
        btn.setTitle(title, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: UIControlState.normal)
        btn.setTitleColor(UIColor.ThemeLabel.colorHighlight, for: UIControlState.selected)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.ThemeView.border.cgColor
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        return btn
    }
    /// 选择触发价格类型
    @objc func clickTiggerPriceTypeBtn(_ btn : UIButton) {
        btn.isSelected = true
        if btn == lastPriceBtn {
            fairPriceBtn.isSelected = false
            indexPriceBtn.isSelected = false
        } else if btn == fairPriceBtn {
            lastPriceBtn.isSelected = false
            indexPriceBtn.isSelected = false
            idx = 1
        } else if btn == indexPriceBtn {
            lastPriceBtn.isSelected = false
            fairPriceBtn.isSelected = false
            idx = 2
        }
    }
    
    @objc func stopProfitOrLoss(_ btn : UIButton) {
        btn.isSelected = !btn.isSelected
        self.clickProfitMarketBtn()
        profitExcutiveInput.isHidden = !btn.isSelected
        profitPriceInput.isUserInteractionEnabled = btn.isSelected
        marketBtn.isHidden = !btn.isSelected
        anticipateLoss.isHidden = !btn.isSelected
//        self.priceDidChange()
        if btn.isSelected {
            profitPriceInput.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(30)
                make.top.equalTo(stopProfitBtn.snp.bottom).offset(5)
            }
        } else {
            profitPriceInput.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(30)
                make.top.equalTo(stopProfitBtn.snp.bottom).offset(5)
                make.bottom.equalToSuperview().offset(-5)
            }
        }
        self.superview?.layoutSubviews()
    }
}


extension SLStopProfitOrLossV {
    
    //判断类型是否选中
    func isSetProfitOrLoss() -> Bool {
        
        return stopProfitBtn.isSelected
    }
    // 判断输入的触发价 以及执行价 合理
    func isInfoVaild() -> Bool {
        
        let isInfoVaild = isPriceVaild(inputtext: profitPriceInput.input.text ?? "")
        if !isInfoVaild{
            return false
        }
        if !profitMarketCover.isHidden{
            return true
        }
        let extuteInfo = isPriceVaild(inputtext: profitExcutiveInput.input.text ?? "")
        if !extuteInfo {
            return false
        }
        return true
        
    }
    
    func errorShake()  {
        
        
        self.anticipateLoss.shake()
        
    }
    
    //触发价 合理价 以及是否市价
    func profitOrLossInfo() -> (triggerprice:String,excutePrice:String,isMarket:Bool) {
        
        return (triggerprice:profitPriceInput.input.text ?? "",excutePrice:profitExcutiveInput.input.text ?? "", isMarket:!self.profitMarketCover.isHidden)
        
    }
    
    //验证价格合法性
    
    
    private func getErrorInfo()-> String {
        
        let isMore = self.side == .buy_OpenLong
        
        if isMore {
            return !isProfit ? "contract_sting_moreLossMessage".localized():"contract_sting_moreProfitMessage".localized()
        }
        
        return !isProfit ? "contract_sting_lessLossMessage".localized() : "contract_sting_lessProfitMessage".localized()
        
    }
    
     private func isPriceVaild(inputtext:String) -> Bool {
        
        let isMore = self.side == .buy_OpenLong
        if isMore {
            if !isProfit {
                return ((inputtext as NSString).isBig(forceClosePrice) && (inputtext as NSString).isSmall(lastPrice)) ?  true :  false
            }
            return (inputtext as NSString).isBig(forceClosePrice) ? true : false
            
        }else{
            if !isProfit {
                return ((inputtext as NSString).isSmall(forceClosePrice) &&  (inputtext as NSString).isBig(lastPrice)) ? true :  false
                
            }
            return (inputtext as NSString).isSmall(forceClosePrice) ? true :false
        }
    }
    
    
    func priceDidChange() {
        
        let infoVaild = isInfoVaild()
        if infoVaild {
            let goodMessage = String(format: "contract_sting_newPriceMessage".localized(), profitPriceInput.input.text ?? "")
            self.anticipateLoss.text = goodMessage
        }else{
            if self.profitPriceInput.input.text == ""  && self.profitExcutiveInput.input.text == ""{
                self.anticipateLoss.text = ""
            }else{
             
                self.anticipateLoss.text = getErrorInfo()
            }
        }
        self.anticipateLoss.textColor = infoVaild ? UIColor.ThemeState.warning :UIColor.ThemeState.fail
    
    }
    
}
